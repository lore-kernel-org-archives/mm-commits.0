From: akpm@linux-foundation.org
Subject: + ipcns-fix-config_ipc_ns-behavior-fix.patch added to -mm tree
Date: Mon, 26 Mar 2007 21:18:19 -0800
Message-ID: <200703270518.l2R5IJY5007509@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933986AbXC0FVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:21:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, ebiederm@xmission.com, serue@us.ibm.com


The patch titled
     ipcns: fix stupid !CONFIG_IPC error
has been added to the -mm tree.  Its filename is
     ipcns-fix-config_ipc_ns-behavior-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ipcns-fix-config_ipc_ns-behavior-fix.patch
