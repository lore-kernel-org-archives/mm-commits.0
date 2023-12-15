Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276F53FE45
	for <mm-commits@vger.kernel.org>; Fri, 15 Dec 2023 19:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EEx/mp0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7154C433C8;
	Fri, 15 Dec 2023 19:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702668339;
	bh=Zj3ibHL0WdmSNpy4+MlTYeg5kzHQLCdoPts7xRxuITs=;
	h=Date:To:From:Subject:From;
	b=EEx/mp0FE2W/xJU+ivMAthNGFXkPsgOXTps4yL2gauxU4ajJ9RlmplFJv2aO5UEq9
	 f0sfZZqm6J8L/3j3BqnsXI+U/v9eHdwR/+9i+yvhX/0K8wYKRy2cL1PsSCEglAV6UZ
	 XBaK0Z718Q+ZWThTKQkLAzox4ONnnqDzoapQ7bIQ=
Date: Fri, 15 Dec 2023 11:25:39 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,shakeelb@google.com,sachinp@linux.ibm.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mgorman@techsingularity.net,hannes@cmpxchg.org,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch removed from -mm tree
Message-Id: <20231215192539.A7154C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: try to reclaim swapcache pages if no swap space
has been removed from the -mm tree.  Its filename was
     mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: vmscan: try to reclaim swapcache pages if no swap space
Date: Wed, 30 Aug 2023 11:56:00 +0800

When spaces of swap devices are exhausted, only file pages can be
reclaimed.  But there are still some swapcache pages in anon lru list. 
This can lead to a premature out-of-memory.

The problem is found with such step:

 Firstly, set a 9MB disk swap space, then create a cgroup with 10MB
 memory limit, then runs an program to allocates about 15MB memory.

The problem occurs occasionally, which may need about 100 times [1].

Fix it by checking number of swapcache pages in can_reclaim_anon_pages(). 
If the number is not zero, return true and set swapcache_only to 1.  When
scan anon lru list in swapcache_only mode, non-swapcache pages will be
skipped to isolate in order to accelerate reclaim efficiency.

However, in swapcache_only mode, the scan count still increased when scan
non-swapcache pages because there are large number of non-swapcache pages
and rare swapcache pages in swapcache_only mode, and if the non-swapcache
is skipped and do not count, the scan of pages in isolate_lru_folios() can
eventually lead to hung task, just as Sachin reported [2].

By the way, since there are enough times of memory reclaim before OOM, it
is not need to isolate too much swapcache pages in one times.

[1]. https://lore.kernel.org/lkml/CAJD7tkZAfgncV+KbKr36=eDzMnT=9dZOT0dpMWcurHLr6Do+GA@mail.gmail.com/
[2]. https://lore.kernel.org/linux-mm/CAJD7tkafz_2XAuqE8tGLPEcpLngewhUo=5US14PAtSM9tLBUQg@mail.gmail.com/

[liushixin2@huawei.com: fix NULL pointing derefence and hung task problem reported by Sachin]
  Link: https://lkml.kernel.org/r/20230915083417.3190512-1-liushixin2@huawei.com
Link: https://lore.kernel.org/lkml/CAJD7tkZAfgncV+KbKr36=eDzMnT=9dZOT0dpMWcurHLr6Do+GA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230830035600.1656792-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Tested-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 mm/memcontrol.c      |    8 ++++++++
 mm/vmscan.c          |   24 ++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

--- a/include/linux/swap.h~mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space
+++ a/include/linux/swap.h
@@ -655,6 +655,7 @@ static inline void mem_cgroup_uncharge_s
 }
 
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
+extern long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
@@ -677,6 +678,11 @@ static inline long mem_cgroup_get_nr_swa
 	return get_nr_swap_pages();
 }
 
+static inline long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
+{
+	return total_swapcache_pages();
+}
+
 static inline bool mem_cgroup_swap_full(struct folio *folio)
 {
 	return vm_swap_full();
--- a/mm/memcontrol.c~mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space
+++ a/mm/memcontrol.c
@@ -7898,6 +7898,14 @@ long mem_cgroup_get_nr_swap_pages(struct
 	return nr_swap_pages;
 }
 
+long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return total_swapcache_pages();
+
+	return memcg_page_state(memcg, NR_SWAPCACHE);
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
--- a/mm/vmscan.c~mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space
+++ a/mm/vmscan.c
@@ -136,6 +136,9 @@ struct scan_control {
 	/* Always discard instead of demoting to lower tier memory */
 	unsigned int no_demotion:1;
 
+	/* Swap space is exhausted, only reclaim swapcache for anon LRU */
+	unsigned int swapcache_only:1;
+
 	/* Allocation order */
 	s8 order;
 
@@ -319,10 +322,22 @@ static inline bool can_reclaim_anon_page
 		 */
 		if (get_nr_swap_pages() > 0)
 			return true;
+		/* Is there any swapcache pages to reclaim? */
+		if (total_swapcache_pages() > 0) {
+			if (sc)
+				sc->swapcache_only = 1;
+			return true;
+		}
 	} else {
 		/* Is the memcg below its swap limit? */
 		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
 			return true;
+		/* Is there any swapcache pages in memcg to reclaim? */
+		if (mem_cgroup_get_nr_swapcache_pages(memcg) > 0) {
+			if (sc)
+				sc->swapcache_only = 1;
+			return true;
+		}
 	}
 
 	/*
@@ -1646,6 +1661,15 @@ static unsigned long isolate_lru_folios(
 		 */
 		scan += nr_pages;
 
+		/*
+		 * Count non-swapcache too because the swapcache pages may
+		 * be rare and it takes too much times here if not count
+		 * the non-swapcache pages.
+		 */
+		if (unlikely(sc->swapcache_only && !is_file_lru(lru) &&
+		    !folio_test_swapcache(folio)))
+			goto move;
+
 		if (!folio_test_lru(folio))
 			goto move;
 		if (!sc->may_unmap && folio_mapped(folio))
_

Patches currently in -mm which might be from liushixin2@huawei.com are


