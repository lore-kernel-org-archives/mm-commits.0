Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E54EC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8233D61466
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhD3F4P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhD3F4P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5202561462;
        Fri, 30 Apr 2021 05:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762127;
        bh=OitvE7nEBHz4yuTvsmftMoE6scvcM1kzJKwLQeSgZK8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=X1nbWyRM0L9aiFu9QQckJExr701bUR7I8vvTfZRn72GdN3j8B5wN0tw80J6IBB43u
         LTBGOCuSkCCbSwVTejpHhQjRRq4wQfc/Z7bgmlkZecOSEuUSb5YqttXj1Hv8L1DkUd
         G++CIf/EQwU16A6oFpE59bg/xl1h5MZOfnWrDc0s=
Date:   Thu, 29 Apr 2021 22:55:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 044/178] mm/filemap: use filemap_read_page in
 filemap_fault
Message-ID: <20210430055526.9vktZ__HG%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: use filemap_read_page in filemap_fault

After splitting generic_file_buffered_read() into smaller parts, it turns
out we can reuse one of the parts in filemap_fault().  This fixes an
oversight -- waiting for the I/O to complete is now interruptible by a
fatal signal.  And it saves us a few bytes of text in an unlikely path.

$ ./scripts/bloat-o-meter before.o after.o
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-207 (-207)
Function                                     old     new   delta
filemap_fault                               2187    1980    -207
Total: Before=37491, After=37284, chg -0.55%

Link: https://lkml.kernel.org/r/20210226140011.2883498-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/filemap.c~mm-filemap-use-filemap_read_page-in-filemap_fault
+++ a/mm/filemap.c
@@ -2980,7 +2980,6 @@ vm_fault_t filemap_fault(struct vm_fault
 	struct file *file = vmf->vma->vm_file;
 	struct file *fpin = NULL;
 	struct address_space *mapping = file->f_mapping;
-	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
 	pgoff_t offset = vmf->pgoff;
 	pgoff_t max_off;
@@ -3067,14 +3066,8 @@ page_not_uptodate:
 	 * because there really aren't any performance issues here
 	 * and we need to check for errors.
 	 */
-	ClearPageError(page);
 	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-	error = mapping->a_ops->readpage(file, page);
-	if (!error) {
-		wait_on_page_locked(page);
-		if (!PageUptodate(page))
-			error = -EIO;
-	}
+	error = filemap_read_page(file, mapping, page);
 	if (fpin)
 		goto out_retry;
 	put_page(page);
@@ -3082,7 +3075,6 @@ page_not_uptodate:
 	if (!error || error == AOP_TRUNCATED_PAGE)
 		goto retry_find;
 
-	shrink_readahead_size_eio(ra);
 	return VM_FAULT_SIGBUS;
 
 out_retry:
_
