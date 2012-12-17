From: akpm@linux-foundation.org
Subject: [folded-merged] fdinfo-show-sigmask-for-signalfd-fd-v3.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:48:50 -0800
Message-ID: <20121217234851.C1F1120005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44893 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2LQXsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:48:55 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so369667bkc.5
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:48:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fdinfo: show sigmask for signalfd fd
has been removed from the -mm tree.  Its filename was
     fdinfo-show-sigmask-for-signalfd-fd-v3.patch

This patch was dropped because it was folded into fs-epoll-add-procfs-fdinfo-helper-v2.patch

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fdinfo: show sigmask for signalfd fd

The sigmask is read in lockless manner for a sake of
code simplicity, thus if precise data needed here
the tasks which refer to the signalfd should be
stopped before read.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c         |    2 +-
 fs/signalfd.c           |   18 ++++++++++++++++++
 include/linux/proc_fs.h |    3 +++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff -puN fs/proc/array.c~fdinfo-show-sigmask-for-signalfd-fd-v3 fs/proc/array.c
--- a/fs/proc/array.c~fdinfo-show-sigmask-for-signalfd-fd-v3
+++ a/fs/proc/array.c
@@ -220,7 +220,7 @@ static inline void task_state(struct seq
 	seq_putc(m, '\n');
 }
 
-static void render_sigset_t(struct seq_file *m, const char *header,
+void render_sigset_t(struct seq_file *m, const char *header,
 				sigset_t *set)
 {
 	int i;
diff -puN fs/signalfd.c~fdinfo-show-sigmask-for-signalfd-fd-v3 fs/signalfd.c
--- a/fs/signalfd.c~fdinfo-show-sigmask-for-signalfd-fd-v3
+++ a/fs/signalfd.c
@@ -29,6 +29,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
+#include <linux/proc_fs.h>
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
@@ -227,7 +228,24 @@ static ssize_t signalfd_read(struct file
 	return total ? total: ret;
 }
 
+#ifdef CONFIG_PROC_FS
+static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct signalfd_ctx *ctx = f->private_data;
+	sigset_t sigmask;
+
+	sigmask = ctx->sigmask;
+	signotset(&sigmask);
+	render_sigset_t(m, "sigmask:\t", &sigmask);
+
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
diff -puN include/linux/proc_fs.h~fdinfo-show-sigmask-for-signalfd-fd-v3 include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~fdinfo-show-sigmask-for-signalfd-fd-v3
+++ a/include/linux/proc_fs.h
@@ -314,4 +314,7 @@ static inline struct net *PDE_NET(struct
 	return pde->parent->data;
 }
 
+#include <linux/signal.h>
+
+void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set);
 #endif /* _LINUX_PROC_FS_H */
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
proc-pid-status-add-seccomp-field.patch
kcmp-selftests-make-run_tests-fix.patch
kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v7.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-add-missing-space-after-prefix.patch
fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify.patch
fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-fanotify-add-mflags-field-to-fanotify-output.patch
docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch

