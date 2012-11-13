From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-eventfd-add-procfs-fdinfo-helper.patch removed from -mm tree
Date: Tue, 13 Nov 2012 11:43:54 -0800
Message-ID: <20121113194355.360AA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41578 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2KMTn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:43:58 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so205168eei.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:43:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, eventfd: add procfs fdinfo helper
has been removed from the -mm tree.  Its filename was
     fs-eventfd-add-procfs-fdinfo-helper.patch

This patch was dropped because an updated version will be merged

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
fs-epoll-add-procfs-fdinfo-helper.patch
fdinfo-show-sigmask-for-signalfd-fd.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

