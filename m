From: akpm@linux-foundation.org
Subject: [merged] c-r-prctl-add-ability-to-get-clear_tid_address.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:26 -0700
Message-ID: <20120608194126.66B31A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37143 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2FHTl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:28 -0400
Received: by wibhn6 with SMTP id hn6so101896wib.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, avagin@openvz.org, keescook@chromium.org, oleg@redhat.com, palves@redhat.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: prctl: add ability to get clear_tid_address
has been removed from the -mm tree.  Its filename was
     c-r-prctl-add-ability-to-get-clear_tid_address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

[akpm@linux-foundation.org: fix prctl numbering]
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pedro Alves <palves@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |   10 ++++++----
 kernel/sys.c          |   13 +++++++++++++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff -puN include/linux/prctl.h~c-r-prctl-add-ability-to-get-clear_tid_address include/linux/prctl.h
--- a/include/linux/prctl.h~c-r-prctl-add-ability-to-get-clear_tid_address
+++ a/include/linux/prctl.h
@@ -127,8 +127,8 @@
 #define PR_SET_PTRACER 0x59616d61
 # define PR_SET_PTRACER_ANY ((unsigned long)-1)
 
-#define PR_SET_CHILD_SUBREAPER 36
-#define PR_GET_CHILD_SUBREAPER 37
+#define PR_SET_CHILD_SUBREAPER	36
+#define PR_GET_CHILD_SUBREAPER	37
 
 /*
  * If no_new_privs is set, then operations that grant new privileges (i.e.
@@ -142,7 +142,9 @@
  * asking selinux for a specific new context (e.g. with runcon) will result
  * in execve returning -EPERM.
  */
-#define PR_SET_NO_NEW_PRIVS 38
-#define PR_GET_NO_NEW_PRIVS 39
+#define PR_SET_NO_NEW_PRIVS	38
+#define PR_GET_NO_NEW_PRIVS	39
+
+#define PR_GET_TID_ADDRESS	40
 
 #endif /* _LINUX_PRCTL_H */
diff -puN kernel/sys.c~c-r-prctl-add-ability-to-get-clear_tid_address kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-ability-to-get-clear_tid_address
+++ a/kernel/sys.c
@@ -1988,12 +1988,22 @@ out:
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
@@ -2131,6 +2141,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 				else
 					return -EINVAL;
 				break;
+		case PR_GET_TID_ADDRESS:
+			error = prctl_get_tid_address(me, (int __user **)arg2);
+			break;
 			default:
 				return -EINVAL;
 			}
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
c-r-fcntl-add-f_getowner_uids-option.patch

