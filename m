Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3D5C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 04:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345675AbiDLEXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 00:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345883AbiDLEWt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 00:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE032A722
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 21:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE502B81B1B
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 04:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5E0C385A1;
        Tue, 12 Apr 2022 04:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649737221;
        bh=gFP6GMSoT/VJtGu+J6OFmWQIrTw9BtEo80BHpB23WVQ=;
        h=Date:To:From:Subject:From;
        b=rDNz8afumrJbUVD5yeJCmHgsbMBwP9nWrW0C8p45qDAoUqobc0u7pKUHbVUaQ6hir
         dH2VZd3PpMLO8yJoiOKJKIynGj3xer5s4xHX920jLAGtY/lbYDdxRyz/N1zMJ9TUff
         e85gBKhzMejNwtV1YGTDRABCWXvKg33HkbCyw774=
Date:   Mon, 11 Apr 2022 21:20:21 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vaibhav@linux.ibm.com,
        szhai2@cs.rochester.edu, suleiman@google.com, steven@liquorix.net,
        sofia.trinh@edi.works, shy828301@gmail.com,
        oleksandr@natalenko.name, mgorman@techsingularity.net,
        holger@applied-asynchrony.com, Hi-Angel@yandex.ru,
        heftig@archlinux.org, hannes@cmpxchg.org, djbyrne@mtu.edu,
        d@chaos-reins.com, bgeffon@google.com, baohua@kernel.org,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-debugfs-interface.patch added to -mm tree
Message-Id: <20220412042021.8E5E0C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: debugfs interface
has been added to the -mm tree.  Its filename is
     mm-multi-gen-lru-debugfs-interface.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-multi-gen-lru-debugfs-interface.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-multi-gen-lru-debugfs-interface.patch

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
Subject: mm: multi-gen LRU: debugfs interface

Add /sys/kernel/debug/lru_gen for working set estimation and proactive
reclaim.  These features are required to optimize job scheduling (bin
packing) in data centers [1][2].

Compared with the page table-based approach and the PFN-based approach,
e.g., mm/damon/[vp]addr.c, this lruvec-based approach has the following
advantages:

1. It offers better choices because it is aware of memcgs, NUMA nodes,
   shared mappings and unmapped page cache.
2. It is more scalable because it is O(nr_hot_pages), whereas the
   PFN-based approach is O(nr_total_pages).

Add /sys/kernel/debug/lru_gen_full for debugging.

[1] https://dl.acm.org/doi/10.1145/3297858.3304053
[2] https://dl.acm.org/doi/10.1145/3503222.3507731

Link: https://lkml.kernel.org/r/20220407031525.2368067-13-yuzhao@google.com
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


--- a/include/linux/nodemask.h~mm-multi-gen-lru-debugfs-interface
+++ a/include/linux/nodemask.h
@@ -486,6 +486,7 @@ static inline int num_node_state(enum no
 #define first_online_node	0
 #define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
+#define next_memory_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1U
 #define nr_online_nodes		1U
 
--- a/mm/vmscan.c~mm-multi-gen-lru-debugfs-interface
+++ a/mm/vmscan.c
@@ -53,6 +53,7 @@
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
 #include <linux/ctype.h>
+#include <linux/debugfs.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -5207,6 +5208,348 @@ static struct attribute_group lru_gen_at
 };
 
 /******************************************************************************
+ *                          debugfs interface
+ ******************************************************************************/
+
+static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
+{
+	struct mem_cgroup *memcg;
+	loff_t nr_to_skip = *pos;
+
+	m->private = kvmalloc(PATH_MAX, GFP_KERNEL);
+	if (!m->private)
+		return ERR_PTR(-ENOMEM);
+
+	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	do {
+		int nid;
+
+		for_each_node_state(nid, N_MEMORY) {
+			if (!nr_to_skip--)
+				return get_lruvec(memcg, nid);
+		}
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+	return NULL;
+}
+
+static void lru_gen_seq_stop(struct seq_file *m, void *v)
+{
+	if (!IS_ERR_OR_NULL(v))
+		mem_cgroup_iter_break(NULL, lruvec_memcg(v));
+
+	kvfree(m->private);
+	m->private = NULL;
+}
+
+static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	int nid = lruvec_pgdat(v)->node_id;
+	struct mem_cgroup *memcg = lruvec_memcg(v);
+
+	++*pos;
+
+	nid = next_memory_node(nid);
+	if (nid == MAX_NUMNODES) {
+		memcg = mem_cgroup_iter(NULL, memcg, NULL);
+		if (!memcg)
+			return NULL;
+
+		nid = first_memory_node;
+	}
+
+	return get_lruvec(memcg, nid);
+}
+
+static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
+				  unsigned long max_seq, unsigned long *min_seq,
+				  unsigned long seq)
+{
+	int i;
+	int type, tier;
+	int hist = lru_hist_from_seq(seq);
+	struct lru_gen_struct *lrugen = &lruvec->lrugen;
+
+	for (tier = 0; tier < MAX_NR_TIERS; tier++) {
+		seq_printf(m, "            %10d", tier);
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			unsigned long n[3] = {};
+
+			if (seq == max_seq) {
+				n[0] = READ_ONCE(lrugen->avg_refaulted[type][tier]);
+				n[1] = READ_ONCE(lrugen->avg_total[type][tier]);
+
+				seq_printf(m, " %10luR %10luT %10lu ", n[0], n[1], n[2]);
+			} else if (seq == min_seq[type] || NR_HIST_GENS > 1) {
+				n[0] = atomic_long_read(&lrugen->refaulted[hist][type][tier]);
+				n[1] = atomic_long_read(&lrugen->evicted[hist][type][tier]);
+				if (tier)
+					n[2] = READ_ONCE(lrugen->protected[hist][type][tier - 1]);
+
+				seq_printf(m, " %10lur %10lue %10lup", n[0], n[1], n[2]);
+			} else
+				seq_puts(m, "          0           0           0 ");
+		}
+		seq_putc(m, '\n');
+	}
+
+	seq_puts(m, "                      ");
+	for (i = 0; i < NR_MM_STATS; i++) {
+		if (seq == max_seq && NR_HIST_GENS == 1)
+			seq_printf(m, " %10lu%c", READ_ONCE(lruvec->mm_state.stats[hist][i]),
+				   toupper(MM_STAT_CODES[i]));
+		else if (seq != max_seq && NR_HIST_GENS > 1)
+			seq_printf(m, " %10lu%c", READ_ONCE(lruvec->mm_state.stats[hist][i]),
+				   MM_STAT_CODES[i]);
+		else
+			seq_puts(m, "          0 ");
+	}
+	seq_putc(m, '\n');
+}
+
+static int lru_gen_seq_show(struct seq_file *m, void *v)
+{
+	unsigned long seq;
+	bool full = !debugfs_real_fops(m->file)->write;
+	struct lruvec *lruvec = v;
+	struct lru_gen_struct *lrugen = &lruvec->lrugen;
+	int nid = lruvec_pgdat(lruvec)->node_id;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	DEFINE_MAX_SEQ(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+
+	if (nid == first_memory_node) {
+		const char *path = memcg ? m->private : "";
+
+#ifdef CONFIG_MEMCG
+		if (memcg)
+			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
+#endif
+		seq_printf(m, "memcg %5hu %s\n", mem_cgroup_id(memcg), path);
+	}
+
+	seq_printf(m, " node %5d\n", nid);
+
+	if (!full)
+		seq = min_seq[LRU_GEN_ANON];
+	else if (max_seq >= MAX_NR_GENS)
+		seq = max_seq - MAX_NR_GENS + 1;
+	else
+		seq = 0;
+
+	for (; seq <= max_seq; seq++) {
+		int type, zone;
+		int gen = lru_gen_from_seq(seq);
+		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
+
+		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
+
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			long size = 0;
+			char mark = full && seq < min_seq[type] ? 'x' : ' ';
+
+			for (zone = 0; zone < MAX_NR_ZONES; zone++)
+				size += READ_ONCE(lrugen->nr_pages[gen][type][zone]);
+
+			seq_printf(m, " %10lu%c", max(size, 0L), mark);
+		}
+
+		seq_putc(m, '\n');
+
+		if (full)
+			lru_gen_seq_show_full(m, lruvec, max_seq, min_seq, seq);
+	}
+
+	return 0;
+}
+
+static const struct seq_operations lru_gen_seq_ops = {
+	.start = lru_gen_seq_start,
+	.stop = lru_gen_seq_stop,
+	.next = lru_gen_seq_next,
+	.show = lru_gen_seq_show,
+};
+
+static int run_aging(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
+		     bool can_swap, bool full_scan)
+{
+	DEFINE_MAX_SEQ(lruvec);
+
+	if (seq == max_seq)
+		try_to_inc_max_seq(lruvec, max_seq, sc, can_swap, full_scan);
+
+	return seq > max_seq ? -EINVAL : 0;
+}
+
+static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
+			int swappiness, unsigned long nr_to_reclaim)
+{
+	struct blk_plug plug;
+	int err = -EINTR;
+	DEFINE_MAX_SEQ(lruvec);
+
+	if (seq + MIN_NR_GENS > max_seq)
+		return -EINVAL;
+
+	sc->nr_reclaimed = 0;
+
+	blk_start_plug(&plug);
+
+	while (!signal_pending(current)) {
+		DEFINE_MIN_SEQ(lruvec);
+
+		if (seq < min_seq[!swappiness] || sc->nr_reclaimed >= nr_to_reclaim ||
+		    !evict_folios(lruvec, sc, swappiness, NULL)) {
+			err = 0;
+			break;
+		}
+
+		cond_resched();
+	}
+
+	blk_finish_plug(&plug);
+
+	return err;
+}
+
+static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
+		   struct scan_control *sc, int swappiness, unsigned long opt)
+{
+	struct lruvec *lruvec;
+	int err = -EINVAL;
+	struct mem_cgroup *memcg = NULL;
+
+	if (!mem_cgroup_disabled()) {
+		rcu_read_lock();
+		memcg = mem_cgroup_from_id(memcg_id);
+#ifdef CONFIG_MEMCG
+		if (memcg && !css_tryget(&memcg->css))
+			memcg = NULL;
+#endif
+		rcu_read_unlock();
+
+		if (!memcg)
+			goto done;
+	}
+	if (memcg_id != mem_cgroup_id(memcg))
+		goto done;
+
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
+		goto done;
+
+	lruvec = get_lruvec(memcg, nid);
+
+	if (swappiness < 0)
+		swappiness = get_swappiness(lruvec, sc);
+	else if (swappiness > 200)
+		goto done;
+
+	switch (cmd) {
+	case '+':
+		err = run_aging(lruvec, seq, sc, swappiness, opt);
+		break;
+	case '-':
+		err = run_eviction(lruvec, seq, sc, swappiness, opt);
+		break;
+	}
+done:
+	mem_cgroup_put(memcg);
+
+	return err;
+}
+
+static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
+				 size_t len, loff_t *pos)
+{
+	void *buf;
+	char *cur, *next;
+	unsigned int flags;
+	int err = 0;
+	struct scan_control sc = {
+		.may_writepage = true,
+		.may_unmap = true,
+		.may_swap = true,
+		.reclaim_idx = MAX_NR_ZONES - 1,
+		.gfp_mask = GFP_KERNEL,
+	};
+
+	buf = kvmalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, src, len)) {
+		kvfree(buf);
+		return -EFAULT;
+	}
+
+	next = buf;
+	next[len] = '\0';
+
+	sc.reclaim_state.mm_walk = alloc_mm_walk();
+	if (!sc.reclaim_state.mm_walk) {
+		kvfree(buf);
+		return -ENOMEM;
+	}
+
+	set_task_reclaim_state(current, &sc.reclaim_state);
+	flags = memalloc_noreclaim_save();
+
+	while ((cur = strsep(&next, ",;\n"))) {
+		int n;
+		int end;
+		char cmd;
+		unsigned int memcg_id;
+		unsigned int nid;
+		unsigned long seq;
+		unsigned int swappiness = -1;
+		unsigned long opt = -1;
+
+		cur = skip_spaces(cur);
+		if (!*cur)
+			continue;
+
+		n = sscanf(cur, "%c %u %u %lu %n %u %n %lu %n", &cmd, &memcg_id, &nid,
+			   &seq, &end, &swappiness, &end, &opt, &end);
+		if (n < 4 || cur[end]) {
+			err = -EINVAL;
+			break;
+		}
+
+		err = run_cmd(cmd, memcg_id, nid, seq, &sc, swappiness, opt);
+		if (err)
+			break;
+	}
+
+	memalloc_noreclaim_restore(flags);
+	set_task_reclaim_state(current, NULL);
+
+	free_mm_walk(sc.reclaim_state.mm_walk);
+	kvfree(buf);
+
+	return err ? : len;
+}
+
+static int lru_gen_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &lru_gen_seq_ops);
+}
+
+static const struct file_operations lru_gen_rw_fops = {
+	.open = lru_gen_seq_open,
+	.read = seq_read,
+	.write = lru_gen_seq_write,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static const struct file_operations lru_gen_ro_fops = {
+	.open = lru_gen_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+/******************************************************************************
  *                          initialization
  ******************************************************************************/
 
@@ -5264,6 +5607,9 @@ static int __init init_lru_gen(void)
 	if (sysfs_create_group(mm_kobj, &lru_gen_attr_group))
 		pr_err("lru_gen: failed to create sysfs group\n");
 
+	debugfs_create_file("lru_gen", 0644, NULL, NULL, &lru_gen_rw_fops);
+	debugfs_create_file("lru_gen_full", 0444, NULL, NULL, &lru_gen_ro_fops);
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

