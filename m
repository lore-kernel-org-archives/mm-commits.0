Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D07F7DB
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 05:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785412; cv=none; b=TZo6DN86BKfAgHaOGjznfHqPOeDimnqieJAvEOj2pZOroZG1DB9d1ZJqgjDFoxq4bWZqG/Se+AY9j8Kdwf6K6rg3ujm/rUSzrbrwYYJP3JrE4Qz6k6/wOJjvkiW5E0FaieMO/grjRM+PqCZaw78ds0+CQxhuKqaSp7HAM17o4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785412; c=relaxed/simple;
	bh=yxW9WZqiCo/qP8hDHwWHrY2NI89LFE/TJmsHq1vXwFo=;
	h=Date:To:From:Subject:Message-Id; b=Sq7sLmhoCtNnzsbrYmG7OglcMxihFXnPZOHcEDijBF6XDX9ztpaWkYt58Ld68nK+r5BHkK4AiSWpGOns+9Mr+9htytkX3aCia2jo0bGtHOHFfGjgLCk7+A2EFtSyEjMpJ67nErCq4J+ZYpI8HQBS3CpsVnp8FyMFAfTQjUuv1OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pkwRiwrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pkwRiwrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CCBC32782;
	Fri, 16 Aug 2024 05:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785411;
	bh=yxW9WZqiCo/qP8hDHwWHrY2NI89LFE/TJmsHq1vXwFo=;
	h=Date:To:From:Subject:From;
	b=pkwRiwrKx2LZookZYZruQvxO1sH0+ZFjZske7IoEJwy2g7qdpyIxCon9EzmjfuZMH
	 gOf647snwQbsCqcmrCiGJKO3LjlqKWbW8H7V0BtUTeJw4E3VQecrto+8myc3Hw6t1P
	 Ky2TcEbc+qrlTo30zoPIVqyMEAIClAIqWrJGy6aU=
Date: Thu, 15 Aug 2024 22:16:51 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,fan.ni@samsung.com,david@redhat.com,dan.j.williams@intel.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-add-system-wide-stats-items-category.patch removed from -mm tree
Message-Id: <20240816051651.A0CCBC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add system wide stats items category
has been removed from the -mm tree.  Its filename was
     mm-add-system-wide-stats-items-category.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: add system wide stats items category
Date: Thu, 8 Aug 2024 21:34:35 +0000

/proc/vmstat contains events and stats, events can only grow, but stats
can grow and shrink.

vmstat has the following:
-------------------------
NR_VM_ZONE_STAT_ITEMS:	per-zone stats
NR_VM_NUMA_EVENT_ITEMS:	per-numa events
NR_VM_NODE_STAT_ITEMS:	per-numa stats
NR_VM_WRITEBACK_STAT_ITEMS:	system-wide background-writeback and
				dirty-throttling tresholds.
NR_VM_EVENT_ITEMS:	system-wide events
-------------------------

Rename NR_VM_WRITEBACK_STAT_ITEMS to NR_VM_STAT_ITEMS, to track the
system-wide stats, we are going to add per-page metadata stats to this
category in the next patch.

Also delete unused writeback_stat_name().

Link: https://lkml.kernel.org/r/20240809191020.1142142-2-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240808213437.682006-3-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yi Zhang <yi.zhang@redhat.com>
Cc: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   15 ++++-----------
 mm/vmstat.c            |    6 +++---
 2 files changed, 7 insertions(+), 14 deletions(-)

--- a/include/linux/vmstat.h~mm-add-system-wide-stats-items-category
+++ a/include/linux/vmstat.h
@@ -34,10 +34,11 @@ struct reclaim_stat {
 	unsigned nr_lazyfree_fail;
 };
 
-enum writeback_stat_item {
+/* Stat data for system wide items */
+enum vm_stat_item {
 	NR_DIRTY_THRESHOLD,
 	NR_DIRTY_BG_THRESHOLD,
-	NR_VM_WRITEBACK_STAT_ITEMS,
+	NR_VM_STAT_ITEMS,
 };
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
@@ -514,21 +515,13 @@ static inline const char *lru_list_name(
 	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
 }
 
-static inline const char *writeback_stat_name(enum writeback_stat_item item)
-{
-	return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
-			   NR_VM_NUMA_EVENT_ITEMS +
-			   NR_VM_NODE_STAT_ITEMS +
-			   item];
-}
-
 #if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
 static inline const char *vm_event_name(enum vm_event_item item)
 {
 	return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
 			   NR_VM_NUMA_EVENT_ITEMS +
 			   NR_VM_NODE_STAT_ITEMS +
-			   NR_VM_WRITEBACK_STAT_ITEMS +
+			   NR_VM_STAT_ITEMS +
 			   item];
 }
 #endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
--- a/mm/vmstat.c~mm-add-system-wide-stats-items-category
+++ a/mm/vmstat.c
@@ -1257,7 +1257,7 @@ const char * const vmstat_text[] = {
 	"pgdemote_khugepaged",
 	"nr_memmap",
 	"nr_memmap_boot",
-	/* enum writeback_stat_item counters */
+	/* system-wide enum vm_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
 
@@ -1790,7 +1790,7 @@ static const struct seq_operations zonei
 #define NR_VMSTAT_ITEMS (NR_VM_ZONE_STAT_ITEMS + \
 			 NR_VM_NUMA_EVENT_ITEMS + \
 			 NR_VM_NODE_STAT_ITEMS + \
-			 NR_VM_WRITEBACK_STAT_ITEMS + \
+			 NR_VM_STAT_ITEMS + \
 			 (IS_ENABLED(CONFIG_VM_EVENT_COUNTERS) ? \
 			  NR_VM_EVENT_ITEMS : 0))
 
@@ -1827,7 +1827,7 @@ static void *vmstat_start(struct seq_fil
 
 	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
 			    v + NR_DIRTY_THRESHOLD);
-	v += NR_VM_WRITEBACK_STAT_ITEMS;
+	v += NR_VM_STAT_ITEMS;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 	all_vm_events(v);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

