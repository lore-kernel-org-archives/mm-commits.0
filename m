Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C321ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiILDbc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiILD3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45BD2871F
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A068B80C76
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A48C433B5;
        Mon, 12 Sep 2022 03:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953358;
        bh=wnqPpAKhXzierRWCt8/756Ic3sVAigimfwciYvjK05c=;
        h=Date:To:From:Subject:From;
        b=Cjat8f6gHDGSwTsx7xJg8BKpRJ4Zda3mYn/8bnQR4gAZAkAUkod8xnnKat4dQmWtf
         VqJCv6o1nVuZUeQbKRtummXNImKcr9YPG5hmPQ917w0SrUu3BLzSJofZIvB26PUVEg
         TyEChnuXuDiVWXwBchE/kr8xIfe6InlaUGSbA0aY=
Date:   Sun, 11 Sep 2022 20:29:17 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kill-find_min_pfn_with_active_regions.patch removed from -mm tree
Message-Id: <20220912032918.02A48C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kill find_min_pfn_with_active_regions()
has been removed from the -mm tree.  Its filename was
     mm-kill-find_min_pfn_with_active_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kill find_min_pfn_with_active_regions()
Date: Mon, 15 Aug 2022 19:10:17 +0800

find_min_pfn_with_active_regions() is only called from free_area_init(). 
Open-code the PHYS_PFN(memblock_start_of_DRAM()) into free_area_init(),
and kill find_min_pfn_with_active_regions().

Link: https://lkml.kernel.org/r/20220815111017.39341-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/page_alloc.c    |   13 +------------
 2 files changed, 1 insertion(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-kill-find_min_pfn_with_active_regions
+++ a/include/linux/mm.h
@@ -2520,7 +2520,6 @@ extern unsigned long absent_pages_in_ran
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn);
-extern unsigned long find_min_pfn_with_active_regions(void);
 
 #ifndef CONFIG_NUMA
 static inline int early_pfn_to_nid(unsigned long pfn)
--- a/mm/page_alloc.c~mm-kill-find_min_pfn_with_active_regions
+++ a/mm/page_alloc.c
@@ -7908,17 +7908,6 @@ unsigned long __init node_map_pfn_alignm
 	return ~accl_mask + 1;
 }
 
-/**
- * find_min_pfn_with_active_regions - Find the minimum PFN registered
- *
- * Return: the minimum PFN based on information provided via
- * memblock_set_node().
- */
-unsigned long __init find_min_pfn_with_active_regions(void)
-{
-	return PHYS_PFN(memblock_start_of_DRAM());
-}
-
 /*
  * early_calculate_totalpages()
  * Sum pages in active regions for movable zone.
@@ -8211,7 +8200,7 @@ void __init free_area_init(unsigned long
 	memset(arch_zone_highest_possible_pfn, 0,
 				sizeof(arch_zone_highest_possible_pfn));
 
-	start_pfn = find_min_pfn_with_active_regions();
+	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch

