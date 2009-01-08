From: akpm@linux-foundation.org
Subject: - memcg-show-reclaim-stat.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:21 -0800
Message-ID: <200901082249.n08MnLAI028632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763264AbZAHW7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     memcg: show reclaim stat
has been removed from the -mm tree.  Its filename was
     memcg-show-reclaim-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: show reclaim stat
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Add the following four fields to memory.stat file:

  - inactive_ratio
  - recent_rotated_anon
  - recent_rotated_file
  - recent_scanned_anon
  - recent_scanned_file

Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   25 ++++++++++++++++++++
 mm/memcontrol.c                      |   30 +++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff -puN Documentation/controllers/memory.txt~memcg-show-reclaim-stat Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-show-reclaim-stat
+++ a/Documentation/controllers/memory.txt
@@ -289,6 +289,31 @@ will be charged as a new owner of it.
   Because rmdir() moves all pages to parent, some out-of-use page caches can be
   moved to the parent. If you want to avoid that, force_empty will be useful.
 
+5.2 stat file
+  memory.stat file includes following statistics (now)
+	cache			- # of pages from page-cache and shmem.
+	rss			- # of pages from anonymous memory.
+	pgpgin			- # of event of charging
+	pgpgout			- # of event of uncharging
+	active_anon		- # of pages on active lru of anon, shmem.
+	inactive_anon 		- # of pages on active lru of anon, shmem
+	active_file		- # of pages on active lru of file-cache
+	inactive_file		- # of pages on inactive lru of file cache
+	unevictable		- # of pages cannot be reclaimed.(mlocked etc)
+
+	Below is depend on CONFIG_DEBUG_VM.
+	inactive_ratio		- VM inernal parameter. (see mm/page_alloc.c)
+	recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
+	recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
+	recent_scanned_anon 	- VM internal parameter. (see mm/vmscan.c)
+	recent_scanned_file 	- VM internal parameter. (see mm/vmscan.c)
+
+  Memo:
+	recent_rotated means recent frequency of lru rotation.
+	recent_scanned means recent # of scans to lru.
+	showing for better debug please see the code for meanings.
+
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
diff -puN mm/memcontrol.c~memcg-show-reclaim-stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-show-reclaim-stat
+++ a/mm/memcontrol.c
@@ -1816,6 +1816,36 @@ static int mem_control_stat_show(struct 
 		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
 
 	}
+
+#ifdef CONFIG_DEBUG_VM
+	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);
+
+	{
+		int nid, zid;
+		struct mem_cgroup_per_zone *mz;
+		unsigned long recent_rotated[2] = {0, 0};
+		unsigned long recent_scanned[2] = {0, 0};
+
+		for_each_online_node(nid)
+			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+				mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
+
+				recent_rotated[0] +=
+					mz->reclaim_stat.recent_rotated[0];
+				recent_rotated[1] +=
+					mz->reclaim_stat.recent_rotated[1];
+				recent_scanned[0] +=
+					mz->reclaim_stat.recent_scanned[0];
+				recent_scanned[1] +=
+					mz->reclaim_stat.recent_scanned[1];
+			}
+		cb->fill(cb, "recent_rotated_anon", recent_rotated[0]);
+		cb->fill(cb, "recent_rotated_file", recent_rotated[1]);
+		cb->fill(cb, "recent_scanned_anon", recent_scanned[0]);
+		cb->fill(cb, "recent_scanned_file", recent_scanned[1]);
+	}
+#endif
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

