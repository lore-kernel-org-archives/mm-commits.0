From: akpm@osdl.org
Subject: + sysctl-reimplement-the-sysctl-proc-support.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:13:55 -0800
Message-ID: <200701240313.l0O3Dt74006997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49263 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030212AbXAXDN7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     sysctl: reimplement the sysctl proc support
has been added to the -mm tree.  Its filename is
     sysctl-reimplement-the-sysctl-proc-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: reimplement the sysctl proc support
From: Eric W. Biederman <ebiederm@xmission.com>

With this change the sysctl inodes can be cached and nothing needs to be done
when removing a sysctl table.

For a costk of 2K code we will save about 4K of static tables (when we remove
de from ctl_table) and 70K in proc_dir_entries that we will not allocate, or
about half that on a 32bit arch.

The speed feels about the same, even though we can now cache the sysctl
dentries :(

We get the core advantage that we don't need to have a 1 to 1 mapping between
ctl table entries and proc files.  Making it possible to have /proc/sys vary
depending on the namespace you are in.  The currently merged namespaces don't
have an issue here but the network namespace under /proc/sys/net needs to have
different directories depending on which network adapters are visible.  By
simply being a cache different directories being visible depending on who you
are is trivial to implement.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/Makefile      |    2 
 fs/proc/inode.c       |    1 
 fs/proc/internal.h    |    2 
 fs/proc/proc_sysctl.c |  477 ++++++++++++++++++++++++++++++++++++++++
 fs/proc/root.c        |   10 
 init/main.c           |    4 
 kernel/sysctl.c       |  182 ---------------
 7 files changed, 484 insertions(+), 194 deletions(-)

diff -puN fs/proc/Makefile~sysctl-reimplement-the-sysctl-proc-support fs/proc/Makefile
--- a/fs/proc/Makefile~sysctl-reimplement-the-sysctl-proc-support
+++ a/fs/proc/Makefile
@@ -8,7 +8,7 @@ proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
-		proc_tty.o proc_misc.o
+		proc_tty.o proc_misc.o proc_sysctl.o
 
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
 proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
diff -puN fs/proc/inode.c~sysctl-reimplement-the-sysctl-proc-support fs/proc/inode.c
--- a/fs/proc/inode.c~sysctl-reimplement-the-sysctl-proc-support
+++ a/fs/proc/inode.c
@@ -154,6 +154,7 @@ struct inode *proc_get_inode(struct supe
 	if (!inode)
 		goto out_ino;
 
+	PROC_I(inode)->fd = 0;
 	PROC_I(inode)->pde = de;
 	if (de) {
 		if (de->mode) {
diff -puN fs/proc/internal.h~sysctl-reimplement-the-sysctl-proc-support fs/proc/internal.h
--- a/fs/proc/internal.h~sysctl-reimplement-the-sysctl-proc-support
+++ a/fs/proc/internal.h
@@ -11,6 +11,8 @@
 
 #include <linux/proc_fs.h>
 
+extern int proc_sys_init(void);
+
 struct vmalloc_info {
 	unsigned long	used;
 	unsigned long	largest_chunk;
diff -puN /dev/null fs/proc/proc_sysctl.c
--- /dev/null
+++ a/fs/proc/proc_sysctl.c
@@ -0,0 +1,477 @@
+/*
+ * /proc/sys support
+ */
+
+#include <linux/sysctl.h>
+#include <linux/proc_fs.h>
+#include <linux/security.h>
+#include "internal.h"
+
+static struct dentry_operations proc_sys_dentry_operations;
+static const struct file_operations proc_sys_file_operations;
+static struct inode_operations proc_sys_inode_operations;
+
+static void proc_sys_refresh_inode(struct inode *inode, struct ctl_table *table)
+{
+	/* Refresh the cached information bits in the inode */
+	if (table) {
+		inode->i_uid = 0;
+		inode->i_gid = 0;
+		inode->i_mode = table->mode;
+		if (table->proc_handler) {
+			inode->i_mode |= S_IFREG;
+			inode->i_nlink = 1;
+		} else {
+			inode->i_mode |= S_IFDIR;
+			inode->i_nlink = 0;	/* It is too hard to figure out */
+		}
+	}
+}
+
+static struct inode *proc_sys_make_inode(struct inode *dir, struct ctl_table *table)
+{
+	struct inode *inode;
+	struct proc_inode *dir_ei, *ei;
+	int depth;
+
+	inode = new_inode(dir->i_sb);
+	if (!inode)
+		goto out;
+
+	/* A directory is always one deeper than it's parent */
+	dir_ei = PROC_I(dir);
+	depth = dir_ei->fd + 1;
+
+	ei = PROC_I(inode);
+	ei->fd = depth;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	inode->i_op = &proc_sys_inode_operations;
+	inode->i_fop = &proc_sys_file_operations;
+	proc_sys_refresh_inode(inode, table);
+out:
+	return inode;
+}
+
+static struct dentry *proc_sys_ancestor(struct dentry *dentry, int depth)
+{
+	for (;;) {
+		struct proc_inode *ei;
+
+		ei = PROC_I(dentry->d_inode);
+		if (ei->fd == depth)
+			break; /* found */
+
+		dentry = dentry->d_parent;
+	}
+	return dentry;
+}
+
+static struct ctl_table *proc_sys_lookup_table_one(struct ctl_table *table,
+							struct qstr *name)
+{
+	int len;
+	for ( ; table->ctl_name || table->procname; table++) {
+
+		if (!table->procname)
+			continue;
+
+		len = strlen(table->procname);
+		if (len != name->len)
+			continue;
+
+		if (memcmp(table->procname, name->name, len) != 0)
+			continue;
+
+		/* I have a match */
+		return table;
+	}
+	return NULL;
+}
+
+static struct ctl_table *proc_sys_lookup_table(struct dentry *dentry,
+						struct ctl_table *table)
+{
+	struct dentry *ancestor;
+	struct proc_inode *ei;
+	int depth, i;
+
+	ei = PROC_I(dentry->d_inode);
+	depth = ei->fd;
+
+	if (depth == 0)
+		return table;
+
+	for (i = 1; table && (i <= depth); i++) {
+		ancestor = proc_sys_ancestor(dentry, i);
+		table = proc_sys_lookup_table_one(table, &ancestor->d_name);
+		if (table)
+			table = table->child;
+	}
+	return table;
+
+}
+static struct ctl_table *proc_sys_lookup_entry(struct dentry *dparent,
+						struct qstr *name,
+						struct ctl_table *table)
+{
+	table = proc_sys_lookup_table(dparent, table);
+	if (table)
+		table = proc_sys_lookup_table_one(table, name);
+	return table;
+}
+
+static struct ctl_table *do_proc_sys_lookup(struct dentry *parent,
+						struct qstr *name,
+						struct ctl_table_header **ptr)
+{
+	struct ctl_table_header *head;
+	struct ctl_table *table;
+
+	for (head = sysctl_head_next(NULL); head; head = sysctl_head_next(head)) {
+		table = proc_sys_lookup_entry(parent, name, head->ctl_table);
+		if (table)
+			break;
+	}
+	*ptr = head;
+	return table;
+}
+
+static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
+					struct nameidata *nd)
+{
+	struct ctl_table_header *head;
+	struct inode *inode;
+	struct dentry *err;
+	struct ctl_table *table;
+
+	err = ERR_PTR(-ENOENT);
+	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
+	if (!table)
+		goto out;
+
+	err = ERR_PTR(-ENOMEM);
+	inode = proc_sys_make_inode(dir, table);
+	if (!inode)
+		goto out;
+
+	err = NULL;
+	dentry->d_op = &proc_sys_dentry_operations;
+	d_add(dentry, inode);
+
+out:
+	sysctl_head_finish(head);
+	return err;
+}
+
+static ssize_t proc_sys_read(struct file *filp, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct dentry *dentry = filp->f_dentry;
+	struct ctl_table_header *head;
+	struct ctl_table *table;
+	ssize_t error, res;
+
+	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
+	/* Has the sysctl entry disappeared on us? */
+	error = -ENOENT;
+	if (!table)
+		goto out;
+
+	/* Has the sysctl entry been replaced by a directory? */
+	error = -EISDIR;
+	if (!table->proc_handler)
+		goto out;
+
+	/*
+	 * At this point we know that the sysctl was not unregistered
+	 * and won't be until we finish.
+	 */
+	error = -EPERM;
+	if (sysctl_perm(table, MAY_READ))
+		goto out;
+
+	/* careful: calling conventions are nasty here */
+	res = count;
+	error = table->proc_handler(table, 0, filp, buf, &res, ppos);
+	if (!error)
+		error = res;
+out:
+	sysctl_head_finish(head);
+
+	return error;
+}
+
+static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct dentry *dentry = filp->f_dentry;
+	struct ctl_table_header *head;
+	struct ctl_table *table;
+	ssize_t error, res;
+
+	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
+	/* Has the sysctl entry disappeared on us? */
+	error = -ENOENT;
+	if (!table)
+		goto out;
+
+	/* Has the sysctl entry been replaced by a directory? */
+	error = -EISDIR;
+	if (!table->proc_handler)
+		goto out;
+
+	/*
+	 * At this point we know that the sysctl was not unregistered
+	 * and won't be until we finish.
+	 */
+	error = -EPERM;
+	if (sysctl_perm(table, MAY_WRITE))
+		goto out;
+
+	/* careful: calling conventions are nasty here */
+	res = count;
+	error = table->proc_handler(table, 1, filp, buf, &res, ppos);
+	if (!error)
+		error = res;
+out:
+	sysctl_head_finish(head);
+
+	return error;
+}
+
+
+static int proc_sys_fill_cache(struct file *filp, void *dirent,
+				filldir_t filldir, struct ctl_table *table)
+{
+	struct ctl_table_header *head;
+	struct ctl_table *child_table = NULL;
+	struct dentry *child, *dir = filp->f_path.dentry;
+	struct inode *inode;
+	struct qstr qname;
+	ino_t ino = 0;
+	unsigned type = DT_UNKNOWN;
+	int ret;
+
+	qname.name = table->procname;
+	qname.len  = strlen(table->procname);
+	qname.hash = full_name_hash(qname.name, qname.len);
+
+	/* Suppress duplicates.
+	 * Only fill a directory entry if it is the value that
+	 * an ordinary lookup of that name returns.  Hide all
+	 * others.
+	 *
+	 * If we ever cache this translation in the dcache
+	 * I should do a dcache lookup first.  But for now
+	 * it is just simpler not to.
+	 */
+	ret = 0;
+	child_table = do_proc_sys_lookup(dir, &qname, &head);
+	sysctl_head_finish(head);
+	if (child_table != table)
+		return 0;
+
+	child = d_lookup(dir, &qname);
+	if (!child) {
+		struct dentry *new;
+		new = d_alloc(dir, &qname);
+		if (new) {
+			inode = proc_sys_make_inode(dir->d_inode, table);
+			if (!inode)
+				child = ERR_PTR(-ENOMEM);
+			else {
+				new->d_op = &proc_sys_dentry_operations;
+				d_add(new, inode);
+			}
+			if (child)
+				dput(new);
+			else
+				child = new;
+		}
+	}
+	if (!child || IS_ERR(child) || !child->d_inode)
+		goto end_instantiate;
+	inode = child->d_inode;
+	if (inode) {
+		ino  = inode->i_ino;
+		type = inode->i_mode >> 12;
+	}
+	dput(child);
+end_instantiate:
+	if (!ino)
+		ino= find_inode_number(dir, &qname);
+	if (!ino)
+		ino = 1;
+	return filldir(dirent, qname.name, qname.len, filp->f_pos, ino, type);
+}
+
+static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct dentry *dentry = filp->f_dentry;
+	struct inode *inode = dentry->d_inode;
+	struct ctl_table_header *head = NULL;
+	struct ctl_table *table;
+	unsigned long pos;
+	int ret;
+
+	ret = -ENOTDIR;
+	if (!S_ISDIR(inode->i_mode))
+		goto out;
+
+	ret = 0;
+	switch(filp->f_pos) {
+	case 0:
+		if (filldir(dirent, ".", 1, filp->f_pos, inode->i_ino, DT_DIR) < 0)
+			goto out;
+		filp->f_pos++;
+		/* fall through */
+	case 1:
+		if (filldir(dirent, "..", 2, filp->f_pos, parent_ino(dentry), DT_DIR) < 0)
+			goto out;
+		filp->f_pos++;
+		/* fall through */
+	default:
+		pos = 2;
+		break;
+	}
+
+	/* - Find each instance of the directory
+	 * - Read all entries in each instance
+	 * - Before returning an entry to user space lookup the entry
+	 *   by name and if I find a different entry don't return
+	 *   this one because it means it is a buried dup.
+	 * For sysctl this should only happen for directory entries.
+	 */
+	for (head = sysctl_head_next(NULL); head; head = sysctl_head_next(head)) {
+		table = proc_sys_lookup_table(dentry, head->ctl_table);
+
+		if (!table)
+			continue;
+
+		for (; table->ctl_name || table->procname; table++, pos++) {
+			/* Can't do anything without a proc name */
+			if (!table->procname)
+				continue;
+
+			if (pos < filp->f_pos)
+				continue;
+
+			if (proc_sys_fill_cache(filp, dirent, filldir, table) < 0)
+				goto out;
+			filp->f_pos = pos + 1;
+		}
+	}
+	ret = 1;
+out:
+	sysctl_head_finish(head);
+	return ret;
+}
+
+static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	/*
+	 * sysctl entries that are not writeable,
+	 * are _NOT_ writeable, capabilities or not.
+	 */
+	struct ctl_table_header *head;
+	struct ctl_table *table;
+	struct dentry *dentry;
+	int mode;
+	int depth;
+	int error;
+
+	head = NULL;
+	depth = PROC_I(inode)->fd;
+
+	/* First check the cached permissions, in case we don't have
+	 * enough information to lookup the sysctl table entry.
+	 */
+	error = -EACCES;
+	mode = inode->i_mode;
+
+	if (current->euid == 0)
+		mode >>= 6;
+	else if (in_group_p(0))
+		mode >>= 3;
+
+	if ((mode & mask & (MAY_READ|MAY_WRITE|MAY_EXEC)) == mask)
+		error = 0;
+
+	/* If we can't get a sysctl table entry the permission
+	 * checks on the cached mode will have to be enough.
+	 */
+	if (!nd || !depth)
+		goto out;
+
+	dentry = nd->dentry;
+	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
+
+	/* If the entry does not exist deny permission */
+	error = -EACCES;
+	if (!table)
+		goto out;
+
+	/* Use the permissions on the sysctl table entry */
+	error = sysctl_perm(table, mask);
+out:
+	sysctl_head_finish(head);
+	return error;
+}
+
+static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	if (attr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
+		return -EPERM;
+
+	error = inode_change_ok(inode, attr);
+	if (!error) {
+		error = security_inode_setattr(dentry, attr);
+		if (!error)
+			error = inode_setattr(inode, attr);
+	}
+
+	return error;
+}
+
+/* I'm lazy and don't distinguish between files and directories,
+ * until access time.
+ */
+static const struct file_operations proc_sys_file_operations = {
+	.read		= proc_sys_read,
+	.write		= proc_sys_write,
+	.readdir	= proc_sys_readdir,
+};
+
+static struct inode_operations proc_sys_inode_operations = {
+	.lookup		= proc_sys_lookup,
+	.permission	= proc_sys_permission,
+	.setattr	= proc_sys_setattr,
+};
+
+static int proc_sys_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	struct ctl_table_header *head;
+	struct ctl_table *table;
+	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
+	proc_sys_refresh_inode(dentry->d_inode, table);
+	sysctl_head_finish(head);
+	return !!table;
+}
+
+static struct dentry_operations proc_sys_dentry_operations = {
+	.d_revalidate	= proc_sys_revalidate,
+};
+
+struct proc_dir_entry *proc_sys_root;
+
+int proc_sys_init(void)
+{
+	proc_sys_root = proc_mkdir("sys", NULL);
+	proc_sys_root->proc_iops = &proc_sys_inode_operations;
+	proc_sys_root->proc_fops = &proc_sys_file_operations;
+	proc_sys_root->nlink = 0;
+	return 0;
+}
diff -puN fs/proc/root.c~sysctl-reimplement-the-sysctl-proc-support fs/proc/root.c
--- a/fs/proc/root.c~sysctl-reimplement-the-sysctl-proc-support
+++ a/fs/proc/root.c
@@ -23,10 +23,6 @@
 
 struct proc_dir_entry *proc_net, *proc_net_stat, *proc_bus, *proc_root_fs, *proc_root_driver;
 
-#ifdef CONFIG_SYSCTL
-struct proc_dir_entry *proc_sys_root;
-#endif
-
 static int proc_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
@@ -71,9 +67,6 @@ void __init proc_root_init(void)
 #ifdef CONFIG_SYSVIPC
 	proc_mkdir("sysvipc", NULL);
 #endif
-#ifdef CONFIG_SYSCTL
-	proc_sys_root = proc_mkdir("sys", NULL);
-#endif
 	proc_root_fs = proc_mkdir("fs", NULL);
 	proc_root_driver = proc_mkdir("driver", NULL);
 	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
@@ -86,6 +79,9 @@ void __init proc_root_init(void)
 	proc_device_tree_init();
 #endif
 	proc_bus = proc_mkdir("bus", NULL);
+#ifdef CONFIG_SYSCTL
+	proc_sys_init();
+#endif
 }
 
 static int proc_root_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat
diff -puN init/main.c~sysctl-reimplement-the-sysctl-proc-support init/main.c
--- a/init/main.c~sysctl-reimplement-the-sysctl-proc-support
+++ a/init/main.c
@@ -87,7 +87,6 @@ extern void init_IRQ(void);
 extern void fork_init(unsigned long);
 extern void mca_init(void);
 extern void sbus_init(void);
-extern void sysctl_init(void);
 extern void signals_init(void);
 extern void pidhash_init(void);
 extern void pidmap_init(void);
@@ -690,9 +689,6 @@ static void __init do_basic_setup(void)
 	usermodehelper_init();
 	driver_init();
 
-#ifdef CONFIG_SYSCTL
-	sysctl_init();
-#endif
 #ifdef CONFIG_PROC_FS
 	init_irq_proc();
 #endif
diff -puN kernel/sysctl.c~sysctl-reimplement-the-sysctl-proc-support kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-reimplement-the-sysctl-proc-support
+++ a/kernel/sysctl.c
@@ -168,26 +168,6 @@ int sysctl_legacy_va_layout;
 
 
 
-/* /proc declarations: */
-
-#ifdef CONFIG_PROC_SYSCTL
-
-static ssize_t proc_readsys(struct file *, char __user *, size_t, loff_t *);
-static ssize_t proc_writesys(struct file *, const char __user *, size_t, loff_t *);
-static int proc_opensys(struct inode *, struct file *);
-
-const struct file_operations proc_sys_file_operations = {
-	.open		= proc_opensys,
-	.read		= proc_readsys,
-	.write		= proc_writesys,
-};
-
-extern struct proc_dir_entry *proc_sys_root;
-
-static void register_proc_table(ctl_table *, struct proc_dir_entry *, void *);
-static void unregister_proc_table(ctl_table *, struct proc_dir_entry *);
-#endif
-
 /* The default sysctl tables: */
 
 static ctl_table root_table[] = {
@@ -1145,13 +1125,6 @@ struct ctl_table_header *sysctl_head_nex
 	return NULL;
 }
 
-void __init sysctl_init(void)
-{
-#ifdef CONFIG_PROC_SYSCTL
-	register_proc_table(root_table, proc_sys_root, &root_table_header);
-#endif
-}
-
 #ifdef CONFIG_SYSCTL_SYSCALL
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
@@ -1388,9 +1361,6 @@ struct ctl_table_header *register_sysctl
 	spin_lock(&sysctl_lock);
 	list_add_tail(&tmp->ctl_entry, &root_table_header.ctl_entry);
 	spin_unlock(&sysctl_lock);
-#ifdef CONFIG_PROC_SYSCTL
-	register_proc_table(table, proc_sys_root, tmp);
-#endif
 	return tmp;
 }
 
@@ -1406,9 +1376,6 @@ void unregister_sysctl_table(struct ctl_
 	might_sleep();
 	spin_lock(&sysctl_lock);
 	start_unregistering(header);
-#ifdef CONFIG_PROC_SYSCTL
-	unregister_proc_table(header->ctl_table, proc_sys_root);
-#endif
 	spin_unlock(&sysctl_lock);
 	kfree(header);
 }
@@ -1432,155 +1399,6 @@ void unregister_sysctl_table(struct ctl_
 
 #ifdef CONFIG_PROC_SYSCTL
 
-/* Scan the sysctl entries in table and add them all into /proc */
-static void register_proc_table(ctl_table * table, struct proc_dir_entry *root, void *set)
-{
-	struct proc_dir_entry *de;
-	int len;
-	mode_t mode;
-	
-	for (; table->ctl_name || table->procname; table++) {
-		/* Can't do anything without a proc name. */
-		if (!table->procname)
-			continue;
-		/* Maybe we can't do anything with it... */
-		if (!table->proc_handler && !table->child) {
-			printk(KERN_WARNING "SYSCTL: Can't register %s\n",
-				table->procname);
-			continue;
-		}
-
-		len = strlen(table->procname);
-		mode = table->mode;
-
-		de = NULL;
-		if (table->proc_handler)
-			mode |= S_IFREG;
-		else {
-			mode |= S_IFDIR;
-			for (de = root->subdir; de; de = de->next) {
-				if (proc_match(len, table->procname, de))
-					break;
-			}
-			/* If the subdir exists already, de is non-NULL */
-		}
-
-		if (!de) {
-			de = create_proc_entry(table->procname, mode, root);
-			if (!de)
-				continue;
-			de->set = set;
-			de->data = (void *) table;
-			if (table->proc_handler)
-				de->proc_fops = &proc_sys_file_operations;
-		}
-		table->de = de;
-		if (de->mode & S_IFDIR)
-			register_proc_table(table->child, de, set);
-	}
-}
-
-/*
- * Unregister a /proc sysctl table and any subdirectories.
- */
-static void unregister_proc_table(ctl_table * table, struct proc_dir_entry *root)
-{
-	struct proc_dir_entry *de;
-	for (; table->ctl_name || table->procname; table++) {
-		if (!(de = table->de))
-			continue;
-		if (de->mode & S_IFDIR) {
-			if (!table->child) {
-				printk (KERN_ALERT "Help - malformed sysctl tree on free\n");
-				continue;
-			}
-			unregister_proc_table(table->child, de);
-
-			/* Don't unregister directories which still have entries.. */
-			if (de->subdir)
-				continue;
-		}
-
-		/*
-		 * In any case, mark the entry as goner; we'll keep it
-		 * around if it's busy, but we'll know to do nothing with
-		 * its fields.  We are under sysctl_lock here.
-		 */
-		de->data = NULL;
-
-		/* Don't unregister proc entries that are still being used.. */
-		if (atomic_read(&de->count))
-			continue;
-
-		table->de = NULL;
-		remove_proc_entry(table->procname, root);
-	}
-}
-
-static ssize_t do_rw_proc(int write, struct file * file, char __user * buf,
-			  size_t count, loff_t *ppos)
-{
-	int op;
-	struct proc_dir_entry *de = PDE(file->f_path.dentry->d_inode);
-	struct ctl_table *table;
-	size_t res;
-	ssize_t error = -ENOTDIR;
-	
-	spin_lock(&sysctl_lock);
-	if (de && de->data && use_table(de->set)) {
-		/*
-		 * at that point we know that sysctl was not unregistered
-		 * and won't be until we finish
-		 */
-		spin_unlock(&sysctl_lock);
-		table = (struct ctl_table *) de->data;
-		if (!table || !table->proc_handler)
-			goto out;
-		error = -EPERM;
-		op = (write ? 002 : 004);
-		if (sysctl_perm(table, op))
-			goto out;
-		
-		/* careful: calling conventions are nasty here */
-		res = count;
-		error = (*table->proc_handler)(table, write, file,
-						buf, &res, ppos);
-		if (!error)
-			error = res;
-	out:
-		spin_lock(&sysctl_lock);
-		unuse_table(de->set);
-	}
-	spin_unlock(&sysctl_lock);
-	return error;
-}
-
-static int proc_opensys(struct inode *inode, struct file *file)
-{
-	if (file->f_mode & FMODE_WRITE) {
-		/*
-		 * sysctl entries that are not writable,
-		 * are _NOT_ writable, capabilities or not.
-		 */
-		if (!(inode->i_mode & S_IWUSR))
-			return -EPERM;
-	}
-
-	return 0;
-}
-
-static ssize_t proc_readsys(struct file * file, char __user * buf,
-			    size_t count, loff_t *ppos)
-{
-	return do_rw_proc(0, file, buf, count, ppos);
-}
-
-static ssize_t proc_writesys(struct file * file, const char __user * buf,
-			     size_t count, loff_t *ppos)
-{
-	return do_rw_proc(1, file, (char __user *) buf, count, ppos);
-}
-
 static int _proc_do_string(void* data, int maxlen, int write,
 			   struct file *filp, void __user *buffer,
 			   size_t *lenp, loff_t *ppos)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
remove-find_attach_pid.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
