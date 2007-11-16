From: akpm@linux-foundation.org
Subject: + cleanup-the-code-managed-with-pid_ns-option.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:02:42 -0800
Message-ID: <200711160002.lAG02gNT022761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51968 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759565AbXKPADd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:03:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     namespaces: cleanup the code managed with PID_NS option
has been added to the -mm tree.  Its filename is
     cleanup-the-code-managed-with-pid_ns-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: namespaces: cleanup the code managed with PID_NS option
From: Pavel Emelyanov <xemul@openvz.org>

Just like with the user namespaces, move the namespace management code into
the separate .c file and mark the (already existing) PID_NS option as "depend
on NAMESPACES"

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h           |    2 
 include/linux/pid_namespace.h |    6 
 init/Kconfig                  |   24 +--
 kernel/Makefile               |    1 
 kernel/pid.c                  |  184 -----------------------------
 kernel/pid_namespace.c        |  197 ++++++++++++++++++++++++++++++++
 6 files changed, 220 insertions(+), 194 deletions(-)

diff -puN include/linux/pid.h~cleanup-the-code-managed-with-pid_ns-option include/linux/pid.h
--- a/include/linux/pid.h~cleanup-the-code-managed-with-pid_ns-option
+++ a/include/linux/pid.h
@@ -118,10 +118,10 @@ extern struct pid *find_pid(int nr);
  */
 extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
+int next_pidmap(struct pid_namespace *pid_ns, int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void FASTCALL(free_pid(struct pid *pid));
-extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 
 /*
  * the helpers to get the pid's id seen from different namespaces
diff -puN include/linux/pid_namespace.h~cleanup-the-code-managed-with-pid_ns-option include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~cleanup-the-code-managed-with-pid_ns-option
+++ a/include/linux/pid_namespace.h
@@ -39,6 +39,7 @@ static inline struct pid_namespace *get_
 
 extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
 extern void free_pid_ns(struct kref *kref);
+extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 
 static inline void put_pid_ns(struct pid_namespace *ns)
 {
@@ -66,6 +67,11 @@ static inline void put_pid_ns(struct pid
 {
 }
 
+
+static inline void zap_pid_ns_processes(struct pid_namespace *ns)
+{
+	BUG();
+}
 #endif /* CONFIG_PID_NS */
 
 static inline struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
diff -puN init/Kconfig~cleanup-the-code-managed-with-pid_ns-option init/Kconfig
--- a/init/Kconfig~cleanup-the-code-managed-with-pid_ns-option
+++ a/init/Kconfig
@@ -206,18 +206,6 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
-config PID_NS
-	bool "PID Namespaces (EXPERIMENTAL)"
-	default n
-	depends on EXPERIMENTAL
-	help
-	  Suport process id namespaces.  This allows having multiple
-	  process with the same pid as long as they are in different
-	  pid namespaces.  This is a building block of containers.
-
-	  Unless you want to work with an experimental feature
-	  say N here.
-
 config AUDIT
 	bool "Auditing support"
 	depends on NET
@@ -426,6 +414,18 @@ config USER_NS
 	  to provide different user info for different servers.
 	  If unsure, say N.
 
+config PID_NS
+	bool "PID Namespaces (EXPERIMENTAL)"
+	default n
+	depends on NAMESPACES && EXPERIMENTAL
+	help
+	  Suport process id namespaces.  This allows having multiple
+	  process with the same pid as long as they are in different
+	  pid namespaces.  This is a building block of containers.
+
+	  Unless you want to work with an experimental feature
+	  say N here.
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
diff -puN kernel/Makefile~cleanup-the-code-managed-with-pid_ns-option kernel/Makefile
--- a/kernel/Makefile~cleanup-the-code-managed-with-pid_ns-option
+++ a/kernel/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
+obj-$(CONFIG_PID_NS) += pid_namespace.o
 obj-$(CONFIG_SYSFS) += ksysfs.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
diff -puN kernel/pid.c~cleanup-the-code-managed-with-pid_ns-option kernel/pid.c
--- a/kernel/pid.c~cleanup-the-code-managed-with-pid_ns-option
+++ a/kernel/pid.c
@@ -41,7 +41,6 @@
 static struct hlist_head *pid_hash;
 static int pidhash_shift;
 struct pid init_struct_pid = INIT_STRUCT_PID;
-static struct kmem_cache *pid_ns_cachep;
 
 int pid_max = PID_MAX_DEFAULT;
 
@@ -181,7 +180,7 @@ static int alloc_pidmap(struct pid_names
 	return -1;
 }
 
-static int next_pidmap(struct pid_namespace *pid_ns, int last)
+int next_pidmap(struct pid_namespace *pid_ns, int last)
 {
 	int offset;
 	struct pidmap *map, *end;
@@ -487,180 +486,6 @@ struct pid *find_ge_pid(int nr, struct p
 }
 EXPORT_SYMBOL_GPL(find_get_pid);
 
-struct pid_cache {
-	int nr_ids;
-	char name[16];
-	struct kmem_cache *cachep;
-	struct list_head list;
-};
-
-static LIST_HEAD(pid_caches_lh);
-static DEFINE_MUTEX(pid_caches_mutex);
-
-/*
- * creates the kmem cache to allocate pids from.
- * @nr_ids: the number of numerical ids this pid will have to carry
- */
-
-static struct kmem_cache *create_pid_cachep(int nr_ids)
-{
-	struct pid_cache *pcache;
-	struct kmem_cache *cachep;
-
-	mutex_lock(&pid_caches_mutex);
-	list_for_each_entry (pcache, &pid_caches_lh, list)
-		if (pcache->nr_ids == nr_ids)
-			goto out;
-
-	pcache = kmalloc(sizeof(struct pid_cache), GFP_KERNEL);
-	if (pcache == NULL)
-		goto err_alloc;
-
-	snprintf(pcache->name, sizeof(pcache->name), "pid_%d", nr_ids);
-	cachep = kmem_cache_create(pcache->name,
-			sizeof(struct pid) + (nr_ids - 1) * sizeof(struct upid),
-			0, SLAB_HWCACHE_ALIGN, NULL);
-	if (cachep == NULL)
-		goto err_cachep;
-
-	pcache->nr_ids = nr_ids;
-	pcache->cachep = cachep;
-	list_add(&pcache->list, &pid_caches_lh);
-out:
-	mutex_unlock(&pid_caches_mutex);
-	return pcache->cachep;
-
-err_cachep:
-	kfree(pcache);
-err_alloc:
-	mutex_unlock(&pid_caches_mutex);
-	return NULL;
-}
-
-#ifdef CONFIG_PID_NS
-static struct pid_namespace *create_pid_namespace(int level)
-{
-	struct pid_namespace *ns;
-	int i;
-
-	ns = kmem_cache_alloc(pid_ns_cachep, GFP_KERNEL);
-	if (ns == NULL)
-		goto out;
-
-	ns->pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!ns->pidmap[0].page)
-		goto out_free;
-
-	ns->pid_cachep = create_pid_cachep(level + 1);
-	if (ns->pid_cachep == NULL)
-		goto out_free_map;
-
-	kref_init(&ns->kref);
-	ns->last_pid = 0;
-	ns->child_reaper = NULL;
-	ns->level = level;
-
-	set_bit(0, ns->pidmap[0].page);
-	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
-
-	for (i = 1; i < PIDMAP_ENTRIES; i++) {
-		ns->pidmap[i].page = 0;
-		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
-	}
-
-	return ns;
-
-out_free_map:
-	kfree(ns->pidmap[0].page);
-out_free:
-	kmem_cache_free(pid_ns_cachep, ns);
-out:
-	return ERR_PTR(-ENOMEM);
-}
-
-static void destroy_pid_namespace(struct pid_namespace *ns)
-{
-	int i;
-
-	for (i = 0; i < PIDMAP_ENTRIES; i++)
-		kfree(ns->pidmap[i].page);
-	kmem_cache_free(pid_ns_cachep, ns);
-}
-
-struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
-{
-	struct pid_namespace *new_ns;
-
-	BUG_ON(!old_ns);
-	new_ns = get_pid_ns(old_ns);
-	if (!(flags & CLONE_NEWPID))
-		goto out;
-
-	new_ns = ERR_PTR(-EINVAL);
-	if (flags & CLONE_THREAD)
-		goto out_put;
-
-	new_ns = create_pid_namespace(old_ns->level + 1);
-	if (!IS_ERR(new_ns))
-		new_ns->parent = get_pid_ns(old_ns);
-
-out_put:
-	put_pid_ns(old_ns);
-out:
-	return new_ns;
-}
-
-void free_pid_ns(struct kref *kref)
-{
-	struct pid_namespace *ns, *parent;
-
-	ns = container_of(kref, struct pid_namespace, kref);
-
-	parent = ns->parent;
-	destroy_pid_namespace(ns);
-
-	if (parent != NULL)
-		put_pid_ns(parent);
-}
-#endif /* CONFIG_PID_NS */
-
-void zap_pid_ns_processes(struct pid_namespace *pid_ns)
-{
-	int nr;
-	int rc;
-
-	/*
-	 * The last thread in the cgroup-init thread group is terminating.
-	 * Find remaining pid_ts in the namespace, signal and wait for them
-	 * to exit.
-	 *
-	 * Note:  This signals each threads in the namespace - even those that
-	 * 	  belong to the same thread group, To avoid this, we would have
-	 * 	  to walk the entire tasklist looking a processes in this
-	 * 	  namespace, but that could be unnecessarily expensive if the
-	 * 	  pid namespace has just a few processes. Or we need to
-	 * 	  maintain a tasklist for each pid namespace.
-	 *
-	 */
-	read_lock(&tasklist_lock);
-	nr = next_pidmap(pid_ns, 1);
-	while (nr > 0) {
-		kill_proc_info(SIGKILL, SEND_SIG_PRIV, nr);
-		nr = next_pidmap(pid_ns, nr);
-	}
-	read_unlock(&tasklist_lock);
-
-	do {
-		clear_thread_flag(TIF_SIGPENDING);
-		rc = sys_wait4(-1, NULL, __WALL, NULL);
-	} while (rc != -ECHILD);
-
-
-	/* Child reaper for the pid namespace is going away */
-	pid_ns->child_reaper = NULL;
-	return;
-}
-
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
@@ -693,9 +518,6 @@ void __init pidmap_init(void)
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
 
-	init_pid_ns.pid_cachep = create_pid_cachep(1);
-	if (init_pid_ns.pid_cachep == NULL)
-		panic("Can't create pid_1 cachep\n");
-
-	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
+	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
+			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
 }
diff -puN /dev/null kernel/pid_namespace.c
--- /dev/null
+++ a/kernel/pid_namespace.c
@@ -0,0 +1,197 @@
+/*
+ * Pid namespaces
+ *
+ * Authors:
+ *    (C) 2007 Pavel Emelyanov <xemul@openvz.org>, OpenVZ, SWsoft Inc.
+ *    (C) 2007 Sukadev Bhattiprolu <sukadev@us.ibm.com>, IBM
+ *     Many thanks to Oleg Nesterov for comments and help
+ *
+ */
+
+#include <linux/pid.h>
+#include <linux/pid_namespace.h>
+#include <linux/syscalls.h>
+#include <linux/err.h>
+
+#define BITS_PER_PAGE		(PAGE_SIZE*8)
+
+struct pid_cache {
+	int nr_ids;
+	char name[16];
+	struct kmem_cache *cachep;
+	struct list_head list;
+};
+
+static LIST_HEAD(pid_caches_lh);
+static DEFINE_MUTEX(pid_caches_mutex);
+static struct kmem_cache *pid_ns_cachep;
+
+/*
+ * creates the kmem cache to allocate pids from.
+ * @nr_ids: the number of numerical ids this pid will have to carry
+ */
+
+static struct kmem_cache *create_pid_cachep(int nr_ids)
+{
+	struct pid_cache *pcache;
+	struct kmem_cache *cachep;
+
+	mutex_lock(&pid_caches_mutex);
+	list_for_each_entry (pcache, &pid_caches_lh, list)
+		if (pcache->nr_ids == nr_ids)
+			goto out;
+
+	pcache = kmalloc(sizeof(struct pid_cache), GFP_KERNEL);
+	if (pcache == NULL)
+		goto err_alloc;
+
+	snprintf(pcache->name, sizeof(pcache->name), "pid_%d", nr_ids);
+	cachep = kmem_cache_create(pcache->name,
+			sizeof(struct pid) + (nr_ids - 1) * sizeof(struct upid),
+			0, SLAB_HWCACHE_ALIGN, NULL);
+	if (cachep == NULL)
+		goto err_cachep;
+
+	pcache->nr_ids = nr_ids;
+	pcache->cachep = cachep;
+	list_add(&pcache->list, &pid_caches_lh);
+out:
+	mutex_unlock(&pid_caches_mutex);
+	return pcache->cachep;
+
+err_cachep:
+	kfree(pcache);
+err_alloc:
+	mutex_unlock(&pid_caches_mutex);
+	return NULL;
+}
+
+static struct pid_namespace *create_pid_namespace(int level)
+{
+	struct pid_namespace *ns;
+	int i;
+
+	ns = kmem_cache_alloc(pid_ns_cachep, GFP_KERNEL);
+	if (ns == NULL)
+		goto out;
+
+	ns->pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!ns->pidmap[0].page)
+		goto out_free;
+
+	ns->pid_cachep = create_pid_cachep(level + 1);
+	if (ns->pid_cachep == NULL)
+		goto out_free_map;
+
+	kref_init(&ns->kref);
+	ns->last_pid = 0;
+	ns->child_reaper = NULL;
+	ns->level = level;
+
+	set_bit(0, ns->pidmap[0].page);
+	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
+
+	for (i = 1; i < PIDMAP_ENTRIES; i++) {
+		ns->pidmap[i].page = 0;
+		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
+	}
+
+	return ns;
+
+out_free_map:
+	kfree(ns->pidmap[0].page);
+out_free:
+	kmem_cache_free(pid_ns_cachep, ns);
+out:
+	return ERR_PTR(-ENOMEM);
+}
+
+static void destroy_pid_namespace(struct pid_namespace *ns)
+{
+	int i;
+
+	for (i = 0; i < PIDMAP_ENTRIES; i++)
+		kfree(ns->pidmap[i].page);
+	kmem_cache_free(pid_ns_cachep, ns);
+}
+
+struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
+{
+	struct pid_namespace *new_ns;
+
+	BUG_ON(!old_ns);
+	new_ns = get_pid_ns(old_ns);
+	if (!(flags & CLONE_NEWPID))
+		goto out;
+
+	new_ns = ERR_PTR(-EINVAL);
+	if (flags & CLONE_THREAD)
+		goto out_put;
+
+	new_ns = create_pid_namespace(old_ns->level + 1);
+	if (!IS_ERR(new_ns))
+		new_ns->parent = get_pid_ns(old_ns);
+
+out_put:
+	put_pid_ns(old_ns);
+out:
+	return new_ns;
+}
+
+void free_pid_ns(struct kref *kref)
+{
+	struct pid_namespace *ns, *parent;
+
+	ns = container_of(kref, struct pid_namespace, kref);
+
+	parent = ns->parent;
+	destroy_pid_namespace(ns);
+
+	if (parent != NULL)
+		put_pid_ns(parent);
+}
+
+void zap_pid_ns_processes(struct pid_namespace *pid_ns)
+{
+	int nr;
+	int rc;
+
+	/*
+	 * The last thread in the cgroup-init thread group is terminating.
+	 * Find remaining pid_ts in the namespace, signal and wait for them
+	 * to exit.
+	 *
+	 * Note:  This signals each threads in the namespace - even those that
+	 * 	  belong to the same thread group, To avoid this, we would have
+	 * 	  to walk the entire tasklist looking a processes in this
+	 * 	  namespace, but that could be unnecessarily expensive if the
+	 * 	  pid namespace has just a few processes. Or we need to
+	 * 	  maintain a tasklist for each pid namespace.
+	 *
+	 */
+	read_lock(&tasklist_lock);
+	nr = next_pidmap(pid_ns, 1);
+	while (nr > 0) {
+		kill_proc_info(SIGKILL, SEND_SIG_PRIV, nr);
+		nr = next_pidmap(pid_ns, nr);
+	}
+	read_unlock(&tasklist_lock);
+
+	do {
+		clear_thread_flag(TIF_SIGPENDING);
+		rc = sys_wait4(-1, NULL, __WALL, NULL);
+	} while (rc != -ECHILD);
+
+
+	/* Child reaper for the pid namespace is going away */
+	pid_ns->child_reaper = NULL;
+	return;
+}
+
+static __init int pid_namespaces_init(void)
+{
+	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
+	return 0;
+}
+
+__initcall(pid_namespaces_init);
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
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
reiser4.patch
