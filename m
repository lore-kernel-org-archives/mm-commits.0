From: akpm@linux-foundation.org
Subject: + procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:40:21 -0800
Message-ID: <200703110940.l2B9eLEZ009023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41575 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXCKJle (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:41:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, ebiederm@xmission.com


The patch titled
     procfs: reorder struct pid_dentry to save space on 64bit archs, and constify them
has been added to the -mm tree.  Its filename is
     procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: procfs: reorder struct pid_dentry to save space on 64bit archs, and constify them
From: Eric Dumazet <dada1@cosmosbay.com>

Change the order of fields of struct pid_entry (file fs/proc/base.c) in order
to avoid a hole on 64bit archs.  (8 bytes saved per object)

Also change all pid_entry arrays to be const qualified, to make clear they
must not be modified.

Before (on x86_64) :

# size fs/proc/base.o
   text    data     bss     dec     hex filename
  15549    2192       0   17741    454d fs/proc/base.o

After :

# size fs/proc/base.o
   text    data     bss     dec     hex filename
  17229     176       0   17405    43fd fs/proc/base.o

Thats 336 bytes saved on kernel size on x86_64

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   53 +++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff -puN fs/proc/base.c~procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them fs/proc/base.c
--- a/fs/proc/base.c~procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them
+++ a/fs/proc/base.c
@@ -90,8 +90,8 @@
 #define PROC_NUMBUF 13
 
 struct pid_entry {
-	int len;
 	char *name;
+	int len;
 	mode_t mode;
 	const struct inode_operations *iop;
 	const struct file_operations *fop;
@@ -99,8 +99,8 @@ struct pid_entry {
 };
 
 #define NOD(NAME, MODE, IOP, FOP, OP) {			\
-	.len  = sizeof(NAME) - 1,			\
 	.name = (NAME),					\
+	.len  = sizeof(NAME) - 1,			\
 	.mode = MODE,					\
 	.iop  = IOP,					\
 	.fop  = FOP,					\
@@ -1151,7 +1151,8 @@ static struct dentry_operations pid_dent
 
 /* Lookups */
 
-typedef struct dentry *instantiate_t(struct inode *, struct dentry *, struct task_struct *, void *);
+typedef struct dentry *instantiate_t(struct inode *, struct dentry *,
+				struct task_struct *, const void *);
 
 /*
  * Fill a directory entry.
@@ -1167,7 +1168,7 @@ typedef struct dentry *instantiate_t(str
  */
 static int proc_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 	char *name, int len,
-	instantiate_t instantiate, struct task_struct *task, void *ptr)
+	instantiate_t instantiate, struct task_struct *task, const void *ptr)
 {
 	struct dentry *child, *dir = filp->f_path.dentry;
 	struct inode *inode;
@@ -1302,9 +1303,9 @@ static struct dentry_operations tid_fd_d
 };
 
 static struct dentry *proc_fd_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	unsigned fd = *(unsigned *)ptr;
+	unsigned fd = *(const unsigned *)ptr;
 	struct file *file;
 	struct files_struct *files;
  	struct inode *inode;
@@ -1470,9 +1471,9 @@ static const struct inode_operations pro
 };
 
 static struct dentry *proc_pident_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	struct pid_entry *p = ptr;
+	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-EINVAL);
@@ -1501,13 +1502,13 @@ out:
 
 static struct dentry *proc_pident_lookup(struct inode *dir, 
 					 struct dentry *dentry,
-					 struct pid_entry *ents,
+					 const struct pid_entry *ents,
 					 unsigned int nents)
 {
 	struct inode *inode;
 	struct dentry *error;
 	struct task_struct *task = get_proc_task(dir);
-	struct pid_entry *p, *last;
+	const struct pid_entry *p, *last;
 
 	error = ERR_PTR(-ENOENT);
 	inode = NULL;
@@ -1536,8 +1537,8 @@ out_no_task:
 	return error;
 }
 
-static int proc_pident_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	struct task_struct *task, struct pid_entry *p)
+static int proc_pident_fill_cache(struct file *filp, void *dirent,
+	filldir_t filldir, struct task_struct *task, const struct pid_entry *p)
 {
 	return proc_fill_cache(filp, dirent, filldir, p->name, p->len,
 				proc_pident_instantiate, task, p);
@@ -1545,14 +1546,14 @@ static int proc_pident_fill_cache(struct
 
 static int proc_pident_readdir(struct file *filp,
 		void *dirent, filldir_t filldir,
-		struct pid_entry *ents, unsigned int nents)
+		const struct pid_entry *ents, unsigned int nents)
 {
 	int i;
 	int pid;
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
-	struct pid_entry *p, *last;
+	const struct pid_entry *p, *last;
 	ino_t ino;
 	int ret;
 
@@ -1676,7 +1677,7 @@ static const struct file_operations proc
 	.write		= proc_pid_attr_write,
 };
 
-static struct pid_entry attr_dir_stuff[] = {
+static const struct pid_entry attr_dir_stuff[] = {
 	REG("current",    S_IRUGO|S_IWUGO, pid_attr),
 	REG("prev",       S_IRUGO,	   pid_attr),
 	REG("exec",       S_IRUGO|S_IWUGO, pid_attr),
@@ -1742,7 +1743,7 @@ static const struct inode_operations pro
  * that properly belong to the /proc filesystem, as they describe
  * describe something that is process related.
  */
-static struct pid_entry proc_base_stuff[] = {
+static const struct pid_entry proc_base_stuff[] = {
 	NOD("self", S_IFLNK|S_IRWXUGO,
 		&proc_self_inode_operations, NULL, {}),
 };
@@ -1771,9 +1772,9 @@ static struct dentry_operations proc_bas
 };
 
 static struct dentry *proc_base_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	struct pid_entry *p = ptr;
+	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-EINVAL);
@@ -1821,7 +1822,7 @@ static struct dentry *proc_base_lookup(s
 {
 	struct dentry *error;
 	struct task_struct *task = get_proc_task(dir);
-	struct pid_entry *p, *last;
+	const struct pid_entry *p, *last;
 
 	error = ERR_PTR(-ENOENT);
 
@@ -1847,8 +1848,8 @@ out_no_task:
 	return error;
 }
 
-static int proc_base_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	struct task_struct *task, struct pid_entry *p)
+static int proc_base_fill_cache(struct file *filp, void *dirent,
+	filldir_t filldir, struct task_struct *task, const struct pid_entry *p)
 {
 	return proc_fill_cache(filp, dirent, filldir, p->name, p->len,
 				proc_base_instantiate, task, p);
@@ -1885,7 +1886,7 @@ static int proc_pid_io_accounting(struct
 static const struct file_operations proc_task_operations;
 static const struct inode_operations proc_task_inode_operations;
 
-static struct pid_entry tgid_base_stuff[] = {
+static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, task),
 	DIR("fd",         S_IRUSR|S_IXUSR, fd),
 	INF("environ",    S_IRUSR, pid_environ),
@@ -2028,7 +2029,7 @@ out:
 
 static struct dentry *proc_pid_instantiate(struct inode *dir,
 					   struct dentry * dentry,
-					   struct task_struct *task, void *ptr)
+					   struct task_struct *task, const void *ptr)
 {
 	struct dentry *error = ERR_PTR(-ENOENT);
 	struct inode *inode;
@@ -2143,7 +2144,7 @@ int proc_pid_readdir(struct file * filp,
 		goto out_no_task;
 
 	for (; nr < ARRAY_SIZE(proc_base_stuff); filp->f_pos++, nr++) {
-		struct pid_entry *p = &proc_base_stuff[nr];
+		const struct pid_entry *p = &proc_base_stuff[nr];
 		if (proc_base_fill_cache(filp, dirent, filldir, reaper, p) < 0)
 			goto out;
 	}
@@ -2169,7 +2170,7 @@ out_no_task:
 /*
  * Tasks
  */
-static struct pid_entry tid_base_stuff[] = {
+static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, fd),
 	INF("environ",   S_IRUSR, pid_environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
@@ -2239,7 +2240,7 @@ static const struct inode_operations pro
 };
 
 static struct dentry *proc_task_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
 	struct dentry *error = ERR_PTR(-ENOENT);
 	struct inode *inode;
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
