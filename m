Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535D5CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjJRVUS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjJRVUR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:20:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D065114
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:20:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCADC433C8;
        Wed, 18 Oct 2023 21:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664015;
        bh=MqSCX2TB6wXhqj8xbQNAS/1BUcbGifaBZlX6h4WG4ww=;
        h=Date:To:From:Subject:From;
        b=nNHXCNgj7T20gFRhgo2GFf8te4hMg61fSsGHytRgDPlaHIwJ1z1hcWNNza1UGOvf1
         Cg36l1S2KNRDPCAWk886vMj3IsBmKViPPNNUIBq9ITkDuRdUkt8opIsAk4wUN70BDU
         iifaYzN+53DGsc6+9Xl+OykW6rgGGBsQviDT7Z/4=
Date:   Wed, 18 Oct 2023 14:20:15 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch removed from -mm tree
Message-Id: <20231018212015.BFCADC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch

This patch was dropped because it was folded into fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2
Date: Tue Sep 26 02:20:27 PM PDT 2023

fix CONFIG_HUGETLB_PAGE=n warning

| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309260903.qzpqNFz3-lkp@intel.com/
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2
+++ a/fs/proc/task_mmu.c
@@ -1940,6 +1940,19 @@ static void make_uffd_wp_huge_pte(struct
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
 }
+
+static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
+				       unsigned long addr, unsigned long end)
+{
+	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
+
+	if (cur_buf->start != addr)
+		cur_buf->end = addr;
+	else
+		cur_buf->start = cur_buf->end = 0;
+
+	p->found_pages -= (end - addr) / PAGE_SIZE;
+}
 #endif /* CONFIG_HUGETLB_PAGE */
 
 static bool pagemap_scan_is_interesting_page(unsigned long categories,
@@ -2019,19 +2032,6 @@ static bool pagemap_scan_push_range(unsi
 	return true;
 }
 
-static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
-				       unsigned long addr, unsigned long end)
-{
-	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
-
-	if (cur_buf->start != addr)
-		cur_buf->end = addr;
-	else
-		cur_buf->start = cur_buf->end = 0;
-
-	p->found_pages -= (end - addr) / PAGE_SIZE;
-}
-
 static int pagemap_scan_output(unsigned long categories,
 			       struct pagemap_scan_private *p,
 			       unsigned long addr, unsigned long *end)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap-fix.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

