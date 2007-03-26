From: akpm@linux-foundation.org
Subject: + ipcns-fix-config_ipc_ns-behavior.patch added to -mm tree
Date: Mon, 26 Mar 2007 15:07:14 -0700
Message-ID: <200703262207.l2QM7EoY031792@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbXCZWHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, ebiederm@xmission.com


The patch titled
     ipcns: fix !CONFIG_IPC_NS behavior
has been added to the -mm tree.  Its filename is
     ipcns-fix-config_ipc_ns-behavior.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 include/linux/ipc.h |    7 +------
 ipc/util.c          |    7 +++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/ipc.h~ipcns-fix-config_ipc_ns-behavior include/linux/ipc.h
--- a/include/linux/ipc.h~ipcns-fix-config_ipc_ns-behavior
+++ a/include/linux/ipc.h
@@ -96,15 +96,10 @@ extern struct ipc_namespace init_ipc_ns;
 #define INIT_IPC_NS(ns)
 #endif
 
+extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
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

utsns-fix-config_uts_ns-behavior.patch
ipcns-fix-config_ipc_ns-behavior.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
attach_pid-with-struct-pid-parameter.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
