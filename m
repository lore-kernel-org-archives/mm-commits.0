Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625C0C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245601AbiDLEXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345874AbiDLEWt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F192A243
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2F5E6178A
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B17CC385A1;
        Tue, 12 Apr 2022 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737217;
        bh=vNFFoOXCUvkriaHaFCOMTgoyYKwDpn1hACAqkTGXaT4=;
        h=Date:To:From:Subject:From;
        b=i0dJfrlt34WhwWiEg8la1y5m1Ex73fbu0uIfjGggdudU5frAuiwEMMH0WnEf6f2iP
         TEKD3uJaGC4bE4+tSeO7pZWUSI5ZjevAaA3Cpy+80phW/qzNUFtj1DYClh5pJoTRZb
         vAuDMF1TE8czj00dyoL9nRTIsCAUBYqkFy2paGnE=
Date:   Mon, 11 Apr 2022 21:20:16 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-kill-switch.patch added to -mm tree
Message-Id: <20220412042017.4B17CC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: kill switch
has been added to the -mm tree.  Its filename is
     mm-multi-gen-lru-kill-switch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-multi-gen-lru-kill-switch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-multi-gen-lru-kill-switch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: kill switch

Add /sys/kernel/mm/lru_gen/enabled as a kill switch. Components that
can be disabled include:
  0x0001: the multi-gen LRU core
  0x0002: walking page table, when arch_has_hw_pte_young() returns
          true
  0x0004: clearing the accessed bit in non-leaf PMD entries, when
          CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG=y
  [yYnN]: apply to all the components above
E.g.,
  echo y >/sys/kernel/mm/lru_gen/enabled
  cat /sys/kernel/mm/lru_gen/enabled
  0x0007
  echo 5 >/sys/kernel/mm/lru_gen/enabled
  cat /sys/kernel/mm/lru_gen/enabled
  0x0005

NB: the page table walks happen on the scale of seconds under heavy memory
pressure, in which case the mmap_lock contention is a lesser concern,
compared with the LRU lock contention and the I/O congestion.  So far the
only well-known case of the mmap_lock contention happens on Android, due
to Scudo [1] which allocates several thousand VMAs for merely a few
hundred MBs.  The SPF and the Maple Tree also have provided their own
assessments [2][3].  However, if walking page tables does worsen the
mmap_lock contention, the kill switch can be used to disable it.  In this
case the multi-gen LRU will suffer a minor performance degradation, as
shown previously.

Clearing the accessed bit in non-leaf PMD entries can also be disabled,
since this behavior was not tested on x86 varieties other than Intel and
AMD.

[1] https://source.android.com/devices/tech/debug/scudo
[2] https://lore.kernel.org/r/20220128131006.67712-1-michel@lespinasse.org/
[3] https://lore.kernel.org/r/20220202024137.2516438-1-Liam.Howlett@oracle.com/

Link: https://lkml.kernel.org/r/20220407031525.2368067-11-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Acked-by: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Acked-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Acked-by: Steven Barrett <steven@liquorix.net>
Acked-by: Suleiman Souhlal <suleiman@google.com>
Tested-by: Daniel Byrne <djbyrne@mtu.edu>
Tested-by: Donald Carr <d@chaos-reins.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Tested-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Tested-by: Shuang Zhai <szhai2@cs.rochester.edu>
Tested-by: Sofia Trinh <sofia.trinh@edi.works>
Tested-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/cgroup.h~mm-multi-gen-lru-kill-switch
+++ a/include/linux/cgroup.h
@@ -432,6 +432,18 @@ static inline void cgroup_put(struct cgr
 	css_put(&cgrp->self);
 }
 
+extern struct mutex cgroup_mutex;
+
+static inline void cgroup_lock(void)
+{
+	mutex_lock(&cgroup_mutex);
+}
+
+static inline void cgroup_unlock(void)
+{
+	mutex_unlock(&cgroup_mutex);
+}
+
 /**
  * task_css_set_check - obtain a task's css_set with extra access conditions
  * @task: the task to obtain css_set for
@@ -446,7 +458,6 @@ static inline void cgroup_put(struct cgr
  * as locks used during the cgroup_subsys::attach() methods.
  */
 #ifdef CONFIG_PROVE_RCU
-extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 #define task_css_set_check(task, __c)					\
 	rcu_dereference_check((task)->cgroups,				\
@@ -708,6 +719,8 @@ struct cgroup;
 static inline u64 cgroup_id(const struct cgroup *cgrp) { return 1; }
 static inline void css_get(struct cgroup_subsys_state *css) {}
 static inline void css_put(struct cgroup_subsys_state *css) {}
+static inline void cgroup_lock(void) {}
+static inline void cgroup_unlock(void) {}
 static inline int cgroup_attach_task_all(struct task_struct *from,
 					 struct task_struct *t) { return 0; }
 static inline int cgroupstats_build(struct cgroupstats *stats,
--- a/include/linux/mm_inline.h~mm-multi-gen-lru-kill-switch
+++ a/include/linux/mm_inline.h
@@ -108,7 +108,15 @@ static __always_inline enum lru_list fol
 
 static inline bool lru_gen_enabled(void)
 {
-	return true;
+#ifdef CONFIG_LRU_GEN_ENABLED
+	DECLARE_STATIC_KEY_TRUE(lru_gen_caps[NR_LRU_GEN_CAPS]);
+
+	return static_branch_likely(&lru_gen_caps[LRU_GEN_CORE]);
+#else
+	DECLARE_STATIC_KEY_FALSE(lru_gen_caps[NR_LRU_GEN_CAPS]);
+
+	return static_branch_unlikely(&lru_gen_caps[LRU_GEN_CORE]);
+#endif
 }
 
 static inline bool lru_gen_in_fault(void)
@@ -198,7 +206,7 @@ static inline bool lru_gen_add_folio(str
 	int zone = folio_zonenum(folio);
 	struct lru_gen_struct *lrugen = &lruvec->lrugen;
 
-	if (folio_test_unevictable(folio))
+	if (folio_test_unevictable(folio) || !lrugen->enabled)
 		return false;
 	/*
 	 * There are three common cases for this page:
--- a/include/linux/mmzone.h~mm-multi-gen-lru-kill-switch
+++ a/include/linux/mmzone.h
@@ -384,6 +384,13 @@ enum {
 	LRU_GEN_FILE,
 };
 
+enum {
+	LRU_GEN_CORE,
+	LRU_GEN_MM_WALK,
+	LRU_GEN_NONLEAF_YOUNG,
+	NR_LRU_GEN_CAPS
+};
+
 #define MIN_LRU_BATCH		BITS_PER_LONG
 #define MAX_LRU_BATCH		(MIN_LRU_BATCH * 128)
 
@@ -422,6 +429,8 @@ struct lru_gen_struct {
 	/* can be modified without holding the LRU lock */
 	atomic_long_t evicted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
+	/* whether the multi-gen LRU is enabled */
+	bool enabled;
 };
 
 enum {
--- a/kernel/cgroup/cgroup-internal.h~mm-multi-gen-lru-kill-switch
+++ a/kernel/cgroup/cgroup-internal.h
@@ -165,7 +165,6 @@ struct cgroup_mgctx {
 #define DEFINE_CGROUP_MGCTX(name)						\
 	struct cgroup_mgctx name = CGROUP_MGCTX_INIT(name)
 
-extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
--- a/mm/Kconfig~mm-multi-gen-lru-kill-switch
+++ a/mm/Kconfig
@@ -935,6 +935,12 @@ config LRU_GEN
 	help
 	  A high performance LRU implementation to overcommit memory.
 
+config LRU_GEN_ENABLED
+	bool "Enable by default"
+	depends on LRU_GEN
+	help
+	  This option enables the multi-gen LRU by default.
+
 config LRU_GEN_STATS
 	bool "Full stats for debugging"
 	depends on LRU_GEN
--- a/mm/vmscan.c~mm-multi-gen-lru-kill-switch
+++ a/mm/vmscan.c
@@ -52,6 +52,7 @@
 #include <linux/psi.h>
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
+#include <linux/ctype.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -3004,6 +3005,12 @@ static bool can_age_anon_pages(struct pg
 
 #ifdef CONFIG_LRU_GEN
 
+#ifdef CONFIG_LRU_GEN_ENABLED
+DEFINE_STATIC_KEY_ARRAY_TRUE(lru_gen_caps, NR_LRU_GEN_CAPS);
+#else
+DEFINE_STATIC_KEY_ARRAY_FALSE(lru_gen_caps, NR_LRU_GEN_CAPS);
+#endif
+
 /******************************************************************************
  *                          shorthand helpers
  ******************************************************************************/
@@ -3040,6 +3047,15 @@ static int folio_lru_tier(struct folio *
 	return lru_tier_from_refs(refs);
 }
 
+static bool get_cap(int cap)
+{
+#ifdef CONFIG_LRU_GEN_ENABLED
+	return static_branch_likely(&lru_gen_caps[cap]);
+#else
+	return static_branch_unlikely(&lru_gen_caps[cap]);
+#endif
+}
+
 static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
@@ -3848,7 +3864,8 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG))
+			if (IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG) &&
+			    get_cap(LRU_GEN_NONLEAF_YOUNG))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
@@ -3955,10 +3972,12 @@ restart:
 		priv->mm_stats[MM_PMD_TOTAL]++;
 
 #ifdef CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG
-		if (!pmd_young(val))
-			continue;
+		if (get_cap(LRU_GEN_NONLEAF_YOUNG)) {
+			if (!pmd_young(val))
+				continue;
 
-		walk_pmd_range_locked(pud, addr, vma, walk, &pos);
+			walk_pmd_range_locked(pud, addr, vma, walk, &pos);
+		}
 #endif
 		if (!priv->full_scan && !test_bloom_filter(priv->lruvec, priv->max_seq, pmd + i))
 			continue;
@@ -4195,7 +4214,7 @@ static bool try_to_inc_max_seq(struct lr
 	 * handful of PTEs. Spreading the work out over a period of time usually
 	 * is less efficient, but it avoids bursty page faults.
 	 */
-	if (!full_scan && !arch_has_hw_pte_young()) {
+	if (!full_scan && (!arch_has_hw_pte_young() || !get_cap(LRU_GEN_MM_WALK))) {
 		success = iterate_mm_list_nowalk(lruvec, max_seq);
 		goto done;
 	}
@@ -4926,6 +4945,211 @@ static void lru_gen_shrink_lruvec(struct
 }
 
 /******************************************************************************
+ *                          state change
+ ******************************************************************************/
+
+static bool __maybe_unused state_is_valid(struct lruvec *lruvec)
+{
+	struct lru_gen_struct *lrugen = &lruvec->lrugen;
+
+	if (lrugen->enabled) {
+		enum lru_list lru;
+
+		for_each_evictable_lru(lru) {
+			if (!list_empty(&lruvec->lists[lru]))
+				return false;
+		}
+	} else {
+		int gen, type, zone;
+
+		for_each_gen_type_zone(gen, type, zone) {
+			if (!list_empty(&lrugen->lists[gen][type][zone]))
+				return false;
+
+			/* unlikely but not a bug when reset_batch_size() is pending */
+			VM_WARN_ON(lrugen->nr_pages[gen][type][zone]);
+		}
+	}
+
+	return true;
+}
+
+static bool fill_evictable(struct lruvec *lruvec)
+{
+	enum lru_list lru;
+	int remaining = MAX_LRU_BATCH;
+
+	for_each_evictable_lru(lru) {
+		int type = is_file_lru(lru);
+		bool active = is_active_lru(lru);
+		struct list_head *head = &lruvec->lists[lru];
+
+		while (!list_empty(head)) {
+			bool success;
+			struct folio *folio = lru_to_folio(head);
+
+			VM_BUG_ON_FOLIO(folio_test_unevictable(folio), folio);
+			VM_BUG_ON_FOLIO(folio_test_active(folio) != active, folio);
+			VM_BUG_ON_FOLIO(folio_is_file_lru(folio) != type, folio);
+			VM_BUG_ON_FOLIO(folio_lru_gen(folio) < MAX_NR_GENS, folio);
+
+			lruvec_del_folio(lruvec, folio);
+			success = lru_gen_add_folio(lruvec, folio, false);
+			VM_BUG_ON(!success);
+
+			if (!--remaining)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static bool drain_evictable(struct lruvec *lruvec)
+{
+	int gen, type, zone;
+	int remaining = MAX_LRU_BATCH;
+
+	for_each_gen_type_zone(gen, type, zone) {
+		struct list_head *head = &lruvec->lrugen.lists[gen][type][zone];
+
+		while (!list_empty(head)) {
+			bool success;
+			struct folio *folio = lru_to_folio(head);
+
+			VM_BUG_ON_FOLIO(folio_test_unevictable(folio), folio);
+			VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
+			VM_BUG_ON_FOLIO(folio_is_file_lru(folio) != type, folio);
+			VM_BUG_ON_FOLIO(folio_zonenum(folio) != zone, folio);
+
+			success = lru_gen_del_folio(lruvec, folio, false);
+			VM_BUG_ON(!success);
+			lruvec_add_folio(lruvec, folio);
+
+			if (!--remaining)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static void lru_gen_change_state(bool enable)
+{
+	static DEFINE_MUTEX(state_mutex);
+
+	struct mem_cgroup *memcg;
+
+	cgroup_lock();
+	cpus_read_lock();
+	get_online_mems();
+	mutex_lock(&state_mutex);
+
+	if (enable == lru_gen_enabled())
+		goto unlock;
+
+	if (enable)
+		static_branch_enable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
+	else
+		static_branch_disable_cpuslocked(&lru_gen_caps[LRU_GEN_CORE]);
+
+	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	do {
+		int nid;
+
+		for_each_node(nid) {
+			struct lruvec *lruvec = get_lruvec(memcg, nid);
+
+			if (!lruvec)
+				continue;
+
+			spin_lock_irq(&lruvec->lru_lock);
+
+			VM_BUG_ON(!seq_is_valid(lruvec));
+			VM_BUG_ON(!state_is_valid(lruvec));
+
+			lruvec->lrugen.enabled = enable;
+
+			while (!(enable ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
+				spin_unlock_irq(&lruvec->lru_lock);
+				cond_resched();
+				spin_lock_irq(&lruvec->lru_lock);
+			}
+
+			spin_unlock_irq(&lruvec->lru_lock);
+		}
+
+		cond_resched();
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+unlock:
+	mutex_unlock(&state_mutex);
+	put_online_mems();
+	cpus_read_unlock();
+	cgroup_unlock();
+}
+
+/******************************************************************************
+ *                          sysfs interface
+ ******************************************************************************/
+
+static ssize_t show_enable(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	unsigned int caps = 0;
+
+	if (get_cap(LRU_GEN_CORE))
+		caps |= BIT(LRU_GEN_CORE);
+
+	if (arch_has_hw_pte_young() && get_cap(LRU_GEN_MM_WALK))
+		caps |= BIT(LRU_GEN_MM_WALK);
+
+	if (IS_ENABLED(CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG) && get_cap(LRU_GEN_NONLEAF_YOUNG))
+		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
+
+	return snprintf(buf, PAGE_SIZE, "0x%04x\n", caps);
+}
+
+static ssize_t store_enable(struct kobject *kobj, struct kobj_attribute *attr,
+			    const char *buf, size_t len)
+{
+	int i;
+	unsigned int caps;
+
+	if (tolower(*buf) == 'n')
+		caps = 0;
+	else if (tolower(*buf) == 'y')
+		caps = -1;
+	else if (kstrtouint(buf, 0, &caps))
+		return -EINVAL;
+
+	for (i = 0; i < NR_LRU_GEN_CAPS; i++) {
+		bool enable = caps & BIT(i);
+
+		if (i == LRU_GEN_CORE)
+			lru_gen_change_state(enable);
+		else if (enable)
+			static_branch_enable(&lru_gen_caps[i]);
+		else
+			static_branch_disable(&lru_gen_caps[i]);
+	}
+
+	return len;
+}
+
+static struct kobj_attribute lru_gen_enabled_attr = __ATTR(
+	enabled, 0644, show_enable, store_enable
+);
+
+static struct attribute *lru_gen_attrs[] = {
+	&lru_gen_enabled_attr.attr,
+	NULL
+};
+
+static struct attribute_group lru_gen_attr_group = {
+	.name = "lru_gen",
+	.attrs = lru_gen_attrs,
+};
+
+/******************************************************************************
  *                          initialization
  ******************************************************************************/
 
@@ -4935,6 +5159,7 @@ void lru_gen_init_lruvec(struct lruvec *
 	struct lru_gen_struct *lrugen = &lruvec->lrugen;
 
 	lrugen->max_seq = MIN_NR_GENS + 1;
+	lrugen->enabled = lru_gen_enabled();
 
 	for_each_gen_type_zone(gen, type, zone)
 		INIT_LIST_HEAD(&lrugen->lists[gen][type][zone]);
@@ -4975,6 +5200,9 @@ static int __init init_lru_gen(void)
 	BUILD_BUG_ON(BIT(LRU_GEN_WIDTH) <= MAX_NR_GENS);
 	BUILD_BUG_ON(sizeof(MM_STAT_CODES) != NR_MM_STATS + 1);
 
+	if (sysfs_create_group(mm_kobj, &lru_gen_attr_group))
+		pr_err("lru_gen: failed to create sysfs group\n");
+
 	return 0;
 };
 late_initcall(init_lru_gen);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-x86-arm64-add-arch_has_hw_pte_young.patch
mm-x86-add-config_arch_has_nonleaf_pmd_young.patch
mm-vmscanc-refactor-shrink_node.patch
revert-include-linux-mm_inlineh-fold-__update_lru_size-into-its-sole-caller.patch
mm-multi-gen-lru-groundwork.patch
mm-multi-gen-lru-minimal-implementation.patch
mm-multi-gen-lru-exploit-locality-in-rmap.patch
mm-multi-gen-lru-support-page-table-walks.patch
mm-multi-gen-lru-optimize-multiple-memcgs.patch
mm-multi-gen-lru-kill-switch.patch
mm-multi-gen-lru-thrashing-prevention.patch
mm-multi-gen-lru-debugfs-interface.patch
mm-multi-gen-lru-admin-guide.patch
mm-multi-gen-lru-design-doc.patch

