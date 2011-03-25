From: akpm@linux-foundation.org
Subject: [merged] userns-add-a-user-namespace-owner-of-ipc-ns.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:58 -0700
Message-ID: <201103250726.p2P7Qqo0026187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933996Ab1CYH1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns: add a user namespace owner of ipc ns
has been removed from the -mm tree.  Its filename was
     userns-add-a-user-namespace-owner-of-ipc-ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: add a user namespace owner of ipc ns
From: "Serge E. Hallyn" <serge@hallyn.com>

Changelog:
	Feb 15: Don't set new ipc->user_ns if we didn't create a new
		ipc_ns.
	Feb 23: Move extern declaration to ipc_namespace.h, and group
		fwd declarations at top.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    3 +++
 ipc/msgutil.c                 |    1 +
 ipc/namespace.c               |    9 +++++++--
 kernel/nsproxy.c              |    5 +++++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff -puN include/linux/ipc_namespace.h~userns-add-a-user-namespace-owner-of-ipc-ns include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~userns-add-a-user-namespace-owner-of-ipc-ns
+++ a/include/linux/ipc_namespace.h
@@ -15,6 +15,7 @@
 
 #define IPCNS_CALLBACK_PRI 0
 
+struct user_namespace;
 
 struct ipc_ids {
 	int in_use;
@@ -56,6 +57,8 @@ struct ipc_namespace {
 	unsigned int    mq_msg_max;      /* initialized to DFLT_MSGMAX */
 	unsigned int    mq_msgsize_max;  /* initialized to DFLT_MSGSIZEMAX */
 
+	/* user_ns which owns the ipc ns */
+	struct user_namespace *user_ns;
 };
 
 extern struct ipc_namespace init_ipc_ns;
diff -puN ipc/msgutil.c~userns-add-a-user-namespace-owner-of-ipc-ns ipc/msgutil.c
--- a/ipc/msgutil.c~userns-add-a-user-namespace-owner-of-ipc-ns
+++ a/ipc/msgutil.c
@@ -32,6 +32,7 @@ struct ipc_namespace init_ipc_ns = {
 	.mq_msg_max      = DFLT_MSGMAX,
 	.mq_msgsize_max  = DFLT_MSGSIZEMAX,
 #endif
+	.user_ns = &init_user_ns,
 };
 
 atomic_t nr_ipc_ns = ATOMIC_INIT(1);
diff -puN ipc/namespace.c~userns-add-a-user-namespace-owner-of-ipc-ns ipc/namespace.c
--- a/ipc/namespace.c~userns-add-a-user-namespace-owner-of-ipc-ns
+++ a/ipc/namespace.c
@@ -11,10 +11,11 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/user_namespace.h>
 
 #include "util.h"
 
-static struct ipc_namespace *create_ipc_ns(void)
+static struct ipc_namespace *create_ipc_ns(struct ipc_namespace *old_ns)
 {
 	struct ipc_namespace *ns;
 	int err;
@@ -43,6 +44,9 @@ static struct ipc_namespace *create_ipc_
 	ipcns_notify(IPCNS_CREATED);
 	register_ipcns_notifier(ns);
 
+	ns->user_ns = old_ns->user_ns;
+	get_user_ns(ns->user_ns);
+
 	return ns;
 }
 
@@ -50,7 +54,7 @@ struct ipc_namespace *copy_ipcs(unsigned
 {
 	if (!(flags & CLONE_NEWIPC))
 		return get_ipc_ns(ns);
-	return create_ipc_ns();
+	return create_ipc_ns(ns);
 }
 
 /*
@@ -105,6 +109,7 @@ static void free_ipc_ns(struct ipc_names
 	 * order to have a correct value when recomputing msgmni.
 	 */
 	ipcns_notify(IPCNS_REMOVED);
+	put_user_ns(ns->user_ns);
 }
 
 /*
diff -puN kernel/nsproxy.c~userns-add-a-user-namespace-owner-of-ipc-ns kernel/nsproxy.c
--- a/kernel/nsproxy.c~userns-add-a-user-namespace-owner-of-ipc-ns
+++ a/kernel/nsproxy.c
@@ -80,6 +80,11 @@ static struct nsproxy *create_new_namesp
 		err = PTR_ERR(new_nsp->ipc_ns);
 		goto out_ipc;
 	}
+	if (new_nsp->ipc_ns != tsk->nsproxy->ipc_ns) {
+		put_user_ns(new_nsp->ipc_ns->user_ns);
+		new_nsp->ipc_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
+		get_user_ns(new_nsp->ipc_ns->user_ns);
+	}
 
 	new_nsp->pid_ns = copy_pid_ns(flags, task_active_pid_ns(tsk));
 	if (IS_ERR(new_nsp->pid_ns)) {
_

Patches currently in -mm which might be from serge@hallyn.com are

origin.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch

