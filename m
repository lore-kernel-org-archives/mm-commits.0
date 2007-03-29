From: akpm@linux-foundation.org
Subject: - ipcns-fix-config_ipc_ns-behavior.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:26 -0700
Message-ID: <200703290742.l2T7gQ23030300@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46216 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965111AbXC2HnT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     ipcns: fix !CONFIG_IPC_NS behavior
has been removed from the -mm tree.  Its filename was
     ipcns-fix-config_ipc_ns-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipcns: fix !CONFIG_IPC_NS behavior
From: "Serge E. Hallyn" <serue@us.ibm.com>

When CONFIG_IPC_NS=n, clone(CLONE_NEWIPC) claims success, but did not actually
clone a new IPC namespace.

Fix this to return -EINVAL so the caller knows his request was denied.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    9 +++------
 ipc/util.c          |    7 +++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN include/linux/ipc.h~ipcns-fix-config_ipc_ns-behavior include/linux/ipc.h
--- a/include/linux/ipc.h~ipcns-fix-config_ipc_ns-behavior
+++ a/include/linux/ipc.h
@@ -92,19 +92,16 @@ extern struct ipc_namespace init_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
+extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 #else
 #define INIT_IPC_NS(ns)
+static inline int copy_ipcs(unsigned long flags, struct task_struct *tsk)
+{ return 0; }
 #endif
 
 #ifdef CONFIG_IPC_NS
 extern void free_ipc_ns(struct kref *kref);
-extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 extern int unshare_ipcs(unsigned long flags, struct ipc_namespace **ns);
-#else
-static inline int copy_ipcs(unsigned long flags, struct task_struct *tsk)
-{
-	return 0;
-}
 #endif
 
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
diff -puN ipc/util.c~ipcns-fix-config_ipc_ns-behavior ipc/util.c
--- a/ipc/util.c~ipcns-fix-config_ipc_ns-behavior
+++ a/ipc/util.c
@@ -144,6 +144,13 @@ void free_ipc_ns(struct kref *kref)
 	shm_exit_ns(ns);
 	kfree(ns);
 }
+#else
+int copy_ipcs(unsigned long flags, struct task_struct *tsk)
+{
+	if (flags & CLONE_NEWIPC)
+		return -EINVAL;
+	return 0;
+}
 #endif
 
 /**
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
attach_pid-with-struct-pid-parameter.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
