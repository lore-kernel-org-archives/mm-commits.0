From: akpm@linux-foundation.org
Subject: + memcg-remove-memcg_tasklist.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:27:24 -0800
Message-ID: <200911122127.nACLROD8029948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546AbZKLV10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove memcg_tasklist
has been added to the -mm tree.  Its filename is
     memcg-remove-memcg_tasklist.patch

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
Subject: memcg: remove memcg_tasklist
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

memcg_tasklist was introduced at commit 7f4d454d(memcg: avoid deadlock
caused by race between oom and cpuset_attach) instead of cgroup_mutex to
fix a deadlock problem.  The cgroup_mutex, which was removed by the
commit, in mem_cgroup_out_of_memory() was originally introduced at commit
c7ba5c9e (Memory controller: OOM handling).

IIUC, the intention of this cgroup_mutex was to prevent task move during
select_bad_process() so that situations like below can be avoided.

  Assume cgroup "foo" has exceeded its limit and is about to trigger oom.
  1. Process A, which has been in cgroup "baa" and uses large memory, is just
     moved to cgroup "foo". Process A can be the candidates for being killed.
  2. Process B, which has been in cgroup "foo" and uses large memory, is just
     moved from cgroup "foo". Process B can be excluded from the candidates for
     being killed.

But these race window exists anyway even if we hold a lock, because
__mem_cgroup_try_charge() decides wether it should trigger oom or not
outside of the lock.  So the original cgroup_mutex in
mem_cgroup_out_of_memory and thus current memcg_tasklist has no use.  And
IMHO, those races are not so critical for users.

This patch removes it and make codes simpler.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-memcg_tasklist mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-memcg_tasklist
+++ a/mm/memcontrol.c
@@ -55,7 +55,6 @@ static int really_do_swap_account __init
 #define do_swap_account		(0)
 #endif
 
-static DEFINE_MUTEX(memcg_tasklist);	/* can be hold under cgroup_mutex */
 #define SOFTLIMIT_EVENTS_THRESH (1000)
 
 /*
@@ -1475,9 +1474,7 @@ static int __mem_cgroup_try_charge(struc
 
 		if (!nr_retries--) {
 			if (oom) {
-				mutex_lock(&memcg_tasklist);
 				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
-				mutex_unlock(&memcg_tasklist);
 				record_last_oom(mem_over_limit);
 			}
 			goto nomem;
@@ -3385,12 +3382,10 @@ static void mem_cgroup_move_task(struct 
 				struct task_struct *p,
 				bool threadgroup)
 {
-	mutex_lock(&memcg_tasklist);
 	/*
 	 * FIXME: It's better to move charges of this process from old
 	 * memcg to new memcg. But it's just on TODO-List now.
 	 */
-	mutex_unlock(&memcg_tasklist);
 }
 
 struct cgroup_subsys mem_cgroup_subsys = {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-wrong-pointer-initialization-at-page-migration-when-memcg-is-disabled.patch
memcg-coalesce-uncharge-during-unmap-truncate.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-coalesce-charging-via-percpu-storage-fix-2.patch
memcg-make-memcgs-file-mapped-consistent-with-global-vm.patch
memcg-add-mem_cgroup_cancel_charge.patch
memcg-cleanup-mem_cgroup_move_parent.patch
memcg-remove-memcg_tasklist.patch

