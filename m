Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04172C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 18:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbiHQSXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 14:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbiHQSXD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 14:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7745D9925E
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 11:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BD0BB81EB5
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 18:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57CFC433C1;
        Wed, 17 Aug 2022 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660760579;
        bh=mhzQFoLuPkl2z3e3c2GMNFzfl6u5Ij85CZbUSo1I78k=;
        h=Date:To:From:Subject:From;
        b=UTypeAje71Rc+GApQVgbqw+Xn4luy+GTcaRhfgUamvh3TrtX+j8CMl2TXeZDQMMl9
         wrpEt7aH4obh5EojtbCZci/AWfjtrNeZwNuLLRNdxQvb4RtHdHqeX4YfzoPVgnyXXh
         eoDYDuts4Vsn+n05ydGG6McSE+JWniLHal09+ty8=
Date:   Wed, 17 Aug 2022 11:22:58 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kill-find_min_pfn_with_active_regions.patch added to mm-unstable branch
Message-Id: <20220817182258.E57CFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kill find_min_pfn_with_active_regions()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kill-find_min_pfn_with_active_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kill-find_min_pfn_with_active_regions.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -2512,7 +2512,6 @@ extern unsigned long absent_pages_in_ran
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn);
-extern unsigned long find_min_pfn_with_active_regions(void);
 
 #ifndef CONFIG_NUMA
 static inline int early_pfn_to_nid(unsigned long pfn)
--- a/mm/page_alloc.c~mm-kill-find_min_pfn_with_active_regions
+++ a/mm/page_alloc.c
@@ -7917,17 +7917,6 @@ unsigned long __init node_map_pfn_alignm
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
@@ -8220,7 +8209,7 @@ void __init free_area_init(unsigned long
 	memset(arch_zone_highest_possible_pfn, 0,
 				sizeof(arch_zone_highest_possible_pfn));
 
-	start_pfn = find_min_pfn_with_active_regions();
+	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch

