From: akpm@linux-foundation.org
Subject: + move-the-ipc-namespace-under-ipc_ns-option.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:01:53 -0800
Message-ID: <200711160001.lAG01sDw022714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762291AbXKPADN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:03:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     namespaces: move the IPC namespace under IPC_NS option
has been added to the -mm tree.  Its filename is
     move-the-ipc-namespace-under-ipc_ns-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: namespaces: move the IPC namespace under IPC_NS option
From: Pavel Emelyanov <xemul@openvz.org>

Currently the IPC namespace management code is spread over the ipc/*.c files. 
I moved this code into ipc/namespace.c file which is compiled out when needed.

The linux/ipc_namespace.h file is used to store the prototypes of the
functions in namespace.c and the stubs for NAMESPACES=n case.  This is done
so, because the stub for copy_ipc_namespace requires the knowledge of the
CLONE_NEWIPC flag, which is in sched.h.  But the linux/ipc.h file itself in
included into many many .c files via the sys.h->sem.h sequence so adding the
sched.h into it will make all these .c depend on sched.h which is not that
good.  On the other hand the knowledge about the namespaces stuff is required
in 4 .c files only.

Besides, this patch compiles out some auxiliary functions from ipc/sem.c,
msg.c and shm.c files.  It turned out that moving these functions into
namespaces.c is not that easy because they use many other calls and macros
from the original file.  Moving them would make this patch complicated.  On
the other hand all these functions can be consolidated, so I will send a
separate patch doing this a bit later.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h           |   52 ----------------------
 include/linux/ipc_namespace.h |   69 ++++++++++++++++++++++++++++++
 init/Kconfig                  |    7 +++
 ipc/Makefile                  |    1 
 ipc/ipc_sysctl.c              |    1 
 ipc/msg.c                     |    3 +
 ipc/namespace.c               |   73 ++++++++++++++++++++++++++++++++
 ipc/sem.c                     |    3 +
 ipc/shm.c                     |    3 +
 ipc/util.c                    |   61 --------------------------
 ipc/util.h                    |    2 
 kernel/nsproxy.c              |    1 
 12 files changed, 164 insertions(+), 112 deletions(-)

diff -puN include/linux/ipc.h~move-the-ipc-namespace-under-ipc_ns-option include/linux/ipc.h
--- a/include/linux/ipc.h~move-the-ipc-namespace-under-ipc_ns-option
+++ a/include/linux/ipc.h
@@ -100,58 +100,6 @@ struct kern_ipc_perm
 	void		*security;
 };
 
-struct ipc_ids;
-struct ipc_namespace {
-	struct kref	kref;
-	struct ipc_ids	*ids[3];
-
-	int		sem_ctls[4];
-	int		used_sems;
-
-	int		msg_ctlmax;
-	int		msg_ctlmnb;
-	int		msg_ctlmni;
-	atomic_t	msg_bytes;
-	atomic_t	msg_hdrs;
-
-	size_t		shm_ctlmax;
-	size_t		shm_ctlall;
-	int		shm_ctlmni;
-	int		shm_tot;
-};
-
-extern struct ipc_namespace init_ipc_ns;
-
-#ifdef CONFIG_SYSVIPC
-#define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
-extern void free_ipc_ns(struct kref *kref);
-extern struct ipc_namespace *copy_ipcs(unsigned long flags,
-						struct ipc_namespace *ns);
-#else
-#define INIT_IPC_NS(ns)
-static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
-						struct ipc_namespace *ns)
-{
-	return ns;
-}
-#endif
-
-static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
-{
-#ifdef CONFIG_SYSVIPC
-	if (ns)
-		kref_get(&ns->kref);
-#endif
-	return ns;
-}
-
-static inline void put_ipc_ns(struct ipc_namespace *ns)
-{
-#ifdef CONFIG_SYSVIPC
-	kref_put(&ns->kref, free_ipc_ns);
-#endif
-}
-
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_IPC_H */
diff -puN /dev/null include/linux/ipc_namespace.h
--- /dev/null
+++ a/include/linux/ipc_namespace.h
@@ -0,0 +1,69 @@
+#ifndef __IPC_NAMESPACE_H__
+#define __IPC_NAMESPACE_H__
+
+#include <linux/err.h>
+
+struct ipc_ids;
+struct ipc_namespace {
+	struct kref	kref;
+	struct ipc_ids	*ids[3];
+
+	int		sem_ctls[4];
+	int		used_sems;
+
+	int		msg_ctlmax;
+	int		msg_ctlmnb;
+	int		msg_ctlmni;
+	atomic_t	msg_bytes;
+	atomic_t	msg_hdrs;
+
+	size_t		shm_ctlmax;
+	size_t		shm_ctlall;
+	int		shm_ctlmni;
+	int		shm_tot;
+};
+
+extern struct ipc_namespace init_ipc_ns;
+
+#ifdef CONFIG_SYSVIPC
+#define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
+#else
+#define INIT_IPC_NS(ns)
+#endif
+
+#if defined(CONFIG_SYSVIPC) && defined(CONFIG_IPC_NS)
+extern void free_ipc_ns(struct kref *kref);
+extern struct ipc_namespace *copy_ipcs(unsigned long flags,
+						struct ipc_namespace *ns);
+
+static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
+{
+	if (ns)
+		kref_get(&ns->kref);
+	return ns;
+}
+
+static inline void put_ipc_ns(struct ipc_namespace *ns)
+{
+	kref_put(&ns->kref, free_ipc_ns);
+}
+#else
+static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
+		struct ipc_namespace *ns)
+{
+	if (flags & CLONE_NEWIPC)
+		return ERR_PTR(-EINVAL);
+
+	return ns;
+}
+
+static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
+{
+	return ns;
+}
+
+static inline void put_ipc_ns(struct ipc_namespace *ns)
+{
+}
+#endif
+#endif
diff -puN init/Kconfig~move-the-ipc-namespace-under-ipc_ns-option init/Kconfig
--- a/init/Kconfig~move-the-ipc-namespace-under-ipc_ns-option
+++ a/init/Kconfig
@@ -420,6 +420,13 @@ config UTS_NS
 	  In this namespace tasks see different info provided with the
 	  uname() system call
 
+config IPC_NS
+	bool "IPC namespace"
+	depends on NAMESPACES && SYSVIPC
+	help
+	  In this namespace tasks work with IPC ids which correspond to
+	  different IPC objects in different namespaces
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
diff -puN ipc/Makefile~move-the-ipc-namespace-under-ipc_ns-option ipc/Makefile
--- a/ipc/Makefile~move-the-ipc-namespace-under-ipc_ns-option
+++ a/ipc/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_SYSVIPC) += util.o msgutil.
 obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysctl.o
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
+obj-$(CONFIG_IPC_NS) += namespace.o
 
diff -puN ipc/ipc_sysctl.c~move-the-ipc-namespace-under-ipc_ns-option ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~move-the-ipc-namespace-under-ipc_ns-option
+++ a/ipc/ipc_sysctl.c
@@ -14,6 +14,7 @@
 #include <linux/nsproxy.h>
 #include <linux/sysctl.h>
 #include <linux/uaccess.h>
+#include <linux/ipc_namespace.h>
 
 static void *get_ipc(ctl_table *table)
 {
diff -puN ipc/msg.c~move-the-ipc-namespace-under-ipc_ns-option ipc/msg.c
--- a/ipc/msg.c~move-the-ipc-namespace-under-ipc_ns-option
+++ a/ipc/msg.c
@@ -36,6 +36,7 @@
 #include <linux/seq_file.h>
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
+#include <linux/ipc_namespace.h>
 
 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -90,6 +91,7 @@ static void __msg_init_ns(struct ipc_nam
 	ipc_init_ids(ids);
 }
 
+#ifdef CONFIG_IPC_NS
 int msg_init_ns(struct ipc_namespace *ns)
 {
 	struct ipc_ids *ids;
@@ -128,6 +130,7 @@ void msg_exit_ns(struct ipc_namespace *n
 	kfree(ns->ids[IPC_MSG_IDS]);
 	ns->ids[IPC_MSG_IDS] = NULL;
 }
+#endif
 
 void __init msg_init(void)
 {
diff -puN /dev/null ipc/namespace.c
--- /dev/null
+++ a/ipc/namespace.c
@@ -0,0 +1,73 @@
+/*
+ * linux/ipc/namespace.c
+ * Copyright (C) 2006 Pavel Emelyanov <xemul@openvz.org> OpenVZ, SWsoft Inc.
+ */
+
+#include <linux/ipc.h>
+#include <linux/msg.h>
+#include <linux/ipc_namespace.h>
+#include <linux/rcupdate.h>
+#include <linux/nsproxy.h>
+#include <linux/slab.h>
+
+#include "util.h"
+
+static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
+{
+	int err;
+	struct ipc_namespace *ns;
+
+	err = -ENOMEM;
+	ns = kmalloc(sizeof(struct ipc_namespace), GFP_KERNEL);
+	if (ns == NULL)
+		goto err_mem;
+
+	err = sem_init_ns(ns);
+	if (err)
+		goto err_sem;
+	err = msg_init_ns(ns);
+	if (err)
+		goto err_msg;
+	err = shm_init_ns(ns);
+	if (err)
+		goto err_shm;
+
+	kref_init(&ns->kref);
+	return ns;
+
+err_shm:
+	msg_exit_ns(ns);
+err_msg:
+	sem_exit_ns(ns);
+err_sem:
+	kfree(ns);
+err_mem:
+	return ERR_PTR(err);
+}
+
+struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
+{
+	struct ipc_namespace *new_ns;
+
+	BUG_ON(!ns);
+	get_ipc_ns(ns);
+
+	if (!(flags & CLONE_NEWIPC))
+		return ns;
+
+	new_ns = clone_ipc_ns(ns);
+
+	put_ipc_ns(ns);
+	return new_ns;
+}
+
+void free_ipc_ns(struct kref *kref)
+{
+	struct ipc_namespace *ns;
+
+	ns = container_of(kref, struct ipc_namespace, kref);
+	sem_exit_ns(ns);
+	msg_exit_ns(ns);
+	shm_exit_ns(ns);
+	kfree(ns);
+}
diff -puN ipc/sem.c~move-the-ipc-namespace-under-ipc_ns-option ipc/sem.c
--- a/ipc/sem.c~move-the-ipc-namespace-under-ipc_ns-option
+++ a/ipc/sem.c
@@ -82,6 +82,7 @@
 #include <linux/seq_file.h>
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
+#include <linux/ipc_namespace.h>
 
 #include <asm/uaccess.h>
 #include "util.h"
@@ -128,6 +129,7 @@ static void __sem_init_ns(struct ipc_nam
 	ipc_init_ids(ids);
 }
 
+#ifdef CONFIG_IPC_NS
 int sem_init_ns(struct ipc_namespace *ns)
 {
 	struct ipc_ids *ids;
@@ -165,6 +167,7 @@ void sem_exit_ns(struct ipc_namespace *n
 	kfree(ns->ids[IPC_SEM_IDS]);
 	ns->ids[IPC_SEM_IDS] = NULL;
 }
+#endif
 
 void __init sem_init (void)
 {
diff -puN ipc/shm.c~move-the-ipc-namespace-under-ipc_ns-option ipc/shm.c
--- a/ipc/shm.c~move-the-ipc-namespace-under-ipc_ns-option
+++ a/ipc/shm.c
@@ -38,6 +38,7 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/mount.h>
+#include <linux/ipc_namespace.h>
 
 #include <asm/uaccess.h>
 
@@ -96,6 +97,7 @@ static void do_shm_rmid(struct ipc_names
 		shm_destroy(ns, shp);
 }
 
+#ifdef CONFIG_IPC_NS
 int shm_init_ns(struct ipc_namespace *ns)
 {
 	struct ipc_ids *ids;
@@ -133,6 +135,7 @@ void shm_exit_ns(struct ipc_namespace *n
 	kfree(ns->ids[IPC_SHM_IDS]);
 	ns->ids[IPC_SHM_IDS] = NULL;
 }
+#endif
 
 void __init shm_init (void)
 {
diff -puN ipc/util.c~move-the-ipc-namespace-under-ipc_ns-option ipc/util.c
--- a/ipc/util.c~move-the-ipc-namespace-under-ipc_ns-option
+++ a/ipc/util.c
@@ -33,6 +33,7 @@
 #include <linux/audit.h>
 #include <linux/nsproxy.h>
 #include <linux/rwsem.h>
+#include <linux/ipc_namespace.h>
 
 #include <asm/unistd.h>
 
@@ -51,66 +52,6 @@ struct ipc_namespace init_ipc_ns = {
 	},
 };
 
-static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
-{
-	int err;
-	struct ipc_namespace *ns;
-
-	err = -ENOMEM;
-	ns = kmalloc(sizeof(struct ipc_namespace), GFP_KERNEL);
-	if (ns == NULL)
-		goto err_mem;
-
-	err = sem_init_ns(ns);
-	if (err)
-		goto err_sem;
-	err = msg_init_ns(ns);
-	if (err)
-		goto err_msg;
-	err = shm_init_ns(ns);
-	if (err)
-		goto err_shm;
-
-	kref_init(&ns->kref);
-	return ns;
-
-err_shm:
-	msg_exit_ns(ns);
-err_msg:
-	sem_exit_ns(ns);
-err_sem:
-	kfree(ns);
-err_mem:
-	return ERR_PTR(err);
-}
-
-struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
-{
-	struct ipc_namespace *new_ns;
-
-	BUG_ON(!ns);
-	get_ipc_ns(ns);
-
-	if (!(flags & CLONE_NEWIPC))
-		return ns;
-
-	new_ns = clone_ipc_ns(ns);
-
-	put_ipc_ns(ns);
-	return new_ns;
-}
-
-void free_ipc_ns(struct kref *kref)
-{
-	struct ipc_namespace *ns;
-
-	ns = container_of(kref, struct ipc_namespace, kref);
-	sem_exit_ns(ns);
-	msg_exit_ns(ns);
-	shm_exit_ns(ns);
-	kfree(ns);
-}
-
 /**
  *	ipc_init	-	initialise IPC subsystem
  *
diff -puN ipc/util.h~move-the-ipc-namespace-under-ipc_ns-option ipc/util.h
--- a/ipc/util.h~move-the-ipc-namespace-under-ipc_ns-option
+++ a/ipc/util.h
@@ -20,6 +20,8 @@ void sem_init (void);
 void msg_init (void);
 void shm_init (void);
 
+struct ipc_namespace;
+
 int sem_init_ns(struct ipc_namespace *ns);
 int msg_init_ns(struct ipc_namespace *ns);
 int shm_init_ns(struct ipc_namespace *ns);
diff -puN kernel/nsproxy.c~move-the-ipc-namespace-under-ipc_ns-option kernel/nsproxy.c
--- a/kernel/nsproxy.c~move-the-ipc-namespace-under-ipc_ns-option
+++ a/kernel/nsproxy.c
@@ -21,6 +21,7 @@
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
+#include <linux/ipc_namespace.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
git-net.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
reiser4.patch
