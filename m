Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C993C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0034864F19
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbhBXUFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234738AbhBXUEQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:04:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3FE864EC4;
        Wed, 24 Feb 2021 20:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197004;
        bh=M1Gn7Dj+t+KJBU+acHHEte0g2HJKcoyAty8oF30LUW4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=arMops0b5/Q1k9CiAvYb+8F5xr9A/6Y+gku61JQ8o0YB+6UuVdwZ55d6XEZmDJvyz
         PH2T/9TcBrKMNblnDszs6qrsXIWB/TlZ5cQjRIxI9pqV25tcbZIiTwteHkZKyJF1NR
         CVKiteHDG4FTXHmKXrmaNcwhooE9YM85YrkTZVSk=
Date:   Wed, 24 Feb 2021 12:03:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        feng.tang@intel.com, gregkh@linuxfoundation.org, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        neilb@suse.de, pankaj.gupta@cloud.ionos.com, rafael@kernel.org,
        rdunlap@infradead.org, samitolvanen@google.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 058/173] mm: memcontrol: convert NR_ANON_THPS
 account to pages
Message-ID: <20210224200323.A_ab8u0-S%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: convert NR_ANON_THPS account to pages

Currently we use struct per_cpu_nodestat to cache the vmstat counters,
which leads to inaccurate statistics especially THP vmstat counters.  In
the systems with hundreds of processors it can be GBs of memory.  For
example, for a 96 CPUs system, the threshold is the maximum number of 125.
And the per cpu counters can cache 23.4375 GB in total.

The THP page is already a form of batched addition (it will add 512 worth
of memory in one go) so skipping the batching seems like sensible. 
Although every THP stats update overflows the per-cpu counter, resorting
to atomic global updates.  But it can make the statistics more accuracy
for the THP vmstat counters.

So we convert the NR_ANON_THPS account to pages.  This patch is consistent
with 8f182270dfec ("mm/swap.c: flush lru pvecs on compound page arrival").
Doing this also can make the unit of vmstat counters more unified. 
Finally, the unit of the vmstat counters are pages, kB and bytes.  The
B/KB suffix can tell us that the unit is bytes or kB.  The rest which is
without suffix are pages.

Link: https://lkml.kernel.org/r/20201228164110.2838-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael. J. Wysocki <rafael@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |   15 +++++++++------
 fs/proc/meminfo.c      |    2 +-
 include/linux/mmzone.h |   13 +++++++++++++
 mm/huge_memory.c       |    3 ++-
 mm/memcontrol.c        |   20 ++++++--------------
 mm/page_alloc.c        |    2 +-
 mm/rmap.c              |    6 +++---
 mm/vmstat.c            |   11 +++++++++--
 8 files changed, 44 insertions(+), 28 deletions(-)

--- a/drivers/base/node.c~mm-memcontrol-convert-nr_anon_thps-account-to-pages
+++ a/drivers/base/node.c
@@ -461,8 +461,7 @@ static ssize_t node_read_meminfo(struct
 			     nid, K(sunreclaimable)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			     ,
-			     nid, K(node_page_state(pgdat, NR_ANON_THPS) *
-				    HPAGE_PMD_NR),
+			     nid, K(node_page_state(pgdat, NR_ANON_THPS)),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_THPS) *
 				    HPAGE_PMD_NR),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
@@ -519,10 +518,14 @@ static ssize_t node_read_vmstat(struct d
 				     sum_zone_numa_state(nid, i));
 
 #endif
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-		len += sysfs_emit_at(buf, len, "%s %lu\n",
-				     node_stat_name(i),
-				     node_page_state_pages(pgdat, i));
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+		unsigned long pages = node_page_state_pages(pgdat, i);
+
+		if (vmstat_item_print_in_thp(i))
+			pages /= HPAGE_PMD_NR;
+		len += sysfs_emit_at(buf, len, "%s %lu\n", node_stat_name(i),
+				     pages);
+	}
 
 	return len;
 }
--- a/fs/proc/meminfo.c~mm-memcontrol-convert-nr_anon_thps-account-to-pages
+++ a/fs/proc/meminfo.c
@@ -129,7 +129,7 @@ static int meminfo_proc_show(struct seq_
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	show_val_kb(m, "AnonHugePages:  ",
-		    global_node_page_state(NR_ANON_THPS) * HPAGE_PMD_NR);
+		    global_node_page_state(NR_ANON_THPS));
 	show_val_kb(m, "ShmemHugePages: ",
 		    global_node_page_state(NR_SHMEM_THPS) * HPAGE_PMD_NR);
 	show_val_kb(m, "ShmemPmdMapped: ",
--- a/include/linux/mmzone.h~mm-memcontrol-convert-nr_anon_thps-account-to-pages
+++ a/include/linux/mmzone.h
@@ -210,6 +210,19 @@ enum node_stat_item {
 };
 
 /*
+ * Returns true if the item should be printed in THPs (/proc/vmstat
+ * currently prints number of anon, file and shmem THPs. But the item
+ * is charged in pages).
+ */
+static __always_inline bool vmstat_item_print_in_thp(enum node_stat_item item)
+{
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return false;
+
+	return item == NR_ANON_THPS;
+}
+
+/*
  * Returns true if the value is measured in bytes (most vmstat values are
  * measured in pages). This defines the API part, the internal representation
  * might be different.
--- a/mm/huge_memory.c~mm-memcontrol-convert-nr_anon_thps-account-to-pages
+++ a/mm/huge_memory.c
@@ -2176,7 +2176,8 @@ static void __split_huge_pmd_locked(stru
 		lock_page_memcg(page);
 		if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
 			/* Last compound_mapcount is gone. */
-			__dec_lruvec_page_state(page, NR_ANON_THPS);
+			__mod_lruvec_page_state(page, NR_ANON_THPS,
+						-HPAGE_PMD_NR);
 			if (TestClearPageDoubleMap(page)) {
 				/* No need in mapcount reference anymore */
 				for (i = 0; i < HPAGE_PMD_NR; i++)
--- a/mm/memcontrol.c~mm-memcontrol-convert-nr_anon_thps-account-to-pages
+++ a/mm/memcontrol.c
@@ -1533,7 +1533,7 @@ static struct memory_stat memory_stats[]
 	 * on some architectures, the macro of HPAGE_PMD_SIZE is not
 	 * constant(e.g. powerpc).
 	 */
-	{ "anon_thp", 0, NR_ANON_THPS },
+	{ "anon_thp", PAGE_SIZE, NR_ANON_THPS },
 	{ "file_thp", 0, NR_FILE_THPS },
 	{ "shmem_thp", 0, NR_SHMEM_THPS },
 #endif
@@ -1566,8 +1566,7 @@ static int __init memory_stats_init(void
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memory_stats[i].idx == NR_ANON_THPS ||
-		    memory_stats[i].idx == NR_FILE_THPS ||
+		if (memory_stats[i].idx == NR_FILE_THPS ||
 		    memory_stats[i].idx == NR_SHMEM_THPS)
 			memory_stats[i].ratio = HPAGE_PMD_SIZE;
 #endif
@@ -4087,10 +4086,6 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memcg1_stats[i] == NR_ANON_THPS)
-			nr *= HPAGE_PMD_NR;
-#endif
 		seq_printf(m, "%s %lu\n", memcg1_stat_names[i], nr * PAGE_SIZE);
 	}
 
@@ -4121,10 +4116,6 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		nr = memcg_page_state(memcg, memcg1_stats[i]);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memcg1_stats[i] == NR_ANON_THPS)
-			nr *= HPAGE_PMD_NR;
-#endif
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
 						(u64)nr * PAGE_SIZE);
 	}
@@ -5652,10 +5643,11 @@ static int mem_cgroup_move_account(struc
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
 			if (PageTransHuge(page)) {
-				__dec_lruvec_state(from_vec, NR_ANON_THPS);
-				__inc_lruvec_state(to_vec, NR_ANON_THPS);
+				__mod_lruvec_state(from_vec, NR_ANON_THPS,
+						   -nr_pages);
+				__mod_lruvec_state(to_vec, NR_ANON_THPS,
+						   nr_pages);
 			}
-
 		}
 	} else {
 		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
--- a/mm/page_alloc.c~mm-memcontrol-convert-nr_anon_thps-account-to-pages
+++ a/mm/page_alloc.c
@@ -5587,7 +5587,7 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_SHMEM_THPS) * HPAGE_PMD_NR),
 			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)
 					* HPAGE_PMD_NR),
-			K(node_page_state(pgdat, NR_ANON_THPS) * HPAGE_PMD_NR),
+			K(node_page_state(pgdat, NR_ANON_THPS)),
 #endif
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			node_page_state(pgdat, NR_KERNEL_STACK_KB),
--- a/mm/rmap.c~mm-memcontrol-convert-nr_anon_thps-account-to-pages
+++ a/mm/rmap.c
@@ -1144,7 +1144,7 @@ void do_page_add_anon_rmap(struct page *
 		 * disabled.
 		 */
 		if (compound)
-			__inc_lruvec_page_state(page, NR_ANON_THPS);
+			__mod_lruvec_page_state(page, NR_ANON_THPS, nr);
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, nr);
 	}
 
@@ -1186,7 +1186,7 @@ void page_add_new_anon_rmap(struct page
 		if (hpage_pincount_available(page))
 			atomic_set(compound_pincount_ptr(page), 0);
 
-		__inc_lruvec_page_state(page, NR_ANON_THPS);
+		__mod_lruvec_page_state(page, NR_ANON_THPS, nr);
 	} else {
 		/* Anon THP always mapped first with PMD */
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
@@ -1292,7 +1292,7 @@ static void page_remove_anon_compound_rm
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return;
 
-	__dec_lruvec_page_state(page, NR_ANON_THPS);
+	__mod_lruvec_page_state(page, NR_ANON_THPS, -thp_nr_pages(page));
 
 	if (TestClearPageDoubleMap(page)) {
 		/*
--- a/mm/vmstat.c~mm-memcontrol-convert-nr_anon_thps-account-to-pages
+++ a/mm/vmstat.c
@@ -1619,8 +1619,12 @@ static void zoneinfo_show_print(struct s
 	if (is_zone_first_populated(pgdat, zone)) {
 		seq_printf(m, "\n  per-node stats");
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+			unsigned long pages = node_page_state_pages(pgdat, i);
+
+			if (vmstat_item_print_in_thp(i))
+				pages /= HPAGE_PMD_NR;
 			seq_printf(m, "\n      %-12s %lu", node_stat_name(i),
-				   node_page_state_pages(pgdat, i));
+				   pages);
 		}
 	}
 	seq_printf(m,
@@ -1740,8 +1744,11 @@ static void *vmstat_start(struct seq_fil
 	v += NR_VM_NUMA_STAT_ITEMS;
 #endif
 
-	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 		v[i] = global_node_page_state_pages(i);
+		if (vmstat_item_print_in_thp(i))
+			v[i] /= HPAGE_PMD_NR;
+	}
 	v += NR_VM_NODE_STAT_ITEMS;
 
 	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
_
