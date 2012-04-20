From: akpm@linux-foundation.org
Subject: + c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch added to -mm tree
Date: Fri, 20 Apr 2012 15:44:01 -0700
Message-ID: <20120420224401.C9698A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53044 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab2DTWoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 18:44:04 -0400
Received: by qcsp5 with SMTP id p5so1162961qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 15:44:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: c/r: prctl: simplify PR_SET_MM on mm::code/data assignment
has been added to the -mm tree.  Its filename is
     c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch

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
Subject: c/r: prctl: simplify PR_SET_MM on mm::code/data assignment

The mm::start_code, end_code, start_data, end_data members are set during
startup of executable file and are not changed after.

But the program itself might map new executable or/and data areas in time
so the original values written into mm fields mentioned above might not
have correspond VMA area at all, thus if one try to use this prctl codes
without underlied VMA, the error will be returned.

Drop this requirement.  This shrinks the code and eliminates redundant
calls to vma_flags_mismatch.  The worst thing one can do (if say to write
some bad values here) -- the weird results will be shown in
/proc/$pid/statm or in /proc/pid/stat.

Still, assignement of data on stack (such as command line and environment
variables) requires the underlied VMA to exist.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff -puN kernel/sys.c~c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment
+++ a/kernel/sys.c
@@ -1727,42 +1727,21 @@ static int prctl_set_mm(int opt, unsigne
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
-	error = -EINVAL;
-
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
-	if (opt != PR_SET_MM_START_BRK &&
-	    opt != PR_SET_MM_BRK &&
-	    opt != PR_SET_MM_AUXV) {
-		/* It must be existing VMA */
-		if (!vma || vma->vm_start > addr)
-			goto out;
-	}
-
 	switch (opt) {
 	case PR_SET_MM_START_CODE:
+		mm->start_code = addr;
+		break;
 	case PR_SET_MM_END_CODE:
-		if (vma_flags_mismatch(vma, VM_READ | VM_EXEC,
-				       VM_WRITE | VM_MAYSHARE))
-			goto out;
-
-		if (opt == PR_SET_MM_START_CODE)
-			mm->start_code = addr;
-		else
-			mm->end_code = addr;
+		mm->end_code = addr;
 		break;
-
 	case PR_SET_MM_START_DATA:
+		mm->start_data = addr;
+		break;
 	case PR_SET_MM_END_DATA:
-		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE,
-				       VM_EXEC | VM_MAYSHARE))
-			goto out;
-
-		if (opt == PR_SET_MM_START_DATA)
-			mm->start_data = addr;
-		else
-			mm->end_data = addr;
+		mm->end_data = addr;
 		break;
 
 	case PR_SET_MM_START_BRK:
@@ -1801,6 +1780,8 @@ static int prctl_set_mm(int opt, unsigne
 	case PR_SET_MM_ARG_END:
 	case PR_SET_MM_ENV_START:
 	case PR_SET_MM_ENV_END:
+		if (!vma)
+			goto out;
 #ifdef CONFIG_STACK_GROWSUP
 		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
 #else
_
Subject: Subject: c/r: prctl: simplify PR_SET_MM on mm::code/data assignment

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-ipc-message-queue-receive-cleanup.patch
c-r-ipc-message-queue-receive-cleanup-fix.patch
c-r-ipc-message-queue-stealing-feature-introduced.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv.patch

