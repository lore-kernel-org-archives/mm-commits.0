From: akpm@linux-foundation.org
Subject: [withdrawn] signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2.patch removed from -mm tree
Date: Mon, 11 Feb 2013 14:44:06 -0800
Message-ID: <20130211224406.9B3BF31C265@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:48414 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab3BKWoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 17:44:08 -0500
Received: by mail-ob0-f202.google.com with SMTP id wd20so1228736obb.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 14:44:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, dhowells@redhat.com, gorcunov@openvz.org, mtk.manpages@gmail.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signalfd: add ability to return siginfo in a raw format
has been removed from the -mm tree.  Its filename was
     signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: signalfd: add ability to return siginfo in a raw format

signalfd should be called with the flag SFD_RAW for that.

signalfd_siginfo is not full for siginfo with a negative si_code. 
copy_siginfo_to_user() is copied a full siginfo to user-space, if si_code
is negative.  signalfd_copyinfo() doesn't do that and can't be expanded,
because it has not compatible format with siginfo_t.

Another problem is that a constant __SI_* is removed from si_code.  It's
not a problem for usual applications, because they expect a defined type
of siginfo (internal logic).  When we want to dump pending signals, we
can't predict a type of siginfo, so we should get it from kernel.

The main idea of the raw format is that it should be enough for restoring
exactly the same siginfo for the current process.

This functionality is required for checkpointing pending signals.

[akpm@linux-foundation.org: fix __user annotations, tidy comments and code layout]
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c                 |   65 +++++++++++++++++++++++++++++---
 include/uapi/linux/signalfd.h |    1 
 2 files changed, 61 insertions(+), 5 deletions(-)

diff -puN fs/signalfd.c~signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2 fs/signalfd.c
--- a/fs/signalfd.c~signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2
+++ a/fs/signalfd.c
@@ -30,6 +30,7 @@
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
 #include <linux/proc_fs.h>
+#include <linux/compat.h>
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
@@ -74,6 +75,39 @@ static unsigned int signalfd_poll(struct
 }
 
 /*
+ * Copy a whole siginfo into userspace.
+ * The main idea of this format is that it should be enough
+ * for restoring siginfo back into the kernel.
+ */
+static int signalfd_copy_raw_info(struct signalfd_siginfo __user *siginfo,
+					siginfo_t *kinfo)
+{
+	siginfo_t __user *uinfo = (siginfo_t __user *)siginfo;
+	int err;
+
+	BUILD_BUG_ON(sizeof(siginfo_t) != sizeof(struct signalfd_siginfo));
+
+	err = __clear_user(uinfo, sizeof(*uinfo));
+
+#ifdef CONFIG_COMPAT
+	if (unlikely(is_compat_task())) {
+		compat_siginfo_t __user *compat_uinfo;
+
+		compat_uinfo = (compat_siginfo_t __user *)siginfo;
+		err |= copy_siginfo_to_user32(compat_uinfo, kinfo);
+		err |= put_user(kinfo->si_code, &compat_uinfo->si_code);
+
+		return err ? -EFAULT : sizeof(*compat_uinfo);
+	}
+#endif
+
+	err |= copy_siginfo_to_user(uinfo, kinfo);
+	err |= put_user(kinfo->si_code, &uinfo->si_code);
+
+	return err ? -EFAULT : sizeof(*uinfo);
+}
+
+/*
  * Copied from copy_siginfo_to_user() in kernel/signal.c
  */
 static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
@@ -205,6 +239,7 @@ static ssize_t signalfd_read(struct file
 	struct signalfd_ctx *ctx = file->private_data;
 	struct signalfd_siginfo __user *siginfo;
 	int nonblock = file->f_flags & O_NONBLOCK;
+	bool raw = file->f_flags & SFD_RAW;
 	ssize_t ret, total = 0;
 	siginfo_t info;
 
@@ -217,7 +252,12 @@ static ssize_t signalfd_read(struct file
 		ret = signalfd_dequeue(ctx, &info, nonblock);
 		if (unlikely(ret <= 0))
 			break;
-		ret = signalfd_copyinfo(siginfo, &info);
+
+		if (raw)
+			ret = signalfd_copy_raw_info(siginfo, &info);
+		else
+			ret = signalfd_copyinfo(siginfo, &info);
+
 		if (ret < 0)
 			break;
 		siginfo++;
@@ -262,7 +302,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK))
+	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW))
 		return -EINVAL;
 
 	if (sizemask != sizeof(sigset_t) ||
@@ -272,20 +312,35 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 	signotset(&sigmask);
 
 	if (ufd == -1) {
+		struct file *file;
 		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 		if (!ctx)
 			return -ENOMEM;
 
 		ctx->sigmask = sigmask;
 
+		ufd = get_unused_fd_flags(flags);
+		if (ufd < 0) {
+			kfree(ctx);
+			goto out;
+		}
+
 		/*
 		 * When we call this, the initialization must be complete, since
 		 * anon_inode_getfd() will install the fd.
 		 */
-		ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx,
+		file = anon_inode_getfile("[signalfd]", &signalfd_fops, ctx,
 				       O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
-		if (ufd < 0)
+		if (IS_ERR(file)) {
+			put_unused_fd(ufd);
+			ufd = PTR_ERR(file);
 			kfree(ctx);
+			goto out;
+		}
+
+		file->f_flags |= flags & SFD_RAW;
+
+		fd_install(ufd, file);
 	} else {
 		struct fd f = fdget(ufd);
 		if (!f.file)
@@ -302,7 +357,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 		wake_up(&current->sighand->signalfd_wqh);
 		fdput(f);
 	}
