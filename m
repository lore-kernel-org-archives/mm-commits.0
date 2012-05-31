From: akpm@linux-foundation.org
Subject: [folded] c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch removed from -mm tree
Date: Thu, 31 May 2012 14:03:16 -0700
Message-ID: <20120531210316.6F273A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:56307 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185Ab2EaVDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 17:03:18 -0400
Received: by lagr15 with SMTP id r15so79438lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 14:03:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: return -EFAULT instead of -EINVAL in case if underlied VMA is not found
has been removed from the -mm tree.  Its filename was
     c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch

This patch was dropped because it was folded into c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: return -EFAULT instead of -EINVAL in case if underlied VMA is not found

In case if underlied VMA is not found prctl_set_mm will return -EINVAL,
but Michael proposed to return -EFAULT and Kosaki seconded.  Make it so.

Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/sys.c~c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found
+++ a/kernel/sys.c
@@ -1864,8 +1864,10 @@ static int prctl_set_mm(int opt, unsigne
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

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

