Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02CFC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJCVG2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiJCVFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5DE140EF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62CBACE0E7D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83911C433D7;
        Mon,  3 Oct 2022 21:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831103;
        bh=6BuaBkBm0R2KtuOE0lcPUKqbp0+bJNQHMk+NyeNkVWE=;
        h=Date:To:From:Subject:From;
        b=zaDcw3AtZFeA+GTOqo+Re2nw16JjCvnyY/ZGdHEsx37L2H7pUb6b3A/zHyp5BpCjm
         KCcUAs8INfabkFdd5fu0Tpm3VulifJTDIgZLD/WTWlCXi+0JqQ2YGUNBOTcf/PbZep
         bry3YzFGkFpyKQPcyx+zfeiSqHORev+1m9QWRaAI=
Date:   Mon, 03 Oct 2022 14:05:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-add-shmem_get_folio.patch removed from -mm tree
Message-Id: <20221003210503.83911C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: add shmem_get_folio()
has been removed from the -mm tree.  Its filename was
     shmem-add-shmem_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: add shmem_get_folio()
Date: Fri, 2 Sep 2022 20:46:20 +0100

With no remaining callers of shmem_getpage_gfp(), add shmem_get_folio()
and reimplement shmem_getpage() as a call to shmem_get_folio().

Link: https://lkml.kernel.org/r/20220902194653.1739778-25-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 ++
 mm/shmem.c               |   23 ++++++++++-------------
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/include/linux/shmem_fs.h~shmem-add-shmem_get_folio
+++ a/include/linux/shmem_fs.h
@@ -113,6 +113,8 @@ enum sgp_type {
 
 extern int shmem_getpage(struct inode *inode, pgoff_t index,
 		struct page **pagep, enum sgp_type sgp);
+int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
+		enum sgp_type sgp);
 
 static inline struct page *shmem_read_mapping_page(
 				struct address_space *mapping, pgoff_t index)
--- a/mm/shmem.c~shmem-add-shmem_get_folio
+++ a/mm/shmem.c
@@ -2025,14 +2025,18 @@ unlock:
 	return error;
 }
 
-static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
-		struct page **pagep, enum sgp_type sgp,
-		gfp_t gfp, struct vm_area_struct *vma,
-		struct vm_fault *vmf, vm_fault_t *fault_type)
+int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
+		enum sgp_type sgp)
+{
+	return shmem_get_folio_gfp(inode, index, foliop, sgp,
+			mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
+}
+
+int shmem_getpage(struct inode *inode, pgoff_t index,
+		struct page **pagep, enum sgp_type sgp)
 {
 	struct folio *folio = NULL;
-	int ret = shmem_get_folio_gfp(inode, index, &folio, sgp, gfp, vma,
-			vmf, fault_type);
+	int ret = shmem_get_folio(inode, index, &folio, sgp);
 
 	if (folio)
 		*pagep = folio_file_page(folio, index);
@@ -2041,13 +2045,6 @@ static int shmem_getpage_gfp(struct inod
 	return ret;
 }
 
-int shmem_getpage(struct inode *inode, pgoff_t index,
-		struct page **pagep, enum sgp_type sgp)
-{
-	return shmem_getpage_gfp(inode, index, pagep, sgp,
-		mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
-}
-
 /*
  * This is like autoremove_wake_function, but it removes the wait queue
  * entry unconditionally - even if something else had already woken the
_

Patches currently in -mm which might be from willy@infradead.org are


