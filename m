Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9B2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbiDLEXL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345877AbiDLEWt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFACC2A704
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B38D6177F
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5DEC385A1;
        Tue, 12 Apr 2022 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737219;
        bh=SfbVXI0mPMO1AC7/JwSckEMngQ2ga4UkO/pT693nMbg=;
        h=Date:To:From:Subject:From;
        b=ISl3IUKYgvzdFwgxkjoJXPs34zvM1s+JApds7zu8bmduvS+MW3zy4b/gaTxKYWTpX
         RiyKV7DPJ1VIXoaTgTo/iQ/hGxhsIm0M5OmUwZ283R09FvER0lAOocPC7JTPkmEtq/
         USAwzr0kV+lxbE4nj4o+9i8XTBViKKRn5x8xNVEQ=
Date:   Mon, 11 Apr 2022 21:20:19 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-thrashing-prevention.patch added to -mm tree
Message-Id: <20220412042019.CF5DEC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: thrashing prevention
has been added to the -mm tree.  Its filename is
     mm-multi-gen-lru-thrashing-prevention.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-multi-gen-lru-thrashing-prevention.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-multi-gen-lru-thrashing-prevention.patch

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
Subject: mm: multi-gen LRU: thrashing prevention

Add /sys/kernel/mm/lru_gen/min_ttl_ms for thrashing prevention, as
requested by many desktop users [1].

When set to value N, it prevents the working set of N milliseconds from
getting evicted.  The OOM killer is triggered if this working set cannot
be kept in memory.  Based on the average human detectable lag (~100ms),
N=1000 usually eliminates intolerable lags due to thrashing.  Larger
values like N=3000 make lags less noticeable at the risk of premature OOM
kills.

Compared with the size-based approach, e.g., [2], this time-based approach
has the following advantages:

1. It is easier to configure because it is agnostic to applications
   and memory sizes.
2. It is more reliable because it is directly wired to the OOM killer.

[1] https://lore.kernel.org/r/Ydza%2FzXKY9ATRoh6@google.com/
[2] https://lore.kernel.org/r/20211130201652.2218636d@mail.inbox.lv/

Link: https://lkml.kernel.org/r/20220407031525.2368067-12-yuzhao@google.com
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


--- a/include/linux/mmzone.h~mm-multi-gen-lru-thrashing-prevention
+++ a/include/linux/mmzone.h
@@ -416,6 +416,8 @@ struct lru_gen_struct {
 	unsigned long max_seq;
 	/* the eviction increments the oldest generation numbers */
 	unsigned long min_seq[ANON_AND_FILE];
+	/* the birth time of each generation in jiffies */
+	unsigned long timestamps[MAX_NR_GENS];
 	/* the multi-gen LRU lists */
 	struct list_head lists[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the sizes of the above lists */
--- a/mm/vmscan.c~mm-multi-gen-lru-thrashing-prevention
+++ a/mm/vmscan.c
@@ -4192,6 +4192,7 @@ static void inc_max_seq(struct lruvec *l
 	for (type = 0; type < ANON_AND_FILE; type++)
 		reset_ctrl_pos(lruvec, type, false);
 
+	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
 
@@ -4317,7 +4318,8 @@ static long get_nr_evictable(struct lruv
 	return total > 0 ? total : 0;
 }
 
-static void age_lruvec(struct lruvec *lruvec, struct scan_control *sc)
+static bool age_lruvec(struct lruvec *lruvec, struct scan_control *sc,
+		       unsigned long min_ttl)
 {
 	bool need_aging;
 	long nr_to_scan;
@@ -4326,14 +4328,22 @@ static void age_lruvec(struct lruvec *lr
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
+	if (min_ttl) {
+		int gen = lru_gen_from_seq(min_seq[LRU_GEN_FILE]);
+		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
+
+		if (time_is_after_jiffies(birth + min_ttl))
+			return false;
+	}
+
 	mem_cgroup_calculate_protection(NULL, memcg);
 
 	if (mem_cgroup_below_min(memcg))
-		return;
+		return false;
 
 	nr_to_scan = get_nr_evictable(lruvec, max_seq, min_seq, swappiness, &need_aging);
 	if (!nr_to_scan)
-		return;
+		return false;
 
 	nr_to_scan >>= sc->priority;
 
@@ -4342,11 +4352,18 @@ static void age_lruvec(struct lruvec *lr
 
 	if (nr_to_scan && need_aging && (!mem_cgroup_below_low(memcg) || sc->memcg_low_reclaim))
 		try_to_inc_max_seq(lruvec, max_seq, sc, swappiness, false);
+
+	return true;
 }
 
+/* to protect the working set of the last N jiffies */
+static unsigned long lru_gen_min_ttl __read_mostly;
+
 static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
+	bool success = false;
+	unsigned long min_ttl = READ_ONCE(lru_gen_min_ttl);
 
 	VM_BUG_ON(!current_is_kswapd());
 
@@ -4372,12 +4389,29 @@ static void lru_gen_age_node(struct pgli
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-		age_lruvec(lruvec, sc);
+		if (age_lruvec(lruvec, sc, min_ttl))
+			success = true;
 
 		cond_resched();
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
 
 	current->reclaim_state->mm_walk = NULL;
+
+	/*
+	 * The main goal is to OOM kill if every generation from all memcgs is
+	 * younger than min_ttl. However, another theoretical possibility is all
+	 * memcgs are either below min or empty.
+	 */
+	if (!success && mutex_trylock(&oom_lock)) {
+		struct oom_control oc = {
+			.gfp_mask = sc->gfp_mask,
+			.order = sc->order,
+		};
+
+		out_of_memory(&oc);
+
+		mutex_unlock(&oom_lock);
+	}
 }
 
 /*
@@ -5092,6 +5126,28 @@ unlock:
  *                          sysfs interface
  ******************************************************************************/
 
+static ssize_t show_min_ttl(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", jiffies_to_msecs(READ_ONCE(lru_gen_min_ttl)));
+}
+
+static ssize_t store_min_ttl(struct kobject *kobj, struct kobj_attribute *attr,
+			     const char *buf, size_t len)
+{
+	unsigned int msecs;
+
+	if (kstrtouint(buf, 0, &msecs))
+		return -EINVAL;
+
+	WRITE_ONCE(lru_gen_min_ttl, msecs_to_jiffies(msecs));
+
+	return len;
+}
+
+static struct kobj_attribute lru_gen_min_ttl_attr = __ATTR(
+	min_ttl_ms, 0644, show_min_ttl, store_min_ttl
+);
+
 static ssize_t show_enable(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	unsigned int caps = 0;
@@ -5140,6 +5196,7 @@ static struct kobj_attribute lru_gen_ena
 );
 
 static struct attribute *lru_gen_attrs[] = {
+	&lru_gen_min_ttl_attr.attr,
 	&lru_gen_enabled_attr.attr,
 	NULL
 };
@@ -5155,12 +5212,16 @@ static struct attribute_group lru_gen_at
 
 void lru_gen_init_lruvec(struct lruvec *lruvec)
 {
+	int i;
 	int gen, type, zone;
 	struct lru_gen_struct *lrugen = &lruvec->lrugen;
 
 	lrugen->max_seq = MIN_NR_GENS + 1;
 	lrugen->enabled = lru_gen_enabled();
 
+	for (i = 0; i <= MIN_NR_GENS + 1; i++)
+		lrugen->timestamps[i] = jiffies;
+
 	for_each_gen_type_zone(gen, type, zone)
 		INIT_LIST_HEAD(&lrugen->lists[gen][type][zone]);
 
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

