From: akpm@linux-foundation.org
Subject: - mount-options-add-generic_show_options.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:30 -0800
Message-ID: <200802082019.m18KJBUh011009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761192AbYBHUcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:32:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mount options: add generic_show_options()
has been removed from the -mm tree.  Its filename was
     mount-options-add-generic_show_options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -320,6 +320,50 @@ void mnt_unpin(struct vfsmount *mnt)
 
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
@@ -341,11 +385,6 @@ static void m_stop(struct seq_file *m, v
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
@@ -105,6 +105,7 @@ static inline void destroy_super(struct 
 {
 	security_sb_free(s);
 	kfree(s->s_subtype);
+	kfree(s->s_options);
 	kfree(s);
 }
 
diff -puN include/linux/fs.h~mount-options-add-generic_show_options include/linux/fs.h
--- a/include/linux/fs.h~mount-options-add-generic_show_options
+++ a/include/linux/fs.h
@@ -1038,6 +1038,12 @@ struct super_block {
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
@@ -1970,6 +1976,9 @@ extern int __must_check inode_setattr(st
 
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
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
