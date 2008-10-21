From: akpm@linux-foundation.org
Subject: - memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch removed from -mm tree
Date: Mon, 20 Oct 2008 17:19:13 -0700
Message-ID: <200810210019.m9L0JDs5019614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbYJUATq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com


The patch titled
     Memory rlimit enhance mm_owner_changed callback to deal with exited owner
has been removed from the -mm tree.  Its filename was
     memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch

This patch was dropped because it was folded into memrlimit-add-memrlimit-controller-accounting-and-control.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory rlimit enhance mm_owner_changed callback to deal with exited owner
From: Balbir Singh <balbir@linux.vnet.ibm.com>

mm_owner_changed callback can also be called with new task set to NULL. 
(race between try_to_unuse() and mm->owner exiting).  Surprisingly the
order of cgroup arguments being passed was incorrect (proves that we did
not run into mm_owner_changed callback at all).

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memrlimitcgroup.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner
+++ a/mm/memrlimitcgroup.c
@@ -73,6 +73,12 @@ void memrlimit_cgroup_uncharge_as(struct
 {
 	struct memrlimit_cgroup *memrcg;
 
+	/*
+	 * Uncharge happened as a part of the mm_owner_changed callback
+	 */
+	if (!mm->owner)
+		return;
+
 	memrcg = memrlimit_cgroup_from_task(mm->owner);
 	res_counter_uncharge(&memrcg->as_res, (nr_pages << PAGE_SHIFT));
 }
@@ -193,8 +199,8 @@ out:
  * This callback is called with mmap_sem held
  */
 static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
-						struct cgroup *cgrp,
 						struct cgroup *old_cgrp,
+						struct cgroup *cgrp,
 						struct task_struct *p)
 {
 	struct memrlimit_cgroup *memrcg, *old_memrcg;
@@ -204,7 +210,12 @@ static void memrlimit_cgroup_mm_owner_ch
 	memrcg = memrlimit_cgroup_from_cgrp(cgrp);
 	old_memrcg = memrlimit_cgroup_from_cgrp(old_cgrp);
 
-	if (res_counter_charge(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
+	/*
+	 * If we don't have a new cgroup, we just uncharge from the old one.
+	 * It means that the task is going away
+	 */
+	if (memrcg &&
+	    res_counter_charge(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
 		goto out;
 	res_counter_uncharge(&old_memrcg->as_res, (mm->total_vm << PAGE_SHIFT));
 out:
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

