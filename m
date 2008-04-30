From: akpm@linux-foundation.org
Subject: - ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:03 -0700
Message-ID: <200804300544.m3U5i3eH029372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760815AbYD3GMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ipc: do not recompute msgmni anymore if explicitly set by user
has been removed from the -mm tree.  Its filename was
     ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: do not recompute msgmni anymore if explicitly set by user
From: Nadia Derbey <Nadia.Derbey@bull.net>

Make msgmni not recomputed anymore upon ipc namespace creation / removal or
memory add/remove, as soon as it has been set from userland.

As soon as msgmni is explicitly set via procfs or sysctl(), the associated
callback routine is unregistered from the ipc namespace notifier chain.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff -puN ipc/ipc_sysctl.c~ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user
+++ a/ipc/ipc_sysctl.c
@@ -35,6 +35,24 @@ static int proc_ipc_dointvec(ctl_table *
 	return proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
 }
 
+static int proc_ipc_callback_dointvec(ctl_table *table, int write,
+	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	size_t lenp_bef = *lenp;
+	int rc;
+
+	rc = proc_ipc_dointvec(table, write, filp, buffer, lenp, ppos);
+
+	if (write && !rc && lenp_bef == *lenp)
+		/*
+		 * Tunable has successfully been changed from userland:
+		 * disable its automatic recomputing.
+		 */
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+
+	return rc;
+}
+
 static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
 	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -49,6 +67,7 @@ static int proc_ipc_doulongvec_minmax(ct
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
+#define proc_ipc_callback_dointvec NULL
 #endif
 
 #ifdef CONFIG_SYSCTL_SYSCALL
@@ -90,8 +109,28 @@ static int sysctl_ipc_data(ctl_table *ta
 	}
 	return 1;
 }
+
+static int sysctl_ipc_registered_data(ctl_table *table, int __user *name,
+		int nlen, void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	int rc;
+
+	rc = sysctl_ipc_data(table, name, nlen, oldval, oldlenp, newval,
+		newlen);
+
+	if (newval && newlen && rc > 0)
+		/*
+		 * Tunable has successfully been changed from userland:
+		 * disable its automatic recomputing.
+		 */
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+
+	return rc;
+}
 #else
 #define sysctl_ipc_data NULL
+#define sysctl_ipc_registered_data NULL
 #endif
 
 static struct ctl_table ipc_kern_table[] = {
@@ -137,8 +176,8 @@ static struct ctl_table ipc_kern_table[]
 		.data		= &init_ipc_ns.msg_ctlmni,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
+		.proc_handler	= proc_ipc_callback_dointvec,
+		.strategy	= sysctl_ipc_registered_data,
 	},
 	{
 		.ctl_name	= KERN_MSGMNB,
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-fix-idr_remove.patch
idr-introduce-the-ridr-structure.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

