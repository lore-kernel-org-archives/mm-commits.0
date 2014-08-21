From: akpm@linux-foundation.org
Subject: +
 prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch added to
 -mm tree
Date: Thu, 21 Aug 2014 15:51:37 -0700
Message-ID: <53f677f9.hcvjHk6wgaj8Xx41%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:49368 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaHUWvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:51:39 -0400
Received: by mail-qg0-f73.google.com with SMTP id i50so725836qgf.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:51:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com, jln@google.com, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, mtk.manpages@gmail.com, segoon@openwall.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: PR_SET_MM -- factor out mmap_sem when updating mm::exe_file
has been added to the -mm tree.  Its filename is
     prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: prctl: PR_SET_MM -- factor out mmap_sem when updating mm::exe_file

Instead of taking mm->mmap_sem inside prctl_set_mm_exe_file() move it out
and rename the helper to prctl_set_mm_exe_file_locked().  This will allow
to reuse this function in a next patch.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Julien Tinnes <jln@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN kernel/sys.c~prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file kernel/sys.c
--- a/kernel/sys.c~prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file
+++ a/kernel/sys.c
@@ -1628,12 +1628,14 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
-static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
+static int prctl_set_mm_exe_file_locked(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
 	struct inode *inode;
 	int err;
 
+	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+
 	exe = fdget(fd);
 	if (!exe.file)
 		return -EBADF;
@@ -1654,8 +1656,6 @@ static int prctl_set_mm_exe_file(struct
 	if (err)
 		goto exit;
 
-	down_write(&mm->mmap_sem);
-
 	/*
 	 * Forbid mm->exe_file change if old file still mapped.
 	 */
@@ -1667,7 +1667,7 @@ static int prctl_set_mm_exe_file(struct
 			if (vma->vm_file &&
 			    path_equal(&vma->vm_file->f_path,
 				       &mm->exe_file->f_path))
-				goto exit_unlock;
+				goto exit;
 	}
 
 	/*
@@ -1678,13 +1678,10 @@ static int prctl_set_mm_exe_file(struct
 	 */
 	err = -EPERM;
 	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
-		goto exit_unlock;
+		goto exit;
 
 	err = 0;
 	set_mm_exe_file(mm, exe.file);	/* this grabs a reference to exe.file */
-exit_unlock:
-	up_write(&mm->mmap_sem);
-
 exit:
 	fdput(exe);
 	return err;
@@ -1703,8 +1700,12 @@ static int prctl_set_mm(int opt, unsigne
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
-	if (opt == PR_SET_MM_EXE_FILE)
-		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
+	if (opt == PR_SET_MM_EXE_FILE) {
+		down_write(&mm->mmap_sem);
+		error = prctl_set_mm_exe_file_locked(mm, (unsigned int)addr);
+		up_write(&mm->mmap_sem);
+		return error;
+	}
 
 	if (addr >= TASK_SIZE || addr < mmap_min_addr)
 		return -EINVAL;
_

Patches currently in -mm which might be from gorcunov@openvz.org are

mm-introduce-check_data_rlimit-helper-v2.patch
mm-use-may_adjust_brk-helper.patch
prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch

