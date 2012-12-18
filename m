From: akpm@linux-foundation.org
Subject: [merged] fs-eventfd-add-procfs-fdinfo-helper.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:12:30 -0800
Message-ID: <20121218201230.F3DAC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:33860 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2LRUMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:12:32 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so126515qch.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:12:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, eventfd: add procfs fdinfo helper
has been removed from the -mm tree.  Its filename was
     fs-eventfd-add-procfs-fdinfo-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, eventfd: add procfs fdinfo helper

This allows us to print out raw counter value.  The /proc/pid/fdinfo/fd
output is

 | pos:	0
 | flags:	04002
 | eventfd-count:               5a

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

origin.patch
linux-next.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch

