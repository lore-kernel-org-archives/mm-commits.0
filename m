From: akpm@linux-foundation.org
Subject: - memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:28:22 -0700
Message-ID: <200807250028.m6P0SMTE014180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbYGYA3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:29:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com


The patch titled
     memrlimit: fix mmap_sem deadlock
has been removed from the -mm tree.  Its filename was
     memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch

This patch was dropped because it was folded into memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: fix mmap_sem deadlock
From: Hugh Dickins <hugh@veritas.com>

"ps -f" hung after "killall make" of make -j20 kernel builds.  It's
generally considered bad manners to down_write something you already have
down_read.  exit_mm up_reads before calling mm_update_next_owner, so I
guess exec_mmap can safely do so too.  (And with that repositioning
there's not much point in mm_need_new_owner allowing for NULL mm.)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    2 +-
 kernel/exit.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/exec.c~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock fs/exec.c
--- a/fs/exec.c~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock
+++ a/fs/exec.c
@@ -738,11 +738,11 @@ static int exec_mmap(struct mm_struct *m
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
 	task_unlock(tsk);
-	mm_update_next_owner(old_mm);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
 		BUG_ON(active_mm != old_mm);
+		mm_update_next_owner(old_mm);
 		mmput(old_mm);
 		return 0;
 	}
diff -puN kernel/exit.c~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock kernel/exit.c
--- a/kernel/exit.c~memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock
+++ a/kernel/exit.c
@@ -586,8 +586,6 @@ mm_need_new_owner(struct mm_struct *mm, 
 	 * If there are other users of the mm and the owner (us) is exiting
 	 * we need to find a new owner to take on the responsibility.
 	 */
-	if (!mm)
-		return 0;
 	if (atomic_read(&mm->mm_users) <= 1)
 		return 0;
 	if (mm->owner != p)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exec-remove-some-includes.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch

