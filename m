From: akpm@linux-foundation.org
Subject: [merged] fs-use-seq_open_private-for-proc_mounts.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:46:35 -0700
Message-ID: <559adb1b.c7M/Dk3iB1/VH3lm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbbGFTqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: use seq_open_private() for proc_mounts
has been removed from the -mm tree.  Its filename was
     fs-use-seq_open_private-for-proc_mounts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: fs: use seq_open_private() for proc_mounts

A patchset to remove support for passing pre-allocated struct seq_file to
seq_open().  Such feature is undocumented and prone to error.

In particular, if seq_release() is used in release handler, it will
kfree() a pointer which was not allocated by seq_open().

So this patchset drops support for pre-allocated struct seq_file: it's
only of use in proc_namespace.c and can be easily replaced by using
seq_open_private()/seq_release_private().

Additionally, it documents the use of file->private_data to hold pointer
to struct seq_file by seq_open().



This patch (of 3):

Since patch described below, from v2.6.15-rc1, seq_open() could use a
struct seq_file already allocated by the caller if the pointer to the
structure is stored in file->private_data before calling the function.

    Commit 1abe77b0fc4b485927f1f798ae81a752677e1d05
    Author: Al Viro <viro@zeniv.linux.org.uk>
    Date:   Mon Nov 7 17:15:34 2005 -0500

        [PATCH] allow callers of seq_open do allocation themselves

        Allow caller of seq_open() to kmalloc() seq_file + whatever else they
        want and set ->private_data to it.  seq_open() will then abstain from
        doing allocation itself.

Such behavior is only used by mounts_open_common().

In order to drop support for such uncommon feature, proc_mounts is
converted to use seq_open_private(), which take care of allocating the
proc_mounts structure, making it available through ->private in struct
seq_file.

Conversely, proc_mounts is converted to use seq_release_private(), in
order to release the private structure allocated by seq_open_private().

Then, ->private is used directly instead of proc_mounts() macro to access
to the proc_mounts structure.

Link: http://lkml.kernel.org/r/cover.1433193673.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mount.h          |    3 ---
 fs/namespace.c      |    6 +++---
 fs/proc_namespace.c |   34 ++++++++++++++++------------------
 3 files changed, 19 insertions(+), 24 deletions(-)

diff -puN fs/mount.h~fs-use-seq_open_private-for-proc_mounts fs/mount.h
--- a/fs/mount.h~fs-use-seq_open_private-for-proc_mounts
+++ a/fs/mount.h
@@ -118,7 +118,6 @@ static inline void unlock_mount_hash(voi
 }
 
 struct proc_mounts {
-	struct seq_file m;
 	struct mnt_namespace *ns;
 	struct path root;
 	int (*show)(struct seq_file *, struct vfsmount *);
@@ -127,8 +126,6 @@ struct proc_mounts {
 	loff_t cached_index;
 };
 
-#define proc_mounts(p) (container_of((p), struct proc_mounts, m))
-
 extern const struct seq_operations mounts_op;
 
 extern bool __is_local_mountpoint(struct dentry *dentry);
diff -puN fs/namespace.c~fs-use-seq_open_private-for-proc_mounts fs/namespace.c
--- a/fs/namespace.c~fs-use-seq_open_private-for-proc_mounts
+++ a/fs/namespace.c
@@ -1226,7 +1226,7 @@ EXPORT_SYMBOL(replace_mount_options);
 /* iterator; we want it to have access to namespace_sem, thus here... */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	struct proc_mounts *p = proc_mounts(m);
+	struct proc_mounts *p = m->private;
 
 	down_read(&namespace_sem);
 	if (p->cached_event == p->ns->event) {
@@ -1247,7 +1247,7 @@ static void *m_start(struct seq_file *m,
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct proc_mounts *p = proc_mounts(m);
+	struct proc_mounts *p = m->private;
 
 	p->cached_mount = seq_list_next(v, &p->ns->list, pos);
 	p->cached_index = *pos;
@@ -1261,7 +1261,7 @@ static void m_stop(struct seq_file *m, v
 
 static int m_show(struct seq_file *m, void *v)
 {
-	struct proc_mounts *p = proc_mounts(m);
+	struct proc_mounts *p = m->private;
 	struct mount *r = list_entry(v, struct mount, mnt_list);
 	return p->show(m, &r->mnt);
 }
diff -puN fs/proc_namespace.c~fs-use-seq_open_private-for-proc_mounts fs/proc_namespace.c
--- a/fs/proc_namespace.c~fs-use-seq_open_private-for-proc_mounts
+++ a/fs/proc_namespace.c
@@ -17,7 +17,8 @@
 
 static unsigned mounts_poll(struct file *file, poll_table *wait)
 {
-	struct proc_mounts *p = proc_mounts(file->private_data);
+	struct seq_file *m = file->private_data;
+	struct proc_mounts *p = m->private;
 	struct mnt_namespace *ns = p->ns;
 	unsigned res = POLLIN | POLLRDNORM;
 	int event;
@@ -25,8 +26,8 @@ static unsigned mounts_poll(struct file
 	poll_wait(file, &p->ns->poll, wait);
 
 	event = ACCESS_ONCE(ns->event);
-	if (p->m.poll_event != event) {
-		p->m.poll_event = event;
+	if (m->poll_event != event) {
+		m->poll_event = event;
 		res |= POLLERR | POLLPRI;
 	}
 
@@ -92,7 +93,7 @@ static void show_type(struct seq_file *m
 
 static int show_vfsmnt(struct seq_file *m, struct vfsmount *mnt)
 {
-	struct proc_mounts *p = proc_mounts(m);
+	struct proc_mounts *p = m->private;
 	struct mount *r = real_mount(mnt);
 	int err = 0;
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
@@ -126,7 +127,7 @@ out:
 
 static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 {
-	struct proc_mounts *p = proc_mounts(m);
+	struct proc_mounts *p = m->private;
 	struct mount *r = real_mount(mnt);
 	struct super_block *sb = mnt->mnt_sb;
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
@@ -186,7 +187,7 @@ out:
 
 static int show_vfsstat(struct seq_file *m, struct vfsmount *mnt)
 {
-	struct proc_mounts *p = proc_mounts(m);
+	struct proc_mounts *p = m->private;
 	struct mount *r = real_mount(mnt);
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
 	struct super_block *sb = mnt_path.dentry->d_sb;
@@ -236,6 +237,7 @@ static int mounts_open_common(struct ino
 	struct mnt_namespace *ns = NULL;
 	struct path root;
 	struct proc_mounts *p;
+	struct seq_file *m;
 	int ret = -EINVAL;
 
 	if (!task)
@@ -260,26 +262,21 @@ static int mounts_open_common(struct ino
 	task_unlock(task);
 	put_task_struct(task);
 
-	ret = -ENOMEM;
-	p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
-	if (!p)
+	ret = seq_open_private(file, &mounts_op, sizeof(struct proc_mounts));
+	if (ret)
 		goto err_put_path;
 
-	file->private_data = &p->m;
-	ret = seq_open(file, &mounts_op);
-	if (ret)
-		goto err_free;
+	m = file->private_data;
+	m->poll_event = ns->event;
 
+	p = m->private;
 	p->ns = ns;
 	p->root = root;
-	p->m.poll_event = ns->event;
 	p->show = show;
 	p->cached_event = ~0ULL;
 
 	return 0;
 
- err_free:
-	kfree(p);
  err_put_path:
 	path_put(&root);
  err_put_ns:
@@ -290,10 +287,11 @@ static int mounts_open_common(struct ino
 
 static int mounts_release(struct inode *inode, struct file *file)
 {
-	struct proc_mounts *p = proc_mounts(file->private_data);
+	struct seq_file *m = file->private_data;
+	struct proc_mounts *p = m->private;
 	path_put(&p->root);
 	put_mnt_ns(p->ns);
-	return seq_release(inode, file);
+	return seq_release_private(inode, file);
 }
 
 static int mounts_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from ydroneaud@opteya.com are


