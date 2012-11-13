From: akpm@linux-foundation.org
Subject: [to-be-updated] fdinfo-show-sigmask-for-signalfd-fd.patch removed from -mm tree
Date: Tue, 13 Nov 2012 11:44:04 -0800
Message-ID: <20121113194404.D4D3E100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55861 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2KMToG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:44:06 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so893065ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:44:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fdinfo: show sigmask for signalfd fd
has been removed from the -mm tree.  Its filename was
     fdinfo-show-sigmask-for-signalfd-fd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fdinfo: show sigmask for signalfd fd

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c         |    2 +-
 fs/signalfd.c           |   26 ++++++++++++++++++++++++++
 include/linux/proc_fs.h |    3 +++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff -puN fs/proc/array.c~fdinfo-show-sigmask-for-signalfd-fd fs/proc/array.c
--- a/fs/proc/array.c~fdinfo-show-sigmask-for-signalfd-fd
+++ a/fs/proc/array.c
@@ -220,7 +220,7 @@ static inline void task_state(struct seq
 	seq_putc(m, '\n');
 }
 
-static void render_sigset_t(struct seq_file *m, const char *header,
+void render_sigset_t(struct seq_file *m, const char *header,
 				sigset_t *set)
 {
 	int i;
diff -puN fs/signalfd.c~fdinfo-show-sigmask-for-signalfd-fd fs/signalfd.c
--- a/fs/signalfd.c~fdinfo-show-sigmask-for-signalfd-fd
+++ a/fs/signalfd.c
@@ -29,6 +29,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
+#include <linux/proc_fs.h>
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
@@ -46,6 +47,7 @@ void signalfd_cleanup(struct sighand_str
 }
 
 struct signalfd_ctx {
+	seqcount_t cnt;
 	sigset_t sigmask;
 };
 
@@ -227,7 +229,28 @@ static ssize_t signalfd_read(struct file
 	return total ? total: ret;
 }
 
+#ifdef CONFIG_PROC_FS
+static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct signalfd_ctx *ctx = f->private_data;
+	sigset_t sigmask;
+	unsigned seq;
+
+	do {
+		seq = read_seqcount_begin(&ctx->cnt);
+		sigmask = ctx->sigmask;
+	} while (read_seqcount_retry(&ctx->cnt, seq));
+
+	signotset(&sigmask);
+	render_sigset_t(m, "sigmask:\t", &sigmask);
+	return 0;
+}
+#endif
+
 static const struct file_operations signalfd_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= signalfd_show_fdinfo,
+#endif
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
@@ -259,6 +282,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 			return -ENOMEM;
 
 		ctx->sigmask = sigmask;
+		seqcount_init(&ctx->cnt);
 
 		/*
 		 * When we call this, the initialization must be complete, since
@@ -278,7 +302,9 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 			return -EINVAL;
 		}
 		spin_lock_irq(&current->sighand->siglock);
+		write_seqcount_begin(&ctx->cnt);
 		ctx->sigmask = sigmask;
+		write_seqcount_end(&ctx->cnt);
 		spin_unlock_irq(&current->sighand->siglock);
 
 		wake_up(&current->sighand->signalfd_wqh);
diff -puN include/linux/proc_fs.h~fdinfo-show-sigmask-for-signalfd-fd include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~fdinfo-show-sigmask-for-signalfd-fd
+++ a/include/linux/proc_fs.h
@@ -290,4 +290,7 @@ static inline struct net *PDE_NET(struct
 	return pde->parent->data;
 }
 
+#include <asm/signal.h>
+
+void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set);
 #endif /* _LINUX_PROC_FS_H */
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
proc-pid-status-add-seccomp-field.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

