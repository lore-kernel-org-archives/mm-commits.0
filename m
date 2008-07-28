From: akpm@linux-foundation.org
Subject: - vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:52:16 -0700
Message-ID: <200807282352.m6SNqGHf002521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbYG1X5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:57:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     memcg: lru scan fix
has been removed from the -mm tree.  Its filename was
     vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch

This patch was dropped because it was folded into vmscan-second-chance-replacement-for-anonymous-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: lru scan fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Since rc5-mm3, memcg easily goes into OOM when limit was low.  This is a
fix to split-lru to fix OOM.

Under memcg, active anon tend not to go to inactive anon.  This will cause
OOM in memcg easily when tons of anon was used at once.  This check was
lacked in split-lru.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix
+++ a/mm/vmscan.c
@@ -1353,6 +1353,8 @@ static unsigned long shrink_zone(int pri
 	 */
 	if (!scan_global_lru(sc) || inactive_anon_is_low(zone))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
+	else if (!scan_global_lru(sc))
+		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
 	return nr_reclaimed;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroup-fix-possible-memory-leak.patch
cgroup-remove-duplicate-code-in-allocate_cg_link.patch
cgroup-uninline-cgroup_has_css_refs.patch
memcg-remove-redundant-check-in-move_task.patch
cpuset-a-bit-cleanup-for-scan_for_empty_cpusets.patch
cpuset-speed-up-sched-domain-partition.patch
cpuset-fix-wrong-calculation-of-relax-domain-level.patch
cpuset-clean-up-cpuset-hierarchy-traversal-code.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

