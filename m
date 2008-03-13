From: akpm@linux-foundation.org
Subject: + vfs-mountinfo-stable-peer-group-id.patch added to -mm tree
Date: Thu, 13 Mar 2008 15:50:45 -0700
Message-ID: <200803132250.m2DMojng004538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbYCMWv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 18:51:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: mountinfo stable peer group id
has been added to the -mm tree.  Its filename is
     vfs-mountinfo-stable-peer-group-id.patch

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
Subject: vfs: mountinfo stable peer group id
From: Miklos Szeredi <mszeredi@suse.cz>

Add a stable identifier for shared mounts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   12 +----
 fs/namespace.c                     |    7 ++-
 fs/pnode.c                         |   63 ++++++++++++++++++---------
 fs/pnode.h                         |    1 
 include/linux/mount.h              |    1 
 5 files changed, 52 insertions(+), 32 deletions(-)

diff -puN Documentation/filesystems/proc.txt~vfs-mountinfo-stable-peer-group-id Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~vfs-mountinfo-stable-peer-group-id
+++ a/Documentation/filesystems/proc.txt
@@ -2367,18 +2367,12 @@ MNTOPTS: per mount options
 SBOPTS: per super block options
 PROPAGATION: propagation type
 
-propagation type: <propagation_flag>[:<mntid>][,...]
-	note: 'shared' flag is followed by the mntid of its peer mount
-	      'slave' flag is followed by the mntid of its master mount
+propagation type: <propagation_flag>[:<peergrpid>][,...]
+	note: 'shared' flag is followed by the id of this mount's peer group
+	      'slave' flag is followed by the peer group id of its master mount
 	      'private' flag stands by itself
 	      'unbindable' flag stands by itself
 
-The 'mntid' used in the propagation type is a canonical ID of the peer
-group (currently the smallest ID within the group is used for this
-purpose, but this should not be relied on).  Since mounts can be added
-or removed from the peer group, this ID only guaranteed to stay the
-same on a static propagation tree.
-
 For more information see:
 
   Documentation/filesystems/sharedsubtree.txt
diff -puN fs/namespace.c~vfs-mountinfo-stable-peer-group-id fs/namespace.c
--- a/fs/namespace.c~vfs-mountinfo-stable-peer-group-id
+++ a/fs/namespace.c
@@ -94,6 +94,7 @@ struct vfsmount *alloc_vfsmnt(const char
 			return NULL;
 		}
 
+		mnt->mnt_pgid = -1;
 		atomic_set(&mnt->mnt_count, 1);
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
@@ -544,8 +545,10 @@ static struct vfsmount *clone_mnt(struct
 			mnt->mnt_master = old;
 			clear_mnt_shared(mnt);
 		} else if (!(flag & CL_PRIVATE)) {
-			if ((flag & CL_PROPAGATION) || IS_MNT_SHARED(old))
-				list_add(&mnt->mnt_share, &old->mnt_share);
+			if (flag & CL_PROPAGATION)
+				set_mnt_shared(old);
+			if (IS_MNT_SHARED(old))
+				make_mnt_peer(old, mnt);
 			if (IS_MNT_SLAVE(old))
 				list_add(&mnt->mnt_slave, &old->mnt_slave);
 			mnt->mnt_master = old->mnt_master;
diff -puN fs/pnode.c~vfs-mountinfo-stable-peer-group-id fs/pnode.c
--- a/fs/pnode.c~vfs-mountinfo-stable-peer-group-id
+++ a/fs/pnode.c
@@ -9,8 +9,12 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/idr.h>
 #include "pnode.h"
 
+static DEFINE_SPINLOCK(mnt_pgid_lock);
+static DEFINE_IDA(mnt_pgid_ida);
+
 /* return the next shared peer mount of @p */
 static inline struct vfsmount *next_peer(struct vfsmount *p)
 {
@@ -27,47 +31,58 @@ static inline struct vfsmount *next_slav
 	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
 }
 
-void set_mnt_shared(struct vfsmount *mnt)
+static void __set_mnt_shared(struct vfsmount *mnt)
 {
 	mnt->mnt_flags &= ~MNT_PNODE_MASK;
 	mnt->mnt_flags |= MNT_SHARED;
 }
 
-void clear_mnt_shared(struct vfsmount *mnt)
+void set_mnt_shared(struct vfsmount *mnt)
 {
-	mnt->mnt_flags &= ~MNT_SHARED;
+	int res;
+
+ retry:
+	spin_lock(&mnt_pgid_lock);
+	if (IS_MNT_SHARED(mnt)) {
+		spin_unlock(&mnt_pgid_lock);
+		return;
+	}
+
+	res = ida_get_new(&mnt_pgid_ida, &mnt->mnt_pgid);
+	spin_unlock(&mnt_pgid_lock);
+	if (res == -EAGAIN) {
+		if (ida_pre_get(&mnt_pgid_ida, GFP_KERNEL))
+			goto retry;
+	}
+	__set_mnt_shared(mnt);
 }
 
-static int __peer_group_id(struct vfsmount *mnt)
+void clear_mnt_shared(struct vfsmount *mnt)
 {
-	struct vfsmount *m;
-	int id = mnt->mnt_id;
-
-	for (m = next_peer(mnt); m != mnt; m = next_peer(m))
-		id = min(id, m->mnt_id);
+	if (IS_MNT_SHARED(mnt)) {
+		mnt->mnt_flags &= ~MNT_SHARED;
+		mnt->mnt_pgid = -1;
+	}
+}
 
-	return id;
+void make_mnt_peer(struct vfsmount *old, struct vfsmount *mnt)
+{
+	mnt->mnt_pgid = old->mnt_pgid;
+	list_add(&mnt->mnt_share, &old->mnt_share);
+	__set_mnt_shared(mnt);
 }
 
-/* return the smallest ID within the peer group */
 int get_peer_group_id(struct vfsmount *mnt)
 {
-	int id;
-
-	spin_lock(&vfsmount_lock);
-	id = __peer_group_id(mnt);
-	spin_unlock(&vfsmount_lock);
-
-	return id;
+	return mnt->mnt_pgid;
 }
 
-/* return the smallest ID within the master's peer group */
 int get_master_id(struct vfsmount *mnt)
 {
 	int id;
 
 	spin_lock(&vfsmount_lock);
-	id = __peer_group_id(mnt->mnt_master);
+	id = get_peer_group_id(mnt->mnt_master);
 	spin_unlock(&vfsmount_lock);
 
 	return id;
@@ -91,7 +106,13 @@ static int do_make_slave(struct vfsmount
 		if (peer_mnt == mnt)
 			peer_mnt = NULL;
 	}
-	list_del_init(&mnt->mnt_share);
+	if (!list_empty(&mnt->mnt_share))
+		list_del_init(&mnt->mnt_share);
+	else if (IS_MNT_SHARED(mnt)) {
+		spin_lock(&mnt_pgid_lock);
+		ida_remove(&mnt_pgid_ida, mnt->mnt_pgid);
+		spin_unlock(&mnt_pgid_lock);
+	}
 
 	if (peer_mnt)
 		master = peer_mnt;
diff -puN fs/pnode.h~vfs-mountinfo-stable-peer-group-id fs/pnode.h
--- a/fs/pnode.h~vfs-mountinfo-stable-peer-group-id
+++ a/fs/pnode.h
@@ -25,6 +25,7 @@
 
 void set_mnt_shared(struct vfsmount *);
 void clear_mnt_shared(struct vfsmount *);
+void make_mnt_peer(struct vfsmount *, struct vfsmount *);
 void change_mnt_propagation(struct vfsmount *, int);
 int propagate_mnt(struct vfsmount *, struct dentry *, struct vfsmount *,
 		struct list_head *);
diff -puN include/linux/mount.h~vfs-mountinfo-stable-peer-group-id include/linux/mount.h
--- a/include/linux/mount.h~vfs-mountinfo-stable-peer-group-id
+++ a/include/linux/mount.h
@@ -57,6 +57,7 @@ struct vfsmount {
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	int mnt_id;			/* mount identifier */
+	int mnt_pgid;			/* peer group identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line
_

Patches currently in -mm which might be from mszeredi@suse.cz are

vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch

