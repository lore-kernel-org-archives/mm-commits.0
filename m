From: akpm@linux-foundation.org
Subject: - ipcns-fix-config_ipc_ns-behavior-fix.patch removed from -mm tree
Date: Mon, 26 Mar 2007 21:21:43 -0800
Message-ID: <200703270521.l2R5LhTp007570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993AbXC0FWK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, ebiederm@xmission.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ipcns: fix stupid !CONFIG_IPC error
has been removed from the -mm tree.  Its filename was
     ipcns-fix-config_ipc_ns-behavior-fix.patch

This patch was dropped because it was folded into ipcns-fix-config_ipc_ns-behavior.patch

------------------------------------------------------
Subject: ipcns: fix stupid !CONFIG_IPC error
From: "Serge E. Hallyn" <serge@hallyn.com>

Andrew Morton pointed out my patch to fix CLONE_NEWIPC behavior
when CONFIG_IPC_NS=n broke compilation when CONFIG_IPC=n.

Make sure copy_ipcs() is always defined.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/ipc.h~ipcns-fix-config_ipc_ns-behavior-fix include/linux/ipc.h
--- a/include/linux/ipc.h~ipcns-fix-config_ipc_ns-behavior-fix
+++ a/include/linux/ipc.h
@@ -92,11 +92,13 @@ extern struct ipc_namespace init_ipc_ns;
 
 #ifdef CONFIG_SYSVIPC
 #define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
+extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 #else
 #define INIT_IPC_NS(ns)
+static inline int copy_ipcs(unsigned long flags, struct task_struct *tsk)
+{ return 0; }
 #endif
 
-extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 #ifdef CONFIG_IPC_NS
 extern void free_ipc_ns(struct kref *kref);
 extern int unshare_ipcs(unsigned long flags, struct ipc_namespace **ns);
_

Patches currently in -mm which might be from serge@hallyn.com are

ipcns-fix-config_ipc_ns-behavior.patch
ipcns-fix-config_ipc_ns-behavior-fix.patch
