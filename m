From: akpm@linux-foundation.org
Subject: - rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements-fix.patch removed from -mm tree
Date: Tue, 28 Oct 2008 16:28:31 -0700
Message-ID: <200810282343.m9SNhL8a022191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147AbYJ1Xng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 19:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prasad@linux.vnet.ibm.com, dwilder@us.ibm.com, hunt@redhat.com, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements fix
has been removed from the -mm tree.  Its filename was
     rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements-fix.patch

This patch was dropped because it breaks each time Sam changes something

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements fix
From: "K.Prasad" <prasad@linux.vnet.ibm.com>

Move fork_new_trace.c file into samples/relay directory.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Cc: Martin Hunt <hunt@redhat.com>
Cc: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/relay/fork_new_trace.c |   99 +++++++++++++++++++++++++++++++
 samples/trace/fork_new_trace.c |   99 -------------------------------
 2 files changed, 99 insertions(+), 99 deletions(-)

diff -puN /dev/null samples/relay/fork_new_trace.c
--- /dev/null
+++ a/samples/relay/fork_new_trace.c
@@ -0,0 +1,99 @@
+/*
+ * An example of using trace in a kprobes module
+ *
+ * Copyright (C) 2008 IBM Inc.
+ *
+ * K.Prasad <prasad@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * -------
+ * This module creates a trace channel and places a kprobe
+ * on the function do_fork(). The value of current->pid is written to
+ * the trace channel each time the kprobe is hit..
+ *
+ * How to run the example:
+ * $ mount -t debugfs /debug
+ * $ insmod fork_new_trace.ko
+ *
+ * To view the data produced by the module:
+ * $ cat /debug/relay_example/do_fork/trace0
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/relay_debugfs.h>
+
+#define SAMPLE_PARENT_DIR "relay_new_example"
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+static struct relay_printk_data *tpk;
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	relay_printk(tpk, "%d\n", current->pid);
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret = 0;
+	int len_parent_dir, len_dir;
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	ret = register_kprobe(&kp);
+	if (ret) {
+		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
+		return ret;
+	}
+
+	len_parent_dir = strlen(SAMPLE_PARENT_DIR) + 1;
+	/* Initialising len_dir to the larger of the two dir names */
+	len_dir = strlen("kprobe_struct") + 1;
+
+	tpk = kzalloc(sizeof(*tpk), GFP_KERNEL);
+	if (!tpk)
+		ret = 1;
+
+	tpk->parent_dir = SAMPLE_PARENT_DIR;
+
+	/* Let's do a binary dump of struct kprobe using relay_dump */
+	tpk->dir = "kprobes_struct";
+	tpk->flags = RELAY_GLOBAL_CHANNEL;
+	relay_dump(tpk, &kp, sizeof(kp));
+
+	/* Now change the directory to collect fork pid data */
+	tpk->dir = PROBE_POINT;
+
+	if (ret)
+		printk(KERN_ERR "Unable to find required free memory. "
+				"Trace new sample module loading aborted");
+	return ret;
+}
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+
+	/* Just a single cleanup call passing the parent dir string */
+	relay_cleanup_all(SAMPLE_PARENT_DIR);
+}
+MODULE_LICENSE("GPL");
diff -puN samples/trace/fork_new_trace.c~rename-lib-trace-files-to-kernel-relay_debugfs-and-enhancements-fix /dev/null
--- a/samples/trace/fork_new_trace.c
+++ /dev/null
@@ -1,99 +0,0 @@
-/*
- * An example of using trace in a kprobes module
- *
- * Copyright (C) 2008 IBM Inc.
- *
- * K.Prasad <prasad@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- * -------
- * This module creates a trace channel and places a kprobe
- * on the function do_fork(). The value of current->pid is written to
- * the trace channel each time the kprobe is hit..
- *
- * How to run the example:
- * $ mount -t debugfs /debug
- * $ insmod fork_new_trace.ko
- *
- * To view the data produced by the module:
- * $ cat /debug/relay_example/do_fork/trace0
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/kprobes.h>
-#include <linux/relay_debugfs.h>
-
-#define SAMPLE_PARENT_DIR "relay_new_example"
-#define PROBE_POINT "do_fork"
-
-static struct kprobe kp;
-static struct relay_printk_data *tpk;
-
-static int handler_pre(struct kprobe *p, struct pt_regs *regs)
-{
-	relay_printk(tpk, "%d\n", current->pid);
-	return 0;
-}
-
-int init_module(void)
-{
-	int ret = 0;
-	int len_parent_dir, len_dir;
-
-	/* setup the kprobe */
-	kp.pre_handler = handler_pre;
-	kp.post_handler = NULL;
-	kp.fault_handler = NULL;
-	kp.symbol_name = PROBE_POINT;
-	ret = register_kprobe(&kp);
-	if (ret) {
-		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
-		return ret;
-	}
-
-	len_parent_dir = strlen(SAMPLE_PARENT_DIR) + 1;
-	/* Initialising len_dir to the larger of the two dir names */
-	len_dir = strlen("kprobe_struct") + 1;
-
-	tpk = kzalloc(sizeof(*tpk), GFP_KERNEL);
-	if (!tpk)
-		ret = 1;
-
-	tpk->parent_dir = SAMPLE_PARENT_DIR;
-
-	/* Let's do a binary dump of struct kprobe using relay_dump */
-	tpk->dir = "kprobes_struct";
-	tpk->flags = TRACE_GLOBAL_CHANNEL;
-	relay_dump(tpk, &kp, sizeof(kp));
-
-	/* Now change the directory to collect fork pid data */
-	tpk->dir = PROBE_POINT;
-
-	if (ret)
-		printk(KERN_ERR "Unable to find required free memory. "
-				"Trace new sample module loading aborted");
-	return ret;
-}
-
-void cleanup_module(void)
-{
-	unregister_kprobe(&kp);
