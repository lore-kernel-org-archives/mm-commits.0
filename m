Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BC5C4360C
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DD4664E02
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382104AbhCCNa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235437AbhCCBm3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 20:42:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E340E64E27;
        Wed,  3 Mar 2021 01:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614735056;
        bh=k1uuw0XevgRz6BSxTsyh0PWwMGRUtWtUcBls/qkHoeI=;
        h=Date:From:To:Subject:From;
        b=rgIsrbqKo5bPS8QEHoTyGzZ1LeRr6/3bg30OEAqbR5eX4DvYfCDm8XA8dkc8mmXz9
         i4PkUq8qhtbMCrTu3XdjMy+fR1wbXk9OakgDVv9Yk7UoBRa2hzBtqFoey63fzGr1uw
         5jlYwq7yWSehBBGF6m/+1t7ITT4lprlDmK9f+Ngk=
Date:   Tue, 02 Mar 2021 17:30:55 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + mm-filemap-use-filemap_read_page-in-filemap_fault.patch
 added to -mm tree
Message-ID: <20210303013055.ozKmXSJ75%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: use filemap_read_page in filemap_fault
has been added to the -mm tree.  Its filename is
     mm-filemap-use-filemap_read_page-in-filemap_fault.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-use-filemap_read_page-in-filemap_fault.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-use-filemap_read_page-in-filemap_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2912,7 +2912,6 @@ vm_fault_t filemap_fault(struct vm_fault
 	struct file *file = vmf->vma->vm_file;
 	struct file *fpin = NULL;
 	struct address_space *mapping = file->f_mapping;
-	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
 	pgoff_t offset = vmf->pgoff;
 	pgoff_t max_off;
@@ -2999,14 +2998,8 @@ page_not_uptodate:
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
@@ -3014,7 +3007,6 @@ page_not_uptodate:
 	if (!error || error == AOP_TRUNCATED_PAGE)
 		goto retry_find;
 
-	shrink_readahead_size_eio(ra);
 	return VM_FAULT_SIGBUS;
 
 out_retry:
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch

