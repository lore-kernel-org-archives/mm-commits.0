From: akpm@linux-foundation.org
Subject: + fs-eventfd-add-procfs-fdinfo-helper.patch added to -mm tree
Date: Mon, 12 Nov 2012 17:06:11 -0800
Message-ID: <20121113010612.B0CA85C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:33543 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab2KMBGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 20:06:17 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so37048lag.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 17:06:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: fs, eventfd: add procfs fdinfo helper
has been added to the -mm tree.  Its filename is
     fs-eventfd-add-procfs-fdinfo-helper.patch

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
Subject: fs, eventfd: add procfs fdinfo helper

This allow us to print out raw counter value.
The /proc/pid/fdinfo/fd output is

 | pos:	0
 | flags:	04002
 | eventfd-count:               5a

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
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

 fs/eventfd.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN fs/eventfd.c~fs-eventfd-add-procfs-fdinfo-helper fs/eventfd.c
--- a/fs/eventfd.c~fs-eventfd-add-procfs-fdinfo-helper
+++ a/fs/eventfd.c
@@ -19,6 +19,8 @@
 #include <linux/export.h>
 #include <linux/kref.h>
 #include <linux/eventfd.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 struct eventfd_ctx {
 	struct kref kref;
@@ -284,7 +286,25 @@ static ssize_t eventfd_write(struct file
 	return res;
 }
 
+#ifdef CONFIG_PROC_FS
+static int eventfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct eventfd_ctx *ctx = f->private_data;
+	int ret;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	ret = seq_printf(m, "eventfd-count: %16llx\n",
+			 (unsigned long long)ctx->count);
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return ret;
+}
+#endif
+
 static const struct file_operations eventfd_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= eventfd_show_fdinfo,
+#endif
 	.release	= eventfd_release,
 	.poll		= eventfd_poll,
 	.read		= eventfd_read,
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

