Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8B3C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiJCVGG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJCVFb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36D213FB2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51338CE0E70
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C209C433C1;
        Mon,  3 Oct 2022 21:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831099;
        bh=TtgN8RiuaHEIpYxcDNLuhmCQyvDxEAiJ9rD4mHc5CA0=;
        h=Date:To:From:Subject:From;
        b=WlLG2kZ4bQFRSoZj64d7EC6a7E7Qt+dRThqOrporUxQd0nABKwprdbS75JPLeibFK
         wuIWb1asl2TUvqe6GWcSv4OBxEMR/+hgoYRS5f1W0SK/+EFS7cL4PrZfHC5TV911nY
         gMwHynXH2+iQQ2CLG7FzhYgx0fryrkPwwYY9I7d0=
Date:   Mon, 03 Oct 2022 14:04:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-eliminate-struct-page-from-shmem_swapin_folio.patch removed from -mm tree
Message-Id: <20221003210459.0C209C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: eliminate struct page from shmem_swapin_folio()
has been removed from the -mm tree.  Its filename was
     shmem-eliminate-struct-page-from-shmem_swapin_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: eliminate struct page from shmem_swapin_folio()
Date: Fri, 2 Sep 2022 20:46:16 +0100

Convert shmem_swapin() to return a folio and use swap_cache_get_folio(),
removing all uses of struct page in this function.

Link: https://lkml.kernel.org/r/20220902194653.1739778-21-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/shmem.c~shmem-eliminate-struct-page-from-shmem_swapin_folio
+++ a/mm/shmem.c
@@ -1486,7 +1486,7 @@ static void shmem_pseudo_vma_destroy(str
 	mpol_cond_put(vma->vm_policy);
 }
 
-static struct page *shmem_swapin(swp_entry_t swap, gfp_t gfp,
+static struct folio *shmem_swapin(swp_entry_t swap, gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
@@ -1499,7 +1499,9 @@ static struct page *shmem_swapin(swp_ent
 	page = swap_cluster_readahead(swap, gfp, &vmf);
 	shmem_pseudo_vma_destroy(&pvma);
 
-	return page;
+	if (!page)
+		return NULL;
+	return page_folio(page);
 }
 
 /*
@@ -1721,7 +1723,6 @@ static int shmem_swapin_folio(struct ino
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
-	struct page *page;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
 	int error;
@@ -1734,8 +1735,8 @@ static int shmem_swapin_folio(struct ino
 		return -EIO;
 
 	/* Look it up and read it in.. */
-	page = lookup_swap_cache(swap, NULL, 0);
-	if (!page) {
+	folio = swap_cache_get_folio(swap, NULL, 0);
+	if (!folio) {
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
@@ -1743,13 +1744,12 @@ static int shmem_swapin_folio(struct ino
 			count_memcg_event_mm(charge_mm, PGMAJFAULT);
 		}
 		/* Here we actually start the io */
-		page = shmem_swapin(swap, gfp, info, index);
-		if (!page) {
+		folio = shmem_swapin(swap, gfp, info, index);
+		if (!folio) {
 			error = -ENOMEM;
 			goto failed;
 		}
 	}
-	folio = page_folio(page);
 
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
_

Patches currently in -mm which might be from willy@infradead.org are


