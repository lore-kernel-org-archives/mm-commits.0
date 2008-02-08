From: akpm@linux-foundation.org
Subject: - per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:36 -0800
Message-ID: <200802080804.m1884HTc014253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761701AbYBHIaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:30:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     per-zone and reclaim enhancements for memory controller: add scan_global_lru macro
has been removed from the -mm tree.  Its filename was
     per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: per-zone and reclaim enhancements for memory controller: add scan_global_lru macro
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This is used to detect which scan_control scans global lru or mem_cgroup lru. 
And compiled to be static value (1) when memory controller is not configured. 
This may make the meaning obvious.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro mm/vmscan.c
--- a/mm/vmscan.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro
+++ a/mm/vmscan.c
@@ -126,6 +126,12 @@ long vm_total_pages;	/* The total number
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
+#ifdef CONFIG_CGROUP_MEM_CONT
+#define scan_global_lru(sc)	(!(sc)->mem_cgroup)
+#else
+#define scan_global_lru(sc)	(1)
+#endif
+
 /*
  * Add a shrinker callback to be called from the vm
  */
@@ -1280,11 +1286,12 @@ static unsigned long do_try_to_free_page
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
 		 */
-		if (sc->mem_cgroup == NULL)
+		if (scan_global_lru(sc)) {
 			shrink_slab(sc->nr_scanned, gfp_mask, lru_pages);
-		if (reclaim_state) {
-			nr_reclaimed += reclaim_state->reclaimed_slab;
-			reclaim_state->reclaimed_slab = 0;
+			if (reclaim_state) {
+				nr_reclaimed += reclaim_state->reclaimed_slab;
+				reclaim_state->reclaimed_slab = 0;
+			}
 		}
 		total_scanned += sc->nr_scanned;
 		if (nr_reclaimed >= sc->swap_cluster_max) {
@@ -1311,7 +1318,7 @@ static unsigned long do_try_to_free_page
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
-	if (!sc->all_unreclaimable && sc->mem_cgroup == NULL)
+	if (!sc->all_unreclaimable && scan_global_lru(sc))
 		ret = 1;
 out:
 	/*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
