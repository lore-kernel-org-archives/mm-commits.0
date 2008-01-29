From: akpm@linux-foundation.org
Subject: + mount-options-add-generic_show_options.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:21:59 -0800
Message-ID: <200801292322.m0TNM0fG009653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbYA2XWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mount options: add generic_show_options()
has been added to the -mm tree.  Its filename is
     mount-options-add-generic_show_options.patch

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
Subject: mount options: add generic_show_options()
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new s_options field to struct super_block.  Filesystems can save
mount options passed to them in mount or remount.  It is automatically
freed when the superblock is destroyed.

A new helper function, generic_show_options() is introduced, which uses
this field to display the mount options in /proc/mounts.

Another helper function, save_mount_options() may be used by
filesystems to save the options in the super block.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |   49 ++++++++++++++++++++++++++++++++++++++-----
 fs/super.c         |    1 
 include/linux/fs.h |    9 +++++++
 3 files changed, 54 insertions(+), 5 deletions(-)

diff -puN fs/namespace.c~mount-options-add-generic_show_options fs/namespace.c
--- a/fs/namespace.c~mount-options-add-generic_show_options
+++ a/fs/namespace.c
@@ -575,6 +575,50 @@ void mnt_unpin(struct vfsmount *mnt)
 
 EXPORT_SYMBOL(mnt_unpin);
 
+static inline void mangle(struct seq_file *m, const char *s)
+{
+	seq_escape(m, s, " \t\n\\");
+}
+
+/*
+ * Simple .show_options callback for filesystems which don't want to
+ * implement more complex mount option showing.
+ *
+ * See also save_mount_options().
+ */
+int generic_show_options(struct seq_file *m, struct vfsmount *mnt)
+{
+	const char *options = mnt->mnt_sb->s_options;
+
+	if (options != NULL && options[0]) {
+		seq_putc(m, ',');
+		mangle(m, options);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(generic_show_options);
+
+/*
+ * If filesystem uses generic_show_options(), this function should be
+ * called from the fill_super() callback.
+ *
+ * The .remount_fs callback usually needs to be handled in a special
+ * way, to make sure, that previous options are not overwritten if the
+ * remount fails.
+ *
+ * Also note, that if the filesystem's .remount_fs function doesn't
+ * reset all options to their default value, but changes only newly
+ * given options, then the displayed options will not reflect reality
+ * any more.
+ */
+void save_mount_options(struct super_block *sb, char *options)
+{
+	kfree(sb->s_options);
+	sb->s_options = kstrdup(options, GFP_KERNEL);
+}
+EXPORT_SYMBOL(save_mount_options);
+
 /* iterator */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
@@ -596,11 +640,6 @@ static void m_stop(struct seq_file *m, v
 	up_read(&namespace_sem);
 }
 
-static inline void mangle(struct seq_file *m, const char *s)
-{
-	seq_escape(m, s, " \t\n\\");
-}
-
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
diff -puN fs/super.c~mount-options-add-generic_show_options fs/super.c
--- a/fs/super.c~mount-options-add-generic_show_options
+++ a/fs/super.c
@@ -106,6 +106,7 @@ static inline void destroy_super(struct 
 {
 	security_sb_free(s);
 	kfree(s->s_subtype);
+	kfree(s->s_options);
 	kfree(s);
 }
 
diff -puN include/linux/fs.h~mount-options-add-generic_show_options include/linux/fs.h
--- a/include/linux/fs.h~mount-options-add-generic_show_options
+++ a/include/linux/fs.h
@@ -1042,6 +1042,12 @@ struct super_block {
 	 * in /proc/mounts will be "type.subtype"
 	 */
 	char *s_subtype;
+
+	/*
+	 * Saved mount options for lazy filesystems using
+	 * generic_show_options()
+	 */
+	char *s_options;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
@@ -1973,6 +1979,9 @@ extern int __must_check inode_setattr(st
 
 extern void file_update_time(struct file *file);
 
+extern int generic_show_options(struct seq_file *m, struct vfsmount *mnt);
+extern void save_mount_options(struct super_block *sb, char *options);
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
