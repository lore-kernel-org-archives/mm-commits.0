From: akpm@linux-foundation.org
Subject: [folded] c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2.patch removed from -mm tree
Date: Fri, 06 Apr 2012 15:45:56 -0700
Message-ID: <20120406224556.AAC95A04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:43306 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab2DFWp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 18:45:57 -0400
Received: by ghbz15 with SMTP id z15so317583ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 15:45:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2
has been removed from the -mm tree.  Its filename was
     c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2.patch

This patch was dropped because it was folded into c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2 kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2
+++ a/kernel/sys.c
@@ -1719,9 +1719,8 @@ static int prctl_set_mm_exe_file(struct 
 	int err;
 
 	/*
-	 * Setting new mm::exe_file is only allowed
-	 * when no VM_EXECUTABLE vma's left. So make
-	 * a fast test first.
+	 * Setting new mm::exe_file is only allowed when no VM_EXECUTABLE vma's
+	 * remain. So perform a quick test first.
 	 */
 	if (mm->num_exe_file_vmas)
 		return -EBUSY;
@@ -1733,10 +1732,9 @@ static int prctl_set_mm_exe_file(struct 
 	dentry = exe_file->f_path.dentry;
 
 	/*
-	 * Because the original mm->exe_file
-	 * points to executable file, make sure
-	 * this one is executable as well to not
-	 * break an overall picture.
+	 * Because the original mm->exe_file points to executable file, make
+	 * sure that this one is executable as well, to avoid breaking an
+	 * overall picture.
 	 */
 	err = -EACCES;
 	if (!S_ISREG(dentry->d_inode->i_mode)	||
@@ -1748,8 +1746,10 @@ static int prctl_set_mm_exe_file(struct 
 		goto exit;
 
 	/*
-	 * For security reason changing mm->exe_file
-	 * is one-shot action.
+	 * The symlink can be changed only once, just to disallow arbitrary
+	 * transitions malicious software might bring in. This means one
+	 * could make a snapshot over all processes running and monitor
+	 * /proc/pid/exe changes to notice unusual activity if needed.
 	 */
 	down_write(&mm->mmap_sem);
 	if (likely(!mm->exe_file))
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
c-r-ipc-message-queue-receive-cleanup.patch
c-r-ipc-message-queue-stealing-feature-introduced.patch

