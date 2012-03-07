From: akpm@linux-foundation.org
Subject: + prctl-use-cap_sys_resource-for-pr_set_mm-option.patch added to -mm tree
Date: Wed, 07 Mar 2012 14:15:08 -0800
Message-ID: <20120307221508.E6615A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:34873 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030398Ab2CGWPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Mar 2012 17:15:10 -0500
Received: by vcbfk26 with SMTP id fk26so860169vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Mar 2012 14:15:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, oleg@redhat.com, pebolle@tiscali.nl, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: prctl: use CAP_SYS_RESOURCE for PR_SET_MM option
has been added to the -mm tree.  Its filename is
     prctl-use-cap_sys_resource-for-pr_set_mm-option.patch

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
@@ -1721,7 +1721,7 @@ static int prctl_set_mm(int opt, unsigne
 	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
 	if (addr >= TASK_SIZE)
_
Subject: Subject: prctl: use CAP_SYS_RESOURCE for PR_SET_MM option

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
prctl-use-cap_sys_resource-for-pr_set_mm-option.patch

