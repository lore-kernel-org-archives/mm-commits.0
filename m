From: akpm@linux-foundation.org
Subject: + sysctl-add-register_sysctl_paths-function.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:24:20 -0800
Message-ID: <200711300024.lAU0OKHP014876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761874AbXK3AZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, clg@fr.ibm.com, davem@davemloft.net, dlezcano@fr.ibm.com, herbert@gondor.apana.org.au, okir@suse.de, olaf@aepfle.de, serue@us.ibm.com, xemul@openvz.org


The patch titled
     sysctl: add register_sysctl_paths() function
has been added to the -mm tree.  Its filename is
     sysctl-add-register_sysctl_paths-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: add register_sysctl_paths() function
From: Eric W. Biederman <ebiederm@xmission.com>

Sysctl namespace support.

Currently the network namespace work has gotten about as far as we can without
the ability to make sysctls that are per network namespace.

The techniques we have been using for other namespace of examining current and
replacing the ctl_table.data field depending on the namespace instance that
current->nsproxy refers to are both ugly and do not work for the network
sysctls.

The case in handling the networking sysctls that does not work with the
existing ugly pointer munging techniques are directories like
/proc/sys/net/ipv4/conf/ and /proc/sys/net/ipv4/neigh/ whose contents vary
depending on the networking devices present in the network namespace.

Adding support to the sysctl infrastructure to allow to register a sysctl
table for a particular instance of a particular namespace removes the need for
magic sysctl methods, and allows the use of the techniques for managing
dynamic sysctl tables used for years in the network stack.



This patch:

There are a number of modules that register a sysctl table somewhere deeply
nested in the sysctl hierarchy, such as fs/nfs, fs/xfs, dev/cdrom, etc.

They all specify several dummy ctl_tables for the path name.  This patch
implements register_sysctl_path that takes an additional path name, and makes
up dummy sysctl nodes for each component.

This patch was originally written by Olaf Kirch and brought to my attention
and reworked some by Olaf Hering.  I have changed a few additional things so
the bugs are mine.

After converting all of the easy callers Olaf Hering observed allyesconfig
ARCH=i386, the patch reduces the final binary size by 9369 bytes.

.text +897
.data -7008

   text    data     bss     dec     hex filename
   26959310        4045899 4718592 35723801        2211a19 ../vmlinux-vanilla
   26960207        4038891 4718592 35717690        221023a ../O-allyesconfig/vmlinux

So this change is both a space savings and a code simplification.

Cc: Olaf Kirch <okir@suse.de>
Cc: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    9 +++
 kernel/sysctl.c        |   90 ++++++++++++++++++++++++++++++++-------
 2 files changed, 84 insertions(+), 15 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-add-register_sysctl_paths-function include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-register_sysctl_paths-function
+++ a/include/linux/sysctl.h
@@ -1059,7 +1059,16 @@ struct ctl_table_header
 	struct completion *unregistering;
 };
 
+/* struct ctl_path describes where in the hierarchy a table is added */
+struct ctl_path
+{
+	const char *procname;
+	int ctl_name;
+};
+
 struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
+struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
+						struct ctl_table *table);
 
 void unregister_sysctl_table(struct ctl_table_header * table);
 int sysctl_check_table(struct ctl_table *table);
diff -puN kernel/sysctl.c~sysctl-add-register_sysctl_paths-function kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-register_sysctl_paths-function
+++ a/kernel/sysctl.c
@@ -1490,11 +1490,12 @@ static __init int sysctl_init(void)
 core_initcall(sysctl_init);
 
 /**
- * register_sysctl_table - register a sysctl hierarchy
+ * register_sysctl_paths - register a sysctl hierarchy
+ * @path: The path to the directory the sysctl table is in.
  * @table: the top-level table structure
  *
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
- * array. An entry with a ctl_name of 0 terminates the table. 
+ * array. A completely 0 filled entry terminates the table.
  *
  * The members of the &struct ctl_table structure are used as follows:
  *
@@ -1557,27 +1558,79 @@ core_initcall(sysctl_init);
  * This routine returns %NULL on a failure to register, and a pointer
  * to the table header on success.
  */
-struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
+struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
+						struct ctl_table *table)
 {
-	struct ctl_table_header *tmp;
-	tmp = kmalloc(sizeof(struct ctl_table_header), GFP_KERNEL);
-	if (!tmp)
+	struct ctl_table_header *header;
+	struct ctl_table *new, **prevp;
+	unsigned int n, npath;
+
+	/* Count the path components */
+	for (npath = 0; path[npath].ctl_name || path[npath].procname; ++npath)
+		;
+
+	/*
+	 * For each path component, allocate a 2-element ctl_table array.
+	 * The first array element will be filled with the sysctl entry
+	 * for this, the second will be the sentinel (ctl_name == 0).
+	 *
+	 * We allocate everything in one go so that we don't have to
+	 * worry about freeing additional memory in unregister_sysctl_table.
+	 */
+	header = kzalloc(sizeof(struct ctl_table_header) +
+			 (2 * npath * sizeof(struct ctl_table)), GFP_KERNEL);
+	if (!header)
 		return NULL;
-	tmp->ctl_table = table;
-	INIT_LIST_HEAD(&tmp->ctl_entry);
-	tmp->used = 0;
-	tmp->unregistering = NULL;
-	sysctl_set_parent(NULL, table);
-	if (sysctl_check_table(tmp->ctl_table)) {
-		kfree(tmp);
+
+	new = (struct ctl_table *) (header + 1);
+
+	/* Now connect the dots */
+	prevp = &header->ctl_table;
+	for (n = 0; n < npath; ++n, ++path) {
+		/* Copy the procname */
+		new->procname = path->procname;
+		new->ctl_name = path->ctl_name;
+		new->mode     = 0555;
+
+		*prevp = new;
+		prevp = &new->child;
+
+		new += 2;
+	}
+	*prevp = table;
+
+	INIT_LIST_HEAD(&header->ctl_entry);
+	header->used = 0;
+	header->unregistering = NULL;
+	sysctl_set_parent(NULL, header->ctl_table);
+	if (sysctl_check_table(header->ctl_table)) {
+		kfree(header);
 		return NULL;
 	}
 	spin_lock(&sysctl_lock);
-	list_add_tail(&tmp->ctl_entry, &root_table_header.ctl_entry);
+	list_add_tail(&header->ctl_entry, &root_table_header.ctl_entry);
 	spin_unlock(&sysctl_lock);
-	return tmp;
+
+	return header;
+}
+
+/**
+ * register_sysctl_table - register a sysctl table hierarchy
+ * @table: the top-level table structure
+ *
+ * Register a sysctl table hierarchy. @table should be a filled in ctl_table
+ * array. A completely 0 filled entry terminates the table.
+ *
+ * See register_sysctl_paths for more details.
+ */
+struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
+{
+	static const struct ctl_path null_path[] = { {} };
+
+	return register_sysctl_paths(null_path, table);
 }
 
+
 /**
  * unregister_sysctl_table - unregister a sysctl table hierarchy
  * @header: the header returned from register_sysctl_table
@@ -1600,6 +1653,12 @@ struct ctl_table_header *register_sysctl
 	return NULL;
 }
 
+struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
+						    struct ctl_table *table)
+{
+	return NULL;
+}
+
 void unregister_sysctl_table(struct ctl_table_header * table)
 {
 }
@@ -2658,6 +2717,7 @@ EXPORT_SYMBOL(proc_dostring);
 EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
 EXPORT_SYMBOL(register_sysctl_table);
+EXPORT_SYMBOL(register_sysctl_paths);
 EXPORT_SYMBOL(sysctl_intvec);
 EXPORT_SYMBOL(sysctl_jiffies);
 EXPORT_SYMBOL(sysctl_ms_jiffies);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
the-namespaces-compatibility-list.patch
git-net.patch
sysctl-add-register_sysctl_paths-function.patch
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
