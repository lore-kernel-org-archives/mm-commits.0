From: akpm@linux-foundation.org
Subject: - sysfs-group-removal-avoid-bypass-permission-checks.patch removed from -mm tree
Date: Sat, 21 Apr 2007 03:02:00 -0700
Message-ID: <200704211002.l3LA20of003835@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933102AbXDUKCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 06:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, eparis@redhat.com, htejun@gmail.com, nagendra_tomar@adaptec.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     sysfs group: bypass permission checks
has been removed from the -mm tree.  Its filename was
     sysfs-group-removal-avoid-bypass-permission-checks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: sysfs group: bypass permission checks
From: James Morris <jmorris@namei.org>

Prevent permission checking from being peformed when the kernel wants to
unconditionally remove a sysfs group, by introducing an kernel-only variant
of lookup_one_len(), lookup_one_len_kern().

Additionally, as sysfs_remove_group() does not check the return value of
the lookup before using it, a BUG_ON has been added to pinpoint the cause
of any problems potentially caused by this (and as a form of annotation).

Signed-off-by: James Morris <jmorris@namei.org>
Cc: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |   30 ++++++++++++++++++++++--------
 fs/sysfs/group.c      |    6 ++++--
 include/linux/namei.h |    3 ++-
 3 files changed, 28 insertions(+), 11 deletions(-)

diff -puN fs/namei.c~sysfs-group-removal-avoid-bypass-permission-checks fs/namei.c
--- a/fs/namei.c~sysfs-group-removal-avoid-bypass-permission-checks
+++ a/fs/namei.c
@@ -1248,17 +1248,20 @@ int __user_path_lookup_open(const char _
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
  */
-static struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd)
+static struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd, int kern)
 {
 	struct dentry * dentry;
 	struct inode *inode;
 	int err;
 
 	inode = base->d_inode;
-	err = permission(inode, MAY_EXEC, nd);
-	dentry = ERR_PTR(err);
-	if (err)
-		goto out;
+
+	if (likely(!kern)) {
+		err = permission(inode, MAY_EXEC, nd);
+		dentry = ERR_PTR(err);
+		if (err)
+			goto out;
+	}
 
 	/*
 	 * See if the low-level filesystem might want
@@ -1289,11 +1292,11 @@ out:
 
 static struct dentry *lookup_hash(struct nameidata *nd)
 {
-	return __lookup_hash(&nd->last, nd->dentry, nd);
+	return __lookup_hash(&nd->last, nd->dentry, nd, 0);
 }
 
 /* SMP-safe */
-struct dentry * lookup_one_len(const char * name, struct dentry * base, int len)
+static inline struct dentry * __lookup_one_len(const char * name, struct dentry * base, int len, int kern)
 {
 	unsigned long hash;
 	struct qstr this;
@@ -1313,11 +1316,22 @@ struct dentry * lookup_one_len(const cha
 	}
 	this.hash = end_name_hash(hash);
 
-	return __lookup_hash(&this, base, NULL);
+	return __lookup_hash(&this, base, NULL, kern);
 access:
 	return ERR_PTR(-EACCES);
 }
 
+struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
+{
+	return __lookup_one_len(name, base, len, 0);
+}
+
+struct dentry *lookup_one_len_kern(const char *name, struct dentry *base,
+					int len)
+{
+	return __lookup_one_len(name, base, len, 1);
+}
+
 /*
  *	namei()
  *
diff -puN fs/sysfs/group.c~sysfs-group-removal-avoid-bypass-permission-checks fs/sysfs/group.c
--- a/fs/sysfs/group.c~sysfs-group-removal-avoid-bypass-permission-checks
+++ a/fs/sysfs/group.c
@@ -70,9 +70,11 @@ void sysfs_remove_group(struct kobject *
 {
 	struct dentry * dir;
 
-	if (grp->name)
-		dir = lookup_one_len(grp->name, kobj->dentry,
+	if (grp->name) {
+		dir = lookup_one_len_kern(grp->name, kobj->dentry,
 				strlen(grp->name));
+		BUG_ON(IS_ERR(dir));
+	}
 	else
 		dir = dget(kobj->dentry);
 
diff -puN include/linux/namei.h~sysfs-group-removal-avoid-bypass-permission-checks include/linux/namei.h
--- a/include/linux/namei.h~sysfs-group-removal-avoid-bypass-permission-checks
+++ a/include/linux/namei.h
@@ -81,7 +81,8 @@ extern struct file *lookup_instantiate_f
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
-extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
+extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
+extern struct dentry *lookup_one_len_kern(const char *, struct dentry *, int);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
_

Patches currently in -mm which might be from jmorris@namei.org are

return-eperm-not-echild-on-security_task_wait-failure.patch
sysfs-group-removal-avoid-bypass-permission-checks.patch
git-net.patch
git-selinux.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
allow-access-to-proc-pid-fd-after-setuid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
remove-redundant-check-from-proc_setattr.patch
remove-redundant-check-from-proc_sys_setattr.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
