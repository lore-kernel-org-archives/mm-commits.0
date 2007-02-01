From: akpm@osdl.org
Subject: - user-ns-implement-shared-mounts.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:24:58 -0800
Message-ID: <200702010125.l111PuoJ032646@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35784 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161222AbXBAB10 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, mm-commits@vger.kernel.org


The patch titled
     user ns: implement shared mounts
has been removed from the -mm tree.  Its filename was
     user-ns-implement-shared-mounts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: user ns: implement shared mounts


Implement shared-ns mounts, which allow containers in different user
namespaces to share mounts.  Without this, containers can obviously never even
be started.

Here is a sample smount.c (based on Miklos' version) which only does a bind
mount of arg1 onto arg2, but making the destination a shared-ns mount.

int main(int argc, char *argv[])
{
	int type;
	if(argc != 3) {
		fprintf(stderr, "usage: %s src dest", argv[0]);
		return 1;
	}

	fprintf(stdout, "%s %s %s\n", argv[0], argv[1], argv[2]);

	type = MS_SHARE_NS | MS_BIND;
	setfsuid(getuid());

	if(mount(argv[1], argv[2], "none", type, "") == -1) {
		perror("mount");
		return 1;
	}
	return 0;
}

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namespace.c        |   28 ++++++++++++++++++++++------
 fs/pnode.h            |    1 +
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 include/linux/sched.h |    2 ++
 5 files changed, 27 insertions(+), 6 deletions(-)

diff -puN fs/namespace.c~user-ns-implement-shared-mounts fs/namespace.c
--- a/fs/namespace.c~user-ns-implement-shared-mounts
+++ a/fs/namespace.c
@@ -234,7 +234,12 @@ static struct vfsmount *clone_mnt(struct
 					int flag)
 {
 	struct super_block *sb = old->mnt_sb;
-	struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
+	struct vfsmount *mnt;
+
+	if (!clone_mnt_userns_permission(old))
+		return ERR_PTR(-EPERM);
+
+	mnt = alloc_vfsmnt(old->mnt_devname);
 
 	if (!mnt)
 		return ERR_PTR(-ENOMEM);
@@ -259,6 +264,10 @@ static struct vfsmount *clone_mnt(struct
 	}
 	if (flag & CL_MAKE_SHARED)
 		set_mnt_shared(mnt);
+	if (flag & CL_SHARE_NS)
+		mnt->mnt_flags |= MNT_SHARE_NS;
+	else
+		mnt->mnt_flags &= ~MNT_SHARE_NS;
 
 	/* stick the duplicate mount on the same expiry list
 	 * as the original if that was on one */
@@ -370,6 +379,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NOSUID, ",nosuid" },
 		{ MNT_NODEV, ",nodev" },
 		{ MNT_NOEXEC, ",noexec" },
+		{ MNT_SHARE_NS, ",share_userns" },
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
@@ -902,11 +912,14 @@ static int do_change_type(struct nameida
 /*
  * do loopback mount.
  */
-static int do_loopback(struct nameidata *nd, char *old_name, int recurse)
+static int do_loopback(struct nameidata *nd, char *old_name, int recurse,
+							 int uidns_share)
 {
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
 	int err = mount_is_safe(nd);
+	int flag = (uidns_share ? CL_SHARE_NS : 0);
+
 	if (err)
 		return err;
 	if (!old_name || !*old_name)
@@ -925,9 +938,9 @@ static int do_loopback(struct nameidata 
 
 	err = -ENOMEM;
 	if (recurse)
-		mnt = copy_tree(old_nd.mnt, old_nd.dentry, 0);
+		mnt = copy_tree(old_nd.mnt, old_nd.dentry, flag);
 	else
-		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, 0);
+		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, flag);
 
 	if (!mnt || IS_ERR(mnt)) {
 		err = mnt ? PTR_ERR(mnt) : -ENOMEM;
@@ -1414,9 +1427,11 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_SHARE_NS)
+		mnt_flags |= MNT_SHARE_NS;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_SHARE_NS);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
@@ -1431,7 +1446,8 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_remount(&nd, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&nd, dev_name, flags & MS_REC);
+		retval = do_loopback(&nd, dev_name, flags & MS_REC,
+						 mnt_flags & MNT_SHARE_NS);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&nd, flags);
 	else if (flags & MS_MOVE)
diff -puN fs/pnode.h~user-ns-implement-shared-mounts fs/pnode.h
--- a/fs/pnode.h~user-ns-implement-shared-mounts
+++ a/fs/pnode.h
@@ -22,6 +22,7 @@
 #define CL_COPY_ALL 		0x04
 #define CL_MAKE_SHARED 		0x08
 #define CL_PROPAGATION 		0x10
+#define CL_SHARE_NS 		0x20
 
 static inline void set_mnt_shared(struct vfsmount *mnt)
 {
diff -puN include/linux/fs.h~user-ns-implement-shared-mounts include/linux/fs.h
--- a/include/linux/fs.h~user-ns-implement-shared-mounts
+++ a/include/linux/fs.h
@@ -121,6 +121,7 @@ extern int dir_notify_enable;
 #define MS_SLAVE	(1<<19)	/* change to slave */
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
+#define MS_SHARE_NS	(1<<22) /* ignore user namespaces for permission */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
diff -puN include/linux/mount.h~user-ns-implement-shared-mounts include/linux/mount.h
--- a/include/linux/mount.h~user-ns-implement-shared-mounts
+++ a/include/linux/mount.h
@@ -35,6 +35,7 @@ struct user_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propogation flag mask */
+#define MNT_SHARE_NS	0x4000  /* ignore user namespaces for permission */
 
 struct vfsmount {
 	struct list_head mnt_hash;
diff -puN include/linux/sched.h~user-ns-implement-shared-mounts include/linux/sched.h
--- a/include/linux/sched.h~user-ns-implement-shared-mounts
+++ a/include/linux/sched.h
@@ -1613,6 +1613,8 @@ static inline int task_mnt_same_uidns(st
 {
 	if (tsk->nsproxy == init_task.nsproxy)
 		return 1;
+ 	if (mnt->mnt_flags & MNT_SHARE_NS)
+ 		return 1;
 	if (mnt->mnt_user_ns == tsk->nsproxy->user_ns)
 		return 1;
 	return 0;
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
integrity-service-api-and-dummy-provider-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
