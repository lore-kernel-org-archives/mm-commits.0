From: akpm@linux-foundation.org
Subject: + sysctl-infrastructure-for-per-namespace-sysctls.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:28:56 -0800
Message-ID: <200711300028.lAU0SueI015061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761190AbXK3AaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:30:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, clg@fr.ibm.com, davem@davemloft.net, dlezcano@fr.ibm.com, herbert@gondor.apana.org.au, serue@us.ibm.com, xemul@openvz.org


The patch titled
     sysctl: infrastructure for per namespace sysctls
has been added to the -mm tree.  Its filename is
     sysctl-infrastructure-for-per-namespace-sysctls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: infrastructure for per namespace sysctls
From: Eric W. Biederman <ebiederm@xmission.com>

This patch implements the basic infrastructure for per namespace sysctls.

A list of lists of sysctl headers is added, allowing each namespace to have
it's own list of sysctl headers.

Each list of sysctl headers has a lookup function to find the first
sysctl header in the list, allowing the lists to have a per namespace
instance.

register_sysct_root is added to tell sysctl.c about additional
lists of sysctl_headers.  As all of the users are expected to be in
kernel no unregister function is provided.

sysctl_head_next is updated to walk through the list of lists.

__register_sysctl_paths is added to add a new sysctl table on
a non-default sysctl list.

The only intrusive part of this patch is propagating the information
to decided which list of sysctls to use for sysctl_check_table.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |   16 ++++++
 kernel/sysctl.c        |   93 ++++++++++++++++++++++++++++++++++-----
 kernel/sysctl_check.c  |   25 +++++-----
 3 files changed, 111 insertions(+), 23 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-infrastructure-for-per-namespace-sysctls include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-infrastructure-for-per-namespace-sysctls
+++ a/include/linux/sysctl.h
@@ -945,7 +945,9 @@ enum
 
 /* For the /proc/sys support */
 struct ctl_table;
+struct nsproxy;
 extern struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev);
+extern struct ctl_table_header *__sysctl_head_next(struct nsproxy *namespaces, struct ctl_table_header *prev);
 extern void sysctl_head_finish(struct ctl_table_header *prev);
 extern int sysctl_perm(struct ctl_table *table, int op);
 
@@ -1049,6 +1051,13 @@ struct ctl_table 
 	void *extra2;
 };
 
+struct ctl_table_root {
+	struct list_head root_list;
+	struct list_head header_list;
+	struct list_head *(*lookup)(struct ctl_table_root *root,
+					   struct nsproxy *namespaces);
+};
+
 /* struct ctl_table_header is used to maintain dynamic lists of
    struct ctl_table trees. */
 struct ctl_table_header
@@ -1058,6 +1067,7 @@ struct ctl_table_header
 	int used;
 	struct completion *unregistering;
 	struct ctl_table *ctl_table_arg;
+	struct ctl_table_root *root;
 };
 
 /* struct ctl_path describes where in the hierarchy a table is added */
@@ -1066,12 +1076,16 @@ struct ctl_path {
 	int ctl_name;
 };
 
+void register_sysctl_root(struct ctl_table_root *root);
+struct ctl_table_header *__register_sysctl_paths(
+	struct ctl_table_root *root, struct nsproxy *namespaces,
+	const struct ctl_path *path, struct ctl_table *table);
 struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
 struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 						struct ctl_table *table);
 
 void unregister_sysctl_table(struct ctl_table_header * table);
-int sysctl_check_table(struct ctl_table *table);
+int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table);
 
 #else /* __KERNEL__ */
 
diff -puN kernel/sysctl.c~sysctl-infrastructure-for-per-namespace-sysctls kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-infrastructure-for-per-namespace-sysctls
+++ a/kernel/sysctl.c
@@ -156,8 +156,16 @@ static int proc_dointvec_taint(struct ct
 #endif
 
 static struct ctl_table root_table[];
-static struct ctl_table_header root_table_header =
-	{ root_table, LIST_HEAD_INIT(root_table_header.ctl_entry) };
+static struct ctl_table_root sysctl_table_root;
+static struct ctl_table_header root_table_header = {
+	.ctl_table = root_table,
+	.ctl_entry = LIST_HEAD_INIT(sysctl_table_root.header_list),
+	.root = &sysctl_table_root,
+};
+static struct ctl_table_root sysctl_table_root = {
+	.root_list = LIST_HEAD_INIT(sysctl_table_root.root_list),
+	.header_list = LIST_HEAD_INIT(root_table_header.ctl_entry),
+};
 
 static struct ctl_table kern_table[];
 static struct ctl_table vm_table[];
@@ -1300,12 +1308,27 @@ void sysctl_head_finish(struct ctl_table
 	spin_unlock(&sysctl_lock);
 }
 
-struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev)
+static struct list_head *
+lookup_header_list(struct ctl_table_root *root, struct nsproxy *namespaces)
 {
+	struct list_head *header_list;
+	header_list = &root->header_list;
+	if (root->lookup)
+		header_list = root->lookup(root, namespaces);
+	return header_list;
+}
+
+struct ctl_table_header *__sysctl_head_next(struct nsproxy *namespaces,
+					    struct ctl_table_header *prev)
+{
+	struct ctl_table_root *root;
+	struct list_head *header_list;
 	struct ctl_table_header *head;
 	struct list_head *tmp;
+
 	spin_lock(&sysctl_lock);
 	if (prev) {
+		head = prev;
 		tmp = &prev->ctl_entry;
 		unuse_table(prev);
 		goto next;
@@ -1319,14 +1342,38 @@ struct ctl_table_header *sysctl_head_nex
 		spin_unlock(&sysctl_lock);
 		return head;
 	next:
+		root = head->root;
 		tmp = tmp->next;
-		if (tmp == &root_table_header.ctl_entry)
-			break;
+		header_list = lookup_header_list(root, namespaces);
+		if (tmp != header_list)
+			continue;
+
+		do {
+			root = list_entry(root->root_list.next,
+					struct ctl_table_root, root_list);
+			if (root == &sysctl_table_root)
+				goto out;
+			header_list = lookup_header_list(root, namespaces);
+		} while (list_empty(header_list));
+		tmp = header_list->next;
 	}
+out:
 	spin_unlock(&sysctl_lock);
 	return NULL;
 }
 
+struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev)
+{
+	return __sysctl_head_next(current->nsproxy, prev);
+}
+
+void register_sysctl_root(struct ctl_table_root *root)
+{
+	spin_lock(&sysctl_lock);
+	list_add_tail(&root->root_list, &sysctl_table_root.root_list);
+	spin_unlock(&sysctl_lock);
+}
+
 #ifdef CONFIG_SYSCTL_SYSCALL
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
@@ -1483,14 +1530,16 @@ static __init int sysctl_init(void)
 {
 	int err;
 	sysctl_set_parent(NULL, root_table);
-	err = sysctl_check_table(root_table);
+	err = sysctl_check_table(current->nsproxy, root_table);
 	return 0;
 }
 
 core_initcall(sysctl_init);
 
 /**
- * register_sysctl_paths - register a sysctl hierarchy
+ * __register_sysctl_paths - register a sysctl hierarchy
+ * @root: List of sysctl headers to register on
+ * @namespaces: Data to compute which lists of sysctl entries are visible
  * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
  *
@@ -1558,9 +1607,12 @@ core_initcall(sysctl_init);
  * This routine returns %NULL on a failure to register, and a pointer
  * to the table header on success.
  */
-struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
-						struct ctl_table *table)
+struct ctl_table_header *__register_sysctl_paths(
+	struct ctl_table_root *root,
+	struct nsproxy *namespaces,
+	const struct ctl_path *path, struct ctl_table *table)
 {
+	struct list_head *header_list;
 	struct ctl_table_header *header;
 	struct ctl_table *new, **prevp;
 	unsigned int n, npath;
@@ -1603,19 +1655,38 @@ struct ctl_table_header *register_sysctl
 	INIT_LIST_HEAD(&header->ctl_entry);
 	header->used = 0;
 	header->unregistering = NULL;
+	header->root = root;
 	sysctl_set_parent(NULL, header->ctl_table);
-	if (sysctl_check_table(header->ctl_table)) {
+	if (sysctl_check_table(namespaces, header->ctl_table)) {
 		kfree(header);
 		return NULL;
 	}
 	spin_lock(&sysctl_lock);
-	list_add_tail(&header->ctl_entry, &root_table_header.ctl_entry);
+	header_list = lookup_header_list(root, namespaces);
+	list_add_tail(&header->ctl_entry, header_list);
 	spin_unlock(&sysctl_lock);
 
 	return header;
 }
 
 /**
+ * register_sysctl_table_path - register a sysctl table hierarchy
+ * @path: The path to the directory the sysctl table is in.
+ * @table: the top-level table structure
+ *
+ * Register a sysctl table hierarchy. @table should be a filled in ctl_table
+ * array. A completely 0 filled entry terminates the table.
+ *
+ * See __register_sysctl_paths for more details.
+ */
+struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
+						struct ctl_table *table)
+{
+	return __register_sysctl_paths(&sysctl_table_root, current->nsproxy,
+					path, table);
+}
+
+/**
  * register_sysctl_table - register a sysctl table hierarchy
  * @table: the top-level table structure
  *
diff -puN kernel/sysctl_check.c~sysctl-infrastructure-for-per-namespace-sysctls kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-infrastructure-for-per-namespace-sysctls
+++ a/kernel/sysctl_check.c
@@ -1338,7 +1338,8 @@ static void sysctl_repair_table(struct c
 	}
 }
 
-static struct ctl_table *sysctl_check_lookup(struct ctl_table *table)
+static struct ctl_table *sysctl_check_lookup(struct nsproxy *namespaces,
+						struct ctl_table *table)
 {
 	struct ctl_table_header *head;
 	struct ctl_table *ref, *test;
@@ -1346,8 +1347,8 @@ static struct ctl_table *sysctl_check_lo
 
 	depth = sysctl_depth(table);
 
-	for (head = sysctl_head_next(NULL); head;
-	     head = sysctl_head_next(head)) {
+	for (head = __sysctl_head_next(namespaces, NULL); head;
+	     head = __sysctl_head_next(namespaces, head)) {
 		cur_depth = depth;
 		ref = head->ctl_table;
 repeat:
@@ -1392,13 +1393,14 @@ static void set_fail(const char **fail, 
 	*fail = str;
 }
 
-static int sysctl_check_dir(struct ctl_table *table)
+static int sysctl_check_dir(struct nsproxy *namespaces,
+				struct ctl_table *table)
 {
 	struct ctl_table *ref;
 	int error;
 
 	error = 0;
-	ref = sysctl_check_lookup(table);
+	ref = sysctl_check_lookup(namespaces, table);
 	if (ref) {
 		int match = 0;
 		if ((!table->procname && !ref->procname) ||
@@ -1423,11 +1425,12 @@ static int sysctl_check_dir(struct ctl_t
 	return error;
 }
 
-static void sysctl_check_leaf(struct ctl_table *table, const char **fail)
+static void sysctl_check_leaf(struct nsproxy *namespaces,
+				struct ctl_table *table, const char **fail)
 {
 	struct ctl_table *ref;
 
-	ref = sysctl_check_lookup(table);
+	ref = sysctl_check_lookup(namespaces, table);
 	if (ref && (ref != table))
 		set_fail(fail, table, "Sysctl already exists");
 }
@@ -1451,7 +1454,7 @@ static void sysctl_check_bin_path(struct
 	}
 }
 
-int sysctl_check_table(struct ctl_table *table)
+int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
 {
 	int error = 0;
 	for (; table->ctl_name || table->procname; table++) {
@@ -1481,7 +1484,7 @@ int sysctl_check_table(struct ctl_table 
 				set_fail(&fail, table, "Directory with extra1");
 			if (table->extra2)
 				set_fail(&fail, table, "Directory with extra2");
-			if (sysctl_check_dir(table))
+			if (sysctl_check_dir(namespaces, table))
 				set_fail(&fail, table, "Inconsistent directory names");
 		} else {
 			if ((table->strategy == sysctl_data) ||
@@ -1530,7 +1533,7 @@ int sysctl_check_table(struct ctl_table 
 			if (!table->procname && table->proc_handler)
 				set_fail(&fail, table, "proc_handler without procname");
 #endif
-			sysctl_check_leaf(table, &fail);
+			sysctl_check_leaf(namespaces, table, &fail);
 		}
 		sysctl_check_bin_path(table, &fail);
 		if (fail) {
@@ -1538,7 +1541,7 @@ int sysctl_check_table(struct ctl_table 
 			error = -EINVAL;
 		}
 		if (table->child)
-			error |= sysctl_check_table(table->child);
+			error |= sysctl_check_table(namespaces, table->child);
 	}
 	return error;
 }
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
the-namespaces-compatibility-list.patch
git-net.patch
sysctl-add-register_sysctl_paths-function.patch
sysctl-add-register_sysctl_paths-function-checkpatch-fixes.patch
sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths.patch
sysctl-infrastructure-for-per-namespace-sysctls.patch
net-implement-the-per-network-namespace-sysctl-infrastructure.patch
quirk-enable-msi-mapping-on-ht1000.patch
quirk-enable-msi-mapping-on-ht1000-v2.patch
fix-proc-net-breakage.patch
fix-proc-dcache-deadlock-in-do_exit.patch
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
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
