Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93979C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9FF64ECE
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhBYTZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234326AbhBYTW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:22:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D1D64EFA;
        Thu, 25 Feb 2021 19:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280441;
        bh=9xsSKo+9rco4d5K5dUnKXVD9beJHEaTvh/h9bJz5NrE=;
        h=Date:From:To:Subject:From;
        b=vce/BkNSBF9ybHIXhaeEMXzGgmkK0yCamwfNz1y67/RQIeLNMYpOpoY0T0+hsPNAg
         KvFZFxRWq81g7g9nxgm2H4YLbOnwd1yd735CFRLGaZxRSEOyEjyvzKtEidFPC/uVL4
         F0j3krgiyswWj+RCjE5g5akZ5AgSy3pxL2/pznpY=
Date:   Thu, 25 Feb 2021 11:14:00 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, feng.tang@intel.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, iamjoonsoo.kim@lge.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de,
        pankaj.gupta@cloud.ionos.com, rafael@kernel.org,
        rdunlap@infradead.org, samitolvanen@google.com,
        shakeelb@google.com, songmuchun@bytedance.com,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-convert-nr_file_thps-account-to-pages.patch removed from -mm
 tree
Message-ID: <20210225191400.LaRfW-x3e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: convert NR_FILE_THPS account to pages
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-nr_file_thps-account-to-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: convert NR_FILE_THPS account to pages

Currently we use struct per_cpu_nodestat to cache the vmstat counters,
which leads to inaccurate statistics especially THP vmstat counters.  In
the systems with if hundreds of processors it can be GBs of memory.  For
example, for a 96 CPUs system, the threshold is the maximum number of 125.
And the per cpu counters can cache 23.4375 GB in total.

The THP page is already a form of batched addition (it will add 512 worth
of memory in one go) so skipping the batching seems like sensible. 
Although every THP stats update overflows the per-cpu counter, resorting
to atomic global updates.  But it can make the statistics more accuracy
for the THP vmstat counters.

So we convert the NR_FILE_THPS account to pages.  This patch is consistent
with 8f182270dfec ("mm/swap.c: flush lru pvecs on compound page arrival").
Doing this also can make the unit of vmstat counters more unified. 
Finally, the unit of the vmstat counters are pages, kB and bytes.  The
B/KB suffix can tell us that the unit is bytes or kB.  The rest which is
without suffix are pages.

Link: https://lkml.kernel.org/r/20201228164110.2838-4-songmuchun@bytedance.com
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
 mm/huge_memory.c       |    5 ++++-
 mm/khugepaged.c        |    4 +++-
 mm/memcontrol.c        |    5 ++---
 7 files changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/base/node.c~mm-memcontrol-convert-nr_file_thps-account-to-pages
+++ a/drivers/base/node.c
@@ -466,8 +466,7 @@ static ssize_t node_read_meminfo(struct
 				    HPAGE_PMD_NR),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED) *
 				    HPAGE_PMD_NR),
-			     nid, K(node_page_state(pgdat, NR_FILE_THPS) *
-				    HPAGE_PMD_NR),
+			     nid, K(node_page_state(pgdat, NR_FILE_THPS)),
 			     nid, K(node_page_state(pgdat, NR_FILE_PMDMAPPED) *
 				    HPAGE_PMD_NR)
 #endif
--- a/fs/proc/meminfo.c~mm-memcontrol-convert-nr_file_thps-account-to-pages
+++ a/fs/proc/meminfo.c
@@ -135,7 +135,7 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "ShmemPmdMapped: ",
 		    global_node_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR);
 	show_val_kb(m, "FileHugePages:  ",
-		    global_node_page_state(NR_FILE_THPS) * HPAGE_PMD_NR);
+		    global_node_page_state(NR_FILE_THPS));
 	show_val_kb(m, "FilePmdMapped:  ",
 		    global_node_page_state(NR_FILE_PMDMAPPED) * HPAGE_PMD_NR);
 #endif
--- a/include/linux/mmzone.h~mm-memcontrol-convert-nr_file_thps-account-to-pages
+++ a/include/linux/mmzone.h
@@ -219,7 +219,8 @@ static __always_inline bool vmstat_item_
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return false;
 
-	return item == NR_ANON_THPS;
+	return item == NR_ANON_THPS ||
+	       item == NR_FILE_THPS;
 }
 
 /*
--- a/mm/filemap.c~mm-memcontrol-convert-nr_file_thps-account-to-pages
+++ a/mm/filemap.c
@@ -208,7 +208,7 @@ static void unaccount_page_cache_page(st
 		if (PageTransHuge(page))
 			__dec_lruvec_page_state(page, NR_SHMEM_THPS);
 	} else if (PageTransHuge(page)) {
-		__dec_lruvec_page_state(page, NR_FILE_THPS);
+		__mod_lruvec_page_state(page, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
 
--- a/mm/huge_memory.c~mm-memcontrol-convert-nr_file_thps-account-to-pages
+++ a/mm/huge_memory.c
@@ -2752,10 +2752,13 @@ int split_huge_page_to_list(struct page
 		}
 		spin_unlock(&ds_queue->split_queue_lock);
 		if (mapping) {
+			int nr = thp_nr_pages(head);
+
 			if (PageSwapBacked(head))
 				__dec_lruvec_page_state(head, NR_SHMEM_THPS);
 			else
-				__dec_lruvec_page_state(head, NR_FILE_THPS);
+				__mod_lruvec_page_state(head, NR_FILE_THPS,
+							-nr);
 		}
 
 		__split_huge_page(page, list, end);
--- a/mm/khugepaged.c~mm-memcontrol-convert-nr_file_thps-account-to-pages
+++ a/mm/khugepaged.c
@@ -1643,6 +1643,7 @@ static void collapse_file(struct mm_stru
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
 	bool is_shmem = shmem_file(file);
+	int nr;
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
@@ -1854,11 +1855,12 @@ out_unlock:
 		put_page(page);
 		goto xa_unlocked;
 	}
+	nr = thp_nr_pages(new_page);
 
 	if (is_shmem)
 		__inc_lruvec_page_state(new_page, NR_SHMEM_THPS);
 	else {
-		__inc_lruvec_page_state(new_page, NR_FILE_THPS);
+		__mod_lruvec_page_state(new_page, NR_FILE_THPS, nr);
 		filemap_nr_thps_inc(mapping);
 	}
 
--- a/mm/memcontrol.c~mm-memcontrol-convert-nr_file_thps-account-to-pages
+++ a/mm/memcontrol.c
@@ -1534,7 +1534,7 @@ static struct memory_stat memory_stats[]
 	 * constant(e.g. powerpc).
 	 */
 	{ "anon_thp", PAGE_SIZE, NR_ANON_THPS },
-	{ "file_thp", 0, NR_FILE_THPS },
+	{ "file_thp", PAGE_SIZE, NR_FILE_THPS },
 	{ "shmem_thp", 0, NR_SHMEM_THPS },
 #endif
 	{ "inactive_anon", PAGE_SIZE, NR_INACTIVE_ANON },
@@ -1566,8 +1566,7 @@ static int __init memory_stats_init(void
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		if (memory_stats[i].idx == NR_FILE_THPS ||
-		    memory_stats[i].idx == NR_SHMEM_THPS)
+		if (memory_stats[i].idx == NR_SHMEM_THPS)
 			memory_stats[i].ratio = HPAGE_PMD_SIZE;
 #endif
 		VM_BUG_ON(!memory_stats[i].ratio);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


