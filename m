From: akpm@linux-foundation.org
Subject: + fix-rmmod-read-write-races-in-proc-entries.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:00:44 -0800
Message-ID: <200702090900.l1990i4j008973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36583 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946221AbXBIJAs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:00:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, ebiederm@xmission.com, viro@zeniv.linux.org.uk


The patch titled
     Fix rmmod/read/write races in /proc entries
has been added to the -mm tree.  Its filename is
     fix-rmmod-read-write-races-in-proc-entries.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix rmmod/read/write races in /proc entries
From: Alexey Dobriyan <adobriyan@openvz.org>

Current /proc creation interfaces suffer from at least two types of races:
--------------------------------------------------------
1. Write via ->write_proc sleeps in copy_from_user(). Module disappears
   meanwhile.

   pde = create_proc_entry()
   if (!pde)
	return -ENOMEM;
   pde->write_proc = ...
				open
				write
				copy_from_user
   pde = create_proc_entry();
   if (!pde) {
	remove_proc_entry();
	return -ENOMEM;
	/* module unloaded */
   }
				*boom*
--------------------------------------------------------
2. Read/write happens when PDE only partially initialized. ->data is NULL
   when create_proc_entry() returns. Almost all ->read_proc and
   ->write_proc handlers assume that ->data is valid.

   pde = create_proc_entry();
   if (pde) {
	/* which dereferences ->data */
	pde->write_proc = ...
				open
				write
	pde->data = ...
   }
--------------------------------------------------------

The following plan is going to be executed (as per Al Viro's explanations):

PDE gets counter counting reads and writes in progress done via ->read_proc,
->write_proc, ->get_info .  Generic proc code will bump PDE's counter before
calling into module-specific method and decrement it after it returns.

remove_proc_entry() will wait until all readers and writers are done.  To do
this reliably it will set ->proc_fops to NULL and generic proc code won't call
into module it it sees NULL ->proc_fops.

This patch implements part above.  So far, no changes in proc users required. 
Patch fixes races of type 1.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   69 ++++++++++++++++++++++++++++++++++++--
 include/linux/proc_fs.h |   16 ++++++++
 2 files changed, 82 insertions(+), 3 deletions(-)

diff -puN fs/proc/generic.c~fix-rmmod-read-write-races-in-proc-entries fs/proc/generic.c
--- a/fs/proc/generic.c~fix-rmmod-read-write-races-in-proc-entries
+++ a/fs/proc/generic.c
@@ -76,6 +76,21 @@ proc_file_read(struct file *file, char _
 	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
 		return -ENOMEM;
 
+	spin_lock(&dp->pde_unload_lock);
+	if (!dp->proc_fops)
+		/*
+		 * remove_proc_entry() marked PDE as "going away".
+		 * No new readers allowed.
+		 */
+		goto out_unlock;
+	/*
+	 * We are going to call into module's code via ->get_info or
+	 * ->read_proc. Bump refcount so that remove_proc_entry() will
+	 * wait for read to complete.
+	 */
+	dp->pde_users++;
+	spin_unlock(&dp->pde_unload_lock);
+
 	while ((nbytes > 0) && !eof) {
 		count = min_t(size_t, PROC_BLOCK_SIZE, nbytes);
 
@@ -195,6 +210,11 @@ proc_file_read(struct file *file, char _
 		buf += n;
 		retval += n;
 	}
+
+	spin_lock(&dp->pde_unload_lock);
+	dp->pde_users--;
+out_unlock:
+	spin_unlock(&dp->pde_unload_lock);
 	free_page((unsigned long) page);
 	return retval;
 }
@@ -205,14 +225,39 @@ proc_file_write(struct file *file, const
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct proc_dir_entry * dp;
+	ssize_t rv = -EIO;
 	
 	dp = PDE(inode);
 
 	if (!dp->write_proc)
-		return -EIO;
+		goto out;
+
+	spin_lock(&dp->pde_unload_lock);
+	if (!dp->proc_fops)
+		/*
+		 * remove_proc_entry() marked PDE as "going away".
+		 * No new writers allowed.
+		 */
+		goto out_unlock;
+	/*
+	 * We are going to call into module's code via ->write_proc .
+	 * Bump refcount so that module won't dissapear while ->write_proc
+	 * sleeps in copy_from_user(). remove_proc_entry() will wait for
+	 * write to complete.
+	 */
+	dp->pde_users++;
+	spin_unlock(&dp->pde_unload_lock);
 
+	/* PDE is ready, refcount bumped, call into module. */
 	/* FIXME: does this routine need ppos?  probably... */
-	return dp->write_proc(file, buffer, count, dp->data);
+	rv = dp->write_proc(file, buffer, count, dp->data);
+
+	spin_lock(&dp->pde_unload_lock);
+	dp->pde_users--;
+out_unlock:
+	spin_unlock(&dp->pde_unload_lock);
+out:
+	return rv;
 }
 
 
@@ -607,6 +652,8 @@ static struct proc_dir_entry *proc_creat
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
+	ent->pde_users = 0;
+	spin_lock_init(&ent->pde_unload_lock);
  out:
 	return ent;
 }
@@ -720,12 +767,28 @@ void remove_proc_entry(const char *name,
 	if (!parent && xlate_proc_name(name, &parent, &fn) != 0)
 		goto out;
 	len = strlen(fn);
-
+again:
 	spin_lock(&proc_subdir_lock);
 	for (p = &parent->subdir; *p; p=&(*p)->next ) {
 		if (!proc_match(len, fn, *p))
 			continue;
 		de = *p;
+
+		/*
+		 * Stop accepting new readers/writers. If you're dynamically
+		 * allocating ->proc_fops, save a pointer somewhere.
+		 */
+		spin_lock(&de->pde_unload_lock);
+		de->proc_fops = NULL;
+		/* Wait until all readers/writers are done. */
+		if (de->pde_users > 0) {
+			spin_unlock(&de->pde_unload_lock);
+			spin_unlock(&proc_subdir_lock);
+			schedule();
+			goto again;
+		}
+		spin_unlock(&de->pde_unload_lock);
+
 		*p = de->next;
 		de->next = NULL;
 		if (S_ISDIR(de->mode))
diff -puN include/linux/proc_fs.h~fix-rmmod-read-write-races-in-proc-entries include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~fix-rmmod-read-write-races-in-proc-entries
+++ a/include/linux/proc_fs.h
@@ -56,6 +56,19 @@ struct proc_dir_entry {
 	gid_t gid;
 	loff_t size;
 	struct inode_operations * proc_iops;
+	/*
+	 * NULL ->proc_fops means "PDE is going away RSN" or
+	 * "PDE is just created". In either case ->get_info, ->read_proc,
+	 * ->write_proc won't be called because it's too late or too early,
+	 * respectively.
+	 *
+	 * Valid ->proc_fops means "use this file_operations" or
+	 * "->data is setup, it's safe to call ->read_proc, ->write_proc which
+	 * can dereference it".
+	 *
+	 * If you're allocating ->proc_fops dynamically, save a pointer
+	 * somewhere.
+	 */
 	const struct file_operations * proc_fops;
 	get_info_t *get_info;
 	struct module *owner;
@@ -66,6 +79,9 @@ struct proc_dir_entry {
 	atomic_t count;		/* use count */
 	int deleted;		/* delete flag */
 	void *set;
+	int pde_users;	/* number of readers + number of writers via
+			 * ->read_proc, ->write_proc, ->get_info */
+	spinlock_t pde_unload_lock;
 };
 
 struct kcore_list {
_

Patches currently in -mm which might be from adobriyan@openvz.org are

git-net.patch
revert-x86_64-mm-msr-on-cpu.patch
rdmsr_on_cpu-wrmsr_on_cpu.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
