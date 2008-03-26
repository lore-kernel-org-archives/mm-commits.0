From: akpm@linux-foundation.org
Subject: + vfs-mountinfo-add-proc-pid-mountinfo.patch added to -mm tree
Date: Wed, 26 Mar 2008 15:04:45 -0700
Message-ID: <200803262204.m2QM4jBP004231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755514AbYCZWFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 18:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linuxram@us.ibm.com, hch@lst.de, mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     vfs: mountinfo: add /proc/<pid>/mountinfo
has been added to the -mm tree.  Its filename is
     vfs-mountinfo-add-proc-pid-mountinfo.patch

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
Subject: vfs: mountinfo: add /proc/<pid>/mountinfo
From: Ram Pai <linuxram@us.ibm.com>

/proc/mounts in its current form lacks important information:

 - propagation state
 - root of mount for bind mounts
 - the st_dev value used within the filesystem
 - identifier for each mount and it's parent

It also suffers from the following problems:

 - not easily extendable
 - ambiguity of mountpoints within a chrooted environment
 - doesn't distinguish between filesystem dependent and independent options
 - doesn't distinguish between per mount and per super block options

This patch introduces /proc/<pid>/mountinfo which attempts to address
all these deficiencies.

Code shared between /proc/<pid>/mounts and /proc/<pid>/mountinfo is
extracted into separate functions.

Thanks to Al Viro for the help in getting the design right.

[mszeredi@suse.cz: rewrite and split big patch into managable chunks]
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   33 +++++++
 fs/namespace.c                     |  121 +++++++++++++++++++++------
 fs/proc/base.c                     |   15 +++
 include/linux/mnt_namespace.h      |    1 
 4 files changed, 147 insertions(+), 23 deletions(-)

diff -puN Documentation/filesystems/proc.txt~vfs-mountinfo-add-proc-pid-mountinfo Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~vfs-mountinfo-add-proc-pid-mountinfo
+++ a/Documentation/filesystems/proc.txt
@@ -43,6 +43,7 @@ Table of Contents
   2.13	/proc/<pid>/oom_score - Display current oom-killer score
   2.14	/proc/<pid>/io - Display the IO accounting fields
   2.15	/proc/<pid>/coredump_filter - Core dump filtering settings
+  2.16	/proc/<pid>/mountinfo - Information about mounts
 
 ------------------------------------------------------------------------------
 Preface
@@ -2348,4 +2349,36 @@ For example:
   $ echo 0x7 > /proc/self/coredump_filter
   $ ./some_program
 
+2.16	/proc/<pid>/mountinfo - Information about mounts
+--------------------------------------------------------
+
+This file contains lines of the form:
+
+36 35 98:0 /mnt1 /mnt2 rw,noatime rw master:1 - ext3 /dev/root,errors=continue
+(1)(2)(3)   (4)   (5)      (6)    (7)  (8)   (9) (10)   (11)      (12)
+
+(1) mount ID:  unique identifier of the mount (may be reused after umount)
+(2) parent ID:  ID of parent (or of self for the top of the mount tree)
+(3) major:minor:  value of st_dev for files on filesystem
+(4) root:  root of the mount within the filesystem
+(5) mount point:  mount point relative to the process's root
+(6) mount options:  per mount options
+(7) super options:  filesystem type independent, per super block options
+(8) optional fields:  zero or more fields of the form "tag[:value]"
+(9) separator:  marks the end of the optional fields
+(10) filesystem type:  name of filesystem of the form "type[.subtype]"
+(11) mount source:  filesystem specific information or "none"
+(12) filesystem options:  filesystem type dependent options
+
+Parsers should ignore all unrecognised optional fields.  Currently the
+possible optional fields are:
+
+shared:X  mount is shared in peer group X
+master:X  mount is slave to peer group X
+unbindable  mount is unbindable
+
+For more information on mount propagation see:
+
+  Documentation/filesystems/sharedsubtree.txt
+
 ------------------------------------------------------------------------------
diff -puN fs/namespace.c~vfs-mountinfo-add-proc-pid-mountinfo fs/namespace.c
--- a/fs/namespace.c~vfs-mountinfo-add-proc-pid-mountinfo
+++ a/fs/namespace.c
@@ -753,20 +753,30 @@ static void m_stop(struct seq_file *m, v
 	up_read(&namespace_sem);
 }
 
-static int show_vfsmnt(struct seq_file *m, void *v)
+struct proc_fs_info {
+	int flag;
+	const char *str;
+};
+
+static void show_sb_opts(struct seq_file *m, struct super_block *sb)
 {
-	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
-	int err = 0;
-	static struct proc_fs_info {
-		int flag;
-		char *str;
-	} fs_info[] = {
+	static const struct proc_fs_info fs_info[] = {
 		{ MS_SYNCHRONOUS, ",sync" },
 		{ MS_DIRSYNC, ",dirsync" },
 		{ MS_MANDLOCK, ",mand" },
 		{ 0, NULL }
 	};
-	static struct proc_fs_info mnt_info[] = {
+	const struct proc_fs_info *fs_infop;
+
+	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
+		if (sb->s_flags & fs_infop->flag)
+			seq_puts(m, fs_infop->str);
+	}
+}
+
+static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
+{
+	static const struct proc_fs_info mnt_info[] = {
 		{ MNT_NOSUID, ",nosuid" },
 		{ MNT_NODEV, ",nodev" },
 		{ MNT_NOEXEC, ",noexec" },
@@ -775,27 +785,37 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_RELATIME, ",relatime" },
 		{ 0, NULL }
 	};
-	struct proc_fs_info *fs_infop;
+	const struct proc_fs_info *fs_infop;
+
+	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
+		if (mnt->mnt_flags & fs_infop->flag)
+			seq_puts(m, fs_infop->str);
+	}
+}
+
+static void show_type(struct seq_file *m, struct super_block *sb)
+{
+	mangle(m, sb->s_type->name);
+	if (sb->s_subtype && sb->s_subtype[0]) {
+		seq_putc(m, '.');
+		mangle(m, sb->s_subtype);
+	}
+}
+
+static int show_vfsmnt(struct seq_file *m, void *v)
+{
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
+	int err = 0;
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
 
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_putc(m, ' ');
 	seq_path(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
-	mangle(m, mnt->mnt_sb->s_type->name);
-	if (mnt->mnt_sb->s_subtype && mnt->mnt_sb->s_subtype[0]) {
-		seq_putc(m, '.');
-		mangle(m, mnt->mnt_sb->s_subtype);
-	}
+	show_type(m, mnt->mnt_sb);
 	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
-	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
-		if (mnt->mnt_sb->s_flags & fs_infop->flag)
-			seq_puts(m, fs_infop->str);
-	}
-	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
-		if (mnt->mnt_flags & fs_infop->flag)
-			seq_puts(m, fs_infop->str);
-	}
+	show_sb_opts(m, mnt->mnt_sb);
+	show_mnt_opts(m, mnt);
 	if (mnt->mnt_sb->s_op->show_options)
 		err = mnt->mnt_sb->s_op->show_options(m, mnt);
 	seq_puts(m, " 0 0\n");
@@ -809,6 +829,61 @@ const struct seq_operations mounts_op = 
 	.show	= show_vfsmnt
 };
 
+static int show_mountinfo(struct seq_file *m, void *v)
+{
+	struct proc_mounts *p = m->private;
+	size_t count_save = m->count;
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
+	struct super_block *sb = mnt->mnt_sb;
+	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
+	struct path root = p->root;
+	int err = 0;
+
+	seq_printf(m, "%i %i %u:%u ", mnt->mnt_id, mnt->mnt_parent->mnt_id,
+		   MAJOR(sb->s_dev), MINOR(sb->s_dev));
+	seq_dentry(m, mnt->mnt_root, " \t\n\\");
+	seq_putc(m, ' ');
+	seq_path_root(m, &mnt_path, &root, " \t\n\\");
+	if (root.mnt != p->root.mnt || root.dentry != p->root.dentry) {
+		/*
+		 * Mountpoint is outside root, rewind seq_file. Ugly,
+		 * but necessary for race-free detection of unreachable
+		 * mountpoints.
+		 */
+		m->count = count_save;
+		return 0;
+	}
+	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? " ro" : " rw");
+	show_mnt_opts(m, mnt);
+	seq_puts(m, sb->s_flags & MS_RDONLY ? " ro" : " rw");
+	show_sb_opts(m, sb);
+
+	/* Tagged fields ("foo:X" or "bar") */
+	if (IS_MNT_SHARED(mnt))
+		seq_printf(m, " shared:%i", mnt->mnt_group_id);
+	if (IS_MNT_SLAVE(mnt))
+		seq_printf(m, " master:%i", mnt->mnt_master->mnt_group_id);
+	if (IS_MNT_UNBINDABLE(mnt))
+		seq_puts(m, " unbindable");
+
+	/* Filesystem specific data */
+	seq_puts(m, " - ");
+	show_type(m, sb);
+	seq_putc(m, ' ');
+	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
+	if (sb->s_op->show_options)
+		err = sb->s_op->show_options(m, mnt);
+	seq_putc(m, '\n');
+	return err;
+}
+
+const struct seq_operations mountinfo_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= show_mountinfo,
+};
+
 static int show_vfsstat(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
@@ -829,7 +904,7 @@ static int show_vfsstat(struct seq_file 
 
 	/* file system type */
 	seq_puts(m, "with fstype ");
-	mangle(m, mnt->mnt_sb->s_type->name);
+	show_type(m, mnt->mnt_sb);
 
 	/* optional statistics */
 	if (mnt->mnt_sb->s_op->show_stats) {
diff -puN fs/proc/base.c~vfs-mountinfo-add-proc-pid-mountinfo fs/proc/base.c
--- a/fs/proc/base.c~vfs-mountinfo-add-proc-pid-mountinfo
+++ a/fs/proc/base.c
@@ -604,6 +604,19 @@ static const struct file_operations proc
 	.poll		= mounts_poll,
 };
 
+static int mountinfo_open(struct inode *inode, struct file *file)
+{
+	return mounts_open_common(inode, file, &mountinfo_op);
+}
+
+static const struct file_operations proc_mountinfo_operations = {
+	.open		= mountinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= mounts_release,
+	.poll		= mounts_poll,
+};
+
 static int mountstats_open(struct inode *inode, struct file *file)
 {
 	return mounts_open_common(inode, file, &mountstats_op);
@@ -2305,6 +2318,7 @@ static const struct pid_entry tgid_base_
 	LNK("root",       root),
 	LNK("exe",        exe),
 	REG("mounts",     S_IRUGO, mounts),
+	REG("mountinfo",  S_IRUGO, mountinfo),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
@@ -2637,6 +2651,7 @@ static const struct pid_entry tid_base_s
 	LNK("root",      root),
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
+	REG("mountinfo",  S_IRUGO, mountinfo),
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
diff -puN include/linux/mnt_namespace.h~vfs-mountinfo-add-proc-pid-mountinfo include/linux/mnt_namespace.h
--- a/include/linux/mnt_namespace.h~vfs-mountinfo-add-proc-pid-mountinfo
+++ a/include/linux/mnt_namespace.h
@@ -46,6 +46,7 @@ static inline void get_mnt_ns(struct mnt
 }
 
 extern const struct seq_operations mounts_op;
+extern const struct seq_operations mountinfo_op;
 extern const struct seq_operations mountstats_op;
 
 #endif
_

Patches currently in -mm which might be from linuxram@us.ibm.com are

vfs-mountinfo-add-dentry_path.patch
vfs-mountinfo-add-seq_file_root.patch
vfs-mountinfo-add-mount-id.patch
vfs-mountinfo-add-mount-peer-group-id.patch
vfs-mountinfo-allow-using-process-root.patch
vfs-mountinfo-add-proc-pid-mountinfo.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-mountinfo-mm-fix.patch

