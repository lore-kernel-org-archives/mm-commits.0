From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 57/67] proc: decouple proc from VFS with "struct
 proc_ops"
Date: Mon, 03 Feb 2020 17:37:14 -0800
Message-ID: <20200204013714.I6etN5N7n%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBhQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:37:16 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: decouple proc from VFS with "struct proc_ops"

Currently core /proc code uses "struct file_operations" for custom hooks,
however, VFS doesn't directly call them.  Every time VFS expands
file_operations hook set, /proc code bloats for no reason.

Introduce "struct proc_ops" which contains only those hooks which /proc
allows to call into (open, release, read, write, ioctl, mmap, poll).  It
doesn't contain module pointer as well.

Save ~184 bytes per usage:

	add/remove: 26/26 grow/shrink: 1/4 up/down: 1922/-6674 (-4752)
	Function                                     old     new   delta
	sysvipc_proc_ops                               -      72     +72
				...
	config_gz_proc_ops                             -      72     +72
	proc_get_inode                               289     339     +50
	proc_reg_get_unmapped_area                   110     107      -3
	close_pdeo                                   227     224      -3
	proc_reg_open                                289     284      -5
	proc_create_data                              60      53      -7
	rt_cpu_seq_fops                              256       -    -256
				...
	default_affinity_proc_fops                   256       -    -256
	Total: Before=5430095, After=5425343, chg -0.09%

Link: http://lkml.kernel.org/r/20191225172228.GA13378@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   38 +++++++++----------
 fs/proc/inode.c         |   76 +++++++++++++++++++-------------------
 fs/proc/internal.h      |    5 ++
 fs/proc/proc_net.c      |   32 ++++++++--------
 fs/proc/proc_sysctl.c   |    2 -
 fs/proc/root.c          |    2 -
 include/linux/proc_fs.h |   23 +++++++++--
 7 files changed, 98 insertions(+), 80 deletions(-)

--- a/fs/proc/generic.c~proc-decouple-proc-from-vfs-with-struct-proc_ops
+++ a/fs/proc/generic.c
@@ -473,7 +473,7 @@ struct proc_dir_entry *proc_mkdir_data(c
 	ent = __proc_create(&parent, name, S_IFDIR | mode, 2);
 	if (ent) {
 		ent->data = data;
-		ent->proc_fops = &proc_dir_operations;
+		ent->proc_dir_ops = &proc_dir_operations;
 		ent->proc_iops = &proc_dir_inode_operations;
 		ent = proc_register(parent, ent);
 	}
@@ -503,7 +503,7 @@ struct proc_dir_entry *proc_create_mount
 	ent = __proc_create(&parent, name, mode, 2);
 	if (ent) {
 		ent->data = NULL;
-		ent->proc_fops = NULL;
+		ent->proc_dir_ops = NULL;
 		ent->proc_iops = NULL;
 		ent = proc_register(parent, ent);
 	}
@@ -533,25 +533,23 @@ struct proc_dir_entry *proc_create_reg(c
 
 struct proc_dir_entry *proc_create_data(const char *name, umode_t mode,
 		struct proc_dir_entry *parent,
-		const struct file_operations *proc_fops, void *data)
+		const struct proc_ops *proc_ops, void *data)
 {
 	struct proc_dir_entry *p;
 
-	BUG_ON(proc_fops == NULL);
-
 	p = proc_create_reg(name, mode, &parent, data);
 	if (!p)
 		return NULL;
-	p->proc_fops = proc_fops;
+	p->proc_ops = proc_ops;
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL(proc_create_data);
  
 struct proc_dir_entry *proc_create(const char *name, umode_t mode,
 				   struct proc_dir_entry *parent,
-				   const struct file_operations *proc_fops)
+				   const struct proc_ops *proc_ops)
 {
-	return proc_create_data(name, mode, parent, proc_fops, NULL);
+	return proc_create_data(name, mode, parent, proc_ops, NULL);
 }
 EXPORT_SYMBOL(proc_create);
 
@@ -573,11 +571,11 @@ static int proc_seq_release(struct inode
 	return seq_release(inode, file);
 }
 
-static const struct file_operations proc_seq_fops = {
-	.open		= proc_seq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= proc_seq_release,
+static const struct proc_ops proc_seq_ops = {
+	.proc_open	= proc_seq_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= proc_seq_release,
 };
 
 struct proc_dir_entry *proc_create_seq_private(const char *name, umode_t mode,
@@ -589,7 +587,7 @@ struct proc_dir_entry *proc_create_seq_p
 	p = proc_create_reg(name, mode, &parent, data);
 	if (!p)
 		return NULL;
-	p->proc_fops = &proc_seq_fops;
+	p->proc_ops = &proc_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
 	return proc_register(parent, p);
@@ -603,11 +601,11 @@ static int proc_single_open(struct inode
 	return single_open(file, de->single_show, de->data);
 }
 
-static const struct file_operations proc_single_fops = {
-	.open		= proc_single_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static const struct proc_ops proc_single_ops = {
+	.proc_open	= proc_single_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 struct proc_dir_entry *proc_create_single_data(const char *name, umode_t mode,
@@ -619,7 +617,7 @@ struct proc_dir_entry *proc_create_singl
 	p = proc_create_reg(name, mode, &parent, data);
 	if (!p)
 		return NULL;
-	p->proc_fops = &proc_single_fops;
+	p->proc_ops = &proc_single_ops;
 	p->single_show = show;
 	return proc_register(parent, p);
 }
--- a/fs/proc/inode.c~proc-decouple-proc-from-vfs-with-struct-proc_ops
+++ a/fs/proc/inode.c
@@ -163,7 +163,7 @@ static void close_pdeo(struct proc_dir_e
 		pdeo->closing = true;
 		spin_unlock(&pde->pde_unload_lock);
 		file = pdeo->file;
-		pde->proc_fops->release(file_inode(file), file);
+		pde->proc_ops->proc_release(file_inode(file), file);
 		spin_lock(&pde->pde_unload_lock);
 		/* After ->release. */
 		list_del(&pdeo->lh);
@@ -200,12 +200,12 @@ static loff_t proc_reg_llseek(struct fil
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	loff_t rv = -EINVAL;
 	if (use_pde(pde)) {
-		typeof_member(struct file_operations, llseek) llseek;
+		typeof_member(struct proc_ops, proc_lseek) lseek;
 
-		llseek = pde->proc_fops->llseek;
-		if (!llseek)
-			llseek = default_llseek;
-		rv = llseek(file, offset, whence);
+		lseek = pde->proc_ops->proc_lseek;
+		if (!lseek)
+			lseek = default_llseek;
+		rv = lseek(file, offset, whence);
 		unuse_pde(pde);
 	}
 	return rv;
@@ -216,9 +216,9 @@ static ssize_t proc_reg_read(struct file
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	ssize_t rv = -EIO;
 	if (use_pde(pde)) {
-		typeof_member(struct file_operations, read) read;
+		typeof_member(struct proc_ops, proc_read) read;
 
-		read = pde->proc_fops->read;
+		read = pde->proc_ops->proc_read;
 		if (read)
 			rv = read(file, buf, count, ppos);
 		unuse_pde(pde);
@@ -231,9 +231,9 @@ static ssize_t proc_reg_write(struct fil
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	ssize_t rv = -EIO;
 	if (use_pde(pde)) {
-		typeof_member(struct file_operations, write) write;
+		typeof_member(struct proc_ops, proc_write) write;
 
-		write = pde->proc_fops->write;
+		write = pde->proc_ops->proc_write;
 		if (write)
 			rv = write(file, buf, count, ppos);
 		unuse_pde(pde);
@@ -246,9 +246,9 @@ static __poll_t proc_reg_poll(struct fil
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	__poll_t rv = DEFAULT_POLLMASK;
 	if (use_pde(pde)) {
-		typeof_member(struct file_operations, poll) poll;
+		typeof_member(struct proc_ops, proc_poll) poll;
 
-		poll = pde->proc_fops->poll;
+		poll = pde->proc_ops->proc_poll;
 		if (poll)
 			rv = poll(file, pts);
 		unuse_pde(pde);
@@ -261,9 +261,9 @@ static long proc_reg_unlocked_ioctl(stru
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	long rv = -ENOTTY;
 	if (use_pde(pde)) {
-		typeof_member(struct file_operations, unlocked_ioctl) ioctl;
+		typeof_member(struct proc_ops, proc_ioctl) ioctl;
 
-		ioctl = pde->proc_fops->unlocked_ioctl;
+		ioctl = pde->proc_ops->proc_ioctl;
 		if (ioctl)
 			rv = ioctl(file, cmd, arg);
 		unuse_pde(pde);
@@ -277,9 +277,9 @@ static long proc_reg_compat_ioctl(struct
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	long rv = -ENOTTY;
 	if (use_pde(pde)) {
-		typeof_member(struct file_operations, compat_ioctl) compat_ioctl;
+		typeof_member(struct proc_ops, proc_compat_ioctl) compat_ioctl;
 
-		compat_ioctl = pde->proc_fops->compat_ioctl;
+		compat_ioctl = pde->proc_ops->proc_compat_ioctl;
 		if (compat_ioctl)
 			rv = compat_ioctl(file, cmd, arg);
 		unuse_pde(pde);
@@ -293,9 +293,9 @@ static int proc_reg_mmap(struct file *fi
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	int rv = -EIO;
 	if (use_pde(pde)) {
-		typeof_member(struct file_operations, mmap) mmap;
+		typeof_member(struct proc_ops, proc_mmap) mmap;
 
-		mmap = pde->proc_fops->mmap;
+		mmap = pde->proc_ops->proc_mmap;
 		if (mmap)
 			rv = mmap(file, vma);
 		unuse_pde(pde);
@@ -312,9 +312,9 @@ proc_reg_get_unmapped_area(struct file *
 	unsigned long rv = -EIO;
 
 	if (use_pde(pde)) {
-		typeof_member(struct file_operations, get_unmapped_area) get_area;
+		typeof_member(struct proc_ops, proc_get_unmapped_area) get_area;
 
-		get_area = pde->proc_fops->get_unmapped_area;
+		get_area = pde->proc_ops->proc_get_unmapped_area;
 #ifdef CONFIG_MMU
 		if (!get_area)
 			get_area = current->mm->get_unmapped_area;
@@ -333,8 +333,8 @@ static int proc_reg_open(struct inode *i
 {
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
-	typeof_member(struct file_operations, open) open;
-	typeof_member(struct file_operations, release) release;
+	typeof_member(struct proc_ops, proc_open) open;
+	typeof_member(struct proc_ops, proc_release) release;
 	struct pde_opener *pdeo;
 
 	/*
@@ -351,7 +351,7 @@ static int proc_reg_open(struct inode *i
 	if (!use_pde(pde))
 		return -ENOENT;
 
-	release = pde->proc_fops->release;
+	release = pde->proc_ops->proc_release;
 	if (release) {
 		pdeo = kmem_cache_alloc(pde_opener_cache, GFP_KERNEL);
 		if (!pdeo) {
@@ -360,7 +360,7 @@ static int proc_reg_open(struct inode *i
 		}
 	}
 
-	open = pde->proc_fops->open;
+	open = pde->proc_ops->proc_open;
 	if (open)
 		rv = open(inode, file);
 
@@ -468,21 +468,23 @@ struct inode *proc_get_inode(struct supe
 			inode->i_size = de->size;
 		if (de->nlink)
 			set_nlink(inode, de->nlink);
-		WARN_ON(!de->proc_iops);
-		inode->i_op = de->proc_iops;
-		if (de->proc_fops) {
-			if (S_ISREG(inode->i_mode)) {
+
+		if (S_ISREG(inode->i_mode)) {
+			inode->i_op = de->proc_iops;
+			inode->i_fop = &proc_reg_file_ops;
 #ifdef CONFIG_COMPAT
-				if (!de->proc_fops->compat_ioctl)
-					inode->i_fop =
-						&proc_reg_file_ops_no_compat;
-				else
-#endif
-					inode->i_fop = &proc_reg_file_ops;
-			} else {
-				inode->i_fop = de->proc_fops;
+			if (!de->proc_ops->proc_compat_ioctl) {
+				inode->i_fop = &proc_reg_file_ops_no_compat;
 			}
-		}
+#endif
+		} else if (S_ISDIR(inode->i_mode)) {
+			inode->i_op = de->proc_iops;
+			inode->i_fop = de->proc_dir_ops;
+		} else if (S_ISLNK(inode->i_mode)) {
+			inode->i_op = de->proc_iops;
+			inode->i_fop = NULL;
+		} else
+			BUG();
 	} else
 	       pde_put(de);
 	return inode;
--- a/fs/proc/internal.h~proc-decouple-proc-from-vfs-with-struct-proc_ops
+++ a/fs/proc/internal.h
@@ -39,7 +39,10 @@ struct proc_dir_entry {
 	spinlock_t pde_unload_lock;
 	struct completion *pde_unload_completion;
 	const struct inode_operations *proc_iops;
-	const struct file_operations *proc_fops;
+	union {
+		const struct proc_ops *proc_ops;
+		const struct file_operations *proc_dir_ops;
+	};
 	const struct dentry_operations *proc_dops;
 	union {
 		const struct seq_operations *seq_ops;
--- a/fs/proc/proc_net.c~proc-decouple-proc-from-vfs-with-struct-proc_ops
+++ a/fs/proc/proc_net.c
@@ -90,12 +90,12 @@ static int seq_release_net(struct inode
 	return 0;
 }
 
-static const struct file_operations proc_net_seq_fops = {
-	.open		= seq_open_net,
-	.read		= seq_read,
-	.write		= proc_simple_write,
-	.llseek		= seq_lseek,
-	.release	= seq_release_net,
+static const struct proc_ops proc_net_seq_ops = {
+	.proc_open	= seq_open_net,
+	.proc_read	= seq_read,
+	.proc_write	= proc_simple_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release_net,
 };
 
 struct proc_dir_entry *proc_create_net_data(const char *name, umode_t mode,
@@ -108,7 +108,7 @@ struct proc_dir_entry *proc_create_net_d
 	if (!p)
 		return NULL;
 	pde_force_lookup(p);
-	p->proc_fops = &proc_net_seq_fops;
+	p->proc_ops = &proc_net_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
 	return proc_register(parent, p);
@@ -152,7 +152,7 @@ struct proc_dir_entry *proc_create_net_d
 	if (!p)
 		return NULL;
 	pde_force_lookup(p);
-	p->proc_fops = &proc_net_seq_fops;
+	p->proc_ops = &proc_net_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
 	p->write = write;
@@ -183,12 +183,12 @@ static int single_release_net(struct ino
 	return single_release(ino, f);
 }
 
-static const struct file_operations proc_net_single_fops = {
-	.open		= single_open_net,
-	.read		= seq_read,
-	.write		= proc_simple_write,
-	.llseek		= seq_lseek,
-	.release	= single_release_net,
+static const struct proc_ops proc_net_single_ops = {
+	.proc_open	= single_open_net,
+	.proc_read	= seq_read,
+	.proc_write	= proc_simple_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release_net,
 };
 
 struct proc_dir_entry *proc_create_net_single(const char *name, umode_t mode,
@@ -201,7 +201,7 @@ struct proc_dir_entry *proc_create_net_s
 	if (!p)
 		return NULL;
 	pde_force_lookup(p);
-	p->proc_fops = &proc_net_single_fops;
+	p->proc_ops = &proc_net_single_ops;
 	p->single_show = show;
 	return proc_register(parent, p);
 }
@@ -244,7 +244,7 @@ struct proc_dir_entry *proc_create_net_s
 	if (!p)
 		return NULL;
 	pde_force_lookup(p);
-	p->proc_fops = &proc_net_single_fops;
+	p->proc_ops = &proc_net_single_ops;
 	p->single_show = show;
 	p->write = write;
 	return proc_register(parent, p);
--- a/fs/proc/proc_sysctl.c~proc-decouple-proc-from-vfs-with-struct-proc_ops
+++ a/fs/proc/proc_sysctl.c
@@ -1720,7 +1720,7 @@ int __init proc_sys_init(void)
 
 	proc_sys_root = proc_mkdir("sys", NULL);
 	proc_sys_root->proc_iops = &proc_sys_dir_operations;
-	proc_sys_root->proc_fops = &proc_sys_dir_file_operations;
+	proc_sys_root->proc_dir_ops = &proc_sys_dir_file_operations;
 	proc_sys_root->nlink = 0;
 
 	return sysctl_init();
--- a/fs/proc/root.c~proc-decouple-proc-from-vfs-with-struct-proc_ops
+++ a/fs/proc/root.c
@@ -292,7 +292,7 @@ struct proc_dir_entry proc_root = {
 	.nlink		= 2, 
 	.refcnt		= REFCOUNT_INIT(1),
 	.proc_iops	= &proc_root_inode_operations, 
-	.proc_fops	= &proc_root_operations,
+	.proc_dir_ops	= &proc_root_operations,
 	.parent		= &proc_root,
 	.subdir		= RB_ROOT,
 	.name		= "/proc",
--- a/include/linux/proc_fs.h~proc-decouple-proc-from-vfs-with-struct-proc_ops
+++ a/include/linux/proc_fs.h
@@ -12,6 +12,21 @@ struct proc_dir_entry;
 struct seq_file;
 struct seq_operations;
 
+struct proc_ops {
+	int	(*proc_open)(struct inode *, struct file *);
+	ssize_t	(*proc_read)(struct file *, char __user *, size_t, loff_t *);
+	ssize_t	(*proc_write)(struct file *, const char __user *, size_t, loff_t *);
+	loff_t	(*proc_lseek)(struct file *, loff_t, int);
+	int	(*proc_release)(struct inode *, struct file *);
+	__poll_t (*proc_poll)(struct file *, struct poll_table_struct *);
+	long	(*proc_ioctl)(struct file *, unsigned int, unsigned long);
+#ifdef CONFIG_COMPAT
+	long	(*proc_compat_ioctl)(struct file *, unsigned int, unsigned long);
+#endif
+	int	(*proc_mmap)(struct file *, struct vm_area_struct *);
+	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+};
+
 #ifdef CONFIG_PROC_FS
 
 typedef int (*proc_write_t)(struct file *, char *, size_t);
@@ -43,10 +58,10 @@ struct proc_dir_entry *proc_create_singl
  
 extern struct proc_dir_entry *proc_create_data(const char *, umode_t,
 					       struct proc_dir_entry *,
-					       const struct file_operations *,
+					       const struct proc_ops *,
 					       void *);
 
-struct proc_dir_entry *proc_create(const char *name, umode_t mode, struct proc_dir_entry *parent, const struct file_operations *proc_fops);
+struct proc_dir_entry *proc_create(const char *name, umode_t mode, struct proc_dir_entry *parent, const struct proc_ops *proc_ops);
 extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
 extern void *PDE_DATA(const struct inode *);
@@ -108,8 +123,8 @@ static inline struct proc_dir_entry *pro
 #define proc_create_seq(name, mode, parent, ops) ({NULL;})
 #define proc_create_single(name, mode, parent, show) ({NULL;})
 #define proc_create_single_data(name, mode, parent, show, data) ({NULL;})
-#define proc_create(name, mode, parent, proc_fops) ({NULL;})
-#define proc_create_data(name, mode, parent, proc_fops, data) ({NULL;})
+#define proc_create(name, mode, parent, proc_ops) ({NULL;})
+#define proc_create_data(name, mode, parent, proc_ops, data) ({NULL;})
 
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
_
