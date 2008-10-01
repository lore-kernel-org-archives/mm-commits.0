From: akpm@linux-foundation.org
Subject: - mm-owner-fix-race-between-swap-and-exit-fix-fix.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:58 -0700
Message-ID: <200810012152.m91LqwuJ006094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269AbYJAVxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, hugh@veritas.com, jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: handle null dereference of mm->owner
has been removed from the -mm tree.  Its filename was
     mm-owner-fix-race-between-swap-and-exit-fix-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: handle null dereference of mm->owner
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mm_update_next_owner() may clear mm->owner to NULL
if it races with swapoff, page migration, etc.
(This behavior was introduced by mm-owner-fix-race-between-swap-and-exit.patch.)

But memcg doesn't take account of this situation, and causes:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000630

This fixes it.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN mm/memcontrol.c~mm-owner-fix-race-between-swap-and-exit-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-owner-fix-race-between-swap-and-exit-fix-fix
+++ a/mm/memcontrol.c
@@ -250,6 +250,14 @@ static struct mem_cgroup *mem_cgroup_fro
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
+	/*
+	 * mm_update_next_owner() may clear mm->owner to NULL
+	 * if it races with swapoff, page migration, etc.
+	 * So this can be called with p == NULL.
+	 */
+	if (unlikely(!p))
+		return NULL;
+
 	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
 				struct mem_cgroup, css);
 }
@@ -549,6 +557,11 @@ static int mem_cgroup_charge_common(stru
 	if (likely(!memcg)) {
 		rcu_read_lock();
 		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+		if (unlikely(!mem)) {
+			rcu_read_unlock();
+			kmem_cache_free(page_cgroup_cache, pc);
+			return 0;
+		}
 		/*
 		 * For every charge from the cgroup, increment reference count
 		 */
@@ -801,6 +814,10 @@ int mem_cgroup_shrink_usage(struct mm_st
 
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	if (unlikely(!mem)) {
+		rcu_read_unlock();
+		return 0;
+	}
 	css_get(&mem->css);
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch
unevictable-lru-infrastructure.patch

