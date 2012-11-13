From: akpm@linux-foundation.org
Subject: + fdinfo-show-sigmask-for-signalfd-fd.patch added to -mm tree
Date: Mon, 12 Nov 2012 17:06:19 -0800
Message-ID: <20121113010620.C82F920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:36411 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2KMBGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 20:06:24 -0500
Received: by mail-ea0-f202.google.com with SMTP id f11so153072eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 17:06:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: fdinfo: show sigmask for signalfd fd
has been added to the -mm tree.  Its filename is
     fdinfo-show-sigmask-for-signalfd-fd.patch

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
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers-fix.patch
fs-exportfs-avoid-nil-dereference-if-no-s_export_op-present.patch
fs-notify-add-file-handle-entry-into-inotify_inode_mark.patch
fs-notify-add-procfs-fdinfo-helper.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper.patch
fdinfo-show-sigmask-for-signalfd-fd.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

