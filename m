From: akpm@linux-foundation.org
Subject: [merged]
 oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch removed from
 -mm tree
Date: Mon, 23 May 2016 12:45:48 -0700
Message-ID: <57435dec.Uih82KIpt8sQ90kh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbcEWTpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, iamjoonsoo.kim@lge.com, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: consider multi-threaded tasks in task_will_free_mem
has been removed from the -mm tree.  Its filename was
     oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom: consider multi-threaded tasks in task_will_free_mem

task_will_free_mem is a misnomer for a more complex PF_EXITING test for
early break out from the oom killer because it is believed that such a
task would release its memory shortly and so we do not have to select an
oom victim and perform a disruptive action.

Currently we make sure that the given task is not participating in the
core dumping because it might get blocked for a long time - see
d003f371b270 ("oom: don't assume that a coredumping thread will exit
soon").

The check can still do better though.  We shouldn't consider the task
unless the whole thread group is going down.  This is rather unlikely but
not impossible.  A single exiting thread would surely leave all the
address space behind.  If we are really unlucky it might get stuck on the
exit path and keep its TIF_MEMDIE and so block the oom killer.

Link: http://lkml.kernel.org/r/1460452756-15491-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/oom.h~oom-consider-multi-threaded-tasks-in-task_will_free_mem include/linux/oom.h
--- a/include/linux/oom.h~oom-consider-multi-threaded-tasks-in-task_will_free_mem
+++ a/include/linux/oom.h
@@ -110,13 +110,24 @@ extern struct task_struct *find_lock_tas
 
 static inline bool task_will_free_mem(struct task_struct *task)
 {
+	struct signal_struct *sig = task->signal;
+
 	/*
 	 * A coredumping process may sleep for an extended period in exit_mm(),
 	 * so the oom killer cannot assume that the process will promptly exit
 	 * and release memory.
 	 */
-	return (task->flags & PF_EXITING) &&
-		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
+	if (sig->flags & SIGNAL_GROUP_COREDUMP)
+		return false;
+
+	if (!(task->flags & PF_EXITING))
+		return false;
+
+	/* Make sure that the whole thread group is going down */
+	if (!thread_group_empty(task) && !(sig->flags & SIGNAL_GROUP_EXIT))
+		return false;
+
+	return true;
 }
 
 /* sysctls */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls.patch
mm-make-vm_mmap-killable.patch
mm-make-vm_munmap-killable.patch
mm-aout-handle-vm_brk-failures.patch
mm-elf-handle-vm_brk-error.patch
mm-make-vm_brk-killable.patch
mm-proc-make-clear_refs-killable.patch
mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable.patch
ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable.patch
vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable.patch
coredump-make-coredump_wait-wait-for-mmap_sem-for-write-killable.patch
aio-make-aio_setup_ring-killable.patch
exec-make-exec-path-waiting-for-mmap_sem-killable.patch
prctl-make-pr_set_thp_disable-wait-for-mmap_sem-killable.patch
uprobes-wait-for-mmap_sem-for-write-killable.patch
drm-i915-make-i915_gem_mmap_ioctl-wait-for-mmap_sem-killable.patch
drm-radeon-make-radeon_mn_get-wait-for-mmap_sem-killable.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch

