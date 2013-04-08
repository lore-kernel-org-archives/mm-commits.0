From: akpm@linux-foundation.org
Subject: [wrecked] procfs-improve-scaling-in-proc.patch removed from -mm tree
Date: Mon, 08 Apr 2013 11:57:49 -0700
Message-ID: <20130408185749.C3B9B31C24B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:40914 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935549Ab3DHS5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 14:57:55 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1544405iad.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 11:57:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, adobriyan@gmail.com, dwmw2@infradead.org, ebiederm@xmission.com, eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: improve scaling in proc
has been removed from the -mm tree.  Its filename was
     procfs-improve-scaling-in-proc.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: procfs: improve scaling in proc

I am currently tracking a hotlock reported by a customer on a large
system, 512 cores.  I am currently running 3.8-rc7 but the issue looks
like it has been this way for a very long time.  The offending lock is
proc_dir_entry->pde_unload_lock.

This patch converts the lock to use rcu.  However the pde_openers list
still is controlled by a spin lock.  I tested on a 4096 machine and the
lock doesn't seem hot at least according to perf.

This is a refresh of what was orignally suggested by Eric Dumazet some
time ago.  I have also taken in some comments from Andrew and several
other people whose names escape me but I am quite grateful too.

Supporting numbers, lower is better, they are from the test I posted earlier.
cpuinfo baseline        Rcu
tasks   read-sec        read-sec
1       0.0141          0.0141
2       0.0140          0.0142
4       0.0140          0.0141
8       0.0145          0.0140
16      0.0553          0.0168
32      0.1688          0.0549
64      0.5017          0.1690
128     1.7005          0.5038
256     5.2513          2.0804
512     8.0529          3.0162

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   62 +++++++-------
 fs/proc/inode.c         |  161 +++++++++++++++++++++-----------------
 include/linux/proc_fs.h |    6 -
 3 files changed, 123 insertions(+), 106 deletions(-)

diff -puN fs/proc/generic.c~procfs-improve-scaling-in-proc fs/proc/generic.c
--- a/fs/proc/generic.c~procfs-improve-scaling-in-proc
+++ a/fs/proc/generic.c
@@ -181,14 +181,16 @@ proc_file_read(struct file *file, char _
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	ssize_t rv = -EIO;
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	rcu_read_unlock();
 
 	rv = __proc_file_read(file, buf, nbytes, ppos);
 
@@ -204,13 +206,16 @@ proc_file_write(struct file *file, const
 	ssize_t rv = -EIO;
 
 	if (pde->write_proc) {
-		spin_lock(&pde->pde_unload_lock);
-		if (!pde->proc_fops) {
-			spin_unlock(&pde->pde_unload_lock);
+		const struct file_operations *fops;
+
+		rcu_read_lock();
+		fops = rcu_dereference(pde->proc_fops);
+		if (!fops) {
+			rcu_read_unlock();
 			return rv;
 		}
-		pde->pde_users++;
-		spin_unlock(&pde->pde_unload_lock);
+		atomic_inc(&pde->pde_users);
+		rcu_read_unlock();
 
 		/* FIXME: does this routine need ppos?  probably... */
 		rv = pde->write_proc(file, buffer, count, pde->data);
@@ -542,7 +547,7 @@ static int proc_register(struct proc_dir
 
 	if (S_ISDIR(dp->mode)) {
 		if (dp->proc_iops == NULL) {
-			dp->proc_fops = &proc_dir_operations;
+			RCU_INIT_POINTER(dp->proc_fops, &proc_dir_operations);
 			dp->proc_iops = &proc_dir_inode_operations;
 		}
 		dir->nlink++;
@@ -551,7 +556,7 @@ static int proc_register(struct proc_dir
 			dp->proc_iops = &proc_link_inode_operations;
 	} else if (S_ISREG(dp->mode)) {
 		if (dp->proc_fops == NULL)
-			dp->proc_fops = &proc_file_operations;
+			RCU_INIT_POINTER(dp->proc_fops, &proc_file_operations);
 		if (dp->proc_iops == NULL)
 			dp->proc_iops = &proc_file_inode_operations;
 	}
@@ -604,7 +609,8 @@ static struct proc_dir_entry *__proc_cre
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
-	spin_lock_init(&ent->pde_unload_lock);
+	atomic_set(&ent->pde_users, 1);
+	spin_lock_init(&ent->pde_openers_lock);
 	INIT_LIST_HEAD(&ent->pde_openers);
 out:
 	return ent;
@@ -728,7 +734,7 @@ struct proc_dir_entry *proc_create_data(
 	pde = __proc_create(&parent, name, mode, nlink);
 	if (!pde)
 		goto out;
-	pde->proc_fops = proc_fops;
+	rcu_assign_pointer(pde->proc_fops, proc_fops);
 	pde->data = data;
 	if (proc_register(parent, pde) < 0)
 		goto out_free;
@@ -764,6 +770,7 @@ void remove_proc_entry(const char *name,
 	struct proc_dir_entry *de = NULL;
 	const char *fn = name;
 	unsigned int len;
+	DECLARE_COMPLETION_ONSTACK(c);
 
 	spin_lock(&proc_subdir_lock);
 	if (__xlate_proc_name(name, &parent, &fn) != 0) {
@@ -786,37 +793,30 @@ void remove_proc_entry(const char *name,
 		return;
 	}
 
-	spin_lock(&de->pde_unload_lock);
 	/*
 	 * Stop accepting new callers into module. If you're
 	 * dynamically allocating ->proc_fops, save a pointer somewhere.
 	 */
-	de->proc_fops = NULL;
-	/* Wait until all existing callers into module are done. */
-	if (de->pde_users > 0) {
-		DECLARE_COMPLETION_ONSTACK(c);
-
-		if (!de->pde_unload_completion)
-			de->pde_unload_completion = &c;
-
-		spin_unlock(&de->pde_unload_lock);
-
+	rcu_assign_pointer(de->proc_fops, NULL);
+	synchronize_rcu();
+	/*
+	 * Wait until all existing callers into module are done.
+	 * Once pde_users hits zero we are free to clean out pde_openers.
+	 */
+	de->pde_unload_completion = &c;
+	if (!atomic_dec_and_test(&de->pde_users))
 		wait_for_completion(de->pde_unload_completion);
 
-		spin_lock(&de->pde_unload_lock);
-	}
-
+	spin_lock(&de->pde_openers_lock);
 	while (!list_empty(&de->pde_openers)) {
 		struct pde_opener *pdeo;
 
 		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
 		list_del(&pdeo->lh);
-		spin_unlock(&de->pde_unload_lock);
 		pdeo->release(pdeo->inode, pdeo->file);
 		kfree(pdeo);
-		spin_lock(&de->pde_unload_lock);
 	}
-	spin_unlock(&de->pde_unload_lock);
+	spin_unlock(&de->pde_openers_lock);
 
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
diff -puN fs/proc/inode.c~procfs-improve-scaling-in-proc fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-improve-scaling-in-proc
+++ a/fs/proc/inode.c
@@ -129,46 +129,41 @@ static const struct super_operations pro
 	.show_options	= proc_show_options,
 };
 
-static void __pde_users_dec(struct proc_dir_entry *pde)
-{
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-}
-
 void pde_users_dec(struct proc_dir_entry *pde)
 {
-	spin_lock(&pde->pde_unload_lock);
-	__pde_users_dec(pde);
-	spin_unlock(&pde->pde_unload_lock);
+	if (atomic_dec_and_test(&pde->pde_users) && pde->pde_unload_completion)
+		complete(pde->pde_unload_completion);
 }
 
 static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 {
+	const struct file_operations *fops;
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	loff_t rv = -EINVAL;
 	loff_t (*llseek)(struct file *, loff_t, int);
 
-	spin_lock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
 	/*
 	 * remove_proc_entry() is going to delete PDE (as part of module
 	 * cleanup sequence). No new callers into module allowed.
 	 */
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
 	/*
 	 * Bump refcount so that remove_proc_entry will wail for ->llseek to
 	 * complete.
 	 */
-	pde->pde_users++;
+	atomic_inc(&pde->pde_users);
+
 	/*
-	 * Save function pointer under lock, to protect against ->proc_fops
-	 * NULL'ifying right after ->pde_unload_lock is dropped.
+	 * Save function pointer under rcu lock, to protect against
+	 * ->proc_fops NULL'ifying by remove_proc_entry.
 	 */
-	llseek = pde->proc_fops->llseek;
-	spin_unlock(&pde->pde_unload_lock);
+	llseek = fops->llseek;
+	rcu_read_unlock();
 
 	if (!llseek)
 		llseek = default_llseek;
@@ -183,15 +178,17 @@ static ssize_t proc_reg_read(struct file
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	ssize_t rv = -EIO;
 	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	read = pde->proc_fops->read;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	read = fops->read;
+	rcu_read_unlock();
 
 	if (read)
 		rv = read(file, buf, count, ppos);
@@ -205,15 +202,17 @@ static ssize_t proc_reg_write(struct fil
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	ssize_t rv = -EIO;
 	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	write = pde->proc_fops->write;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	write = fops->write;
+	rcu_read_unlock();
 
 	if (write)
 		rv = write(file, buf, count, ppos);
@@ -227,15 +226,17 @@ static unsigned int proc_reg_poll(struct
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	unsigned int rv = DEFAULT_POLLMASK;
 	unsigned int (*poll)(struct file *, struct poll_table_struct *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	poll = pde->proc_fops->poll;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	poll = fops->poll;
+	rcu_read_unlock();
 
 	if (poll)
 		rv = poll(file, pts);
@@ -249,15 +250,17 @@ static long proc_reg_unlocked_ioctl(stru
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	long rv = -ENOTTY;
 	long (*ioctl)(struct file *, unsigned int, unsigned long);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
-	ioctl = pde->proc_fops->unlocked_ioctl;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	ioctl = fops->unlocked_ioctl;
+	rcu_read_unlock();
 
 	if (ioctl)
 		rv = ioctl(file, cmd, arg);
@@ -272,15 +275,17 @@ static long proc_reg_compat_ioctl(struct
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	long rv = -ENOTTY;
 	long (*compat_ioctl)(struct file *, unsigned int, unsigned long);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
+	atomic_inc(&pde->pde_users);
 	compat_ioctl = pde->proc_fops->compat_ioctl;
-	spin_unlock(&pde->pde_unload_lock);
+	rcu_read_unlock();
 
 	if (compat_ioctl)
 		rv = compat_ioctl(file, cmd, arg);
@@ -295,15 +300,17 @@ static int proc_reg_mmap(struct file *fi
 	struct proc_dir_entry *pde = PDE(file_inode(file));
 	int rv = -EIO;
 	int (*mmap)(struct file *, struct vm_area_struct *);
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		return rv;
 	}
-	pde->pde_users++;
+	atomic_inc(&pde->pde_users);
 	mmap = pde->proc_fops->mmap;
-	spin_unlock(&pde->pde_unload_lock);
+	rcu_read_unlock();
 
 	if (mmap)
 		rv = mmap(file, vma);
@@ -319,6 +326,7 @@ static int proc_reg_open(struct inode *i
 	int (*open)(struct inode *, struct file *);
 	int (*release)(struct inode *, struct file *);
 	struct pde_opener *pdeo;
+	const struct file_operations *fops;
 
 	/*
 	 * What for, you ask? Well, we can have open, rmmod, remove_proc_entry
@@ -334,32 +342,33 @@ static int proc_reg_open(struct inode *i
 	if (!pdeo)
 		return -ENOMEM;
 
-	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
+		rcu_read_unlock();
 		kfree(pdeo);
 		return -ENOENT;
 	}
-	pde->pde_users++;
-	open = pde->proc_fops->open;
-	release = pde->proc_fops->release;
-	spin_unlock(&pde->pde_unload_lock);
+	atomic_inc(&pde->pde_users);
+	open = fops->open;
+	release = fops->release;
+	rcu_read_lock();
 
 	if (open)
 		rv = open(inode, file);
 
-	spin_lock(&pde->pde_unload_lock);
 	if (rv == 0 && release) {
 		/* To know what to release. */
 		pdeo->inode = inode;
 		pdeo->file = file;
 		/* Strictly for "too late" ->release in proc_reg_release(). */
 		pdeo->release = release;
+		spin_lock(&pde->pde_openers_lock);
 		list_add(&pdeo->lh, &pde->pde_openers);
+		spin_unlock(&pde->pde_openers_lock);
 	} else
 		kfree(pdeo);
-	__pde_users_dec(pde);
-	spin_unlock(&pde->pde_unload_lock);
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -368,10 +377,14 @@ static struct pde_opener *find_pde_opene
 {
 	struct pde_opener *pdeo;
 
+	spin_lock(&pde->pde_openers_lock);
 	list_for_each_entry(pdeo, &pde->pde_openers, lh) {
-		if (pdeo->inode == inode && pdeo->file == file)
+		if (pdeo->inode == inode && pdeo->file == file) {
+			spin_unlock(&pde->pde_openers_lock);
 			return pdeo;
+		}
 	}
+	spin_unlock(&pde->pde_openers_lock);
 	return NULL;
 }
 
@@ -381,10 +394,12 @@ static int proc_reg_release(struct inode
 	int rv = 0;
 	int (*release)(struct inode *, struct file *);
 	struct pde_opener *pdeo;
+	const struct file_operations *fops;
 
-	spin_lock(&pde->pde_unload_lock);
 	pdeo = find_pde_opener(pde, inode, file);
-	if (!pde->proc_fops) {
+	rcu_read_lock();
+	fops = rcu_dereference(pde->proc_fops);
+	if (!fops) {
 		/*
 		 * Can't simply exit, __fput() will think that everything is OK,
 		 * and move on to freeing struct file. remove_proc_entry() will
@@ -394,21 +409,23 @@ static int proc_reg_release(struct inode
 		 * But if opener is removed from list, who will ->release it?
 		 */
 		if (pdeo) {
+			spin_lock(&pde->pde_openers_lock);
 			list_del(&pdeo->lh);
-			spin_unlock(&pde->pde_unload_lock);
+			spin_unlock(&pde->pde_openers_lock);
 			rv = pdeo->release(inode, file);
 			kfree(pdeo);
-		} else
-			spin_unlock(&pde->pde_unload_lock);
+		}
 		return rv;
 	}
-	pde->pde_users++;
-	release = pde->proc_fops->release;
+	atomic_inc(&pde->pde_users);
+	release = fops->release;
+	rcu_read_unlock();
 	if (pdeo) {
+		spin_lock(&pde->pde_openers_lock);
 		list_del(&pdeo->lh);
-		kfree(pdeo);
+		spin_unlock(&pde->pde_openers_lock);
 	}
-	spin_unlock(&pde->pde_unload_lock);
+	kfree(pdeo);
 
 	if (release)
 		rv = release(inode, file);
diff -puN include/linux/proc_fs.h~procfs-improve-scaling-in-proc include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~procfs-improve-scaling-in-proc
+++ a/include/linux/proc_fs.h
@@ -68,16 +68,16 @@ struct proc_dir_entry {
 	 * If you're allocating ->proc_fops dynamically, save a pointer
 	 * somewhere.
 	 */
-	const struct file_operations *proc_fops;
+	const struct file_operations __rcu *proc_fops;
 	struct proc_dir_entry *next, *parent, *subdir;
 	void *data;
 	read_proc_t *read_proc;
 	write_proc_t *write_proc;
 	atomic_t count;		/* use count */
-	int pde_users;	/* number of callers into module in progress */
+	atomic_t pde_users;	/* number of callers into module in progress */
 	struct completion *pde_unload_completion;
+	spinlock_t pde_openers_lock;
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	u8 namelen;
 	char name[];
 };
_

Patches currently in -mm which might be from nzimmer@sgi.com are

linux-next.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v5.patch
procfs-improve-scaling-in-proc-v5.patch

