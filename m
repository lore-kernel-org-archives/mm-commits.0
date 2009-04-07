From: akpm@linux-foundation.org
Subject: [merged] namespaces-mqueue-namespace-adapt-sysctl.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:44 -0700
Message-ID: <200904071907.n37J7iMI011445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbZDGTwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, Nadia.Derbey@bull.net, adobriyan@gmail.com, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     namespaces: mqueue namespace: adapt sysctl
has been removed from the -mm tree.  Its filename was
     namespaces-mqueue-namespace-adapt-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces: mqueue namespace: adapt sysctl
From: "Serge E. Hallyn" <serue@us.ibm.com>

Largely inspired from ipc/ipc_sysctl.c.  This patch isolates the mqueue
sysctl stuff in its own file.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |   14 +++
 init/Kconfig                  |    6 +
 ipc/Makefile                  |    1 
 ipc/mq_sysctl.c               |  116 ++++++++++++++++++++++++++++++++
 ipc/mqueue.c                  |   65 -----------------
 5 files changed, 138 insertions(+), 64 deletions(-)

diff -puN include/linux/ipc_namespace.h~namespaces-mqueue-namespace-adapt-sysctl include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~namespaces-mqueue-namespace-adapt-sysctl
+++ a/include/linux/ipc_namespace.h
@@ -128,4 +128,18 @@ static inline void put_ipc_ns(struct ipc
 {
 }
 #endif
+
+#ifdef CONFIG_POSIX_MQUEUE_SYSCTL
+
+struct ctl_table_header;
+extern struct ctl_table_header *mq_register_sysctl_table(void);
+
+#else /* CONFIG_POSIX_MQUEUE_SYSCTL */
+
+static inline struct ctl_table_header *mq_register_sysctl_table(void)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_POSIX_MQUEUE_SYSCTL */
 #endif
diff -puN init/Kconfig~namespaces-mqueue-namespace-adapt-sysctl init/Kconfig
--- a/init/Kconfig~namespaces-mqueue-namespace-adapt-sysctl
+++ a/init/Kconfig
@@ -208,6 +208,12 @@ config POSIX_MQUEUE
 
 	  If unsure, say Y.
 
+config POSIX_MQUEUE_SYSCTL
+	bool
+	depends on POSIX_MQUEUE
+	depends on SYSCTL
+	default y
+
 config BSD_PROCESS_ACCT
 	bool "BSD Process Accounting"
 	help
diff -puN ipc/Makefile~namespaces-mqueue-namespace-adapt-sysctl ipc/Makefile
--- a/ipc/Makefile~namespaces-mqueue-namespace-adapt-sysctl
+++ a/ipc/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysc
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
 obj-$(CONFIG_IPC_NS) += namespace.o
+obj-$(CONFIG_POSIX_MQUEUE_SYSCTL) += mq_sysctl.o
 
diff -puN /dev/null ipc/mq_sysctl.c
--- /dev/null
+++ a/ipc/mq_sysctl.c
@@ -0,0 +1,116 @@
+/*
+ *  Copyright (C) 2007 IBM Corporation
+ *
+ *  Author: Cedric Le Goater <clg@fr.ibm.com>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License as
+ *  published by the Free Software Foundation, version 2 of the
+ *  License.
+ */
+
+#include <linux/nsproxy.h>
+#include <linux/ipc_namespace.h>
+#include <linux/sysctl.h>
+
+/*
+ * Define the ranges various user-specified maximum values can
+ * be set to.
+ */
+#define MIN_MSGMAX	1		/* min value for msg_max */
+#define MAX_MSGMAX	HARD_MSGMAX	/* max value for msg_max */
+#define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
+#define MAX_MSGSIZEMAX	(8192*128)	/* max value for msgsize_max */
+
+static void *get_mq(ctl_table *table)
+{
+	char *which = table->data;
+	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
+	which = (which - (char *)&init_ipc_ns) + (char *)ipc_ns;
+	return which;
+}
+
+#ifdef CONFIG_PROC_SYSCTL
+static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
+	void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table mq_table;
+	memcpy(&mq_table, table, sizeof(mq_table));
+	mq_table.data = get_mq(table);
+
+	return proc_dointvec(&mq_table, write, filp, buffer, lenp, ppos);
+}
+
+static int proc_mq_dointvec_minmax(ctl_table *table, int write,
+	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table mq_table;
+	memcpy(&mq_table, table, sizeof(mq_table));
+	mq_table.data = get_mq(table);
+
+	return proc_dointvec_minmax(&mq_table, write, filp, buffer,
+					lenp, ppos);
+}
+#else
+#define proc_mq_dointvec NULL
+#define proc_mq_dointvec_minmax NULL
+#endif
+
+static int msg_max_limit_min = MIN_MSGMAX;
+static int msg_max_limit_max = MAX_MSGMAX;
+
+static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
+static int msg_maxsize_limit_max = MAX_MSGSIZEMAX;
+
+static ctl_table mq_sysctls[] = {
+	{
+		.procname	= "queues_max",
+		.data		= &init_ipc_ns.mq_queues_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_mq_dointvec,
+	},
+	{
+		.procname	= "msg_max",
+		.data		= &init_ipc_ns.mq_msg_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_max_limit_min,
+		.extra2		= &msg_max_limit_max,
+	},
+	{
+		.procname	= "msgsize_max",
+		.data		= &init_ipc_ns.mq_msgsize_max,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_mq_dointvec_minmax,
+		.extra1		= &msg_maxsize_limit_min,
+		.extra2		= &msg_maxsize_limit_max,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table mq_sysctl_dir[] = {
+	{
+		.procname	= "mqueue",
+		.mode		= 0555,
+		.child		= mq_sysctls,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table mq_sysctl_root[] = {
+	{
+		.ctl_name	= CTL_FS,
+		.procname	= "fs",
+		.mode		= 0555,
+		.child		= mq_sysctl_dir,
+	},
+	{ .ctl_name = 0 }
+};
+
+struct ctl_table_header *mq_register_sysctl_table(void)
+{
+	return register_sysctl_table(mq_sysctl_root);
+}
diff -puN ipc/mqueue.c~namespaces-mqueue-namespace-adapt-sysctl ipc/mqueue.c
--- a/ipc/mqueue.c~namespaces-mqueue-namespace-adapt-sysctl
+++ a/ipc/mqueue.c
@@ -47,15 +47,6 @@
 #define STATE_PENDING	1
 #define STATE_READY	2
 
-/*
- * Define the ranges various user-specified maximum values can
- * be set to.
- */
-#define MIN_MSGMAX	1		/* min value for msg_max */
-#define MAX_MSGMAX	HARD_MSGMAX	/* max value for msg_max */
-#define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
-#define MAX_MSGSIZEMAX	(8192*128)	/* max value for msgsize_max */
-
 struct ext_wait_queue {		/* queue of sleeping tasks */
 	struct task_struct *task;
 	struct list_head list;
@@ -1271,60 +1262,6 @@ void mq_put_mnt(struct ipc_namespace *ns
 	mntput(ns->mq_mnt);
 }
 
-static int msg_max_limit_min = MIN_MSGMAX;
-static int msg_max_limit_max = MAX_MSGMAX;
-
-static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
-static int msg_maxsize_limit_max = MAX_MSGSIZEMAX;
-
-static ctl_table mq_sysctls[] = {
-	{
-		.procname	= "queues_max",
-		.data		= &init_ipc_ns.mq_queues_max,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.procname	= "msg_max",
-		.data		= &init_ipc_ns.mq_msg_max,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.extra1		= &msg_max_limit_min,
-		.extra2		= &msg_max_limit_max,
-	},
-	{
-		.procname	= "msgsize_max",
-		.data		= &init_ipc_ns.mq_msgsize_max,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.extra1		= &msg_maxsize_limit_min,
-		.extra2		= &msg_maxsize_limit_max,
-	},
-	{ .ctl_name = 0 }
-};
-
-static ctl_table mq_sysctl_dir[] = {
-	{
-		.procname	= "mqueue",
-		.mode		= 0555,
-		.child		= mq_sysctls,
-	},
-	{ .ctl_name = 0 }
-};
-
-static ctl_table mq_sysctl_root[] = {
-	{
-		.ctl_name	= CTL_FS,
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= mq_sysctl_dir,
-	},
-	{ .ctl_name = 0 }
-};
