From: akpm@linux-foundation.org
Subject: + fix-proc-net-breakage.patch added to -mm tree
Date: Tue, 27 Nov 2007 13:19:46 -0800
Message-ID: <200711272119.lARLJk5M030938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698AbXK0VUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 16:20:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, davem@davemloft.net, herbert@gondor.apana.org.au, pavel@ucw.cz, rjw@sisk.pl, xemul@openvz.org


The patch titled
     Fix /proc/net breakage
has been added to the -mm tree.  Its filename is
     fix-proc-net-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix /proc/net breakage
From: ebiederm@xmission.com (Eric W. Biederman)

Well I clearly goofed when I added the initial network namespace support
for /proc/net.  Currently things work but there are odd details visible to
user space, even when we have a single network namespace.

Since we do not cache proc_dir_entry dentries at the moment we can just
modify ->lookup to return a different directory inode depending on the
network namespace of the process looking at /proc/net, replacing the
current technique of using a magic and fragile follow_link method.

To accomplish that this patch:
- introduces a shadow_proc method to allow different dentries to
  be returned from proc_lookup.
- Removes the old /proc/net follow_link magic
- Fixes a weakness in our not caching of proc generic dentries.

As shadow_proc uses a task struct to decided which dentry to return we can
go back later and fix the proc generic caching without modifying any code
that uses the shadow_proc method.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   12 ++++-
 fs/proc/proc_net.c      |   86 ++------------------------------------
 include/linux/proc_fs.h |    3 +
 3 files changed, 19 insertions(+), 82 deletions(-)

diff -puN fs/proc/generic.c~fix-proc-net-breakage fs/proc/generic.c
--- a/fs/proc/generic.c~fix-proc-net-breakage
+++ a/fs/proc/generic.c
@@ -374,9 +374,16 @@ static int proc_delete_dentry(struct den
 	return 1;
 }
 
+static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
+{
+	d_drop(dentry);
+	return 0;
+}
+
 static struct dentry_operations proc_dentry_operations =
 {
 	.d_delete	= proc_delete_dentry,
+	.d_revalidate	= proc_revalidate_dentry,
 };
 
 /*
@@ -397,8 +404,11 @@ struct dentry *proc_lookup(struct inode 
 			if (de->namelen != dentry->d_name.len)
 				continue;
 			if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
-				unsigned int ino = de->low_ino;
+				unsigned int ino;
 
+				if (de->shadow_proc)
+					de = de->shadow_proc(current, de);
+				ino = de->low_ino;
 				de_get(de);
 				spin_unlock(&proc_subdir_lock);
 				error = -EINVAL;
diff -puN fs/proc/proc_net.c~fix-proc-net-breakage fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~fix-proc-net-breakage
+++ a/fs/proc/proc_net.c
@@ -88,89 +88,14 @@ struct net *get_proc_net(const struct in
 }
 EXPORT_SYMBOL_GPL(get_proc_net);
 
-static struct proc_dir_entry *proc_net_shadow;
+static struct proc_dir_entry *shadow_pde;
 
-static struct dentry *proc_net_shadow_dentry(struct dentry *parent,
+static struct proc_dir_entry *proc_net_shadow(struct task_struct *task,
 						struct proc_dir_entry *de)
 {
-	struct dentry *shadow = NULL;
-	struct inode *inode;
-	if (!de)
-		goto out;
-	de_get(de);
-	inode = proc_get_inode(parent->d_inode->i_sb, de->low_ino, de);
-	if (!inode)
-		goto out_de_put;
-	shadow = d_alloc_name(parent, de->name);
-	if (!shadow)
-		goto out_iput;
-	shadow->d_op = parent->d_op; /* proc_dentry_operations */
-	d_instantiate(shadow, inode);
-out:
-	return shadow;
-out_iput:
-	iput(inode);
-out_de_put:
-	de_put(de);
-	goto out;
-}
-
-static void *proc_net_follow_link(struct dentry *parent, struct nameidata *nd)
-{
-	struct net *net = current->nsproxy->net_ns;
-	struct dentry *shadow;
-	shadow = proc_net_shadow_dentry(parent, net->proc_net);
-	if (!shadow)
-		return ERR_PTR(-ENOENT);
-
-	dput(nd->dentry);
-	/* My dentry count is 1 and that should be enough as the
-	 * shadow dentry is thrown away immediately.
-	 */
-	nd->dentry = shadow;
-	return NULL;
+	return task->nsproxy->net_ns->proc_net;
 }
 
-static struct dentry *proc_net_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nd)
-{
-	struct net *net = current->nsproxy->net_ns;
-	struct dentry *shadow;
-
-	shadow = proc_net_shadow_dentry(nd->dentry, net->proc_net);
-	if (!shadow)
-		return ERR_PTR(-ENOENT);
-
-	dput(nd->dentry);
-	nd->dentry = shadow;
-
-	return shadow->d_inode->i_op->lookup(shadow->d_inode, dentry, nd);
-}
-
-static int proc_net_setattr(struct dentry *dentry, struct iattr *iattr)
-{
-	struct net *net = current->nsproxy->net_ns;
-	struct dentry *shadow;
-	int ret;
-
-	shadow = proc_net_shadow_dentry(dentry->d_parent, net->proc_net);
-	if (!shadow)
-		return -ENOENT;
-	ret = shadow->d_inode->i_op->setattr(shadow, iattr);
-	dput(shadow);
-	return ret;
-}
-
-static const struct file_operations proc_net_dir_operations = {
-	.read			= generic_read_dir,
-};
-
-static struct inode_operations proc_net_dir_inode_operations = {
-	.follow_link	= proc_net_follow_link,
-	.lookup		= proc_net_lookup,
-	.setattr	= proc_net_setattr,
-};
-
 static __net_init int proc_net_ns_init(struct net *net)
 {
 	struct proc_dir_entry *root, *netd, *net_statd;
@@ -223,9 +148,8 @@ static struct pernet_operations __net_in
 
 int __init proc_net_init(void)
 {
-	proc_net_shadow = proc_mkdir("net", NULL);
-	proc_net_shadow->proc_iops = &proc_net_dir_inode_operations;
-	proc_net_shadow->proc_fops = &proc_net_dir_operations;
+	shadow_pde = proc_mkdir("net", NULL);
+	shadow_pde->shadow_proc = proc_net_shadow;
 
 	return register_pernet_subsys(&proc_net_ns_ops);
 }
diff -puN include/linux/proc_fs.h~fix-proc-net-breakage include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~fix-proc-net-breakage
+++ a/include/linux/proc_fs.h
@@ -48,6 +48,8 @@ typedef	int (read_proc_t)(char *page, ch
 typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
 			   unsigned long count, void *data);
 typedef int (get_info_t)(char *, char **, off_t, int);
+typedef struct proc_dir_entry *(shadow_proc_t)(struct task_struct *task,
+						struct proc_dir_entry *pde);
 
 struct proc_dir_entry {
 	unsigned int low_ino;
@@ -79,6 +81,7 @@ struct proc_dir_entry {
 	int pde_users;	/* number of callers into module in progress */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	struct completion *pde_unload_completion;
+	shadow_proc_t *shadow_proc;
 };
 
 struct kcore_list {
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
the-namespaces-compatibility-list.patch
git-net.patch
msi-set-en-bit-of-msi-mapping-capability-on-ht-platform.patch
msi-set-en-bit-of-msi-mapping-capability-on-ht-platform-fix.patch
fix-proc-net-breakage.patch
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
