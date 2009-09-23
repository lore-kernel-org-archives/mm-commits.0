From: akpm@linux-foundation.org
Subject: [folded] memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:31:36 -0700
Message-ID: <200909232231.n8NMVbLI021406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbZIWWbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix softlimit css refcnt handling
has been removed from the -mm tree.  Its filename was
     memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch

This patch was dropped because it was folded into memory-controller-soft-limit-reclaim-on-contention-v9.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix softlimit css refcnt handling
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

SoftLimit tree 'find next one' loop uses next_mz to remember next one to
be visited if reclaimd==0.

But css'refcnt handling for next_mz is not enough and it makes css->refcnt
leak.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling
+++ a/mm/memcontrol.c
@@ -2226,6 +2226,8 @@ unsigned long mem_cgroup_soft_limit_recl
 		if (!reclaimed) {
 			do {
 				/*
+				 * Loop until we find yet another one.
+				 *
 				 * By the time we get the soft_limit lock
 				 * again, someone might have aded the
 				 * group back on the RB tree. Iterate to
@@ -2236,7 +2238,12 @@ unsigned long mem_cgroup_soft_limit_recl
 				 */
 				next_mz =
 				__mem_cgroup_largest_soft_limit_node(mctz);
-			} while (next_mz == mz);
+				if (next_mz == mz) {
+					css_put(&next_mz->mem->css);
+					next_mz = NULL;
+				} else /* next_mz == NULL or other memcg */
+					break;
+			} while (1);
 		}
 		mz->usage_in_excess =
 			res_counter_soft_limit_excess(&mz->mem->res);
@@ -2264,6 +2271,8 @@ unsigned long mem_cgroup_soft_limit_recl
 			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
 			break;
 	} while (!nr_reclaimed);
+	if (next_mz)
+		css_put(&next_mz->mem->css);
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

