From: akpm@linux-foundation.org
Subject: + d_path-use-struct-path-in-struct-avc_audit_data.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:04:26 -0800
Message-ID: <200711052104.lA5L4Qbx019647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805AbXKEVEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:04:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bfields@fieldses.org, hch@infradead.org, jmorris@namei.org, neilb@suse.de, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     d_path: Use struct path in struct avc_audit_data
has been added to the -mm tree.  Its filename is
     d_path-use-struct-path-in-struct-avc_audit_data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: d_path: Use struct path in struct avc_audit_data
From: Jan Blunck <jblunck@suse.de>

audit_log_d_path() is a d_path() wrapper that is used by the audit code.  To
use a struct path in audit_log_d_path() I need to embed it into struct
avc_audit_data.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h          |    5 ++---
 kernel/audit.c                 |   12 ++++++------
 kernel/auditsc.c               |   28 +++++++++++-----------------
 security/selinux/avc.c         |   13 ++++++++-----
 security/selinux/hooks.c       |   28 ++++++++++++----------------
 security/selinux/include/avc.h |    6 ++----
 6 files changed, 41 insertions(+), 51 deletions(-)

diff -puN include/linux/audit.h~d_path-use-struct-path-in-struct-avc_audit_data include/linux/audit.h
--- a/include/linux/audit.h~d_path-use-struct-path-in-struct-avc_audit_data
+++ a/include/linux/audit.h
@@ -527,8 +527,7 @@ extern const char *	    audit_log_n_untr
 							const char *string);
 extern void		    audit_log_d_path(struct audit_buffer *ab,
 					     const char *prefix,
-					     struct dentry *dentry,
-					     struct vfsmount *vfsmnt);
+					     struct path *path);
 extern void		    audit_log_lost(const char *message);
 				/* Private API (for audit.c only) */
 extern int audit_filter_user(struct netlink_skb_parms *cb, int type);
@@ -545,7 +544,7 @@ extern int audit_enabled;
 #define audit_log_hex(a,b,l) do { ; } while (0)
 #define audit_log_untrustedstring(a,s) do { ; } while (0)
 #define audit_log_n_untrustedstring(a,n,s) do { ; } while (0)
-#define audit_log_d_path(b,p,d,v) do { ; } while (0)
+#define audit_log_d_path(b,p,d) do { ; } while (0)
 #define audit_enabled 0
 #endif
 #endif
diff -puN kernel/audit.c~d_path-use-struct-path-in-struct-avc_audit_data kernel/audit.c
--- a/kernel/audit.c~d_path-use-struct-path-in-struct-avc_audit_data
+++ a/kernel/audit.c
@@ -1389,26 +1389,26 @@ const char *audit_log_untrustedstring(st
 
 /* This is a helper-function to print the escaped d_path */
 void audit_log_d_path(struct audit_buffer *ab, const char *prefix,
-		      struct dentry *dentry, struct vfsmount *vfsmnt)
+		      struct path *path)
 {
-	char *p, *path;
+	char *p, *pathname;
 
 	if (prefix)
 		audit_log_format(ab, " %s", prefix);
 
 	/* We will allow 11 spaces for ' (deleted)' to be appended */
-	path = kmalloc(PATH_MAX+11, ab->gfp_mask);
-	if (!path) {
+	pathname = kmalloc(PATH_MAX+11, ab->gfp_mask);
+	if (!pathname) {
 		audit_log_format(ab, "<no memory>");
 		return;
 	}
-	p = d_path(dentry, vfsmnt, path, PATH_MAX+11);
+	p = d_path(path->dentry, path->mnt, pathname, PATH_MAX+11);
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");
 	} else
 		audit_log_untrustedstring(ab, p);
-	kfree(path);
+	kfree(pathname);
 }
 
 /**
diff -puN kernel/auditsc.c~d_path-use-struct-path-in-struct-avc_audit_data kernel/auditsc.c
--- a/kernel/auditsc.c~d_path-use-struct-path-in-struct-avc_audit_data
+++ a/kernel/auditsc.c
@@ -201,8 +201,7 @@ struct audit_context {
 	int		    name_count;
 	struct audit_names  names[AUDIT_NAMES];
 	char *		    filterkey;	/* key for rule that triggered record */
-	struct dentry *	    pwd;
-	struct vfsmount *   pwdmnt;
+	struct path	    pwd;
 	struct audit_context *previous; /* For nested syscalls */
 	struct audit_aux_data *aux;
 	struct audit_aux_data *aux_pids;
@@ -758,12 +757,9 @@ static inline void audit_free_names(stru
 			__putname(context->names[i].name);
 	}
 	context->name_count = 0;
-	if (context->pwd)
-		dput(context->pwd);
-	if (context->pwdmnt)
-		mntput(context->pwdmnt);
-	context->pwd = NULL;
-	context->pwdmnt = NULL;
+	path_put(&context->pwd);
+	context->pwd.dentry = NULL;
+	context->pwd.mnt = NULL;
 }
 
 static inline void audit_free_aux(struct audit_context *context)
@@ -910,8 +906,7 @@ static void audit_log_task_info(struct a
 			if ((vma->vm_flags & VM_EXECUTABLE) &&
 			    vma->vm_file) {
 				audit_log_d_path(ab, "exe=",
-						 vma->vm_file->f_path.dentry,
-						 vma->vm_file->f_path.mnt);
+						 &vma->vm_file->f_path);
 				break;
 			}
 			vma = vma->vm_next;
@@ -1177,10 +1172,10 @@ static void audit_log_exit(struct audit_
 				  context->target_sid))
 			call_panic = 1;
 
-	if (context->pwd && context->pwdmnt) {
+	if (context->pwd.dentry && context->pwd.mnt) {
 		ab = audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
 		if (ab) {
-			audit_log_d_path(ab, "cwd=", context->pwd, context->pwdmnt);
+			audit_log_d_path(ab, "cwd=", &context->pwd);
 			audit_log_end(ab);
 		}
 	}
@@ -1203,8 +1198,7 @@ static void audit_log_exit(struct audit_
 			case 0:
 				/* name was specified as a relative path and the
 				 * directory component is the cwd */
-				audit_log_d_path(ab, " name=", context->pwd,
-						 context->pwdmnt);
+				audit_log_d_path(ab, " name=", &context->pwd);
 				break;
 			default:
 				/* log the name's directory component */
@@ -1526,10 +1520,10 @@ void __audit_getname(const char *name)
 	context->names[context->name_count].ino  = (unsigned long)-1;
 	context->names[context->name_count].osid = 0;
 	++context->name_count;
-	if (!context->pwd) {
+	if (!context->pwd.dentry) {
 		read_lock(&current->fs->lock);
-		context->pwd = dget(current->fs->pwd.dentry);
-		context->pwdmnt = mntget(current->fs->pwd.mnt);
+		context->pwd = current->fs->pwd;
+		path_get(&current->fs->pwd);
 		read_unlock(&current->fs->lock);
 	}
 
diff -puN security/selinux/avc.c~d_path-use-struct-path-in-struct-avc_audit_data security/selinux/avc.c
--- a/security/selinux/avc.c~d_path-use-struct-path-in-struct-avc_audit_data
+++ a/security/selinux/avc.c
@@ -568,10 +568,11 @@ void avc_audit(u32 ssid, u32 tsid,
 			audit_log_format(ab, " capability=%d", a->u.cap);
 			break;
 		case AVC_AUDIT_DATA_FS:
-			if (a->u.fs.dentry) {
-				struct dentry *dentry = a->u.fs.dentry;
-				if (a->u.fs.mnt) {
-					audit_log_d_path(ab, "path=", dentry, a->u.fs.mnt);
+			if (a->u.fs.path.dentry) {
+				struct dentry *dentry = a->u.fs.path.dentry;
+				if (a->u.fs.path.mnt) {
+					audit_log_d_path(ab, "path=",
+							 &a->u.fs.path);
 				} else {
 					audit_log_format(ab, " name=");
 					audit_log_untrustedstring(ab, dentry->d_name.name);
@@ -626,8 +627,10 @@ void avc_audit(u32 ssid, u32 tsid,
 				case AF_UNIX:
 					u = unix_sk(sk);
 					if (u->dentry) {
+						struct path path = { .dentry = u->dentry,
+								     .mnt = u->mnt };
 						audit_log_d_path(ab, "path=",
-								 u->dentry, u->mnt);
+								 &path);
 						break;
 					}
 					if (!u->addr)
diff -puN security/selinux/hooks.c~d_path-use-struct-path-in-struct-avc_audit_data security/selinux/hooks.c
--- a/security/selinux/hooks.c~d_path-use-struct-path-in-struct-avc_audit_data
+++ a/security/selinux/hooks.c
@@ -1080,8 +1080,8 @@ static inline int dentry_has_perm(struct
 	struct inode *inode = dentry->d_inode;
 	struct avc_audit_data ad;
 	AVC_AUDIT_DATA_INIT(&ad,FS);
-	ad.u.fs.mnt = mnt;
-	ad.u.fs.dentry = dentry;
+	ad.u.fs.path.mnt = mnt;
+	ad.u.fs.path.dentry = dentry;
 	return inode_has_perm(tsk, inode, av, &ad);
 }
 
@@ -1099,15 +1099,12 @@ static int file_has_perm(struct task_str
 {
 	struct task_security_struct *tsec = tsk->security;
 	struct file_security_struct *fsec = file->f_security;
-	struct vfsmount *mnt = file->f_path.mnt;
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct avc_audit_data ad;
 	int rc;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
-	ad.u.fs.mnt = mnt;
-	ad.u.fs.dentry = dentry;
+	ad.u.fs.path = file->f_path;
 
 	if (tsec->sid != fsec->sid) {
 		rc = avc_has_perm(tsec->sid, fsec->sid,
@@ -1142,7 +1139,7 @@ static int may_create(struct inode *dir,
 	sbsec = dir->i_sb->s_security;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
-	ad.u.fs.dentry = dentry;
+	ad.u.fs.path.dentry = dentry;
 
 	rc = avc_has_perm(tsec->sid, dsec->sid, SECCLASS_DIR,
 			  DIR__ADD_NAME | DIR__SEARCH,
@@ -1200,7 +1197,7 @@ static int may_link(struct inode *dir,
 	isec = dentry->d_inode->i_security;
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
-	ad.u.fs.dentry = dentry;
+	ad.u.fs.path.dentry = dentry;
 
 	av = DIR__SEARCH;
 	av |= (kind ? DIR__REMOVE_NAME : DIR__ADD_NAME);
@@ -1247,7 +1244,7 @@ static inline int may_rename(struct inod
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
 
-	ad.u.fs.dentry = old_dentry;
+	ad.u.fs.path.dentry = old_dentry;
 	rc = avc_has_perm(tsec->sid, old_dsec->sid, SECCLASS_DIR,
 			  DIR__REMOVE_NAME | DIR__SEARCH, &ad);
 	if (rc)
@@ -1263,7 +1260,7 @@ static inline int may_rename(struct inod
 			return rc;
 	}
 
-	ad.u.fs.dentry = new_dentry;
+	ad.u.fs.path.dentry = new_dentry;
 	av = DIR__ADD_NAME | DIR__SEARCH;
 	if (new_dentry->d_inode)
 		av |= DIR__REMOVE_NAME;
@@ -1642,8 +1639,7 @@ static int selinux_bprm_set_security(str
 	}
 
 	AVC_AUDIT_DATA_INIT(&ad, FS);
-	ad.u.fs.mnt = bprm->file->f_path.mnt;
-	ad.u.fs.dentry = bprm->file->f_path.dentry;
+	ad.u.fs.path = bprm->file->f_path;
 
 	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
 		newsid = tsec->sid;
@@ -2039,7 +2035,7 @@ static int selinux_sb_kern_mount(struct 
 		return rc;
 
 	AVC_AUDIT_DATA_INIT(&ad,FS);
-	ad.u.fs.dentry = sb->s_root;
+	ad.u.fs.path.dentry = sb->s_root;
 	return superblock_has_perm(current, sb, FILESYSTEM__MOUNT, &ad);
 }
 
@@ -2048,7 +2044,7 @@ static int selinux_sb_statfs(struct dent
 	struct avc_audit_data ad;
 
 	AVC_AUDIT_DATA_INIT(&ad,FS);
-	ad.u.fs.dentry = dentry->d_sb->s_root;
+	ad.u.fs.path.dentry = dentry->d_sb->s_root;
 	return superblock_has_perm(current, dentry->d_sb, FILESYSTEM__GETATTR, &ad);
 }
 
@@ -2311,7 +2307,7 @@ static int selinux_inode_setxattr(struct
 		return -EPERM;
 
 	AVC_AUDIT_DATA_INIT(&ad,FS);
-	ad.u.fs.dentry = dentry;
+	ad.u.fs.path.dentry = dentry;
 
 	rc = avc_has_perm(tsec->sid, isec->sid, isec->sclass,
 			  FILE__RELABELFROM, &ad);
diff -puN security/selinux/include/avc.h~d_path-use-struct-path-in-struct-avc_audit_data security/selinux/include/avc.h
--- a/security/selinux/include/avc.h~d_path-use-struct-path-in-struct-avc_audit_data
+++ a/security/selinux/include/avc.h
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/in6.h>
+#include <linux/path.h>
 #include <asm/system.h>
 #include "flask.h"
 #include "av_permissions.h"
@@ -30,8 +31,6 @@ extern int selinux_enforcing;
 struct avc_entry;
 
 struct task_struct;
-struct vfsmount;
-struct dentry;
 struct inode;
 struct sock;
 struct sk_buff;
@@ -46,8 +45,7 @@ struct avc_audit_data {
 	struct task_struct *tsk;
 	union 	{
 		struct {
-			struct vfsmount *mnt;
-			struct dentry *dentry;
+			struct path path;
 			struct inode *inode;
 		} fs;
 		struct {
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
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
