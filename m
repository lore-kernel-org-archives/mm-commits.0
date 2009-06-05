From: akpm@linux-foundation.org
Subject: + memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch added to -mm tree
Date: Fri, 05 Jun 2009 12:58:29 -0700
Message-ID: <200906051958.n55JwTwl007233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbZFET6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 15:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: fix behavior under memory.limit equals to memsw.limit
has been added to the -mm tree.  Its filename is
     memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix behavior under memory.limit equals to memsw.limit
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A user can set memcg.limit_in_bytes == memcg.memsw.limit_in_bytes when the
user just want to limit the total size of applications, in other words,
not very interested in memory usage itself.  In this case, swap-out will
be done only by global-LRU.

But, under current implementation, memory.limit_in_bytes is checked at
first and try_to_free_page() may do swap-out.  But, that swap-out is
useless for memsw.limit_in_bytes and the thread may hit limit again.

This patch tries to fix the current behavior at memory.limit ==
memsw.limit case.  And documentation is updated to explain the behavior of
this special case.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   17 +++++++++++------
 mm/memcontrol.c                  |   19 +++++++++++++++++++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-fix-behavior-under-memorylimit-equals-to-memswlimit Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-fix-behavior-under-memorylimit-equals-to-memswlimit
+++ a/Documentation/cgroups/memory.txt
@@ -152,14 +152,19 @@ When swap is accounted, following files 
 
 usage of mem+swap is limited by memsw.limit_in_bytes.
 
-Note: why 'mem+swap' rather than swap.
+* why 'mem+swap' rather than swap.
 The global LRU(kswapd) can swap out arbitrary pages. Swap-out means
 to move account from memory to swap...there is no change in usage of
-mem+swap.
-
-In other words, when we want to limit the usage of swap without affecting
-global LRU, mem+swap limit is better than just limiting swap from OS point
-of view.
+mem+swap. In other words, when we want to limit the usage of swap without
+affecting global LRU, mem+swap limit is better than just limiting swap from
+OS point of view.
+
+* What happens when a cgroup hits memory.memsw.limit_in_bytes
+When a cgroup his memory.memsw.limit_in_bytes, it's useless to do swap-out
+in this cgroup. Then, swap-out will not be done by cgroup routine and file
+caches are dropped. But as mentioned above, global LRU can do swapout memory
+from it for sanity of the system's memory management state. You can't forbid
+it by cgroup.
 
 2.5 Reclaim
 
diff -puN mm/memcontrol.c~memcg-fix-behavior-under-memorylimit-equals-to-memswlimit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-behavior-under-memorylimit-equals-to-memswlimit
+++ a/mm/memcontrol.c
@@ -177,6 +177,9 @@ struct mem_cgroup {
 
 	unsigned int	swappiness;
 
+	/* set when res.limit == memsw.limit */
+	bool		memsw_is_minimum;
+
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -847,6 +850,10 @@ static int mem_cgroup_hierarchical_recla
 	int ret, total = 0;
 	int loop = 0;
 
+	/* If memsw_is_minimum==1, swap-out is of-no-use. */
+	if (root_mem->memsw_is_minimum)
+		noswap = true;
+
 	while (loop < 2) {
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem)
@@ -1752,6 +1759,12 @@ static int mem_cgroup_resize_limit(struc
 			break;
 		}
 		ret = res_counter_set_limit(&memcg->res, val);
+		if (!ret) {
+			if (memswlimit == val)
+				memcg->memsw_is_minimum = true;
+			else
+				memcg->memsw_is_minimum = false;
+		}
 		mutex_unlock(&set_limit_mutex);
 
 		if (!ret)
@@ -1799,6 +1812,12 @@ static int mem_cgroup_resize_memsw_limit
 			break;
 		}
 		ret = res_counter_set_limit(&memcg->memsw, val);
+		if (!ret) {
+			if (memlimit == val)
+				memcg->memsw_is_minimum = true;
+			else
+				memcg->memsw_is_minimum = false;
+		}
 		mutex_unlock(&set_limit_mutex);
 
 		if (!ret)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

migration-only-migrate_prep-once-per-move_pages.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
mm-add-swap-cache-interface-for-swap-reference.patch
mm-modify-swap_map-and-add-swap_has_cache-flag.patch
mm-modify-swap_map-and-add-swap_has_cache-flag-update.patch
mm-reuse-unused-swap-entry-if-necessary.patch
mm-reuse-unused-swap-entry-if-necessary-update.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch
memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch

