From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-debugging-for-missed-calls.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:49:34 -0800
Message-ID: <200802152249.m1FMnZXL028215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933246AbYBOW61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: debugging for missed calls
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-debugging-for-missed-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: debugging for missed calls
From: Dave Hansen <haveblue@us.ibm.com>

There have been a few oopses caused by 'struct file's with NULL f_vfsmnts. 
There was also a set of potentially missed mnt_want_write()s from
dentry_open() calls.

This patch provides a very simple debugging framework to catch these kinds of
bugs.  It will WARN_ON() them, but should stop us from having any oopses or
mnt_writer count imbalances.

I'm quite convinced that this is a good thing because it found bugs in the
stuff I was working on as soon as I wrote it.

[hch: made it conditional on a debug option.
      But it's still a little bit too ugly]

[hch: merged forced remount r/o fix from Dave and akpm's fix for the fix]

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c    |   11 +++++++--
 fs/open.c          |   12 +++++++++-
 fs/super.c         |    3 ++
 include/linux/fs.h |   49 +++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug  |   10 ++++++++
 5 files changed, 82 insertions(+), 3 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-debugging-for-missed-calls fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-debugging-for-missed-calls
+++ a/fs/file_table.c
@@ -42,6 +42,7 @@ static inline void file_free_rcu(struct 
 static inline void file_free(struct file *f)
 {
 	percpu_counter_dec(&nr_files);
+	file_check_state(f);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -207,6 +208,7 @@ int init_file(struct file *file, struct 
 	 * that we can do debugging checks at __fput()
 	 */
 	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		file_take_write(file);
 		error = mnt_want_write(mnt);
 		WARN_ON(error);
 	}
@@ -237,8 +239,13 @@ void drop_file_write_access(struct file 
 	struct inode *inode = dentry->d_inode;
 
 	put_write_access(inode);
-	if (!special_file(inode->i_mode))
-		mnt_drop_write(mnt);
+
+	if (special_file(inode->i_mode))
+		return;
+	if (file_check_writeable(file) != 0)
+		return;
+	mnt_drop_write(mnt);
+	file_release_write(file);
 }
 EXPORT_SYMBOL_GPL(drop_file_write_access);
 
diff -puN fs/open.c~r-o-bind-mounts-debugging-for-missed-calls fs/open.c
--- a/fs/open.c~r-o-bind-mounts-debugging-for-missed-calls
+++ a/fs/open.c
@@ -806,6 +806,8 @@ static struct file *__dentry_open(struct
 		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
+		if (!special_file(inode->i_mode))
+			file_take_write(f);
 	}
 
 	f->f_mapping = inode->i_mapping;
@@ -847,8 +849,16 @@ cleanup_all:
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
+			file_reset_write(f);
 			mnt_drop_write(mnt);
+		}
 	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
diff -puN fs/super.c~r-o-bind-mounts-debugging-for-missed-calls fs/super.c
--- a/fs/super.c~r-o-bind-mounts-debugging-for-missed-calls
+++ a/fs/super.c
@@ -579,6 +579,9 @@ retry:
 		if (!(f->f_mode & FMODE_WRITE))
 			continue;
 		f->f_mode &= ~FMODE_WRITE;
+		if (file_check_writeable(f) != 0)
+			continue;
+		file_release_write(f);
 		mnt = f->f_path.mnt;
 		file_list_unlock();
 		/*
diff -puN include/linux/fs.h~r-o-bind-mounts-debugging-for-missed-calls include/linux/fs.h
--- a/include/linux/fs.h~r-o-bind-mounts-debugging-for-missed-calls
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
@@ -810,6 +813,9 @@ struct file {
 	spinlock_t		f_ep_lock;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+#ifdef CONFIG_DEBUG_WRITECOUNT
+	unsigned long f_mnt_write_state;
+#endif
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
@@ -818,6 +824,49 @@ extern spinlock_t files_lock;
 #define get_file(x)	atomic_inc(&(x)->f_count)
 #define file_count(x)	atomic_read(&(x)->f_count)
 
+#ifdef CONFIG_DEBUG_WRITECOUNT
+static inline void file_take_write(struct file *f)
+{
+	WARN_ON(f->f_mnt_write_state != 0);
+	f->f_mnt_write_state = FILE_MNT_WRITE_TAKEN;
+}
+static inline void file_release_write(struct file *f)
+{
+	f->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
+}
+static inline void file_reset_write(struct file *f)
+{
+	f->f_mnt_write_state = 0;
+}
+static inline void file_check_state(struct file *f)
+{
+	/*
+	 * At this point, either both or neither of these bits
+	 * should be set.
+	 */
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);
+	WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_RELEASED);
+}
+static inline int file_check_writeable(struct file *f)
+{
+	if (f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN)
+		return 0;
+	printk(KERN_WARNING "writeable file with no "
+			    "mnt_want_write()\n");
+	WARN_ON(1);
+	return -EINVAL;
+}
+#else /* !CONFIG_DEBUG_WRITECOUNT */
+static inline void file_take_write(struct file *filp) {}
+static inline void file_release_write(struct file *filp) {}
+static inline void file_reset_write(struct file *filp) {}
+static inline void file_check_state(struct file *filp) {}
+static inline int file_check_writeable(struct file *filp)
+{
+	return 0;
+}
+#endif /* CONFIG_DEBUG_WRITECOUNT */
+
 #define	MAX_NON_LFS	((1UL<<31) - 1)
 
 /* Page cache limit. The filesystems should put that into their s_maxbytes 
diff -puN lib/Kconfig.debug~r-o-bind-mounts-debugging-for-missed-calls lib/Kconfig.debug
--- a/lib/Kconfig.debug~r-o-bind-mounts-debugging-for-missed-calls
+++ a/lib/Kconfig.debug
@@ -434,6 +434,16 @@ config DEBUG_VM
 
 	  If unsure, say N.
 
+config DEBUG_WRITECOUNT
+	bool "Debug filesystem writers count"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to catch wrong use of the writers count in struct
+	  vfsmount.  This will increase the size of each file struct by
+	  32 bits.
+
+	  If unsure, say N.
+
 config DEBUG_LIST
 	bool "Debug linked list manipulation"
 	depends on DEBUG_KERNEL
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
