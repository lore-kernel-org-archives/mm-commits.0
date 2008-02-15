From: akpm@linux-foundation.org
Subject: - keep-track-of-mnt_writer-state-of-struct-file.patch removed from -mm tree
Date: Thu, 14 Feb 2008 21:31:37 -0800
Message-ID: <200802150531.m1F5VbV7021810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850AbYBOFie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 00:38:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     keep track of mnt_writer state of struct file
has been removed from the -mm tree.  Its filename was
     keep-track-of-mnt_writer-state-of-struct-file.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keep track of mnt_writer state of struct file
From: Dave Hansen <haveblue@us.ibm.com>

There have been a few oopses caused by 'struct file's with NULL f_vfsmnts. 
There was also a set of potentially missed mnt_want_write()s from
dentry_open() calls.

This patch provides a very simple debugging framework to catch these kinds of
bugs.  It will WARN_ON() them, but should stop us from having any oopses or
mnt_writer count imbalances.

I'm quite convinced that this is a good thing because it found bugs in the
stuff I was working on as soon as I wrote it.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c    |   21 +++++++++++++++++++--
 fs/open.c          |   14 +++++++++++++-
 fs/super.c         |   22 ++++++++++++++++++++--
 include/linux/fs.h |    4 ++++
 4 files changed, 56 insertions(+), 5 deletions(-)

diff -puN fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file fs/file_table.c
--- a/fs/file_table.c~keep-track-of-mnt_writer-state-of-struct-file
+++ a/fs/file_table.c
@@ -42,6 +42,12 @@ static inline void file_free_rcu(struct 
 static inline void file_free(struct file *f)
 {
 	percpu_counter_dec(&nr_files);
+	/*
+	 * At this point, either both or neither of these bits
+	 * should be set.
+	 */
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_RELEASED);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -201,6 +207,7 @@ int init_file(struct file *file, struct 
 	 * that we can do debugging checks at __fput()e
 	 */
 	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		file->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
 		error = mnt_want_write(mnt);
 		WARN_ON(error);
 	}
@@ -243,8 +250,18 @@ void __fput(struct file *file)
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode))
-			mnt_drop_write(mnt);
+		if (!special_file(inode->i_mode)) {
+			if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
+				mnt_drop_write(mnt);
+				file->f_mnt_write_state |=
+					FILE_MNT_WRITE_RELEASED;
+			} else {
+				printk(KERN_WARNING "__fput() of writeable "
+						"file with no "
+						"mnt_want_write()\n");
+				WARN_ON(1);
+			}
+		}
 	}
 	put_pid(file->f_owner.pid);
 	file_kill(file);
diff -puN fs/open.c~keep-track-of-mnt_writer-state-of-struct-file fs/open.c
--- a/fs/open.c~keep-track-of-mnt_writer-state-of-struct-file
+++ a/fs/open.c
@@ -810,6 +810,10 @@ static struct file *__dentry_open(struct
 		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
+		if (!special_file(inode->i_mode)) {
+			WARN_ON(f->f_mnt_write_state != 0);
+			f->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
+		}
 	}
 
 	f->f_mapping = inode->i_mapping;
@@ -851,8 +855,16 @@ cleanup_all:
 	fops_put(f->f_op);
 	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
-		if (!special_file(inode->i_mode))
+		if (!special_file(inode->i_mode)) {
+			/*
+			 * We don't consider this a real
+			 * mnt_want/drop_write() pair
+			 * because it all happenend right
+			 * here, so just reset the state.
+			 */
+			f->f_mnt_write_state = 0;
 			mnt_drop_write(mnt);
+		}
 	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
diff -puN fs/super.c~keep-track-of-mnt_writer-state-of-struct-file fs/super.c
--- a/fs/super.c~keep-track-of-mnt_writer-state-of-struct-file
+++ a/fs/super.c
@@ -37,6 +37,7 @@
 #include <linux/idr.h>
 #include <linux/kobject.h>
 #include <linux/mutex.h>
+#include <linux/file.h>
 #include <asm/uaccess.h>
 
 
@@ -567,10 +568,27 @@ static void mark_files_ro(struct super_b
 {
 	struct file *f;
 
+retry:
 	file_list_lock();
 	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
-		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
-			f->f_mode &= ~FMODE_WRITE;
+		struct vfsmount *mnt;
+
+		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
+		       continue;
+		if (!file_count(f))
+			continue;
+		if (!(f->f_mode & FMODE_WRITE))
+			continue;
+		f->f_mode &= ~FMODE_WRITE;
+		f->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
+		mnt = f->f_path.mnt;
+		file_list_unlock();
+		/*
+		 * This can sleep, so we can't hold
+		 * the file_list_lock() spinlock.
+		 */
+		mnt_drop_write(mnt);
+		goto retry;
 	}
 	file_list_unlock();
 }
diff -puN include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file include/linux/fs.h
--- a/include/linux/fs.h~keep-track-of-mnt_writer-state-of-struct-file
+++ a/include/linux/fs.h
@@ -776,6 +776,9 @@ static inline int ra_has_index(struct fi
 		index <  ra->start + ra->size);
 }
 
+#define FILE_MNT_WRITE_TAKEN	1
+#define FILE_MNT_WRITE_RELEASED	2
+
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
@@ -810,6 +813,7 @@ struct file {
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+	unsigned long f_mnt_write_state;
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
