From: akpm@linux-foundation.org
Subject: [merged] ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:55 -0800
Message-ID: <200912162036.nBGKat1a013275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935488AbZLPUhL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dushistov@mail.ru, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     ufs: pass qstr instead of dentry where necessary for NFS
has been removed from the -mm tree.  Its filename was
     ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: pass qstr instead of dentry where necessary for NFS
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c   |   10 +++++-----
 fs/ufs/namei.c |    8 ++++----
 fs/ufs/ufs.h   |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/ufs/dir.c~ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs fs/ufs/dir.c
--- a/fs/ufs/dir.c~ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs
+++ a/fs/ufs/dir.c
@@ -70,13 +70,13 @@ static inline unsigned long ufs_dir_page
 	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
 }
 
-ino_t ufs_inode_by_name(struct inode *dir, struct dentry *dentry)
+ino_t ufs_inode_by_name(struct inode *dir, struct qstr *qstr)
 {
 	ino_t res = 0;
 	struct ufs_dir_entry *de;
 	struct page *page;
 	
-	de = ufs_find_entry(dir, dentry, &page);
+	de = ufs_find_entry(dir, qstr, &page);
 	if (de) {
 		res = fs32_to_cpu(dir->i_sb, de->d_ino);
 		ufs_put_page(page);
@@ -249,12 +249,12 @@ struct ufs_dir_entry *ufs_dotdot(struct 
  * (as a parameter - res_dir). Page is returned mapped and unlocked.
  * Entry is guaranteed to be valid.
  */
-struct ufs_dir_entry *ufs_find_entry(struct inode *dir, struct dentry *dentry,
+struct ufs_dir_entry *ufs_find_entry(struct inode *dir, struct qstr *qstr,
 				     struct page **res_page)
 {
 	struct super_block *sb = dir->i_sb;
-	const char *name = dentry->d_name.name;
-	int namelen = dentry->d_name.len;
+	const char *name = qstr->name;
+	int namelen = qstr->len;
 	unsigned reclen = UFS_DIR_REC_LEN(namelen);
 	unsigned long start, n;
 	unsigned long npages = ufs_dir_pages(dir);
diff -puN fs/ufs/namei.c~ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs fs/ufs/namei.c
--- a/fs/ufs/namei.c~ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs
+++ a/fs/ufs/namei.c
@@ -56,7 +56,7 @@ static struct dentry *ufs_lookup(struct 
 		return ERR_PTR(-ENAMETOOLONG);
 
 	lock_kernel();
-	ino = ufs_inode_by_name(dir, dentry);
+	ino = ufs_inode_by_name(dir, &dentry->d_name);
 	if (ino) {
 		inode = ufs_iget(dir->i_sb, ino);
 		if (IS_ERR(inode)) {
@@ -237,7 +237,7 @@ static int ufs_unlink(struct inode *dir,
 	struct page *page;
 	int err = -ENOENT;
 
-	de = ufs_find_entry(dir, dentry, &page);
+	de = ufs_find_entry(dir, &dentry->d_name, &page);
 	if (!de)
 		goto out;
 
@@ -281,7 +281,7 @@ static int ufs_rename(struct inode *old_
 	struct ufs_dir_entry *old_de;
 	int err = -ENOENT;
 
-	old_de = ufs_find_entry(old_dir, old_dentry, &old_page);
+	old_de = ufs_find_entry(old_dir, &old_dentry->d_name, &old_page);
 	if (!old_de)
 		goto out;
 
@@ -301,7 +301,7 @@ static int ufs_rename(struct inode *old_
 			goto out_dir;
 
 		err = -ENOENT;
-		new_de = ufs_find_entry(new_dir, new_dentry, &new_page);
+		new_de = ufs_find_entry(new_dir, &new_dentry->d_name, &new_page);
 		if (!new_de)
 			goto out_dir;
 		inode_inc_link_count(old_inode);
diff -puN fs/ufs/ufs.h~ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs
+++ a/fs/ufs/ufs.h
@@ -86,9 +86,9 @@ extern void ufs_put_cylinder (struct sup
 /* dir.c */
 extern const struct inode_operations ufs_dir_inode_operations;
 extern int ufs_add_link (struct dentry *, struct inode *);
-extern ino_t ufs_inode_by_name(struct inode *, struct dentry *);
+extern ino_t ufs_inode_by_name(struct inode *, struct qstr *);
 extern int ufs_make_empty(struct inode *, struct inode *);
-extern struct ufs_dir_entry *ufs_find_entry(struct inode *, struct dentry *, struct page **);
+extern struct ufs_dir_entry *ufs_find_entry(struct inode *, struct qstr *, struct page **);
 extern int ufs_delete_entry(struct inode *, struct ufs_dir_entry *, struct page *);
 extern int ufs_empty_dir (struct inode *);
 extern struct ufs_dir_entry *ufs_dotdot(struct inode *, struct page **);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch

