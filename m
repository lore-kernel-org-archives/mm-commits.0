From: akpm@linux-foundation.org
Subject: + c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch added to -mm tree
Date: Tue, 24 Apr 2012 13:38:30 -0700
Message-ID: <20120424203830.DFF50A0172@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:42669 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab2DXUid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Apr 2012 16:38:33 -0400
Received: by lbol12 with SMTP id l12so54948lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Apr 2012 13:38:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, kosaki.motohiro@gmail.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: c/r: prctl: return -EFAULT instead of -EINVAL in case if underlied VMA is not found
has been added to the -mm tree.  Its filename is
     c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch

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
Subject: c/r: prctl: return -EFAULT instead of -EINVAL in case if underlied VMA is not found

In case if underlied VMA is not found prctl_set_mm will return -EINVAL,
but Michael proposed to return -EFAULT and Kosaki seconded.  Make it so.

Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
Cc: Tejun Heo <tj@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/sys.c~c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found
+++ a/kernel/sys.c
@@ -1780,8 +1780,10 @@ static int prctl_set_mm(int opt, unsigne
 	case PR_SET_MM_ARG_END:
 	case PR_SET_MM_ENV_START:
 	case PR_SET_MM_ENV_END:
-		if (!vma)
+		if (!vma) {
+			error = -EFAULT;
 			goto out;
+		}
 #ifdef CONFIG_STACK_GROWSUP
 		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
 #else
_
Subject: Subject: c/r: prctl: return -EFAULT instead of -EINVAL in case if underlied VMA is not found

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
c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch

