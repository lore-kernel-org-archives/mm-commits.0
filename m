From: akpm@linux-foundation.org
Subject: [merged] userns-allow-sethostname-in-a-container.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:48 -0700
Message-ID: <201103250726.p2P7Qh3f026168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933986Ab1CYH0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns: allow sethostname in a container
has been removed from the -mm tree.  Its filename was
     userns-allow-sethostname-in-a-container.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: allow sethostname in a container
From: "Serge E. Hallyn" <serge@hallyn.com>

Changelog:
	Feb 23: let clone_uts_ns() handle setting uts->user_ns
		To do so we need to pass in the task_struct who'll
		get the utsname, so we can get its user_ns.
	Feb 23: As per Oleg's coment, just pass in tsk, instead of two
		of its members.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/utsname.h |    6 +++---
 kernel/nsproxy.c        |    7 +------
 kernel/sys.c            |    2 +-
 kernel/utsname.c        |   12 +++++++-----
 4 files changed, 12 insertions(+), 15 deletions(-)

diff -puN include/linux/utsname.h~userns-allow-sethostname-in-a-container include/linux/utsname.h
--- a/include/linux/utsname.h~userns-allow-sethostname-in-a-container
+++ a/include/linux/utsname.h
@@ -54,7 +54,7 @@ static inline void get_uts_ns(struct uts
 }
 
 extern struct uts_namespace *copy_utsname(unsigned long flags,
-					struct uts_namespace *ns);
+					  struct task_struct *tsk);
 extern void free_uts_ns(struct kref *kref);
 
 static inline void put_uts_ns(struct uts_namespace *ns)
@@ -71,12 +71,12 @@ static inline void put_uts_ns(struct uts
 }
 
 static inline struct uts_namespace *copy_utsname(unsigned long flags,
-					struct uts_namespace *ns)
+						 struct task_struct *tsk)
 {
 	if (flags & CLONE_NEWUTS)
 		return ERR_PTR(-EINVAL);
 
-	return ns;
+	return tsk->nsproxy->uts_ns;
 }
 #endif
 
diff -puN kernel/nsproxy.c~userns-allow-sethostname-in-a-container kernel/nsproxy.c
--- a/kernel/nsproxy.c~userns-allow-sethostname-in-a-container
+++ a/kernel/nsproxy.c
@@ -69,16 +69,11 @@ static struct nsproxy *create_new_namesp
 		goto out_ns;
 	}
 
-	new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns);
+	new_nsp->uts_ns = copy_utsname(flags, tsk);
 	if (IS_ERR(new_nsp->uts_ns)) {
 		err = PTR_ERR(new_nsp->uts_ns);
 		goto out_uts;
 	}
-	if (new_nsp->uts_ns != tsk->nsproxy->uts_ns) {
-		put_user_ns(new_nsp->uts_ns->user_ns);
-		new_nsp->uts_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
-		get_user_ns(new_nsp->uts_ns->user_ns);
-	}
 
 	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
 	if (IS_ERR(new_nsp->ipc_ns)) {
diff -puN kernel/sys.c~userns-allow-sethostname-in-a-container kernel/sys.c
--- a/kernel/sys.c~userns-allow-sethostname-in-a-container
+++ a/kernel/sys.c
@@ -1181,7 +1181,7 @@ SYSCALL_DEFINE2(sethostname, char __user
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (len < 0 || len > __NEW_UTS_LEN)
 		return -EINVAL;
diff -puN kernel/utsname.c~userns-allow-sethostname-in-a-container kernel/utsname.c
--- a/kernel/utsname.c~userns-allow-sethostname-in-a-container
+++ a/kernel/utsname.c
@@ -31,7 +31,8 @@ static struct uts_namespace *create_uts_
  * @old_ns: namespace to clone
  * Return NULL on error (failure to kmalloc), new ns otherwise
  */
-static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
+static struct uts_namespace *clone_uts_ns(struct task_struct *tsk,
+					  struct uts_namespace *old_ns)
 {
 	struct uts_namespace *ns;
 
@@ -41,8 +42,7 @@ static struct uts_namespace *clone_uts_n
 
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
-	ns->user_ns = old_ns->user_ns;
-	get_user_ns(ns->user_ns);
+	ns->user_ns = get_user_ns(task_cred_xxx(tsk, user)->user_ns);
 	up_read(&uts_sem);
 	return ns;
 }
@@ -53,8 +53,10 @@ static struct uts_namespace *clone_uts_n
  * utsname of this process won't be seen by parent, and vice
  * versa.
  */
-struct uts_namespace *copy_utsname(unsigned long flags, struct uts_namespace *old_ns)
+struct uts_namespace *copy_utsname(unsigned long flags,
+				   struct task_struct *tsk)
 {
+	struct uts_namespace *old_ns = tsk->nsproxy->uts_ns;
 	struct uts_namespace *new_ns;
 
 	BUG_ON(!old_ns);
@@ -63,7 +65,7 @@ struct uts_namespace *copy_utsname(unsig
 	if (!(flags & CLONE_NEWUTS))
 		return old_ns;
 
-	new_ns = clone_uts_ns(old_ns);
+	new_ns = clone_uts_ns(tsk, old_ns);
 
 	put_uts_ns(old_ns);
 	return new_ns;
_

Patches currently in -mm which might be from serge@hallyn.com are

origin.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch

