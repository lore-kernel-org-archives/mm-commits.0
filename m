From: akpm@linux-foundation.org
Subject: + memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch added to -mm tree
Date: Tue, 01 Jul 2008 15:27:49 -0700
Message-ID: <200807012227.m61MRoW9017877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800AbYGAW22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 18:28:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memrlimit handle attach_task() failure, add can_attach() callback (update)
has been added to the -mm tree.  Its filename is
     memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch

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
Subject: memrlimit handle attach_task() failure, add can_attach() callback (update)
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Changelog v2->v1

1. Rename res_counter_add_check() to res_counter_can_add()

Making the first argument (struct res_counter *) a constant pointer causes
the compiler to spew out warnings in spin_(un)lock_irq* routines, since
we now pass address from a constant pointer to the lock routines.

This patch fixes a task migration problem reported by Kamezawa-San. This
patch should fix all issues with migraiton, except for a rare condition
documented in memrlimit_cgroup_move_task(). To fix that problem, we
would need to add transaction properties to cgroups.

The problem reported was that migrating to a group that did not have
sufficient limits to accept an incoming task caused a kernel warning.

Steps to reproduce

% mkdir /dev/cgroup/memrlimit/group_01
% mkdir /dev/cgroup/memrlimit/group_02
% echo 1G > /dev/cgroup/memrlimit/group_01/memrlimit.limit_in_bytes
% echo 0 >  /dev/cgroup/memrlimit/group_02/memrlimit.limit_in_bytes
% echo $$ > /dev/cgroup/memrlimit/group_01/tasks
% echo $$ > /dev/cgroup/memrlimit/group_02/tasks
% exit

memrlimit does the right thing by not moving the charges to group_02,
but the task is still put into g2 (since we did not use can_attach to
fail migration). Once in g2, when we echo the task to the root cgroup,
it tries to uncharge the cost of the task from g2. g2 does not have
any charge associated with the task, hence we get a warning.

Reviewed-by: <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    2 +-
 mm/memrlimitcgroup.c        |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/res_counter.h~memrlimit-handle-attach_task-failure-add-can_attach-callback-update include/linux/res_counter.h
--- a/include/linux/res_counter.h~memrlimit-handle-attach_task-failure-add-can_attach-callback-update
+++ a/include/linux/res_counter.h
@@ -163,7 +163,7 @@ static inline void res_counter_reset_fai
  * Add the value val to the resource counter and check if we are
  * still under the limit.
  */
-static inline bool res_counter_add_check(struct res_counter *cnt,
+static inline bool res_counter_can_add(struct res_counter *cnt,
 						unsigned long val)
 {
 	bool ret = false;
diff -puN mm/memrlimitcgroup.c~memrlimit-handle-attach_task-failure-add-can_attach-callback-update mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-handle-attach_task-failure-add-can_attach-callback-update
+++ a/mm/memrlimitcgroup.c
@@ -176,8 +176,7 @@ static int memrlimit_cgroup_can_move_tas
 
 	memrcg = memrlimit_cgroup_from_cgrp(cgrp);
 
-	if (!res_counter_add_check(&memrcg->as_res,
-				(mm->total_vm << PAGE_SHIFT)))
+	if (!res_counter_can_add(&memrcg->as_res, (mm->total_vm << PAGE_SHIFT)))
 		ret = -ENOMEM;
 out:
 	rcu_read_unlock();
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

delay-accounting-maintainer-update.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
distinct-tgid-tid-i-o-statistics.patch
per-task-delay-accounting-add-memory-reclaim-delay.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch

