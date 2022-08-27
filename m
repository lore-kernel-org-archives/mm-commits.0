Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D63ECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 01:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345037AbiH0BgZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 21:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiH0BgY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 21:36:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1302FDF092
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 18:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A427E61CD3
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 01:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE708C433D6;
        Sat, 27 Aug 2022 01:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661564182;
        bh=MF5NogsqWeIxZAZE2lGC50vPMPjNu0GQT+bkNxInBXY=;
        h=Date:To:From:Subject:From;
        b=CPVDue0gyUY+iX6aO/nvjk739yJ0l3Rvlc3ZOaVcbZBffnFkyeEdm5JA7XI7kpvzq
         7SwkKH02xRuAC6aYZYh/UJsnOkb+tMlMx0qoLbEHcHhKCHtRMuoeHfR4clI9gWWgUy
         QkZhMlXiG5ksInWGXd3iRc7/Ml96FFUADfTkmCzo=
Date:   Fri, 26 Aug 2022 18:36:21 -0700
To:     mm-commits@vger.kernel.org, mhocko@kernel.org, feng.tang@intel.com,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-deduplicate-cacheline-padding-code.patch added to mm-unstable branch
Message-Id: <20220827013621.EE708C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: deduplicate cacheline padding code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-deduplicate-cacheline-padding-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-deduplicate-cacheline-padding-code.patch

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
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: deduplicate cacheline padding code
Date: Fri, 26 Aug 2022 23:06:42 +0000

There are three users (mmzone.h, memcontrol.h, page_counter.h) using
similar code for forcing cacheline padding between fields of different
structures.  Dedup that code.

Link: https://lkml.kernel.org/r/20220826230642.566725-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Suggested-by: Feng Tang <feng.tang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
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
@@ -1194,7 +1180,7 @@ typedef struct pglist_data {
 #endif /* CONFIG_NUMA */
 
 	/* Write-intensive fields used by page reclaim */
-	ZONE_PADDING(_pad1_)
+	CACHELINE_PADDING(_pad1_);
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	/*
@@ -1239,7 +1225,7 @@ typedef struct pglist_data {
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

revert-memcg-cleanup-racy-sum-avoidance-code.patch
mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch
mm-page_counter-rearrange-struct-page_counter-fields.patch
memcg-increase-memcg_charge_batch-to-64.patch
mm-deduplicate-cacheline-padding-code.patch

