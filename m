From: akpm@linux-foundation.org
Subject: + userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch added to -mm tree
Date: Fri, 18 Feb 2011 15:59:44 -0800
Message-ID: <201102182359.p1INxi08025076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758764Ab1BSAAT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Feb 2011 19:00:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, adobriyan@gmail.com, ebiederm@xmission.com, jmorris@namei.org, kees.cook@canonical.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com


The patch titled
     userns: add a user_namespace as creator/owner of uts_namespace
has been added to the -mm tree.  Its filename is
     userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch

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
Subject: userns: add a user_namespace as creator/owner of uts_namespace
From: "Serge E. Hallyn" <serge@hallyn.com>

The expected course of development for user namespaces targeted
capabilities is laid out at https://wiki.ubuntu.com/UserNamespace.

Goals:

- Make it safe for an unprivileged user to unshare namespaces.  They
  will be privileged with respect to the new namespace, but this should
  only include resources which the unprivileged user already owns.

- Provide separate limits and accounting for userids in different
  namespaces.  

Status:

  Currently (as of 2.6.38) you can clone with the CLONE_NEWUSER flag to
  get a new user namespace if you have the CAP_SYS_ADMIN, CAP_SETUID, and
  CAP_SETGID capabilities.  What this gets you is a whole new set of
  userids, meaning that user 500 will have a different 'struct user' in
  your namespace than in other namespaces.  So any accounting information
  stored in struct user will be unique to your namespace.

  However, throughout the kernel there are checks which

  - simply check for a capability.  Since root in a child namespace
    has all capabilities, this means that a child namespace is not
    constrained.

  - simply compare uid1 == uid2.  Since these are the integer uids,
    uid 500 in namespace 1 will be said to be equal to uid 500 in
    namespace 2.  

  As a result, the lxc implementation at lxc.sf.net does not use user
  namespaces.  This is actually helpful because it leaves us free to
  develop user namespaces in such a way that, for some time, user
  namespaces may be unuseful.  


Bugs aside, this patchset is supposed to not at all affect systems which
are not actively using user namespaces, and only restrict what tasks in
child user namespace can do.  They begin to limit privilege to a user
namespace, so that root in a container cannot kill or ptrace tasks in the
parent user namespace, and can only get world access rights to files. 
Since all files currently belong to the initila user namespace, that means
that child user namespaces can only get world access rights to *all*
files.  While this temporarily makes user namespaces bad for system
containers, it starts to get useful for some sandboxing.

I've run the 'runltplite.sh' with and without this patchset and found no
difference.




This patch:

copy_process() handles CLONE_NEWUSER before the rest of the namespaces. 
So in the case of clone(CLONE_NEWUSER|CLONE_NEWUTS) the new uts namespace
will have the new user namespace as its owner.  That is what we want,
since we want root in that new userns to be able to have privilege over
it.

Changelog:
	Feb 15: don't set uts_ns->user_ns if we didn't create
		a new uts_ns.
			
Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/utsname.h |    3 +++
 init/version.c          |    2 ++
 kernel/nsproxy.c        |    5 +++++
 kernel/user.c           |    8 ++++++--
 kernel/utsname.c        |    4 ++++
 5 files changed, 20 insertions(+), 2 deletions(-)

diff -puN include/linux/utsname.h~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace include/linux/utsname.h
--- a/include/linux/utsname.h~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace
+++ a/include/linux/utsname.h
@@ -37,9 +37,12 @@ struct new_utsname {
 #include <linux/nsproxy.h>
 #include <linux/err.h>
 
+struct user_namespace;
+
 struct uts_namespace {
 	struct kref kref;
 	struct new_utsname name;
+	struct user_namespace *user_ns;
 };
 extern struct uts_namespace init_uts_ns;
 
diff -puN init/version.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace init/version.c
--- a/init/version.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace
+++ a/init/version.c
@@ -21,6 +21,7 @@ extern int version_string(LINUX_VERSION_
 int version_string(LINUX_VERSION_CODE);
 #endif
 
+extern struct user_namespace init_user_ns;
 struct uts_namespace init_uts_ns = {
 	.kref = {
 		.refcount	= ATOMIC_INIT(2),
@@ -33,6 +34,7 @@ struct uts_namespace init_uts_ns = {
 		.machine	= UTS_MACHINE,
 		.domainname	= UTS_DOMAINNAME,
 	},
+	.user_ns = &init_user_ns,
 };
 EXPORT_SYMBOL_GPL(init_uts_ns);
 
diff -puN kernel/nsproxy.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace kernel/nsproxy.c
--- a/kernel/nsproxy.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace
+++ a/kernel/nsproxy.c
@@ -74,6 +74,11 @@ static struct nsproxy *create_new_namesp
 		err = PTR_ERR(new_nsp->uts_ns);
 		goto out_uts;
 	}
+	if (new_nsp->uts_ns != tsk->nsproxy->uts_ns) {
+		put_user_ns(new_nsp->uts_ns->user_ns);
+		new_nsp->uts_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
+		get_user_ns(new_nsp->uts_ns->user_ns);
+	}
 
 	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
 	if (IS_ERR(new_nsp->ipc_ns)) {
diff -puN kernel/user.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace kernel/user.c
--- a/kernel/user.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace
+++ a/kernel/user.c
@@ -17,9 +17,13 @@
 #include <linux/module.h>
 #include <linux/user_namespace.h>
 
+/*
+ * userns count is 1 for root user, 1 for init_uts_ns,
+ * and 1 for... ?
+ */
 struct user_namespace init_user_ns = {
 	.kref = {
-		.refcount	= ATOMIC_INIT(2),
+		.refcount	= ATOMIC_INIT(3),
 	},
 	.creator = &root_user,
 };
@@ -47,7 +51,7 @@ static struct kmem_cache *uid_cachep;
  */
 static DEFINE_SPINLOCK(uidhash_lock);
 
-/* root_user.__count is 2, 1 for init task cred, 1 for init_user_ns->creator */
+/* root_user.__count is 2, 1 for init task cred, 1 for init_user_ns->user_ns */
 struct user_struct root_user = {
 	.__count	= ATOMIC_INIT(2),
 	.processes	= ATOMIC_INIT(1),
diff -puN kernel/utsname.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace kernel/utsname.c
--- a/kernel/utsname.c~userns-add-a-user_namespace-as-creator-owner-of-uts_namespace
+++ a/kernel/utsname.c
@@ -14,6 +14,7 @@
 #include <linux/utsname.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/user_namespace.h>
 
 static struct uts_namespace *create_uts_ns(void)
 {
@@ -40,6 +41,8 @@ static struct uts_namespace *clone_uts_n
 
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
+	ns->user_ns = old_ns->user_ns;
+	get_user_ns(ns->user_ns);
 	up_read(&uts_sem);
 	return ns;
 }
@@ -71,5 +74,6 @@ void free_uts_ns(struct kref *kref)
 	struct uts_namespace *ns;
 
 	ns = container_of(kref, struct uts_namespace, kref);
+	put_user_ns(ns->user_ns);
 	kfree(ns);
 }
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

