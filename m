Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3996EECAAD1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 20:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiHaUsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiHaUsL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 16:48:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04A0F23CC
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 13:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97035B82012
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 20:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB28C433D6;
        Wed, 31 Aug 2022 20:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661978887;
        bh=7mhOUHpQwFEddVZ4cDkWMTJcFIHeATKHSnSY8HVgFTA=;
        h=Date:To:From:Subject:From;
        b=KmvqYZEhmy0JXjrcKZ+Pd02a5mbCJWTcvVOeDl2gFmrVMPqkHw3nMDnpto5d3VWxO
         AtRHCElIUsvhFIuP4ZzvHMfZiHJ06TFmoLOlcH49BopXWsXdj8lnwBY0ShnB3qa8bN
         Q/SKPk5L07/pRHhG/k6YT5e59s6RKLbjPcD1hjOA=
Date:   Wed, 31 Aug 2022 13:48:06 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@suse.de, hch@infradead.org, hannes@cmpxchg.org,
        dan.carpenter@oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix.patch removed from -mm tree
Message-Id: <20220831204807.1CB28C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix
has been removed from the -mm tree.  Its filename was
     mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix
Date: Tue Aug 30 06:53:22 PM PDT 2022

fix build, remove unneeded __show_mem() arg

lib/show_mem.c: In function '__show_mem':
lib/show_mem.c:17:9: error: too many arguments to function 'show_free_areas'
   17 |         show_free_areas(filter, nodemask, max_zone_idx);
      |         ^~~~~~~~~~~~~~~
In file included from lib/show_mem.c:8:
./include/linux/mm.h:1842:28: note: declared here
 1842 | static void __maybe_unused show_free_areas(unsigned int flags, nodemask_t *nodemask)
      |                            ^~~~~~~~~~~~~~~

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 lib/show_mem.c     |    4 ++--
 mm/oom_kill.c      |    2 +-
 mm/page_alloc.c    |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix
+++ a/include/linux/mm.h
@@ -2583,10 +2583,10 @@ extern int __meminit init_per_zone_wmark
 extern void mem_init(void);
 extern void __init mmap_init(void);
 
-extern void __show_mem(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
+extern void __show_mem(unsigned int flags, nodemask_t *nodemask);
 static inline void show_mem(unsigned int flags, nodemask_t *nodemask)
 {
-	__show_mem(flags, nodemask, MAX_NR_ZONES - 1);
+	__show_mem(flags, nodemask);
 }
 extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
--- a/lib/show_mem.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix
+++ a/lib/show_mem.c
@@ -8,13 +8,13 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 
-void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
+void __show_mem(unsigned int filter, nodemask_t *nodemask)
 {
 	pg_data_t *pgdat;
 	unsigned long total = 0, reserved = 0, highmem = 0;
 
 	printk("Mem-Info:\n");
-	show_free_areas(filter, nodemask, max_zone_idx);
+	show_free_areas(filter, nodemask);
 
 	for_each_online_pgdat(pgdat) {
 		int zoneid;
--- a/mm/oom_kill.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix
+++ a/mm/oom_kill.c
@@ -461,7 +461,7 @@ static void dump_header(struct oom_contr
 	if (is_memcg_oom(oc))
 		mem_cgroup_print_oom_meminfo(oc->memcg);
 	else {
-		__show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask, gfp_zone(oc->gfp_mask));
+		__show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask);
 		if (should_dump_unreclaim_slab())
 			dump_unreclaimable_slab();
 	}
--- a/mm/page_alloc.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update-fix
+++ a/mm/page_alloc.c
@@ -4329,7 +4329,7 @@ static void warn_alloc_show_mem(gfp_t gf
 	if (!in_task() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
-	__show_mem(filter, nodemask, gfp_zone(gfp_mask));
+	__show_mem(filter, nodemask);
 }
 
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch
hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

