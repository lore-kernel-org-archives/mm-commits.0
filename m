Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6D1C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJCVGb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJCVFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AEA5FB3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E96E1610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2BCC433D6;
        Mon,  3 Oct 2022 21:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831110;
        bh=tTIBVMj7nYGHVd8P8AcaI4c5gnl33gzjDK23DA2Z5Ds=;
        h=Date:To:From:Subject:From;
        b=V8zYoIezkix7oPlMip+EiX7HeqsqBjTod5oQ7ehdv6jn1Kh3t0lVuW5MZK6d9JNso
         H0GTeSGYfG9P4SltO6Re3/TKPc3ue6fsBMLzbnt7X7za3GmU3zrcUhHqE0X4W/1pC7
         YlfxodUnfj0x0Z4dQxzLaBpdjKhtIC2QnkLhf1Mc=
Date:   Mon, 03 Oct 2022 14:05:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_get_link-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210510.4A2BCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_get_link() to use a folio
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_get_link-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_get_link() to use a folio
Date: Fri, 2 Sep 2022 20:46:26 +0100

Symlinks will never use a large folio, but using the folio API removes a
lot of unnecessary folio->page->folio conversions.

Link: https://lkml.kernel.org/r/20220902194653.1739778-31-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_get_link-to-use-a-folio
+++ a/mm/shmem.c
@@ -3143,40 +3143,41 @@ static int shmem_symlink(struct user_nam
 
 static void shmem_put_link(void *arg)
 {
-	mark_page_accessed(arg);
-	put_page(arg);
+	folio_mark_accessed(arg);
+	folio_put(arg);
 }
 
 static const char *shmem_get_link(struct dentry *dentry,
 				  struct inode *inode,
 				  struct delayed_call *done)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	int error;
+
 	if (!dentry) {
-		page = find_get_page(inode->i_mapping, 0);
-		if (!page)
+		folio = filemap_get_folio(inode->i_mapping, 0);
+		if (!folio)
 			return ERR_PTR(-ECHILD);
-		if (PageHWPoison(page) ||
-		    !PageUptodate(page)) {
-			put_page(page);
+		if (PageHWPoison(&folio->page) ||
+		    !folio_test_uptodate(folio)) {
+			folio_put(folio);
 			return ERR_PTR(-ECHILD);
 		}
 	} else {
-		error = shmem_getpage(inode, 0, &page, SGP_READ);
+		error = shmem_get_folio(inode, 0, &folio, SGP_READ);
 		if (error)
 			return ERR_PTR(error);
-		if (!page)
+		if (!folio)
 			return ERR_PTR(-ECHILD);
-		if (PageHWPoison(page)) {
-			unlock_page(page);
-			put_page(page);
+		if (PageHWPoison(&folio->page)) {
+			folio_unlock(folio);
+			folio_put(folio);
 			return ERR_PTR(-ECHILD);
 		}
-		unlock_page(page);
+		folio_unlock(folio);
 	}
-	set_delayed_call(done, shmem_put_link, page);
-	return page_address(page);
+	set_delayed_call(done, shmem_put_link, folio);
+	return folio_address(folio);
 }
 
 #ifdef CONFIG_TMPFS_XATTR
_

Patches currently in -mm which might be from willy@infradead.org are


