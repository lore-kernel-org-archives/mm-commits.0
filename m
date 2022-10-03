Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542ECC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiJCVGa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiJCVFn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32EF167FD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26A7F6118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7795EC433D6;
        Mon,  3 Oct 2022 21:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831112;
        bh=kb1nCc/ejnHPWmDaZBMSJgWQhtvZrGoeY+WHCXGdUaA=;
        h=Date:To:From:Subject:From;
        b=WLuzK17NDk+K5iwlsx5nFqowMRxy1OFJX0GpytSLA9QAhrBEQ5rrYkEmnYi5L6AtP
         D4kZxb9CsKcZiABxxJX7BYbxDHRuYhE79vM3k4st/S6YMIt3kVtEw7gULs0pMANHPG
         glb4kgnbKe3oiwAoyRh84btJQME5nETgjwdGVJs8=
Date:   Mon, 03 Oct 2022 14:05:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-convert-mcontinue_atomic_pte-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210512.7795EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: convert mcontinue_atomic_pte() to use a folio
has been removed from the -mm tree.  Its filename was
     userfaultfd-convert-mcontinue_atomic_pte-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: userfaultfd: convert mcontinue_atomic_pte() to use a folio
Date: Fri, 2 Sep 2022 20:46:28 +0100

shmem_getpage() is being replaced by shmem_get_folio() so use a folio
throughout this function.  Saves several calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-33-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-convert-mcontinue_atomic_pte-to-use-a-folio
+++ a/mm/userfaultfd.c
@@ -243,20 +243,22 @@ static int mcontinue_atomic_pte(struct m
 {
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
+	struct folio *folio;
 	struct page *page;
 	int ret;
 
-	ret = shmem_getpage(inode, pgoff, &page, SGP_NOALLOC);
-	/* Our caller expects us to return -EFAULT if we failed to find page. */
+	ret = shmem_get_folio(inode, pgoff, &folio, SGP_NOALLOC);
+	/* Our caller expects us to return -EFAULT if we failed to find folio */
 	if (ret == -ENOENT)
 		ret = -EFAULT;
 	if (ret)
 		goto out;
-	if (!page) {
+	if (!folio) {
 		ret = -EFAULT;
 		goto out;
 	}
 
+	page = folio_file_page(folio, pgoff);
 	if (PageHWPoison(page)) {
 		ret = -EIO;
 		goto out_release;
@@ -267,13 +269,13 @@ static int mcontinue_atomic_pte(struct m
 	if (ret)
 		goto out_release;
 
-	unlock_page(page);
+	folio_unlock(folio);
 	ret = 0;
 out:
 	return ret;
 out_release:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 	goto out;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


