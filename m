Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E17138D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ykanbh6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78132C433C8;
	Mon, 11 Dec 2023 00:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256027;
	bh=xbGv5QOpRDh2ZcTwo74Iv5c3otphaZMkrP4E3+8u7N8=;
	h=Date:To:From:Subject:From;
	b=ykanbh6Gy5oFaDXXmkBFiVhhKhi9y5jjUARlDpr6WKEgiiwG1czFzF5MYC3nvbqp/
	 zpC45GbZVdBy8M7P46qRE5OzW8GSnTjpYnf/mjOsu24ODRDHzdAhuCOawxe8bHILBJ
	 2qAJiXA2eE2/zBCccxAEgvkNbvU9+eCq/w1w+Ndc=
Date: Sun, 10 Dec 2023 16:53:47 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,rafael@kernel.org,gregkh@linuxfoundation.org,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-move-pgdemote_-to-per-node-stats.patch removed from -mm tree
Message-Id: <20231211005347.78132C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: move pgdemote_* to per-node stats
has been removed from the -mm tree.  Its filename was
     mm-vmstat-move-pgdemote_-to-per-node-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/vmstat: move pgdemote_* to per-node stats
Date: Fri, 3 Nov 2023 11:14:50 +0800

Demotion will migrate pages across nodes.  Previously, only the global
demotion statistics were accounted for.  Changed them to per-node
statistics, making it easier to observe where demotion occurs on each
node.

This will help to identify which nodes are under pressure.

This patch also make pgdemote_* behind CONFIG_NUMA_BALANCING, since
demotion is not available for !CONFIG_NUMA_BALANCING

With this patch, here is a sample where node0 node1 are DRAM,
node3 is PMEM:
Global stats:
$ grep demote /proc/vmstat
pgdemote_kswapd 254288
pgdemote_direct 113497
pgdemote_khugepaged 0

Per-node stats:
$ grep demote /sys/devices/system/node/node0/vmstat # demotion source
pgdemote_kswapd 68454
pgdemote_direct 83431
pgdemote_khugepaged 0
$ grep demote /sys/devices/system/node/node1/vmstat # demotion source
pgdemote_kswapd 185834
pgdemote_direct 30066
pgdemote_khugepaged 0
$ grep demote /sys/devices/system/node/node3/vmstat # demotion target
pgdemote_kswapd 0
pgdemote_direct 0
pgdemote_khugepaged 0

Link: https://lkml.kernel.org/r/20231103031450.1456523-1-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    4 ++++
 include/linux/vm_event_item.h |    3 ---
 mm/vmscan.c                   |   12 ++++++++----
 mm/vmstat.c                   |    6 +++---
 4 files changed, 15 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-vmstat-move-pgdemote_-to-per-node-stats
+++ a/include/linux/mmzone.h
@@ -206,6 +206,10 @@ enum node_stat_item {
 #ifdef CONFIG_NUMA_BALANCING
 	PGPROMOTE_SUCCESS,	/* promote successfully */
 	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
+	/* PGDEMOTE_*: pages demoted */
+	PGDEMOTE_KSWAPD,
+	PGDEMOTE_DIRECT,
+	PGDEMOTE_KHUGEPAGED,
 #endif
 	NR_VM_NODE_STAT_ITEMS
 };
--- a/include/linux/vm_event_item.h~mm-vmstat-move-pgdemote_-to-per-node-stats
+++ a/include/linux/vm_event_item.h
@@ -41,9 +41,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGSTEAL_KSWAPD,
 		PGSTEAL_DIRECT,
 		PGSTEAL_KHUGEPAGED,
-		PGDEMOTE_KSWAPD,
-		PGDEMOTE_DIRECT,
-		PGDEMOTE_KHUGEPAGED,
 		PGSCAN_KSWAPD,
 		PGSCAN_DIRECT,
 		PGSCAN_KHUGEPAGED,
--- a/mm/vmscan.c~mm-vmstat-move-pgdemote_-to-per-node-stats
+++ a/mm/vmscan.c
@@ -409,12 +409,14 @@ void drop_slab(void)
 
 static int reclaimer_offset(void)
 {
+#ifdef CONFIG_NUMA_BALANCING
 	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
 			PGDEMOTE_DIRECT - PGDEMOTE_KSWAPD);
-	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
-			PGSCAN_DIRECT - PGSCAN_KSWAPD);
 	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
 			PGDEMOTE_KHUGEPAGED - PGDEMOTE_KSWAPD);
+#endif
+	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
+			PGSCAN_DIRECT - PGSCAN_KSWAPD);
 	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
 			PGSCAN_KHUGEPAGED - PGSCAN_KSWAPD);
 
@@ -976,8 +978,10 @@ static unsigned int demote_folio_list(st
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
-
-	__count_vm_events(PGDEMOTE_KSWAPD + reclaimer_offset(), nr_succeeded);
+#ifdef CONFIG_NUMA_BALANCING
+	mod_node_page_state(pgdat, PGDEMOTE_KSWAPD + reclaimer_offset(),
+			    nr_succeeded);
+#endif
 
 	return nr_succeeded;
 }
--- a/mm/vmstat.c~mm-vmstat-move-pgdemote_-to-per-node-stats
+++ a/mm/vmstat.c
@@ -1248,6 +1248,9 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	"pgpromote_success",
 	"pgpromote_candidate",
+	"pgdemote_kswapd",
+	"pgdemote_direct",
+	"pgdemote_khugepaged",
 #endif
 
 	/* enum writeback_stat_item counters */
@@ -1279,9 +1282,6 @@ const char * const vmstat_text[] = {
 	"pgsteal_kswapd",
 	"pgsteal_direct",
 	"pgsteal_khugepaged",
-	"pgdemote_kswapd",
-	"pgdemote_direct",
-	"pgdemote_khugepaged",
 	"pgscan_kswapd",
 	"pgscan_direct",
 	"pgscan_khugepaged",
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are


