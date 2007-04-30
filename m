From: akpm@linux-foundation.org
Subject: - merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:30:25 -0700
Message-ID: <200704301930.l3UJUP1i012922@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946725AbXD3TbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ipcns: fix !CONFIG_IPC_NS behavior
has been removed from the -mm tree.  Its filename was
     merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix.patch

This patch was dropped because it was folded into merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch

------------------------------------------------------
Subject: ipcns: fix !CONFIG_IPC_NS behavior
From: "Serge E. Hallyn" <serue@us.ibm.com>

When CONFIG_IPC_NS=n, clone(CLONE_NEWIPC) claims success, but did not actually
clone a new IPC namespace.

Fix this to return -EINVAL so the caller knows his request was denied.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |   10 ++--------
 ipc/util.c          |    7 +++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/ipc.h~merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix include/linux/ipc.h
--- a/include/linux/ipc.h~merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix
+++ a/include/linux/ipc.h
@@ -96,16 +96,10 @@ extern struct ipc_namespace init_ipc_ns;
 #define INIT_IPC_NS(ns)
 #endif
 
-#ifdef CONFIG_IPC_NS
-extern void free_ipc_ns(struct kref *kref);
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 		struct ipc_namespace *ns);
-#else
-static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
-		struct ipc_namespace *ns)
-{
-	return ns;
-}
+#ifdef CONFIG_IPC_NS
+extern void free_ipc_ns(struct kref *kref);
 #endif
 
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
diff -puN ipc/util.c~merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix ipc/util.c
--- a/ipc/util.c~merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix
+++ a/ipc/util.c
@@ -111,6 +111,13 @@ void free_ipc_ns(struct kref *kref)
 	shm_exit_ns(ns);
 	kfree(ns);
 }
+#else
+struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
+{
+	if (flags & CLONE_NEWIPC)
+		return ERR_PTR(-EINVAL);
+	return ns;
+}
 #endif
 
 /**
_

Patches currently in -mm which might be from serue@us.ibm.com are

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
