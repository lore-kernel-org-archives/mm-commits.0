From: akpm@osdl.org
Subject: - struct-path-convert-selinux.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:59 -0800
Message-ID: <200612082004.kB8K4xmh002247@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426314AbWLHUFE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert selinux
has been removed from the -mm tree.  Its filename was
     struct-path-convert-selinux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert selinux
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/selinux/hooks.c     |   20 ++++++++++----------
 security/selinux/selinuxfs.c |    8 ++++----
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN security/selinux/hooks.c~struct-path-convert-selinux security/selinux/hooks.c
--- a/security/selinux/hooks.c~struct-path-convert-selinux
+++ a/security/selinux/hooks.c
@@ -1120,8 +1120,8 @@ static int file_has_perm(struct task_str
 {
 	struct task_security_struct *tsec = tsk->security;
 	struct file_security_struct *fsec = file->f_security;
-	struct vfsmount *mnt = file->f_vfsmnt;
-	struct dentry *dentry = file->f_dentry;
+	struct vfsmount *mnt = file->f_path.mnt;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct avc_audit_data ad;
 	int rc;
@@ -1581,7 +1581,7 @@ static int selinux_bprm_alloc_security(s
 static int selinux_bprm_set_security(struct linux_binprm *bprm)
 {
 	struct task_security_struct *tsec;
-	struct inode *inode = bprm->file->f_dentry->d_inode;
+	struct inode *inode = bprm->file->f_path.dentry->d_inode;
 	struct inode_security_struct *isec;
 	struct bprm_security_struct *bsec;
 	u32 newsid;
@@ -1621,10 +1621,10 @@ static int selinux_bprm_set_security(str
 	}
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
-	ad.u.fs.mnt = bprm->file->f_vfsmnt;
-	ad.u.fs.dentry = bprm->file->f_dentry;
+	ad.u.fs.mnt = bprm->file->f_path.mnt;
+	ad.u.fs.dentry = bprm->file->f_path.dentry;
 
-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
+	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
 		newsid = tsec->sid;
 
         if (tsec->sid == newsid) {
@@ -1708,7 +1708,7 @@ static inline void flush_unauthorized_fi
 			   than using file_has_perm, as this particular open
 			   file may belong to another process and we are only
 			   interested in the inode-based check here. */
-			struct inode *inode = file->f_dentry->d_inode;
+			struct inode *inode = file->f_path.dentry->d_inode;
 			if (inode_has_perm(current, inode,
 					   FILE__READ | FILE__WRITE, NULL)) {
 				drop_tty = 1;
@@ -2420,7 +2420,7 @@ static int selinux_inode_listsecurity(st
 static int selinux_file_permission(struct file *file, int mask)
 {
 	int rc;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 
 	if (!mask) {
 		/* No permission to check.  Existence test. */
@@ -2597,7 +2597,7 @@ static int selinux_file_fcntl(struct fil
 
 	switch (cmd) {
 	        case F_SETFL:
-			if (!file->f_dentry || !file->f_dentry->d_inode) {
+			if (!file->f_path.dentry || !file->f_path.dentry->d_inode) {
 				err = -EINVAL;
 				break;
 			}
@@ -2623,7 +2623,7 @@ static int selinux_file_fcntl(struct fil
 		case F_SETLK64:
 	        case F_SETLKW64:
 #endif
-			if (!file->f_dentry || !file->f_dentry->d_inode) {
+			if (!file->f_path.dentry || !file->f_path.dentry->d_inode) {
 				err = -EINVAL;
 				break;
 			}
diff -puN security/selinux/selinuxfs.c~struct-path-convert-selinux security/selinux/selinuxfs.c
--- a/security/selinux/selinuxfs.c~struct-path-convert-selinux
+++ a/security/selinux/selinuxfs.c
@@ -448,7 +448,7 @@ static ssize_t (*write_op[])(struct file
 
 static ssize_t selinux_transaction_write(struct file *file, const char __user *buf, size_t size, loff_t *pos)
 {
-	ino_t ino =  file->f_dentry->d_inode->i_ino;
+	ino_t ino =  file->f_path.dentry->d_inode->i_ino;
 	char *data;
 	ssize_t rv;
 
@@ -805,7 +805,7 @@ static ssize_t sel_read_bool(struct file
 		goto out;
 	}
 
-	inode = filep->f_dentry->d_inode;
+	inode = filep->f_path.dentry->d_inode;
 	cur_enforcing = security_get_bool_value(inode->i_ino - BOOL_INO_OFFSET);
 	if (cur_enforcing < 0) {
 		ret = cur_enforcing;
@@ -864,7 +864,7 @@ static ssize_t sel_write_bool(struct fil
 	if (new_value)
 		new_value = 1;
 
-	inode = filep->f_dentry->d_inode;
+	inode = filep->f_path.dentry->d_inode;
 	bool_pending_values[inode->i_ino - BOOL_INO_OFFSET] = new_value;
 	length = count;
 
@@ -965,7 +965,7 @@ static void sel_remove_bools(struct dent
 	file_list_lock();
 	list_for_each(p, &sb->s_files) {
 		struct file * filp = list_entry(p, struct file, f_u.fu_list);
-		struct dentry * dentry = filp->f_dentry;
+		struct dentry * dentry = filp->f_path.dentry;
 
 		if (dentry->d_parent != de) {
 			continue;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

