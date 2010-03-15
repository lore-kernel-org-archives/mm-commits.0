From: akpm@linux-foundation.org
Subject: [merged] nsproxy-remove-init_nsproxy.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:44 -0400
Message-ID: <201003150702.o2F72H8Q016861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0COHCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     nsproxy: remove INIT_NSPROXY()
has been removed from the -mm tree.  Its filename was
     nsproxy-remove-init_nsproxy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nsproxy: remove INIT_NSPROXY()
From: Alexey Dobriyan <adobriyan@gmail.com>

Remove INIT_NSPROXY(), use C99 initializer.
Remove INIT_IPC_NS(), INIT_NET_NS() while I'm at it.

Note: headers trim will be done later, now it's quite pointless because
results will be invalidated by merge window.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h     |    8 --------
 include/linux/ipc_namespace.h |    5 -----
 include/net/net_namespace.h   |    5 -----
 kernel/nsproxy.c              |   13 ++++++++++++-
 4 files changed, 12 insertions(+), 19 deletions(-)

diff -puN include/linux/init_task.h~nsproxy-remove-init_nsproxy include/linux/init_task.h
--- a/include/linux/init_task.h~nsproxy-remove-init_nsproxy
+++ a/include/linux/init_task.h
@@ -32,14 +32,6 @@ extern struct fs_struct init_fs;
 }
 
 extern struct nsproxy init_nsproxy;
-#define INIT_NSPROXY(nsproxy) {						\
-	.pid_ns		= &init_pid_ns,					\
-	.count		= ATOMIC_INIT(1),				\
-	.uts_ns		= &init_uts_ns,					\
-	.mnt_ns		= NULL,						\
-	INIT_NET_NS(net_ns)                                             \
-	INIT_IPC_NS(ipc_ns)						\
-}
 
 #define INIT_SIGHAND(sighand) {						\
 	.count		= ATOMIC_INIT(1), 				\
diff -puN include/linux/ipc_namespace.h~nsproxy-remove-init_nsproxy include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~nsproxy-remove-init_nsproxy
+++ a/include/linux/ipc_namespace.h
@@ -62,11 +62,6 @@ extern struct ipc_namespace init_ipc_ns;
 extern atomic_t nr_ipc_ns;
 
 extern spinlock_t mq_lock;
-#if defined(CONFIG_POSIX_MQUEUE) || defined(CONFIG_SYSVIPC)
-#define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
-#else
-#define INIT_IPC_NS(ns)
-#endif
 
 #ifdef CONFIG_SYSVIPC
 extern int register_ipcns_notifier(struct ipc_namespace *);
diff -puN include/net/net_namespace.h~nsproxy-remove-init_nsproxy include/net/net_namespace.h
--- a/include/net/net_namespace.h~nsproxy-remove-init_nsproxy
+++ a/include/net/net_namespace.h
@@ -100,14 +100,9 @@ struct net {
 extern struct net init_net;
 
 #ifdef CONFIG_NET
-#define INIT_NET_NS(net_ns) .net_ns = &init_net,
-
 extern struct net *copy_net_ns(unsigned long flags, struct net *net_ns);
 
 #else /* CONFIG_NET */
-
-#define INIT_NET_NS(net_ns)
-
 static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
 {
 	/* There is nothing to copy so this is a noop */
diff -puN kernel/nsproxy.c~nsproxy-remove-init_nsproxy kernel/nsproxy.c
--- a/kernel/nsproxy.c~nsproxy-remove-init_nsproxy
+++ a/kernel/nsproxy.c
@@ -24,7 +24,18 @@
 
 static struct kmem_cache *nsproxy_cachep;
 
-struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
+struct nsproxy init_nsproxy = {
+	.count	= ATOMIC_INIT(1),
+	.uts_ns	= &init_uts_ns,
+#if defined(CONFIG_POSIX_MQUEUE) || defined(CONFIG_SYSVIPC)
+	.ipc_ns	= &init_ipc_ns,
+#endif
+	.mnt_ns	= NULL,
+	.pid_ns	= &init_pid_ns,
+#ifdef CONFIG_NET
+	.net_ns	= &init_net,
+#endif
+};
 
 static inline struct nsproxy *create_nsproxy(void)
 {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
rcu-remove-init_rcu_head-rcu_head_init-rcu_head.patch
mpt-fusion-convert-to-seq_file.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch

