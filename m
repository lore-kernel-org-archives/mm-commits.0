Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAA2C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiJCVGd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiJCVFn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67C618355
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44279611D9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96878C433D6;
        Mon,  3 Oct 2022 21:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831113;
        bh=r5CSMIEi0N8oF9Ff8/SFGY1uye4qyVd9ijBiqqh9Ymc=;
        h=Date:To:From:Subject:From;
        b=a446waJB8Bb1jF5f8ys1ldQA4Qaw4khrclMllXPPqdnrEi5670iqyJbUaTySfHlQE
         lYYXzDEigTJEOJEpxZmCo6XAMKhtSV6iKF7DhQ735x8jcrZvLysz+Um8AQ0RzwzKLT
         Y0f+ZbLieMzLYJ18pfJlZ/aWDUBZ7R8yTz7KYA8g=
Date:   Mon, 03 Oct 2022 14:05:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-remove-shmem_getpage.patch removed from -mm tree
Message-Id: <20221003210513.96878C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: remove shmem_getpage()
has been removed from the -mm tree.  Its filename was
     shmem-remove-shmem_getpage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: remove shmem_getpage()
Date: Fri, 2 Sep 2022 20:46:29 +0100

With all callers removed, remove this wrapper function.  The flags are now
mysteriously called SGP, but I think we can live with that.

Link: https://lkml.kernel.org/r/20220902194653.1739778-34-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    4 +---
 mm/shmem.c               |   15 +--------------
 2 files changed, 2 insertions(+), 17 deletions(-)

--- a/include/linux/shmem_fs.h~shmem-remove-shmem_getpage
+++ a/include/linux/shmem_fs.h
@@ -102,7 +102,7 @@ extern unsigned long shmem_swap_usage(st
 extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 						pgoff_t start, pgoff_t end);
 
-/* Flag allocation requirements to shmem_getpage */
+/* Flag allocation requirements to shmem_get_folio */
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
 	SGP_NOALLOC,	/* similar, but fail on hole or use fallocated page */
@@ -111,8 +111,6 @@ enum sgp_type {
 	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
 };
 
-extern int shmem_getpage(struct inode *inode, pgoff_t index,
-		struct page **pagep, enum sgp_type sgp);
 int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
 		enum sgp_type sgp);
 
--- a/mm/shmem.c~shmem-remove-shmem_getpage
+++ a/mm/shmem.c
@@ -179,7 +179,7 @@ static inline int shmem_reacct_size(unsi
 /*
  * ... whereas tmpfs objects are accounted incrementally as
  * pages are allocated, in order to allow large sparse files.
- * shmem_getpage reports shmem_acct_block failure as -ENOSPC not -ENOMEM,
+ * shmem_get_folio reports shmem_acct_block failure as -ENOSPC not -ENOMEM,
  * so that a failure on a sparse tmpfs mapping will give SIGBUS not OOM.
  */
 static inline int shmem_acct_block(unsigned long flags, long pages)
@@ -2031,19 +2031,6 @@ int shmem_get_folio(struct inode *inode,
 			mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
 }
 
-int shmem_getpage(struct inode *inode, pgoff_t index,
-		struct page **pagep, enum sgp_type sgp)
-{
-	struct folio *folio = NULL;
-	int ret = shmem_get_folio(inode, index, &folio, sgp);
-
-	if (folio)
-		*pagep = folio_file_page(folio, index);
-	else
-		*pagep = NULL;
-	return ret;
-}
-
 /*
  * This is like autoremove_wake_function, but it removes the wait queue
  * entry unconditionally - even if something else had already woken the
_

Patches currently in -mm which might be from willy@infradead.org are


