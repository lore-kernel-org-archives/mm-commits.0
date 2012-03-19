From: akpm@linux-foundation.org
Subject: + c-r-prctl-add-ability-to-get-clear_tid_address.patch added to -mm tree
Date: Mon, 19 Mar 2012 15:19:41 -0700
Message-ID: <20120319221941.F15DCA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58484 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab2CSWTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 18:19:43 -0400
Received: by qcsp5 with SMTP id p5so133589qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2012 15:19:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com, palves@redhat.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: c/r: prctl: add ability to get clear_tid_address
has been added to the -mm tree.  Its filename is
     c-r-prctl-add-ability-to-get-clear_tid_address.patch

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
Subject: c/r: prctl: add ability to get clear_tid_address

Zero is written at clear_tid_address when the process exits.  This
functionality is used by pthread_join().

We already have sys_set_tid_address() to change this address for the
current task but there is no way to obtain it from user space.

Without the ability to find this address and dump it we can't restore
pthread'ed apps which call pthread_join() once they have been restored.

This patch introduces the PR_GET_TID_ADDRESS prctl option which allows the
current process to obtain own clear_tid_address.

This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pedro Alves <palves@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |    2 ++
 kernel/sys.c          |   13 +++++++++++++
 2 files changed, 15 insertions(+)

diff -puN include/linux/prctl.h~c-r-prctl-add-ability-to-get-clear_tid_address include/linux/prctl.h
--- a/include/linux/prctl.h~c-r-prctl-add-ability-to-get-clear_tid_address
+++ a/include/linux/prctl.h
@@ -130,4 +130,6 @@
 #define PR_SET_CHILD_SUBREAPER 36
 #define PR_GET_CHILD_SUBREAPER 37
 
+#define PR_GET_TID_ADDRESS		36
+
 #endif /* _LINUX_PRCTL_H */
diff -puN kernel/sys.c~c-r-prctl-add-ability-to-get-clear_tid_address kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-ability-to-get-clear_tid_address
+++ a/kernel/sys.c
@@ -1912,12 +1912,22 @@ out:
 	up_read(&mm->mmap_sem);
 	return error;
 }
+
+static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
+{
+	return put_user(me->clear_child_tid, tid_addr);
+}
+
 #else /* CONFIG_CHECKPOINT_RESTORE */
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
 	return -EINVAL;
 }
+static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
+{
+	return -EINVAL;
+}
 #endif
 
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
@@ -2080,6 +2090,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			error = put_user(me->signal->is_child_subreaper,
 					 (int __user *) arg2);
 			break;
+		case PR_GET_TID_ADDRESS:
+			error = prctl_get_tid_address(me, (int __user **)arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;
_
Subject: Subject: c/r: prctl: add ability to get clear_tid_address

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
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch

