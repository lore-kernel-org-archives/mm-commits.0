Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E72C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiI0C4H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiI0Cz3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C305D4B0F4
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B623B8190D
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAB0C433D6;
        Tue, 27 Sep 2022 02:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247018;
        bh=jio57l0gB6jx9Rgip4fJ7Ph5C8tFfJB1UFlIwwibh2o=;
        h=Date:To:From:Subject:From;
        b=LMEF9jCk3xV5nuEDKcW+9ev0q6/j/Q7rw53Qpw+O6ioaiKrfu9gfWXrrvYwF6OYug
         33TYwzXMFoTHeLHU34LqfO+GdOkVUTwrHey5vPrOVtynKGIIE1GYTicJAnNRdLuKdp
         s2uHQ6uHPZzvt8dgBRg6noSM6WJls4Ods62ea4/s=
Date:   Mon, 26 Sep 2022 19:50:17 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com, feng.tang@intel.com,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-deduplicate-cacheline-padding-code.patch removed from -mm tree
Message-Id: <20220927025018.0CAB0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: deduplicate cacheline padding code
has been removed from the -mm tree.  Its filename was
     mm-deduplicate-cacheline-padding-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: deduplicate cacheline padding code
Date: Fri, 26 Aug 2022 23:06:42 +0000

There are three users (mmzone.h, memcontrol.h, page_counter.h) using
similar code for forcing cacheline padding between fields of different
structures.  Dedup that code.

Link: https://lkml.kernel.org/r/20220826230642.566725-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Suggested-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cache.h        |   13 +++++++++++++
 include/linux/memcontrol.h   |   13 ++-----------
 include/linux/mmzone.h       |   24 +++++-------------------
 include/linux/page_counter.h |   13 ++-----------
 4 files changed, 22 insertions(+), 41 deletions(-)

--- a/include/linux/cache.h~mm-deduplicate-cacheline-padding-code
+++ a/include/linux/cache.h
@@ -85,4 +85,17 @@
 #define cache_line_size()	L1_CACHE_BYTES
 #endif
 
+/*
+ * Helper to add padding within a struct to ensure data fall into separate
+ * cachelines.
+ */
+#if defined(CONFIG_SMP)
+struct cacheline_padding {
+	char x[0];
+} ____cacheline_internodealigned_in_smp;
+#define CACHELINE_PADDING(name)		struct cacheline_padding name
+#else
+#define CACHELINE_PADDING(name)
+#endif
+
 #endif /* __LINUX_CACHE_H */
--- a/include/linux/memcontrol.h~mm-deduplicate-cacheline-padding-code
+++ a/include/linux/memcontrol.h
@@ -185,15 +185,6 @@ struct mem_cgroup_thresholds {
 	struct mem_cgroup_threshold_ary *spare;
 };
 
-#if defined(CONFIG_SMP)
-struct memcg_padding {
-	char x[0];
-} ____cacheline_internodealigned_in_smp;
-#define MEMCG_PADDING(name)      struct memcg_padding name
-#else
-#define MEMCG_PADDING(name)
-#endif
-
 /*
  * Remember four most recent foreign writebacks with dirty pages in this
  * cgroup.  Inode sharing is expected to be uncommon and, even if we miss
@@ -304,7 +295,7 @@ struct mem_cgroup {
 	spinlock_t		move_lock;
 	unsigned long		move_lock_flags;
 
-	MEMCG_PADDING(_pad1_);
+	CACHELINE_PADDING(_pad1_);
 
 	/* memory.stat */
 	struct memcg_vmstats	vmstats;
@@ -326,7 +317,7 @@ struct mem_cgroup {
 	struct list_head objcg_list;
 #endif
 
-	MEMCG_PADDING(_pad2_);
+	CACHELINE_PADDING(_pad2_);
 
 	/*
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
--- a/include/linux/mmzone.h~mm-deduplicate-cacheline-padding-code
+++ a/include/linux/mmzone.h
@@ -121,20 +121,6 @@ static inline bool free_area_empty(struc
 
 struct pglist_data;
 
-/*
- * Add a wild amount of padding here to ensure data fall into separate
- * cachelines.  There are very few zone structures in the machine, so space
- * consumption is not a concern here.
- */
-#if defined(CONFIG_SMP)
-struct zone_padding {
-	char x[0];
-} ____cacheline_internodealigned_in_smp;
-#define ZONE_PADDING(name)	struct zone_padding name;
-#else
-#define ZONE_PADDING(name)
-#endif
-
 #ifdef CONFIG_NUMA
 enum numa_stat_item {
 	NUMA_HIT,		/* allocated in intended node */
@@ -837,7 +823,7 @@ struct zone {
 	int initialized;
 
 	/* Write-intensive fields used from the page allocator */
-	ZONE_PADDING(_pad1_)
+	CACHELINE_PADDING(_pad1_);
 
 	/* free areas of different sizes */
 	struct free_area	free_area[MAX_ORDER];
@@ -849,7 +835,7 @@ struct zone {
 	spinlock_t		lock;
 
 	/* Write-intensive fields used by compaction and vmstats. */
-	ZONE_PADDING(_pad2_)
+	CACHELINE_PADDING(_pad2_);
 
 	/*
 	 * When free pages are below this point, additional steps are taken
@@ -886,7 +872,7 @@ struct zone {
 
 	bool			contiguous;
 
-	ZONE_PADDING(_pad3_)
+	CACHELINE_PADDING(_pad3_);
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
@@ -1196,7 +1182,7 @@ typedef struct pglist_data {
 #endif /* CONFIG_NUMA */
 
 	/* Write-intensive fields used by page reclaim */
-	ZONE_PADDING(_pad1_)
+	CACHELINE_PADDING(_pad1_);
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	/*
@@ -1241,7 +1227,7 @@ typedef struct pglist_data {
 	struct lru_gen_mm_walk	mm_walk;
 #endif
 
-	ZONE_PADDING(_pad2_)
+	CACHELINE_PADDING(_pad2_);
 
 	/* Per-node vmstats */
 	struct per_cpu_nodestat __percpu *per_cpu_nodestats;
--- a/include/linux/page_counter.h~mm-deduplicate-cacheline-padding-code
+++ a/include/linux/page_counter.h
@@ -7,22 +7,13 @@
 #include <linux/kernel.h>
 #include <asm/page.h>
 
-#if defined(CONFIG_SMP)
-struct pc_padding {
-	char x[0];
-} ____cacheline_internodealigned_in_smp;
-#define PC_PADDING(name)	struct pc_padding name
-#else
-#define PC_PADDING(name)
-#endif
-
 struct page_counter {
 	/*
 	 * Make sure 'usage' does not share cacheline with any other field. The
 	 * memcg->memory.usage is a hot member of struct mem_cgroup.
 	 */
 	atomic_long_t usage;
-	PC_PADDING(_pad1_);
+	CACHELINE_PADDING(_pad1_);
 
 	/* effective memory.min and memory.min usage tracking */
 	unsigned long emin;
@@ -38,7 +29,7 @@ struct page_counter {
 	unsigned long failcnt;
 
 	/* Keep all the read most fields in a separete cacheline. */
-	PC_PADDING(_pad2_);
+	CACHELINE_PADDING(_pad2_);
 
 	unsigned long min;
 	unsigned long low;
_

Patches currently in -mm which might be from shakeelb@google.com are

revert-net-set-proper-memcg-for-net_init-hooks-allocations.patch
memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch
memcg-rearrange-code.patch
memcg-reduce-size-of-memcg-vmstats-structures.patch

