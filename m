From: akpm@linux-foundation.org
Subject: + c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2.patch added to -mm tree
Date: Tue, 20 Mar 2012 13:09:04 -0700
Message-ID: <20120320200905.8D62EA018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:51600 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2CTUJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Mar 2012 16:09:08 -0400
Received: by wejx9 with SMTP id x9so22325wej.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Mar 2012 13:09:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org


The patch titled
     Subject: c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2
has been added to the -mm tree.  Its filename is
     c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2.patch

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
Subject: Subject: c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch

