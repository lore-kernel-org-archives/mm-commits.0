From: akpm@linux-foundation.org
Subject: - memcg-fix-oops-in-mem_cgroup_shrink_usage.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:17 -0700
Message-ID: <200808130852.m7D8qHqr008194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbYHMIxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix oops in mem_cgroup_shrink_usage
has been removed from the -mm tree.  Its filename was
     memcg-fix-oops-in-mem_cgroup_shrink_usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix oops in mem_cgroup_shrink_usage
From: Hugh Dickins <hugh@veritas.com>

Got an oops in mem_cgroup_shrink_usage() when testing loop over tmpfs:
yes, of course, loop0 has no mm: other entry points check but this didn't.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-fix-oops-in-mem_cgroup_shrink_usage mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-oops-in-mem_cgroup_shrink_usage
+++ a/mm/memcontrol.c
@@ -796,6 +796,8 @@ int mem_cgroup_shrink_usage(struct mm_st
 
 	if (mem_cgroup_subsys.disabled)
 		return 0;
+	if (!mm)
+		return 0;
 
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
mm-owner-fix-race-between-swap-and-exit.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
make-mm-rmapc-anon_vma_cachep-static.patch
prio_tree-debugging-patch.patch

