From: akpm@linux-foundation.org
Subject: + c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch added to -mm tree
Date: Thu, 26 Apr 2012 14:24:12 -0700
Message-ID: <20120426212412.DA8ABA0397@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:37425 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2DZVYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 17:24:15 -0400
Received: by bkwj5 with SMTP id j5so1945bkw.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 14:24:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com, serge.hallyn@canonical.com, xemul@parallels.com


The patch titled
     Subject: c/r: prctl: drop VMA flags test on PR_SET_MM_ stack data assignment
has been added to the -mm tree.  Its filename is
     c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: c/r: prctl: drop VMA flags test on PR_SET_MM_ stack data assignment


With the

 | commit b76437579d1344b612cf1851ae610c636cec7db0
 | Author: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
 | Date:   Wed Mar 21 16:34:04 2012 -0700
 |
 | procfs: mark thread stack correctly in proc/<pid>/maps

the stack allocated via clone() is marked in /proc/<pid>/maps as
[stack:%d] thus it might be out of the former mm->start_stack/end_stack
values (and even has some custom VMA flags set).  So to be able to restore
mm->start_stack/end_stack drop vma flags test, but still require the
underlying VMA to exist.

As always note this feature is under CONFIG_CHECKPOINT_RESTORE and
requires CAP_SYS_RESOURCE to be granted.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN kernel/sys.c~c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment
+++ a/kernel/sys.c
@@ -1704,14 +1704,6 @@ SYSCALL_DEFINE1(umask, int, mask)
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
-static bool vma_flags_mismatch(struct vm_area_struct *vma,
-			       unsigned long required,
-			       unsigned long banned)
-{
-	return (vma->vm_flags & required) != required ||
-		(vma->vm_flags & banned);
-}
-
 static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 {
 	struct vm_area_struct *vma;
@@ -1847,12 +1839,6 @@ static int prctl_set_mm(int opt, unsigne
 			error = -EFAULT;
 			goto out;
 		}
-#ifdef CONFIG_STACK_GROWSUP
-		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
-#else
-		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSDOWN, 0))
-#endif
-			goto out;
 		if (opt == PR_SET_MM_START_STACK)
 			mm->start_stack = addr;
 		else if (opt == PR_SET_MM_ARG_START)
_
Subject: Subject: c/r: prctl: drop VMA flags test on PR_SET_MM_ stack data assignment

Patches currently in -mm which might be from gorcunov@gmail.com are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

