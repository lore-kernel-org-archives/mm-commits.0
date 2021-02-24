Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15468C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C343064F23
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhBXUFo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235182AbhBXUER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:04:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C88764F24;
        Wed, 24 Feb 2021 20:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197013;
        bh=jZTHcxv/5SzSsCDU3fViTdSXnALMKQaB98xFlmh9jmw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OUGdOsDyGkHLAt0p31fyv5MZlFnZqUwZHWWwoK257R6PkSxbYwpFZlCOxIbyzYjsw
         OdxslnYWn55AzIYBmAV+yk7onogVp3RQedH77KArNxUbHcB5IxyfHN41RPpg1tMaUa
         yZ4wLNfNncwesfK2dggWbRNZJ6w/auHnSHjk/ubU=
Date:   Wed, 24 Feb 2021 12:03:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        feng.tang@intel.com, gregkh@linuxfoundation.org, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        neilb@suse.de, pankaj.gupta@cloud.ionos.com, rafael@kernel.org,
        rdunlap@infradead.org, samitolvanen@google.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 060/173] mm: memcontrol: convert NR_SHMEM_THPS
 account to pages
Message-ID: <20210224200331.zTTNbuNoQ%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: convert NR_SHMEM_THPS account to pages

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

So we convert the NR_SHMEM_THPS account to pages.  This patch is
consistent with 8f182270dfec ("mm/swap.c: flush lru pvecs on compound page
arrival").  Doing this also can make the unit of vmstat counters more
unified.  Finally, the unit of the vmstat counters are pages, kB and
bytes.  The B/KB suffix can tell us that the unit is bytes or kB.  The
rest which is without suffix are pages.

Link: https://lkml.kernel.org/r/20201228164110.2838-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Rafael. J. Wysocki <rafael@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    3 +--
 fs/proc/meminfo.c      |    2 +-
 include/linux/mmzone.h |    3 ++-
 mm/filemap.c           |    2 +-
 mm/huge_memory.c       |    3 ++-
 mm/khugepaged.c        |    2 +-
 mm/memcontrol.c        |   26 ++------------------------
 mm/page_alloc.c        |    2 +-
 mm/shmem.c             |    2 +-
 9 files changed, 12 insertions(+), 33 deletions(-)

--- a/drivers/base/node.c~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/drivers/base/node.c
@@ -462,8 +462,7 @@ static ssize_t node_read_meminfo(struct
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			     ,
 			     nid, K(node_page_state(pgdat, NR_ANON_THPS)),
-			     nid, K(node_page_state(pgdat, NR_SHMEM_THPS) *
-				    HPAGE_PMD_NR),
+			     nid, K(node_page_state(pgdat, NR_SHMEM_THPS)),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
 				    HPAGE_PMD_NR),
 			     nid, K(node_page_state(pgdat, NR_FILE_THPS)),
--- a/fs/proc/meminfo.c~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/fs/proc/meminfo.c
@@ -131,7 +131,7 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "AnonHugePages:  ",
 		    global_node_page_state(NR_ANON_THPS));
 	show_val_kb(m, "ShmemHugePages: ",
-		    global_node_page_state(NR_SHMEM_THPS) * HPAGE_PMD_NR);
+		    global_node_page_state(NR_SHMEM_THPS));
 	show_val_kb(m, "ShmemPmdMapped: ",
 		    global_node_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR);
 	show_val_kb(m, "FileHugePages:  ",
--- a/include/linux/mmzone.h~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/include/linux/mmzone.h
@@ -220,7 +220,8 @@ static __always_inline bool vmstat_item_
 		return false;
 
 	return item == NR_ANON_THPS ||
-	       item == NR_FILE_THPS;
+	       item == NR_FILE_THPS ||
+	       item == NR_SHMEM_THPS;
 }
 
 /*
--- a/mm/filemap.c~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/mm/filemap.c
@@ -206,7 +206,7 @@ static void unaccount_page_cache_page(st
 	if (PageSwapBacked(page)) {
 		__mod_lruvec_page_state(page, NR_SHMEM, -nr);
 		if (PageTransHuge(page))
-			__dec_lruvec_page_state(page, NR_SHMEM_THPS);
+			__mod_lruvec_page_state(page, NR_SHMEM_THPS, -nr);
 	} else if (PageTransHuge(page)) {
 		__mod_lruvec_page_state(page, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
--- a/mm/huge_memory.c~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/mm/huge_memory.c
@@ -2755,7 +2755,8 @@ int split_huge_page_to_list(struct page
 			int nr = thp_nr_pages(head);
 
 			if (PageSwapBacked(head))
-				__dec_lruvec_page_state(head, NR_SHMEM_THPS);
+				__mod_lruvec_page_state(head, NR_SHMEM_THPS,
+							-nr);
 			else
 				__mod_lruvec_page_state(head, NR_FILE_THPS,
 							-nr);
--- a/mm/khugepaged.c~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/mm/khugepaged.c
@@ -1858,7 +1858,7 @@ out_unlock:
 	nr = thp_nr_pages(new_page);
 
 	if (is_shmem)
-		__inc_lruvec_page_state(new_page, NR_SHMEM_THPS);
+		__mod_lruvec_page_state(new_page, NR_SHMEM_THPS, nr);
 	else {
 		__mod_lruvec_page_state(new_page, NR_FILE_THPS, nr);
 		filemap_nr_thps_inc(mapping);
--- a/mm/memcontrol.c~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/mm/memcontrol.c
@@ -1516,7 +1516,7 @@ struct memory_stat {
 	unsigned int idx;
 };
 
-static struct memory_stat memory_stats[] = {
+static const struct memory_stat memory_stats[] = {
 	{ "anon", PAGE_SIZE, NR_ANON_MAPPED },
 	{ "file", PAGE_SIZE, NR_FILE_PAGES },
 	{ "kernel_stack", 1024, NR_KERNEL_STACK_KB },
@@ -1528,14 +1528,9 @@ static struct memory_stat memory_stats[]
 	{ "file_dirty", PAGE_SIZE, NR_FILE_DIRTY },
 	{ "file_writeback", PAGE_SIZE, NR_WRITEBACK },
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	/*
-	 * The ratio will be initialized in memory_stats_init(). Because
-	 * on some architectures, the macro of HPAGE_PMD_SIZE is not
-	 * constant(e.g. powerpc).
-	 */
 	{ "anon_thp", PAGE_SIZE, NR_ANON_THPS },
 	{ "file_thp", PAGE_SIZE, NR_FILE_THPS },
-	{ "shmem_thp", 0, NR_SHMEM_THPS },
+	{ "shmem_thp", PAGE_SIZE, NR_SHMEM_THPS },
 #endif
 	{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
 	{ "active_anon", PAGE_SIZE, NR_ACTIVE_ANON },
@@ -1560,23 +1555,6 @@ static struct memory_stat memory_stats[]
 	{ "workingset_nodereclaim", 1, WORKINGSET_NODERECLAIM },
 };
 
-static int __init memory_stats_init(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memory_stats[i].idx == NR_SHMEM_THPS)
-			memory_stats[i].ratio = HPAGE_PMD_SIZE;
-#endif
-		VM_BUG_ON(!memory_stats[i].ratio);
-		VM_BUG_ON(memory_stats[i].idx >= MEMCG_NR_STAT);
-	}
-
-	return 0;
-}
-pure_initcall(memory_stats_init);
-
 static char *memory_stat_format(struct mem_cgroup *memcg)
 {
 	struct seq_buf s;
--- a/mm/page_alloc.c~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/mm/page_alloc.c
@@ -5584,7 +5584,7 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_WRITEBACK)),
 			K(node_page_state(pgdat, NR_SHMEM)),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			K(node_page_state(pgdat, NR_SHMEM_THPS) * HPAGE_PMD_NR),
+			K(node_page_state(pgdat, NR_SHMEM_THPS)),
 			K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)
 					* HPAGE_PMD_NR),
 			K(node_page_state(pgdat, NR_ANON_THPS)),
--- a/mm/shmem.c~mm-memcontrol-convert-nr_shmem_thps-account-to-pages
+++ a/mm/shmem.c
@@ -713,7 +713,7 @@ next:
 		}
 		if (PageTransHuge(page)) {
 			count_vm_event(THP_FILE_ALLOC);
-			__inc_lruvec_page_state(page, NR_SHMEM_THPS);
+			__mod_lruvec_page_state(page, NR_SHMEM_THPS, nr);
 		}
 		mapping->nrpages += nr;
 		__mod_lruvec_page_state(page, NR_FILE_PAGES, nr);
_
