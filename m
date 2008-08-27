From: akpm@linux-foundation.org
Subject: + memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch added to -mm tree
Date: Wed, 27 Aug 2008 15:21:31 -0700
Message-ID: <200808272221.m7RMLVAv025707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbYH0WVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 18:21:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memrlimit-setup-the-memrlimit-controller-mm_owner-fix
has been added to the -mm tree.  Its filename is
     memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch

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
Subject: memrlimit-setup-the-memrlimit-controller-mm_owner-fix
From: Balbir Singh <balbir@linux.vnet.ibm.com> and
      Li Zefan <lizf@cn.fujitsu.com>

This patch allows mm->owner to be NULL when mm_owner callback is called.
Without this patch, (for example) you can see panic while you do migrate
a set of task, which calls fork/exit.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +++--
 kernel/exit.c   |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/cgroup.c~memrlimit-setup-the-memrlimit-controller-mm_owner-fix kernel/cgroup.c
--- a/kernel/cgroup.c~memrlimit-setup-the-memrlimit-controller-mm_owner-fix
+++ a/kernel/cgroup.c
@@ -2761,13 +2761,14 @@ void cgroup_fork_callbacks(struct task_s
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
-	struct cgroup *oldcgrp, *newcgrp = NULL;
+	struct cgroup *oldcgrp = NULL, *newcgrp = NULL;
 
 	if (need_mm_owner_callback) {
 		int i;
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
-			oldcgrp = task_cgroup(old, ss->subsys_id);
+			if (old)
+				oldcgrp = task_cgroup(old, ss->subsys_id);
 			if (new)
 				newcgrp = task_cgroup(new, ss->subsys_id);
 			if (oldcgrp == newcgrp)
diff -puN kernel/exit.c~memrlimit-setup-the-memrlimit-controller-mm_owner-fix kernel/exit.c
--- a/kernel/exit.c~memrlimit-setup-the-memrlimit-controller-mm_owner-fix
+++ a/kernel/exit.c
@@ -641,8 +641,8 @@ retry:
 	 * the callback and take action
 	 */
 	down_write(&mm->mmap_sem);
-	cgroup_mm_owner_callbacks(mm->owner, NULL);
 	mm->owner = NULL;
+	cgroup_mm_owner_callbacks(mm->owner, NULL);
 	up_write(&mm->mmap_sem);
 	return;
 
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
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch

