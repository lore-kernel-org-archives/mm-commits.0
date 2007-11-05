From: akpm@linux-foundation.org
Subject: + d_path-make-seq_path-use-a-struct-path-argument.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:11:42 -0800
Message-ID: <200711052111.lA5LBgdq019966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbXKEVMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bfields@fieldses.org, hch@lst.de, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     d_path: Make seq_path() use a struct path argument
has been added to the -mm tree.  Its filename is
     d_path-make-seq_path-use-a-struct-path-argument.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: d_path: Make seq_path() use a struct path argument
From: Jan Blunck <jblunck@suse.de>

seq_path() is always called with a dentry and a vfsmount from a struct path. 
Make seq_path() take it directly as an argument.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c          |    3 +--
 fs/namespace.c           |    6 ++++--
 fs/nfsd/export.c         |    4 ++--
 fs/proc/nommu.c          |    2 +-
 fs/proc/task_mmu.c       |    2 +-
 fs/seq_file.c            |    7 +++----
 include/linux/seq_file.h |    5 ++---
 mm/mempolicy.c           |    2 +-
 mm/swapfile.c            |    2 +-
 9 files changed, 16 insertions(+), 17 deletions(-)

diff -puN drivers/md/md.c~d_path-make-seq_path-use-a-struct-path-argument drivers/md/md.c
--- a/drivers/md/md.c~d_path-make-seq_path-use-a-struct-path-argument
+++ a/drivers/md/md.c
@@ -5018,8 +5018,7 @@ static int md_seq_show(struct seq_file *
 				chunk_kb ? "KB" : "B");
 			if (bitmap->file) {
 				seq_printf(seq, ", file: ");
-				seq_path(seq, bitmap->file->f_path.mnt,
-					 bitmap->file->f_path.dentry," \t\n");
+				seq_path(seq, &bitmap->file->f_path, " \t\n");
 			}
 
 			seq_printf(seq, "\n");
diff -puN fs/namespace.c~d_path-make-seq_path-use-a-struct-path-argument fs/namespace.c
--- a/fs/namespace.c~d_path-make-seq_path-use-a-struct-path-argument
+++ a/fs/namespace.c
@@ -684,10 +684,11 @@ static int show_vfsmnt(struct seq_file *
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
+	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
 
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_putc(m, ' ');
-	seq_path(m, mnt, mnt->mnt_root, " \t\n\\");
+	seq_path(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
 	mangle(m, mnt->mnt_sb->s_type->name);
 	if (mnt->mnt_sb->s_subtype && mnt->mnt_sb->s_subtype[0]) {
@@ -721,6 +722,7 @@ struct seq_operations mounts_op = {
 static int show_vfsstat(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
+	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
 	int err = 0;
 
 	/* device */
@@ -732,7 +734,7 @@ static int show_vfsstat(struct seq_file 
 
 	/* mount point */
 	seq_puts(m, " mounted on ");
-	seq_path(m, mnt, mnt->mnt_root, " \t\n\\");
+	seq_path(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
 
 	/* file system type */
diff -puN fs/nfsd/export.c~d_path-make-seq_path-use-a-struct-path-argument fs/nfsd/export.c
--- a/fs/nfsd/export.c~d_path-make-seq_path-use-a-struct-path-argument
+++ a/fs/nfsd/export.c
@@ -203,7 +203,7 @@ static int expkey_show(struct seq_file *
 	if (test_bit(CACHE_VALID, &h->flags) && 
 	    !test_bit(CACHE_NEGATIVE, &h->flags)) {
 		seq_printf(m, " ");
-		seq_path(m, ek->ek_path.mnt, ek->ek_path.dentry, "\\ \t\n");
+		seq_path(m, &ek->ek_path, "\\ \t\n");
 	}
 	seq_printf(m, "\n");
 	return 0;
@@ -649,7 +649,7 @@ static int svc_export_show(struct seq_fi
 		return 0;
 	}
 	exp = container_of(h, struct svc_export, h);
-	seq_path(m, exp->ex_path.mnt, exp->ex_path.dentry, " \t\n\\");
+	seq_path(m, &exp->ex_path, " \t\n\\");
 	seq_putc(m, '\t');
 	seq_escape(m, exp->ex_client->name, " \t\n\\");
 	seq_putc(m, '(');
diff -puN fs/proc/nommu.c~d_path-make-seq_path-use-a-struct-path-argument fs/proc/nommu.c
--- a/fs/proc/nommu.c~d_path-make-seq_path-use-a-struct-path-argument
+++ a/fs/proc/nommu.c
@@ -67,7 +67,7 @@ int nommu_vma_show(struct seq_file *m, s
 		if (len < 1)
 			len = 1;
 		seq_printf(m, "%*c", len, ' ');
-		seq_path(m, file->f_path.mnt, file->f_path.dentry, "");
+		seq_path(m, &file->f_path, "");
 	}
 
 	seq_putc(m, '\n');
diff -puN fs/proc/task_mmu.c~d_path-make-seq_path-use-a-struct-path-argument fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~d_path-make-seq_path-use-a-struct-path-argument
+++ a/fs/proc/task_mmu.c
@@ -272,7 +272,7 @@ static int show_map(struct seq_file *m, 
 	 */
 	if (file) {
 		pad_len_spaces(m, len);
-		seq_path(m, file->f_path.mnt, file->f_path.dentry, "\n");
+		seq_path(m, &file->f_path, "\n");
 	} else {
 		const char *name = arch_vma_name(vma);
 		if (!name) {
diff -puN fs/seq_file.c~d_path-make-seq_path-use-a-struct-path-argument fs/seq_file.c
--- a/fs/seq_file.c~d_path-make-seq_path-use-a-struct-path-argument
+++ a/fs/seq_file.c
@@ -342,13 +342,12 @@ int seq_printf(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_printf);
 
-int seq_path(struct seq_file *m,
-	     struct vfsmount *mnt, struct dentry *dentry,
-	     char *esc)
+int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
-		char *p = d_path(dentry, mnt, s, m->size - m->count);
+		char *p = d_path(path->dentry, path->mnt, s,
+				 m->size - m->count);
 		if (!IS_ERR(p)) {
 			while (s <= p) {
 				char c = *p++;
diff -puN include/linux/seq_file.h~d_path-make-seq_path-use-a-struct-path-argument include/linux/seq_file.h
--- a/include/linux/seq_file.h~d_path-make-seq_path-use-a-struct-path-argument
+++ a/include/linux/seq_file.h
@@ -8,8 +8,7 @@
 
 struct seq_operations;
 struct file;
-struct vfsmount;
-struct dentry;
+struct path;
 struct inode;
 
 struct seq_file {
@@ -42,7 +41,7 @@ int seq_puts(struct seq_file *m, const c
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
 
-int seq_path(struct seq_file *, struct vfsmount *, struct dentry *, char *);
+int seq_path(struct seq_file *, struct path *, char *);
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
diff -puN mm/mempolicy.c~d_path-make-seq_path-use-a-struct-path-argument mm/mempolicy.c
--- a/mm/mempolicy.c~d_path-make-seq_path-use-a-struct-path-argument
+++ a/mm/mempolicy.c
@@ -1968,7 +1968,7 @@ int show_numa_map(struct seq_file *m, vo
 
 	if (file) {
 		seq_printf(m, " file=");
-		seq_path(m, file->f_path.mnt, file->f_path.dentry, "\n\t= ");
+		seq_path(m, &file->f_path, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_printf(m, " heap");
 	} else if (vma->vm_start <= mm->start_stack &&
diff -puN mm/swapfile.c~d_path-make-seq_path-use-a-struct-path-argument mm/swapfile.c
--- a/mm/swapfile.c~d_path-make-seq_path-use-a-struct-path-argument
+++ a/mm/swapfile.c
@@ -1371,7 +1371,7 @@ static int swap_show(struct seq_file *sw
 	}
 
 	file = ptr->swap_file;
-	len = seq_path(swap, file->f_path.mnt, file->f_path.dentry, " \t\n\\");
+	len = seq_path(swap, &file->f_path, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%u\t%u\t%d\n",
 		       len < 40 ? 40 - len : 1, " ",
 		       S_ISBLK(file->f_path.dentry->d_inode->i_mode) ?
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
