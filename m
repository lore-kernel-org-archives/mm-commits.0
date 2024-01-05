Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156034571
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZlNiE4d2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF82C433C8;
	Fri,  5 Jan 2024 18:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478729;
	bh=8y5bqMV+eKMf1GyyZE0tu5WNTwVcuYby3tE2wCpwor0=;
	h=Date:To:From:Subject:From;
	b=ZlNiE4d2ggBE5up77z9QfRHn7/ylBpldQE02lyIVBFU8dPdWdRh7qjQe6F4dlQxVY
	 YvTAXpVpz/dH20WpqAZXDneOGb3p5Bp9mVx56Ip0cirEuiuVF+mGeCkAZi2/O9SFE1
	 HnIA0VDta+IV8ThdNn9ICsz3eDClNhqCo74JKGoE=
Date: Fri, 05 Jan 2024 10:18:49 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,rafael@kernel.org,gregkh@linuxfoundation.org,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-move-pgdemote_-out-of-config_numa_balancing.patch removed from -mm tree
Message-Id: <20240105181849.9FF82C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: move pgdemote_* out of CONFIG_NUMA_BALANCING
has been removed from the -mm tree.  Its filename was
     mm-vmstat-move-pgdemote_-out-of-config_numa_balancing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/vmstat: move pgdemote_* out of CONFIG_NUMA_BALANCING
Date: Fri, 29 Dec 2023 10:26:51 +0800

Demotion can work well without CONFIG_NUMA_BALANCING.  But the commit
23e9f0138963 ("mm/vmstat: move pgdemote_* to per-node stats") wrongly hid
it behind CONFIG_NUMA_BALANCING.

Fix it by moving them out of CONFIG_NUMA_BALANCING.

Link: https://lkml.kernel.org/r/20231229022651.3229174-1-lizhijian@fujitsu.com
Fixes: 23e9f0138963 ("mm/vmstat: move pgdemote_* to per-node stats")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmscan.c            |    5 +----
 mm/vmstat.c            |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/include/linux/mmzone.h~mm-vmstat-move-pgdemote_-out-of-config_numa_balancing
+++ a/include/linux/mmzone.h
@@ -207,11 +207,11 @@ enum node_stat_item {
 #ifdef CONFIG_NUMA_BALANCING
 	PGPROMOTE_SUCCESS,	/* promote successfully */
 	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
+#endif
 	/* PGDEMOTE_*: pages demoted */
 	PGDEMOTE_KSWAPD,
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
-#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/mm/vmscan.c~mm-vmstat-move-pgdemote_-out-of-config_numa_balancing
+++ a/mm/vmscan.c
@@ -409,12 +409,10 @@ void drop_slab(void)
 
 static int reclaimer_offset(void)
 {
-#ifdef CONFIG_NUMA_BALANCING
 	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
 			PGDEMOTE_DIRECT - PGDEMOTE_KSWAPD);
 	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
 			PGDEMOTE_KHUGEPAGED - PGDEMOTE_KSWAPD);
-#endif
 	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
 			PGSCAN_DIRECT - PGSCAN_KSWAPD);
 	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
@@ -978,10 +976,9 @@ static unsigned int demote_folio_list(st
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
-#ifdef CONFIG_NUMA_BALANCING
+
 	mod_node_page_state(pgdat, PGDEMOTE_KSWAPD + reclaimer_offset(),
 			    nr_succeeded);
-#endif
 
 	return nr_succeeded;
 }
--- a/mm/vmstat.c~mm-vmstat-move-pgdemote_-out-of-config_numa_balancing
+++ a/mm/vmstat.c
@@ -1248,10 +1248,10 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	"pgpromote_success",
 	"pgpromote_candidate",
+#endif
 	"pgdemote_kswapd",
 	"pgdemote_direct",
 	"pgdemote_khugepaged",
-#endif
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are


