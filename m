From: akpm@linux-foundation.org
Subject: + userns-add-a-user-namespace-owner-of-ipc-ns.patch added to -mm tree
Date: Fri, 18 Feb 2011 16:01:27 -0800
Message-ID: <201102190001.p1J01RWj025203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab1BSACC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Feb 2011 19:02:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, adobriyan@gmail.com, ebiederm@xmission.com, jmorris@namei.org, kees.cook@canonical.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com


The patch titled
     userns: add a user namespace owner of ipc ns
has been added to the -mm tree.  Its filename is
     userns-add-a-user-namespace-owner-of-ipc-ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: add a user namespace owner of ipc ns
From: "Serge E. Hallyn" <serge@hallyn.com>

Changelog:
	Feb 15: Don't set new ipc->user_ns if we didn't create a new
		ipc_ns.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    3 +++
 ipc/msgutil.c                 |    3 +++
 ipc/namespace.c               |    9 +++++++--
 kernel/nsproxy.c              |    5 +++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff -puN include/linux/ipc_namespace.h~userns-add-a-user-namespace-owner-of-ipc-ns include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~userns-add-a-user-namespace-owner-of-ipc-ns
+++ a/include/linux/ipc_namespace.h
@@ -24,6 +24,7 @@ struct ipc_ids {
 	struct idr ipcs_idr;
 };
 
+struct user_namespace;
 struct ipc_namespace {
 	atomic_t	count;
 	struct ipc_ids	ids[3];
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
@@ -20,6 +20,8 @@
 
 DEFINE_SPINLOCK(mq_lock);
 
+extern struct user_namespace init_user_ns;
+
 /*
  * The next 2 defines are here bc this is the only file
  * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
@@ -32,6 +34,7 @@ struct ipc_namespace init_ipc_ns = {
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
@@ -85,6 +85,11 @@ static struct nsproxy *create_new_namesp
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

lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
pid-remove-the-child_reaper-special-case-in-init-mainc.patch
pidns-call-pid_ns_prepare_proc-from-create_pid_namespace.patch
procfs-kill-the-global-proc_mnt-variable.patch
userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-allow-sethostname-in-a-container.patch
userns-allow-killing-tasks-in-your-own-or-child-userns.patch
userns-allow-ptrace-from-non-init-user-namespaces.patch
userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch
userns-add-a-user-namespace-owner-of-ipc-ns.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch

