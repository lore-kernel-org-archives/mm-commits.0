From: akpm@linux-foundation.org
Subject: + namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:53:27 -0700
Message-ID: <200706231653.l5NGrOv5019677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760719AbXFWQxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, clg@fr.ibm.com


The patch titled
     namespace: ensure clone_flags are always stored in an unsigned long
has been added to the -mm tree.  Its filename is
     namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: namespace: ensure clone_flags are always stored in an unsigned long
From: Eric W. Biederman <ebiederm@xmission.com>

While working on unshare support for the network namespace I noticed we
were putting clone flags in an int.  Which is weird because the syscall
uses unsigned long and we at least need an unsigned to properly hold all of
the unshare flags.

So to make the code consistent, this patch updates the code to use
unsigned long instead of int for the clone flags in those places
where we get it wrong today.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c                |    2 +-
 include/linux/mnt_namespace.h |    2 +-
 include/linux/nsproxy.h       |    2 +-
 include/linux/pid_namespace.h |    2 +-
 include/linux/utsname.h       |    3 ++-
 kernel/nsproxy.c              |    6 +++---
 kernel/pid.c                  |    2 +-
 kernel/utsname.c              |    2 +-
 8 files changed, 11 insertions(+), 10 deletions(-)

diff -puN fs/namespace.c~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long fs/namespace.c
--- a/fs/namespace.c~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long
+++ a/fs/namespace.c
@@ -1509,7 +1509,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	return new_ns;
 }
 
-struct mnt_namespace *copy_mnt_ns(int flags, struct mnt_namespace *ns,
+struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
 		struct fs_struct *new_fs)
 {
 	struct mnt_namespace *new_ns;
diff -puN include/linux/mnt_namespace.h~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long include/linux/mnt_namespace.h
--- a/include/linux/mnt_namespace.h~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long
+++ a/include/linux/mnt_namespace.h
@@ -14,7 +14,7 @@ struct mnt_namespace {
 	int event;
 };
 
-extern struct mnt_namespace *copy_mnt_ns(int, struct mnt_namespace *,
+extern struct mnt_namespace *copy_mnt_ns(unsigned long, struct mnt_namespace *,
 		struct fs_struct *);
 extern void __put_mnt_ns(struct mnt_namespace *ns);
 
diff -puN include/linux/nsproxy.h~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long
+++ a/include/linux/nsproxy.h
@@ -32,7 +32,7 @@ struct nsproxy {
 };
 extern struct nsproxy init_nsproxy;
 
-int copy_namespaces(int flags, struct task_struct *tsk);
+int copy_namespaces(unsigned long flags, struct task_struct *tsk);
 void get_task_namespaces(struct task_struct *tsk);
 void free_nsproxy(struct nsproxy *ns);
 int unshare_nsproxy_namespaces(unsigned long, struct nsproxy **,
diff -puN include/linux/pid_namespace.h~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long
+++ a/include/linux/pid_namespace.h
@@ -29,7 +29,7 @@ static inline void get_pid_ns(struct pid
 	kref_get(&ns->kref);
 }
 
-extern struct pid_namespace *copy_pid_ns(int flags, struct pid_namespace *ns);
+extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
 extern void free_pid_ns(struct kref *kref);
 
 static inline void put_pid_ns(struct pid_namespace *ns)
diff -puN include/linux/utsname.h~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long include/linux/utsname.h
--- a/include/linux/utsname.h~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long
+++ a/include/linux/utsname.h
@@ -48,7 +48,8 @@ static inline void get_uts_ns(struct uts
 	kref_get(&ns->kref);
 }
 
-extern struct uts_namespace *copy_utsname(int flags, struct uts_namespace *ns);
+extern struct uts_namespace *copy_utsname(unsigned long flags,
+					struct uts_namespace *ns);
 extern void free_uts_ns(struct kref *kref);
 
 static inline void put_uts_ns(struct uts_namespace *ns)
diff -puN kernel/nsproxy.c~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long kernel/nsproxy.c
--- a/kernel/nsproxy.c~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long
+++ a/kernel/nsproxy.c
@@ -58,8 +58,8 @@ static inline struct nsproxy *clone_nspr
  * Return the newly created nsproxy.  Do not attach this to the task,
  * leave it to the caller to do proper locking and attach it to task.
  */
-static struct nsproxy *create_new_namespaces(int flags, struct task_struct *tsk,
-			struct fs_struct *new_fs)
+static struct nsproxy *create_new_namespaces(unsigned long flags,
+			struct task_struct *tsk, struct fs_struct *new_fs)
 {
 	struct nsproxy *new_nsp;
 	int err;
@@ -121,7 +121,7 @@ out_ns:
  * called from clone.  This now handles copy for nsproxy and all
  * namespaces therein.
  */
-int copy_namespaces(int flags, struct task_struct *tsk)
+int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 {
 	struct nsproxy *old_ns = tsk->nsproxy;
 	struct nsproxy *new_ns;
diff -puN kernel/pid.c~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long kernel/pid.c
--- a/kernel/pid.c~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long
+++ a/kernel/pid.c
@@ -365,7 +365,7 @@ struct pid *find_ge_pid(int nr)
 }
 EXPORT_SYMBOL_GPL(find_get_pid);
 
-struct pid_namespace *copy_pid_ns(int flags, struct pid_namespace *old_ns)
+struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
 {
 	BUG_ON(!old_ns);
 	get_pid_ns(old_ns);
diff -puN kernel/utsname.c~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long kernel/utsname.c
--- a/kernel/utsname.c~namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long
+++ a/kernel/utsname.c
@@ -39,7 +39,7 @@ static struct uts_namespace *clone_uts_n
  * utsname of this process won't be seen by parent, and vice
  * versa.
  */
-struct uts_namespace *copy_utsname(int flags, struct uts_namespace *old_ns)
+struct uts_namespace *copy_utsname(unsigned long flags, struct uts_namespace *old_ns)
 {
 	struct uts_namespace *new_ns;
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

fix-refcounting-of-nsproxy-object-when-unshared.patch
dvb_en_50221-convert-to-kthread-api.patch
git-kbuild.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
i386-show-unhandled-signals-fix.patch
x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs.patch
x86-64-disable-the-gart-in-shutdown.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-3.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
buffer-kill-old-incorrect-comment.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
update-procfs-guide-doc-of-read_func.patch
namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
