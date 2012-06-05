From: akpm@linux-foundation.org
Subject: + c-r-fcntl-add-f_getowner_uids-option.patch added to -mm tree
Date: Tue, 05 Jun 2012 15:45:26 -0700
Message-ID: <20120605224526.AF697A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:36400 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab2FEWp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 18:45:29 -0400
Received: by lagr15 with SMTP id r15so358479lag.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 15:45:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, ebiederm@xmission.com, oleg@redhat.com, serge@hallyn.com, xemul@parallels.com


The patch titled
     Subject: c/r: fcntl: add F_GETOWNER_UIDS option
has been added to the -mm tree.  Its filename is
     c-r-fcntl-add-f_getowner_uids-option.patch

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
Subject: c/r: fcntl: add F_GETOWNER_UIDS option

When we restore file descriptors we would like them to look exactly as
they were at dumping time.

With help of fcntl it's almost possible, the missing snippet is file
owners UIDs.

To be able to read their values the F_GETOWNER_UIDS is introduced.

This option is valid iif CONFIG_CHECKPOINT_RESTORE is turned on, otherwise
returning -EINVAL.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c                  |   29 +++++++++++++++++++++++++++++
 include/asm-generic/fcntl.h |    4 ++++
 security/selinux/hooks.c    |    1 +
 3 files changed, 34 insertions(+)

diff -puN fs/fcntl.c~c-r-fcntl-add-f_getowner_uids-option fs/fcntl.c
--- a/fs/fcntl.c~c-r-fcntl-add-f_getowner_uids-option
+++ a/fs/fcntl.c
@@ -20,6 +20,7 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
+#include <linux/user_namespace.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
@@ -340,6 +341,31 @@ static int f_getown_ex(struct file *filp
 	return ret;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int f_getowner_uids(struct file *filp, unsigned long arg)
+{
+	struct user_namespace *user_ns = current_user_ns();
+	uid_t * __user dst = (void * __user)arg;
+	uid_t src[2];
+	int err;
+
+	read_lock(&filp->f_owner.lock);
+	src[0] = from_kuid(user_ns, filp->f_owner.uid);
+	src[1] = from_kuid(user_ns, filp->f_owner.euid);
+	read_unlock(&filp->f_owner.lock);
+
+	err  = put_user(src[0], &dst[0]);
+	err |= put_user(src[1], &dst[1]);
+
+	return err;
+}
+#else
+static int f_getowner_uids(struct file *filp, unsigned long arg)
+{
+	return -EINVAL;
+}
+#endif
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -396,6 +422,9 @@ static long do_fcntl(int fd, unsigned in
 	case F_SETOWN_EX:
 		err = f_setown_ex(filp, arg);
 		break;
+	case F_GETOWNER_UIDS:
+		err = f_getowner_uids(filp, arg);
+		break;
 	case F_GETSIG:
 		err = filp->f_owner.signum;
 		break;
diff -puN include/asm-generic/fcntl.h~c-r-fcntl-add-f_getowner_uids-option include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~c-r-fcntl-add-f_getowner_uids-option
+++ a/include/asm-generic/fcntl.h
@@ -120,6 +120,10 @@
 #define F_GETOWN_EX	16
 #endif
 
+#ifndef F_GETOWNER_UIDS
+#define F_GETOWNER_UIDS	17
+#endif
+
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
 #define F_OWNER_PGRP	2
diff -puN security/selinux/hooks.c~c-r-fcntl-add-f_getowner_uids-option security/selinux/hooks.c
--- a/security/selinux/hooks.c~c-r-fcntl-add-f_getowner_uids-option
+++ a/security/selinux/hooks.c
@@ -3181,6 +3181,7 @@ static int selinux_file_fcntl(struct fil
 	case F_GETFL:
 	case F_GETOWN:
 	case F_GETSIG:
+	case F_GETOWNER_UIDS:
 		/* Just check FD__USE permission */
 		err = file_has_perm(cred, file, 0);
 		break;
_
Subject: Subject: c/r: fcntl: add F_GETOWNER_UIDS option

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch
c-r-fcntl-add-f_getowner_uids-option.patch

