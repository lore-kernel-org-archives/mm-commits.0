From: akpm@linux-foundation.org
Subject: - ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:38 -0800
Message-ID: <200901072220.n07MKcqG019828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762218AbZAGWVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:21:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangcong@zeuux.org, Nadia.Derbey@bull.net, adobriyan@gmail.com, ebiederm@xmision.com, mm-commits@vger.kernel.org


The patch titled
     ipc/ipc_sysctl.c: move the definition of ipc_auto_callback()
has been removed from the -mm tree.  Its filename was
     ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/ipc_sysctl.c: move the definition of ipc_auto_callback()


proc_ipcauto_dointvec_minmax() is the only user of ipc_auto_callback(),
since the former function is protected by CONFIG_PROC_FS, so should be the
latter one.

Just move its definition down.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Eric Biederman <ebiederm@xmision.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |   46 ++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN ipc/ipc_sysctl.c~ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback
+++ a/ipc/ipc_sysctl.c
@@ -26,29 +26,6 @@ static void *get_ipc(ctl_table *table)
 	return which;
 }
 
-/*
- * Routine that is called when the file "auto_msgmni" has successfully been
- * written.
- * Two values are allowed:
- * 0: unregister msgmni's callback routine from the ipc namespace notifier
- *    chain. This means that msgmni won't be recomputed anymore upon memory
- *    add/remove or ipc namespace creation/removal.
- * 1: register back the callback routine.
- */
-static void ipc_auto_callback(int val)
-{
-	if (!val)
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-	else {
-		/*
-		 * Re-enable automatic recomputing only if not already
-		 * enabled.
-		 */
-		recompute_msgmni(current->nsproxy->ipc_ns);
-		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
-	}
-}
-
 #ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -94,6 +71,29 @@ static int proc_ipc_doulongvec_minmax(ct
 					lenp, ppos);
 }
 
+/*
+ * Routine that is called when the file "auto_msgmni" has successfully been
+ * written.
+ * Two values are allowed:
+ * 0: unregister msgmni's callback routine from the ipc namespace notifier
+ *    chain. This means that msgmni won't be recomputed anymore upon memory
+ *    add/remove or ipc namespace creation/removal.
+ * 1: register back the callback routine.
+ */
+static void ipc_auto_callback(int val)
+{
+	if (!val)
+		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
+	else {
+		/*
+		 * Re-enable automatic recomputing only if not already
+		 * enabled.
+		 */
+		recompute_msgmni(current->nsproxy->ipc_ns);
+		cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
+	}
+}
+
 static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
 	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
 {
_

Patches currently in -mm which might be from wangcong@zeuux.org are

origin.patch

