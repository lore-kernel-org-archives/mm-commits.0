Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE85C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00FA964F27
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhBYTZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234559AbhBYTXR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:23:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC05764F1A;
        Thu, 25 Feb 2021 19:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280458;
        bh=3TyQZim8AzCcRH97P1OL3AzVQh3CAGUvPhsZeUMwJR0=;
        h=Date:From:To:Subject:From;
        b=Qy4EOtI6UUe4D6YIbRr2aoJ+nQ2q8rKKU4WMz+jRs5S+KrkSZz/niZXvnKCu1miJu
         tv0zjexexLh+3joGCQ8GX3aFmZG725fypj3oXq171Q+uotmrZa+pfPRDYnj464i9lb
         /tV9hVSaeoTORWJFzvOw1RtzppZlqg2s0iOexB/A=
Date:   Thu, 25 Feb 2021 11:14:17 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com
Subject:  [merged] mm-memcg-add-swapcache-stat-for-memcg-v2.patch
 removed from -mm tree
Message-ID: <20210225191417.KS0jwdg5k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: add swapcache stat for memcg v2
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-swapcache-stat-for-memcg-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: memcg: add swapcache stat for memcg v2

This patch adds swapcache stat for the cgroup v2.  The swapcache
represents the memory that is accounted against both the memory and the
swap limit of the cgroup.  The main motivation behind exposing the
swapcache stat is for enabling users to gracefully migrate from cgroup
v1's memsw counter to cgroup v2's memory and swap counters.

Cgroup v1's memsw limit allows users to limit the memory+swap usage of a
workload but without control on the exact proportion of memory and swap. 
Cgroup v2 provides separate limits for memory and swap which enables more
control on the exact usage of memory and swap individually for the
workload.

With some little subtleties, the v1's memsw limit can be switched with the
sum of the v2's memory and swap limits.  However the alternative for memsw
usage is not yet available in cgroup v2.  Exposing per-cgroup swapcache
stat enables that alternative.  Adding the memory usage and swap usage and
subtracting the swapcache will approximate the memsw usage.  This will
help in the transparent migration of the workloads depending on memsw
usage and limit to v2' memory and swap counters.

The reasons these applications are still interested in this approximate
memsw usage are: (1) these applications are not really interested in two
separate memory and swap usage metrics.  A single usage metric is more
simple to use and reason about for them.

(2) The memsw usage metric hides the underlying system's swap setup from
the applications.  Applications with multiple instances running in a
datacenter with heterogeneous systems (some have swap and some don't) will
keep seeing a consistent view of their usage.

[akpm@linux-foundation.org: fix CONFIG_SWAP=n build]
Link: https://lkml.kernel.org/r/20210108155813.2914586-3-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    4 +++
 drivers/base/node.c                     |    6 ++++
 include/linux/mmzone.h                  |    3 ++
 include/linux/swap.h                    |    6 +++-
 mm/memcontrol.c                         |    3 ++
 mm/migrate.c                            |    6 ++++
 mm/swap_state.c                         |   28 +---------------------
 mm/vmstat.c                             |    3 ++
 8 files changed, 32 insertions(+), 27 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcg-add-swapcache-stat-for-memcg-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1299,6 +1299,10 @@ PAGE_SIZE multiple when read back.
 		Amount of cached filesystem data that was modified and
 		is currently being written back to disk
 
+	  swapcached
+		Amount of swap cached in memory. The swapcache is accounted
+		against both memory and swap usage.
+
 	  anon_thp
 		Amount of memory used in anonymous mappings backed by
 		transparent hugepages
--- a/drivers/base/node.c~mm-memcg-add-swapcache-stat-for-memcg-v2
+++ a/drivers/base/node.c
@@ -372,14 +372,19 @@ static ssize_t node_read_meminfo(struct
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct sysinfo i;
 	unsigned long sreclaimable, sunreclaimable;
+	unsigned long swapcached = 0;
 
 	si_meminfo_node(&i, nid);
 	sreclaimable = node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B);
 	sunreclaimable = node_page_state_pages(pgdat, NR_SLAB_UNRECLAIMABLE_B);
+#ifdef CONFIG_SWAP
+	swapcached = node_page_state_pages(pgdat, NR_SWAPCACHE);
+#endif
 	len = sysfs_emit_at(buf, len,
 			    "Node %d MemTotal:       %8lu kB\n"
 			    "Node %d MemFree:        %8lu kB\n"
 			    "Node %d MemUsed:        %8lu kB\n"
+			    "Node %d SwapCached:     %8lu kB\n"
 			    "Node %d Active:         %8lu kB\n"
 			    "Node %d Inactive:       %8lu kB\n"
 			    "Node %d Active(anon):   %8lu kB\n"
@@ -391,6 +396,7 @@ static ssize_t node_read_meminfo(struct
 			    nid, K(i.totalram),
 			    nid, K(i.freeram),
 			    nid, K(i.totalram - i.freeram),
+			    nid, K(swapcached),
 			    nid, K(node_page_state(pgdat, NR_ACTIVE_ANON) +
 				   node_page_state(pgdat, NR_ACTIVE_FILE)),
 			    nid, K(node_page_state(pgdat, NR_INACTIVE_ANON) +
--- a/include/linux/mmzone.h~mm-memcg-add-swapcache-stat-for-memcg-v2
+++ a/include/linux/mmzone.h
@@ -206,6 +206,9 @@ enum node_stat_item {
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
 	NR_PAGETABLE,		/* used for pagetables */
+#ifdef CONFIG_SWAP
+	NR_SWAPCACHE,
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/include/linux/swap.h~mm-memcg-add-swapcache-stat-for-memcg-v2
+++ a/include/linux/swap.h
@@ -408,7 +408,11 @@ extern struct address_space *swapper_spa
 #define swap_address_space(entry)			    \
 	(&swapper_spaces[swp_type(entry)][swp_offset(entry) \
 		>> SWAP_ADDRESS_SPACE_SHIFT])
-extern unsigned long total_swapcache_pages(void);
+static inline unsigned long total_swapcache_pages(void)
+{
+	return global_node_page_state(NR_SWAPCACHE);
+}
+
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *page);
 extern void *get_shadow_from_swap_cache(swp_entry_t entry);
--- a/mm/memcontrol.c~mm-memcg-add-swapcache-stat-for-memcg-v2
+++ a/mm/memcontrol.c
@@ -1521,6 +1521,9 @@ static const struct memory_stat memory_s
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
 	{ "file_writeback",		NR_WRITEBACK			},
+#ifdef CONFIG_SWAP
+	{ "swapcached",			NR_SWAPCACHE			},
+#endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{ "anon_thp",			NR_ANON_THPS			},
 	{ "file_thp",			NR_FILE_THPS			},
--- a/mm/migrate.c~mm-memcg-add-swapcache-stat-for-memcg-v2
+++ a/mm/migrate.c
@@ -500,6 +500,12 @@ int migrate_page_move_mapping(struct add
 			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
 			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 		}
+#ifdef CONFIG_SWAP
+		if (PageSwapCache(page)) {
+			__mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
+			__mod_lruvec_state(new_lruvec, NR_SWAPCACHE, nr);
+		}
+#endif
 		if (dirty && mapping_can_writeback(mapping)) {
 			__mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
 			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
--- a/mm/swap_state.c~mm-memcg-add-swapcache-stat-for-memcg-v2
+++ a/mm/swap_state.c
@@ -68,32 +68,6 @@ static struct {
 	unsigned long find_total;
 } swap_cache_info;
 
-unsigned long total_swapcache_pages(void)
-{
-	unsigned int i, j, nr;
-	unsigned long ret = 0;
-	struct address_space *spaces;
-	struct swap_info_struct *si;
-
-	for (i = 0; i < MAX_SWAPFILES; i++) {
-		swp_entry_t entry = swp_entry(i, 1);
-
-		/* Avoid get_swap_device() to warn for bad swap entry */
-		if (!swp_swap_info(entry))
-			continue;
-		/* Prevent swapoff to free swapper_spaces */
-		si = get_swap_device(entry);
-		if (!si)
-			continue;
-		nr = nr_swapper_spaces[i];
-		spaces = swapper_spaces[i];
-		for (j = 0; j < nr; j++)
-			ret += spaces[j].nrpages;
-		put_swap_device(si);
-	}
-	return ret;
-}
-
 static atomic_t swapin_readahead_hits = ATOMIC_INIT(4);
 
 void show_swap_cache_info(void)
@@ -163,6 +137,7 @@ int add_to_swap_cache(struct page *page,
 		address_space->nrexceptional -= nr_shadows;
 		address_space->nrpages += nr;
 		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
+		__mod_lruvec_page_state(page, NR_SWAPCACHE, nr);
 		ADD_CACHE_INFO(add_total, nr);
 unlock:
 		xas_unlock_irq(&xas);
@@ -203,6 +178,7 @@ void __delete_from_swap_cache(struct pag
 		address_space->nrexceptional += nr;
 	address_space->nrpages -= nr;
 	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+	__mod_lruvec_page_state(page, NR_SWAPCACHE, -nr);
 	ADD_CACHE_INFO(del_total, nr);
 }
 
--- a/mm/vmstat.c~mm-memcg-add-swapcache-stat-for-memcg-v2
+++ a/mm/vmstat.c
@@ -1215,6 +1215,9 @@ const char * const vmstat_text[] = {
 	"nr_shadow_call_stack",
 #endif
 	"nr_page_table_pages",
+#ifdef CONFIG_SWAP
+	"nr_swapcached",
+#endif
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

Patches currently in -mm which might be from shakeelb@google.com are


