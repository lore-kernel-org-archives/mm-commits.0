From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:19 -0700
Message-ID: <20120608194119.8F715A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58779 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2FHTlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:22 -0400
Received: by eeit10 with SMTP id t10so129452eei.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, gorcunov@openvz.org, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal
has been removed from the -mm tree.  Its filename was
     c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal

A fix for b32dfe377102ce66877 ("c/r: prctl: add ability to set new
mm_struct::exe_file").

After removing mm->num_exe_file_vmas kernel keeps mm->exe_file until final
mmput(), it never becomes NULL while task is alive.

We can check for other mapped files in mm instead of checking
mm->num_exe_file_vmas, and mark mm with flag MMF_EXE_FILE_CHANGED in order
to forbid second changing of mm->exe_file.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 kernel/sys.c          |   31 +++++++++++++++++++------------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff -puN include/linux/sched.h~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal include/linux/sched.h
--- a/include/linux/sched.h~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal
+++ a/include/linux/sched.h
@@ -439,6 +439,7 @@ extern int get_dumpable(struct mm_struct
 					/* leave room for more dump flags */
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
+#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff -puN kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal
+++ a/kernel/sys.c
@@ -1796,17 +1796,11 @@ static bool vma_flags_mismatch(struct vm
 
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
+	struct vm_area_struct *vma;
 	struct file *exe_file;
 	struct dentry *dentry;
 	int err;
 
-	/*
-	 * Setting new mm::exe_file is only allowed when no VM_EXECUTABLE vma's
-	 * remain. So perform a quick test first.
-	 */
-	if (mm->num_exe_file_vmas)
-		return -EBUSY;
-
 	exe_file = fget(fd);
 	if (!exe_file)
 		return -EBADF;
@@ -1827,17 +1821,30 @@ static int prctl_set_mm_exe_file(struct 
 	if (err)
 		goto exit;
 
+	down_write(&mm->mmap_sem);
+
+	/*
+	 * Forbid mm->exe_file change if there are mapped other files.
+	 */
+	err = -EBUSY;
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (vma->vm_file && !path_equal(&vma->vm_file->f_path,
+						&exe_file->f_path))
+			goto exit_unlock;
+	}
+
 	/*
 	 * The symlink can be changed only once, just to disallow arbitrary
 	 * transitions malicious software might bring in. This means one
 	 * could make a snapshot over all processes running and monitor
 	 * /proc/pid/exe changes to notice unusual activity if needed.
 	 */
-	down_write(&mm->mmap_sem);
-	if (likely(!mm->exe_file))
-		set_mm_exe_file(mm, exe_file);
-	else
-		err = -EBUSY;
+	err = -EPERM;
+	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
+		goto exit_unlock;
+
+	set_mm_exe_file(mm, exe_file);
+exit_unlock:
 	up_write(&mm->mmap_sem);
 
 exit:
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch

