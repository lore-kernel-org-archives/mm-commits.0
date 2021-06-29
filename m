Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AE2C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C378461CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhF2Adr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:32880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhF2Adq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:33:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B97861CDA;
        Tue, 29 Jun 2021 00:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926679;
        bh=yo5fVHTlmjA58031LJCSrsIVrQnUOsYzN1mmbK/DCWE=;
        h=Date:From:To:Subject:From;
        b=FdFr4o20L2TO2uIzQjxInIiTXKl3SVNELNYbw86k9vbVxiNI/C7FfbiNd9Bbz1Nb0
         IJqhX8q9TrexbBy8eBpCEGawNPb39+XuFQUjrDlmR0RnPisydbB4ftj+NLfEKEs/AP
         4DrsPyjkyiUU8mA7MrSmnSSGE0NQK318pANsNKcs=
Date:   Mon, 28 Jun 2021 17:31:19 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch removed
 from -mm tree
Message-ID: <20210629003119.7IKxVyM4f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: split per cpu page lists and zone stats -fix -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch

This patch was dropped because it was folded into mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: split per cpu page lists and zone stats -fix -fix

mm/ is not W=1 clean for make allnoconfig but this patch accidentally made
it worse for i386 with the warning

  mm/vmstat.c: In function `refresh_cpu_vm_stats':
  mm/vmstat.c:785:34: warning: unused variable `pcp' [-Wunused-variable]
     struct per_cpu_pages __percpu *pcp = zone->per_cpu_pageset;
                                    ^~~

This is a second fix to the mmotm patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch.

Link: https://lkml.kernel.org/r/20210516140705.GB3735@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmstat.c~mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix
+++ a/mm/vmstat.c
@@ -782,7 +782,9 @@ static int refresh_cpu_vm_stats(bool do_
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
+#ifdef CONFIG_NUMA
 		struct per_cpu_pages __percpu *pcp = zone->per_cpu_pageset;
+#endif
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
 			int v;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch-fix-2.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction-fix.patch
mm-page_alloc-move-free_the_page.patch
mm-page_alloc-allow-high-order-pages-to-be-stored-on-the-per-cpu-lists.patch
mm-page_alloc-split-pcp-high-across-all-online-cpus-for-cpuless-nodes.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

