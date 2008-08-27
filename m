From: akpm@linux-foundation.org
Subject: + memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch added to -mm tree
Date: Wed, 27 Aug 2008 15:22:17 -0700
Message-ID: <200808272222.m7RMMHRd025734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbYH0WW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 18:22:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix
has been added to the -mm tree.  Its filename is
     memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
mm-owner-fix-race-between-swap-and-exit.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch

