From: akpm@linux-foundation.org
Subject: - memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch removed from -mm tree
Date: Mon, 20 Oct 2008 17:19:20 -0700
Message-ID: <200810210019.m9L0JKid019637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbYJUAT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 20:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix
has been removed from the -mm tree.  Its filename was
     memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch

This patch was dropped because it was folded into memrlimit-add-memrlimit-controller-accounting-and-control.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix
From: Balbir Singh <balbir@linux.vnet.ibm.com> and
      Li Zefan <lizf@cn.fujitsu.com>

mm owner fix.

This patch allows mm->owner to be NULL when mm_owner callback is called.
Without this patch, (for example) you can see panic while you do migrate
a set of task, which calls fork/exit.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memrlimitcgroup.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix
+++ a/mm/memrlimitcgroup.c
@@ -207,17 +207,23 @@ static void memrlimit_cgroup_mm_owner_ch
 	struct mm_struct *mm = get_task_mm(p);
 
 	BUG_ON(!mm);
-	memrcg = memrlimit_cgroup_from_cgrp(cgrp);
-	old_memrcg = memrlimit_cgroup_from_cgrp(old_cgrp);
 
 	/*
 	 * If we don't have a new cgroup, we just uncharge from the old one.
 	 * It means that the task is going away
 	 */
-	if (memrcg &&
-	    res_counter_charge(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
-		goto out;
-	res_counter_uncharge(&old_memrcg->as_res, (mm->total_vm << PAGE_SHIFT));
+	if (cgrp) {
+		memrcg = memrlimit_cgroup_from_cgrp(cgrp);
+		if (res_counter_charge(&memrcg->as_res,
+				mm->total_vm << PAGE_SHIFT))
+			goto out;
+	}
+
+	if (old_cgrp) {
+		old_memrcg = memrlimit_cgroup_from_cgrp(old_cgrp);
+		res_counter_uncharge(&old_memrcg->as_res,
+				mm->total_vm <<PAGE_SHIFT);
+	}
 out:
 	mmput(mm);
 }
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

