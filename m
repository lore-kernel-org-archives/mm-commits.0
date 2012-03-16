From: akpm@linux-foundation.org
Subject: [merged] prctl-use-cap_sys_resource-for-pr_set_mm-option.patch removed from -mm tree
Date: Fri, 16 Mar 2012 13:57:57 -0700
Message-ID: <20120316205757.8A381A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:43346 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030326Ab2CPU57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 16:57:59 -0400
Received: by wibhj13 with SMTP id hj13so56094wib.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 13:57:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, oleg@redhat.com, pebolle@tiscali.nl, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: use CAP_SYS_RESOURCE for PR_SET_MM option
has been removed from the -mm tree.  Its filename was
     prctl-use-cap_sys_resource-for-pr_set_mm-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: prctl: use CAP_SYS_RESOURCE for PR_SET_MM option

CAP_SYS_ADMIN is already overloaded left and right, so to have more
fine-grained access control use CAP_SYS_RESOURCE here.

The CAP_SYS_RESOUCE is chosen because this prctl option allows a current
process to adjust some fields of memory map descriptor which rather
represents what the process owns: pointers to code, data, stack segments,
command line, auxiliary vector data and etc.

Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~prctl-use-cap_sys_resource-for-pr_set_mm-option kernel/sys.c
--- a/kernel/sys.c~prctl-use-cap_sys_resource-for-pr_set_mm-option
+++ a/kernel/sys.c
@@ -1706,7 +1706,7 @@ static int prctl_set_mm(int opt, unsigne
 	if (arg4 | arg5)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
 	if (addr >= TASK_SIZE)
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

