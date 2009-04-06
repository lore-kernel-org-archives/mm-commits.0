From: akpm@linux-foundation.org
Subject: [folded] namespaces-mqueue-namespace-adapt-sysctl-update.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:29:55 -0700
Message-ID: <200904062229.n36MTtWw015915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699AbZDFWdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, Nadia.Derbey@bull.net, adobriyan@gmail.com, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mqueue-namespace-adapt-sysctl-update
has been removed from the -mm tree.  Its filename was
     namespaces-mqueue-namespace-adapt-sysctl-update.patch

This patch was dropped because it was folded into namespaces-mqueue-namespace-adapt-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mqueue-namespace-adapt-sysctl-update
From: "Serge E. Hallyn" <serue@us.ibm.com>

Feb 24: comments from Alexey Dobriyan:

1) put proc handlers under CONFIG_PROC_SYSCTL and make them NULL
   otherwise.

2) remove & from proc_handler when assigned to ctl_table.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mq_sysctl.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN ipc/mq_sysctl.c~namespaces-mqueue-namespace-adapt-sysctl-update ipc/mq_sysctl.c
--- a/ipc/mq_sysctl.c~namespaces-mqueue-namespace-adapt-sysctl-update
+++ a/ipc/mq_sysctl.c
@@ -30,7 +30,7 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_PROC_SYSCTL
 static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -51,19 +51,10 @@ static int proc_mq_dointvec_minmax(ctl_t
 	return proc_dointvec_minmax(&mq_table, write, filp, buffer,
 					lenp, ppos);
 }
-#else /* CONFIG_PROC_FS */
-static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
-	void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
-static int proc_mq_dointvec_minmax(ctl_table *table, int write,
-	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-#endif /* CONFIG_PROC_FS */
+#else
+proc_handler *proc_mq_dointvec = NULL;
+proc_handler *proc_mq_dointvec_minmax = NULL;
+#endif
 
 static int msg_max_limit_min = MIN_MSGMAX;
 static int msg_max_limit_max = MAX_MSGMAX;
@@ -77,14 +68,14 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_mq_dointvec,
+		.proc_handler	= proc_mq_dointvec,
 	},
 	{
 		.procname	= "msg_max",
 		.data		= &init_ipc_ns.mq_msg_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_mq_dointvec_minmax,
+		.proc_handler	= proc_mq_dointvec_minmax,
 		.extra1		= &msg_max_limit_min,
 		.extra2		= &msg_max_limit_max,
 	},
@@ -93,7 +84,7 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_msgsize_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_mq_dointvec_minmax,
+		.proc_handler	= proc_mq_dointvec_minmax,
 		.extra1		= &msg_maxsize_limit_min,
 		.extra2		= &msg_maxsize_limit_max,
 	},
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
reiser4.patch

