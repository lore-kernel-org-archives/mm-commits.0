Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E293C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345586AbiDLEWS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344957AbiDLEWP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A31625E96
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0023061787
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD9EC385A6;
        Tue, 12 Apr 2022 04:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737196;
        bh=zctLpYL/sfgAv2alcaXky58wmoaGZRqQXu9dqyG6atY=;
        h=Date:To:From:Subject:From;
        b=GOeXNHSved0x01SNu2oSgPgSaSHUKEBYHpNGja7XNJO2Tf0x86DQpMe9ACtxGGZIa
         Tb2V8FGYFLRYGkq+o71Ygn6BT6pPXfyx8tHJERmGKNa2Q6dBhncGRpiPVvPor3Tb20
         +aqtFStBD4++iF2fgYX7jViQl34s/g70YrWj2ZP4=
Date:   Mon, 11 Apr 2022 21:19:53 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-groundwork.patch added to -mm tree
Message-Id: <20220412041956.4AD9EC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: groundwork
has been added to the -mm tree.  Its filename is
     mm-multi-gen-lru-groundwork.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-multi-gen-lru-groundwork.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-multi-gen-lru-groundwork.patch

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
Subject: mm: multi-gen LRU: groundwork

Evictable pages are divided into multiple generations for each lruvec. 
The youngest generation number is stored in lrugen->max_seq for both anon
and file types as they are aged on an equal footing.  The oldest
generation numbers are stored in lrugen->min_seq[] separately for anon and
file types as clean file pages can be evicted regardless of swap
constraints.  These three variables are monotonically increasing.

Generation numbers are truncated into order_base_2(MAX_NR_GENS+1) bits in
order to fit into the gen counter in folio->flags.  Each truncated
generation number is an index to lrugen->lists[].  The sliding window
technique is used to track at least MIN_NR_GENS and at most MAX_NR_GENS
generations.  The gen counter stores a value within [1, MAX_NR_GENS] while
a page is on one of lrugen->lists[].  Otherwise it stores 0.

There are two conceptually independent procedures: "the aging", which
produces young generations, and "the eviction", which consumes old
generations.  They form a closed-loop system, i.e., "the page reclaim". 
Both procedures can be invoked from userspace for the purposes of working
set estimation and proactive reclaim.  These features are required to
optimize job scheduling (bin packing) in data centers.  The variable size
of the sliding window is designed for such use cases [1][2].

To avoid confusion, the terms "hot" and "cold" will be applied to the
multi-gen LRU, as a new convention; the terms "active" and "inactive" will
be applied to the active/inactive LRU, as usual.

The protection of hot pages and the selection of cold pages are based on
page access channels and patterns.  There are two access channels: one
through page tables and the other through file descriptors.  The
protection of the former channel is by design stronger because:

1. The uncertainty in determining the access patterns of the former
   channel is higher due to the approximation of the accessed bit.
2. The cost of evicting the former channel is higher due to the TLB
   flushes required and the likelihood of encountering the dirty bit.
3. The penalty of underprotecting the former channel is higher because
   applications usually do not prepare themselves for major page
   faults like they do for blocked I/O. E.g., GUI applications
   commonly use dedicated I/O threads to avoid blocking the rendering
   threads.

There are also two access patterns: one with temporal locality and the
other without.  For the reasons listed above, the former channel is
assumed to follow the former pattern unless VM_SEQ_READ or VM_RAND_READ is
present; the latter channel is assumed to follow the latter pattern unless
outlying refaults have been observed [3][4].

The next patch will address the "outlying refaults".  Three macros, i.e.,
LRU_REFS_WIDTH, LRU_REFS_PGOFF and LRU_REFS_MASK, used later are added in
this patch to make the entire patchset less diffy.

A page is added to the youngest generation on faulting.  The aging needs
to check the accessed bit at least twice before handing this page over to
the eviction.  The first check takes care of the accessed bit set on the
initial fault; the second check makes sure this page has not been used
since then.  This protocol, AKA second chance, requires a minimum of two
generations, hence MIN_NR_GENS.

[1] https://dl.acm.org/doi/10.1145/3297858.3304053
[2] https://dl.acm.org/doi/10.1145/3503222.3507731
[3] https://lwn.net/Articles/495543/
[4] https://lwn.net/Articles/815342/

Link: https://lkml.kernel.org/r/20220407031525.2368067-6-yuzhao@google.com
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


--- a/fs/fuse/dev.c~mm-multi-gen-lru-groundwork
+++ a/fs/fuse/dev.c
@@ -777,7 +777,8 @@ static int fuse_check_page(struct page *
 	       1 << PG_active |
 	       1 << PG_workingset |
 	       1 << PG_reclaim |
-	       1 << PG_waiters))) {
+	       1 << PG_waiters |
+	       LRU_GEN_MASK | LRU_REFS_MASK))) {
 		dump_page(page, "fuse: trying to steal weird page");
 		return 1;
 	}
--- a/include/linux/mm.h~mm-multi-gen-lru-groundwork
+++ a/include/linux/mm.h
@@ -1060,6 +1060,8 @@ vm_fault_t finish_mkwrite_fault(struct v
 #define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
 #define LAST_CPUPID_PGOFF	(ZONES_PGOFF - LAST_CPUPID_WIDTH)
 #define KASAN_TAG_PGOFF		(LAST_CPUPID_PGOFF - KASAN_TAG_WIDTH)
+#define LRU_GEN_PGOFF		(KASAN_TAG_PGOFF - LRU_GEN_WIDTH)
+#define LRU_REFS_PGOFF		(LRU_GEN_PGOFF - LRU_REFS_WIDTH)
 
 /*
  * Define the bit shifts to access each section.  For non-existent
--- a/include/linux/mm_inline.h~mm-multi-gen-lru-groundwork
+++ a/include/linux/mm_inline.h
@@ -40,6 +40,9 @@ static __always_inline void __update_lru
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
+	lockdep_assert_held(&lruvec->lru_lock);
+	WARN_ON_ONCE(nr_pages != (int)nr_pages);
+
 	__mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
@@ -101,11 +104,178 @@ static __always_inline enum lru_list fol
 	return lru;
 }
 
+#ifdef CONFIG_LRU_GEN
+
+static inline bool lru_gen_enabled(void)
+{
+	return true;
+}
+
+static inline bool lru_gen_in_fault(void)
+{
+	return current->in_lru_fault;
+}
+
+static inline int lru_gen_from_seq(unsigned long seq)
+{
+	return seq % MAX_NR_GENS;
+}
+
+static inline bool lru_gen_is_active(struct lruvec *lruvec, int gen)
+{
+	unsigned long max_seq = lruvec->lrugen.max_seq;
+
+	VM_BUG_ON(gen >= MAX_NR_GENS);
+
+	/* see the comment on MIN_NR_GENS */
+	return gen == lru_gen_from_seq(max_seq) || gen == lru_gen_from_seq(max_seq - 1);
+}
+
+static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *folio,
+				       int old_gen, int new_gen)
+{
+	int type = folio_is_file_lru(folio);
+	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
+	struct lru_gen_struct *lrugen = &lruvec->lrugen;
+
+	VM_BUG_ON(old_gen != -1 && old_gen >= MAX_NR_GENS);
+	VM_BUG_ON(new_gen != -1 && new_gen >= MAX_NR_GENS);
+	VM_BUG_ON(old_gen == -1 && new_gen == -1);
+
+	if (old_gen >= 0)
+		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
+			   lrugen->nr_pages[old_gen][type][zone] - delta);
+	if (new_gen >= 0)
+		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
+			   lrugen->nr_pages[new_gen][type][zone] + delta);
+
+	/* addition */
+	if (old_gen < 0) {
+		if (lru_gen_is_active(lruvec, new_gen))
+			lru += LRU_ACTIVE;
+		__update_lru_size(lruvec, lru, zone, delta);
+		return;
+	}
+
+	/* deletion */
+	if (new_gen < 0) {
+		if (lru_gen_is_active(lruvec, old_gen))
+			lru += LRU_ACTIVE;
+		__update_lru_size(lruvec, lru, zone, -delta);
+		return;
+	}
+}
+
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+{
+	int gen;
+	unsigned long old_flags, new_flags;
+	int type = folio_is_file_lru(folio);
+	int zone = folio_zonenum(folio);
+	struct lru_gen_struct *lrugen = &lruvec->lrugen;
+
+	if (folio_test_unevictable(folio))
+		return false;
+	/*
+	 * There are three common cases for this page:
+	 * 1. If it's hot, e.g., freshly faulted in or previously hot and
+	 *    migrated, add it to the youngest generation.
+	 * 2. If it's cold but can't be evicted immediately, i.e., an anon page
+	 *    not in swapcache or a dirty page pending writeback, add it to the
+	 *    second oldest generation.
+	 * 3. Everything else (clean, cold) is added to the oldest generation.
+	 */
+	if (folio_test_active(folio))
+		gen = lru_gen_from_seq(lrugen->max_seq);
+	else if ((type == LRU_GEN_ANON && !folio_test_swapcache(folio)) ||
+		 (folio_test_reclaim(folio) &&
+		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
+		gen = lru_gen_from_seq(lrugen->min_seq[type] + 1);
+	else
+		gen = lru_gen_from_seq(lrugen->min_seq[type]);
+
+	do {
+		new_flags = old_flags = READ_ONCE(folio->flags);
+		VM_BUG_ON_FOLIO(new_flags & LRU_GEN_MASK, folio);
+
+		/* see the comment on MIN_NR_GENS */
+		new_flags &= ~(LRU_GEN_MASK | BIT(PG_active));
+		new_flags |= (gen + 1UL) << LRU_GEN_PGOFF;
+	} while (cmpxchg(&folio->flags, old_flags, new_flags) != old_flags);
+
+	lru_gen_update_size(lruvec, folio, -1, gen);
+	/* for folio_rotate_reclaimable() */
+	if (reclaiming)
+		list_add_tail(&folio->lru, &lrugen->lists[gen][type][zone]);
+	else
+		list_add(&folio->lru, &lrugen->lists[gen][type][zone]);
+
+	return true;
+}
+
+static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+{
+	int gen;
+	unsigned long old_flags, new_flags;
+
+	do {
+		new_flags = old_flags = READ_ONCE(folio->flags);
+		if (!(new_flags & LRU_GEN_MASK))
+			return false;
+
+		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
+		VM_BUG_ON_FOLIO(folio_test_unevictable(folio), folio);
+
+		gen = ((new_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+
+		new_flags &= ~LRU_GEN_MASK;
+		/* for shrink_page_list() */
+		if (reclaiming)
+			new_flags &= ~(BIT(PG_referenced) | BIT(PG_reclaim));
+		else if (lru_gen_is_active(lruvec, gen))
+			new_flags |= BIT(PG_active);
+	} while (cmpxchg(&folio->flags, old_flags, new_flags) != old_flags);
+
+	lru_gen_update_size(lruvec, folio, gen, -1);
+	list_del(&folio->lru);
+
+	return true;
+}
+
+#else
+
+static inline bool lru_gen_enabled(void)
+{
+	return false;
+}
+
+static inline bool lru_gen_in_fault(void)
+{
+	return false;
+}
+
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+{
+	return false;
+}
+
+static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+{
+	return false;
+}
+
+#endif /* CONFIG_LRU_GEN */
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	if (lru_gen_add_folio(lruvec, folio, false))
+		return;
+
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
 	if (lru != LRU_UNEVICTABLE)
@@ -123,6 +293,9 @@ void lruvec_add_folio_tail(struct lruvec
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	if (lru_gen_add_folio(lruvec, folio, true))
+		return;
+
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
 	/* This is not expected to be used on LRU_UNEVICTABLE */
@@ -140,6 +313,9 @@ void lruvec_del_folio(struct lruvec *lru
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	if (lru_gen_del_folio(lruvec, folio, false))
+		return;
+
 	if (lru != LRU_UNEVICTABLE)
 		list_del(&folio->lru);
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
--- a/include/linux/mmzone.h~mm-multi-gen-lru-groundwork
+++ a/include/linux/mmzone.h
@@ -317,6 +317,96 @@ enum lruvec_flags {
 					 */
 };
 
+#endif /* !__GENERATING_BOUNDS_H */
+
+/*
+ * Evictable pages are divided into multiple generations. The youngest and the
+ * oldest generation numbers, max_seq and min_seq, are monotonically increasing.
+ * They form a sliding window of a variable size [MIN_NR_GENS, MAX_NR_GENS]. An
+ * offset within MAX_NR_GENS, gen, indexes the LRU list of the corresponding
+ * generation. The gen counter in folio->flags stores gen+1 while a page is on
+ * one of lrugen->lists[]. Otherwise it stores 0.
+ *
+ * A page is added to the youngest generation on faulting. The aging needs to
+ * check the accessed bit at least twice before handing this page over to the
+ * eviction. The first check takes care of the accessed bit set on the initial
+ * fault; the second check makes sure this page hasn't been used since then.
+ * This process, AKA second chance, requires a minimum of two generations,
+ * hence MIN_NR_GENS. And to maintain ABI compatibility with the active/inactive
+ * LRU, these two generations are considered active; the rest of generations, if
+ * they exist, are considered inactive. See lru_gen_is_active(). PG_active is
+ * always cleared while a page is on one of lrugen->lists[] so that the aging
+ * needs not to worry about it. And it's set again when a page considered active
+ * is isolated for non-reclaiming purposes, e.g., migration. See
+ * lru_gen_add_folio() and lru_gen_del_folio().
+ *
+ * MAX_NR_GENS is set to 4 so that the multi-gen LRU can support twice of the
+ * categories of the active/inactive LRU when keeping track of accesses through
+ * page tables. It requires order_base_2(MAX_NR_GENS+1) bits in folio->flags.
+ */
+#define MIN_NR_GENS		2U
+#define MAX_NR_GENS		4U
+
+#ifndef __GENERATING_BOUNDS_H
+
+struct lruvec;
+
+#define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
+#define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
+
+#ifdef CONFIG_LRU_GEN
+
+enum {
+	LRU_GEN_ANON,
+	LRU_GEN_FILE,
+};
+
+/*
+ * The youngest generation number is stored in max_seq for both anon and file
+ * types as they are aged on an equal footing. The oldest generation numbers are
+ * stored in min_seq[] separately for anon and file types as clean file pages
+ * can be evicted regardless of swap constraints.
+ *
+ * Normally anon and file min_seq are in sync. But if swapping is constrained,
+ * e.g., out of swap space, file min_seq is allowed to advance and leave anon
+ * min_seq behind.
+ */
+struct lru_gen_struct {
+	/* the aging increments the youngest generation number */
+	unsigned long max_seq;
+	/* the eviction increments the oldest generation numbers */
+	unsigned long min_seq[ANON_AND_FILE];
+	/* the multi-gen LRU lists */
+	struct list_head lists[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+	/* the sizes of the above lists */
+	unsigned long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+};
+
+void lru_gen_init_lruvec(struct lruvec *lruvec);
+
+#ifdef CONFIG_MEMCG
+void lru_gen_init_memcg(struct mem_cgroup *memcg);
+void lru_gen_exit_memcg(struct mem_cgroup *memcg);
+#endif
+
+#else /* !CONFIG_LRU_GEN */
+
+static inline void lru_gen_init_lruvec(struct lruvec *lruvec)
+{
+}
+
+#ifdef CONFIG_MEMCG
+static inline void lru_gen_init_memcg(struct mem_cgroup *memcg)
+{
+}
+
+static inline void lru_gen_exit_memcg(struct mem_cgroup *memcg)
+{
+}
+#endif
+
+#endif /* CONFIG_LRU_GEN */
+
 struct lruvec {
 	struct list_head		lists[NR_LRU_LISTS];
 	/* per lruvec lru_lock for memcg */
@@ -334,6 +424,10 @@ struct lruvec {
 	unsigned long			refaults[ANON_AND_FILE];
 	/* Various lruvec state flags (enum lruvec_flags) */
 	unsigned long			flags;
+#ifdef CONFIG_LRU_GEN
+	/* evictable pages divided into generations */
+	struct lru_gen_struct		lrugen;
+#endif
 #ifdef CONFIG_MEMCG
 	struct pglist_data *pgdat;
 #endif
--- a/include/linux/page-flags.h~mm-multi-gen-lru-groundwork
+++ a/include/linux/page-flags.h
@@ -1054,7 +1054,7 @@ static __always_inline void __ClearPageA
 	 1UL << PG_private	| 1UL << PG_private_2	|	\
 	 1UL << PG_writeback	| 1UL << PG_reserved	|	\
 	 1UL << PG_slab		| 1UL << PG_active 	|	\
-	 1UL << PG_unevictable	| __PG_MLOCKED)
+	 1UL << PG_unevictable	| __PG_MLOCKED | LRU_GEN_MASK)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
@@ -1065,7 +1065,7 @@ static __always_inline void __ClearPageA
  * alloc-free cycle to prevent from reusing the page.
  */
 #define PAGE_FLAGS_CHECK_AT_PREP	\
-	(PAGEFLAGS_MASK & ~__PG_HWPOISON)
+	((PAGEFLAGS_MASK & ~__PG_HWPOISON) | LRU_GEN_MASK | LRU_REFS_MASK)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
--- a/include/linux/page-flags-layout.h~mm-multi-gen-lru-groundwork
+++ a/include/linux/page-flags-layout.h
@@ -55,7 +55,8 @@
 #define SECTIONS_WIDTH		0
 #endif
 
-#if ZONES_WIDTH + SECTIONS_WIDTH + NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#if ZONES_WIDTH + LRU_GEN_WIDTH + LRU_REFS_WIDTH + SECTIONS_WIDTH + NODES_SHIFT \
+	<= BITS_PER_LONG - NR_PAGEFLAGS
 #define NODES_WIDTH		NODES_SHIFT
 #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
 #error "Vmemmap: No space for nodes field in page flags"
@@ -89,8 +90,8 @@
 #define LAST_CPUPID_SHIFT 0
 #endif
 
-#if ZONES_WIDTH + SECTIONS_WIDTH + NODES_WIDTH + KASAN_TAG_WIDTH + LAST_CPUPID_SHIFT \
-	<= BITS_PER_LONG - NR_PAGEFLAGS
+#if ZONES_WIDTH + LRU_GEN_WIDTH + LRU_REFS_WIDTH + SECTIONS_WIDTH + NODES_WIDTH + \
+	KASAN_TAG_WIDTH + LAST_CPUPID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
 #define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
 #else
 #define LAST_CPUPID_WIDTH 0
@@ -100,8 +101,8 @@
 #define LAST_CPUPID_NOT_IN_PAGE_FLAGS
 #endif
 
-#if ZONES_WIDTH + SECTIONS_WIDTH + NODES_WIDTH + KASAN_TAG_WIDTH + LAST_CPUPID_WIDTH \
-	> BITS_PER_LONG - NR_PAGEFLAGS
+#if ZONES_WIDTH + LRU_GEN_WIDTH + LRU_REFS_WIDTH + SECTIONS_WIDTH + NODES_WIDTH + \
+	KASAN_TAG_WIDTH + LAST_CPUPID_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
 #error "Not enough bits in page flags"
 #endif
 
--- a/include/linux/sched.h~mm-multi-gen-lru-groundwork
+++ a/include/linux/sched.h
@@ -914,6 +914,10 @@ struct task_struct {
 #ifdef CONFIG_MEMCG
 	unsigned			in_user_fault:1;
 #endif
+#ifdef CONFIG_LRU_GEN
+	/* whether the LRU algorithm may apply to this access */
+	unsigned			in_lru_fault:1;
+#endif
 #ifdef CONFIG_COMPAT_BRK
 	unsigned			brk_randomized:1;
 #endif
--- a/kernel/bounds.c~mm-multi-gen-lru-groundwork
+++ a/kernel/bounds.c
@@ -22,6 +22,13 @@ int main(void)
 	DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
 #endif
 	DEFINE(SPINLOCK_SIZE, sizeof(spinlock_t));
+#ifdef CONFIG_LRU_GEN
+	DEFINE(LRU_GEN_WIDTH, order_base_2(MAX_NR_GENS + 1));
+	DEFINE(LRU_REFS_WIDTH, 0);
+#else
+	DEFINE(LRU_GEN_WIDTH, 0);
+	DEFINE(LRU_REFS_WIDTH, 0);
+#endif
 	/* End of constants */
 
 	return 0;
--- a/mm/huge_memory.c~mm-multi-gen-lru-groundwork
+++ a/mm/huge_memory.c
@@ -2371,7 +2371,8 @@ static void __split_huge_page_tail(struc
 #ifdef CONFIG_64BIT
 			 (1L << PG_arch_2) |
 #endif
-			 (1L << PG_dirty)));
+			 (1L << PG_dirty) |
+			 LRU_GEN_MASK | LRU_REFS_MASK));
 
 	/* ->mapping in first tail page is compound_mapcount */
 	VM_BUG_ON_PAGE(tail > 2 && page_tail->mapping != TAIL_MAPPING,
--- a/mm/Kconfig~mm-multi-gen-lru-groundwork
+++ a/mm/Kconfig
@@ -926,6 +926,14 @@ config PTE_MARKER_UFFD_WP
 	  purposes.  It is required to enable userfaultfd write protection on
 	  file-backed memory types like shmem and hugetlbfs.
 
+config LRU_GEN
+	bool "Multi-Gen LRU"
+	depends on MMU
+	# the following options can use up the spare bits in page flags
+	depends on !MAXSMP && (64BIT || !SPARSEMEM || SPARSEMEM_VMEMMAP)
+	help
+	  A high performance LRU implementation to overcommit memory.
+
 source "mm/damon/Kconfig"
 
 endmenu
--- a/mm/memcontrol.c~mm-multi-gen-lru-groundwork
+++ a/mm/memcontrol.c
@@ -5067,6 +5067,7 @@ static void __mem_cgroup_free(struct mem
 
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
 	__mem_cgroup_free(memcg);
 }
@@ -5125,6 +5126,7 @@ static struct mem_cgroup *mem_cgroup_all
 	memcg->deferred_split_queue.split_queue_len = 0;
 #endif
 	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
+	lru_gen_init_memcg(memcg);
 	return memcg;
 fail:
 	mem_cgroup_id_remove(memcg);
--- a/mm/memory.c~mm-multi-gen-lru-groundwork
+++ a/mm/memory.c
@@ -5074,6 +5074,27 @@ static inline void mm_account_fault(stru
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
 }
 
+#ifdef CONFIG_LRU_GEN
+static void lru_gen_enter_fault(struct vm_area_struct *vma)
+{
+	/* the LRU algorithm doesn't apply to sequential or random reads */
+	current->in_lru_fault = !(vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ));
+}
+
+static void lru_gen_exit_fault(void)
+{
+	current->in_lru_fault = false;
+}
+#else
+static void lru_gen_enter_fault(struct vm_area_struct *vma)
+{
+}
+
+static void lru_gen_exit_fault(void)
+{
+}
+#endif /* CONFIG_LRU_GEN */
+
 /*
  * By the time we get here, we already hold the mm semaphore
  *
@@ -5105,11 +5126,15 @@ vm_fault_t handle_mm_fault(struct vm_are
 	if (flags & FAULT_FLAG_USER)
 		mem_cgroup_enter_user_fault();
 
+	lru_gen_enter_fault(vma);
+
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		ret = hugetlb_fault(vma->vm_mm, vma, address, flags);
 	else
 		ret = __handle_mm_fault(vma, address, flags);
 
+	lru_gen_exit_fault();
+
 	if (flags & FAULT_FLAG_USER) {
 		mem_cgroup_exit_user_fault();
 		/*
--- a/mm/mm_init.c~mm-multi-gen-lru-groundwork
+++ a/mm/mm_init.c
@@ -65,14 +65,16 @@ void __init mminit_verify_pageflags_layo
 
 	shift = 8 * sizeof(unsigned long);
 	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH
-		- LAST_CPUPID_SHIFT - KASAN_TAG_WIDTH;
+		- LAST_CPUPID_SHIFT - KASAN_TAG_WIDTH - LRU_GEN_WIDTH - LRU_REFS_WIDTH;
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_widths",
-		"Section %d Node %d Zone %d Lastcpupid %d Kasantag %d Flags %d\n",
+		"Section %d Node %d Zone %d Lastcpupid %d Kasantag %d Gen %d Tier %d Flags %d\n",
 		SECTIONS_WIDTH,
 		NODES_WIDTH,
 		ZONES_WIDTH,
 		LAST_CPUPID_WIDTH,
 		KASAN_TAG_WIDTH,
+		LRU_GEN_WIDTH,
+		LRU_REFS_WIDTH,
 		NR_PAGEFLAGS);
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_shifts",
 		"Section %d Node %d Zone %d Lastcpupid %d Kasantag %d\n",
--- a/mm/mmzone.c~mm-multi-gen-lru-groundwork
+++ a/mm/mmzone.c
@@ -88,6 +88,8 @@ void lruvec_init(struct lruvec *lruvec)
 	 * Poison its list head, so that any operations on it would crash.
 	 */
 	list_del(&lruvec->lists[LRU_UNEVICTABLE]);
+
+	lru_gen_init_lruvec(lruvec);
 }
 
 #if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS)
--- a/mm/swap.c~mm-multi-gen-lru-groundwork
+++ a/mm/swap.c
@@ -460,6 +460,11 @@ void folio_add_lru(struct folio *folio)
 	VM_BUG_ON_FOLIO(folio_test_active(folio) && folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
+	/* see the comment in lru_gen_add_folio() */
+	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
+	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
+		folio_set_active(folio);
+
 	folio_get(folio);
 	local_lock(&lru_pvecs.lock);
 	pvec = this_cpu_ptr(&lru_pvecs.lru_add);
@@ -551,7 +556,7 @@ static void lru_deactivate_file_fn(struc
 
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
 {
-	if (PageActive(page) && !PageUnevictable(page)) {
+	if (!PageUnevictable(page) && (PageActive(page) || lru_gen_enabled())) {
 		int nr_pages = thp_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec);
@@ -666,7 +671,7 @@ void deactivate_file_folio(struct folio
  */
 void deactivate_page(struct page *page)
 {
-	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
+	if (PageLRU(page) && !PageUnevictable(page) && (PageActive(page) || lru_gen_enabled())) {
 		struct pagevec *pvec;
 
 		local_lock(&lru_pvecs.lock);
--- a/mm/vmscan.c~mm-multi-gen-lru-groundwork
+++ a/mm/vmscan.c
@@ -2983,6 +2983,81 @@ static bool can_age_anon_pages(struct pg
 	return can_demote(pgdat->node_id, sc);
 }
 
+#ifdef CONFIG_LRU_GEN
+
+/******************************************************************************
+ *                          shorthand helpers
+ ******************************************************************************/
+
+#define for_each_gen_type_zone(gen, type, zone)				\
+	for ((gen) = 0; (gen) < MAX_NR_GENS; (gen)++)			\
+		for ((type) = 0; (type) < ANON_AND_FILE; (type)++)	\
+			for ((zone) = 0; (zone) < MAX_NR_ZONES; (zone)++)
+
+static struct lruvec __maybe_unused *get_lruvec(struct mem_cgroup *memcg, int nid)
+{
+	struct pglist_data *pgdat = NODE_DATA(nid);
+
+#ifdef CONFIG_MEMCG
+	if (memcg) {
+		struct lruvec *lruvec = &memcg->nodeinfo[nid]->lruvec;
+
+		/* for hotadd_new_pgdat() */
+		if (!lruvec->pgdat)
+			lruvec->pgdat = pgdat;
+
+		return lruvec;
+	}
+#endif
+	VM_BUG_ON(!mem_cgroup_disabled());
+
+	return pgdat ? &pgdat->__lruvec : NULL;
+}
+
+/******************************************************************************
+ *                          initialization
+ ******************************************************************************/
+
+void lru_gen_init_lruvec(struct lruvec *lruvec)
+{
+	int gen, type, zone;
+	struct lru_gen_struct *lrugen = &lruvec->lrugen;
+
+	lrugen->max_seq = MIN_NR_GENS + 1;
+
+	for_each_gen_type_zone(gen, type, zone)
+		INIT_LIST_HEAD(&lrugen->lists[gen][type][zone]);
+}
+
+#ifdef CONFIG_MEMCG
+void lru_gen_init_memcg(struct mem_cgroup *memcg)
+{
+}
+
+void lru_gen_exit_memcg(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *lruvec = get_lruvec(memcg, nid);
+
+		VM_BUG_ON(memchr_inv(lruvec->lrugen.nr_pages, 0,
+				     sizeof(lruvec->lrugen.nr_pages)));
+	}
+}
+#endif
+
+static int __init init_lru_gen(void)
+{
+	BUILD_BUG_ON(MIN_NR_GENS + 1 >= MAX_NR_GENS);
+	BUILD_BUG_ON(BIT(LRU_GEN_WIDTH) <= MAX_NR_GENS);
+
+	return 0;
+};
+late_initcall(init_lru_gen);
+
+#endif /* CONFIG_LRU_GEN */
+
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
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

