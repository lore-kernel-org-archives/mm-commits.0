From: akpm@linux-foundation.org
Subject: + vfs-pnode-cleanup.patch added to -mm tree
Date: Thu, 13 Mar 2008 15:50:42 -0700
Message-ID: <200803132250.m2DMogL3004535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbYCMWva (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 18:51:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: pnode cleanup
has been added to the -mm tree.  Its filename is
     vfs-pnode-cleanup.patch

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
Subject: vfs: pnode cleanup
From: Miklos Szeredi <mszeredi@suse.cz>

Clean up mnt->mnt_slave_list being initialized too many times.

Move set_mnt_shared from pnode.h to pnode.c.  Change
CLEAR_MNT_SHARED() to clear_mnt_shared() function, and move to
pnode.c.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 +-
 fs/pnode.c     |   23 ++++++++++++++++-------
 fs/pnode.h     |    9 ++-------
 3 files changed, 19 insertions(+), 15 deletions(-)

diff -puN fs/namespace.c~vfs-pnode-cleanup fs/namespace.c
--- a/fs/namespace.c~vfs-pnode-cleanup
+++ a/fs/namespace.c
@@ -542,7 +542,7 @@ static struct vfsmount *clone_mnt(struct
 		if (flag & CL_SLAVE) {
 			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
 			mnt->mnt_master = old;
-			CLEAR_MNT_SHARED(mnt);
+			clear_mnt_shared(mnt);
 		} else if (!(flag & CL_PRIVATE)) {
 			if ((flag & CL_PROPAGATION) || IS_MNT_SHARED(old))
 				list_add(&mnt->mnt_share, &old->mnt_share);
diff -puN fs/pnode.c~vfs-pnode-cleanup fs/pnode.c
--- a/fs/pnode.c~vfs-pnode-cleanup
+++ a/fs/pnode.c
@@ -27,6 +27,17 @@ static inline struct vfsmount *next_slav
 	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
 }
 
+void set_mnt_shared(struct vfsmount *mnt)
+{
+	mnt->mnt_flags &= ~MNT_PNODE_MASK;
+	mnt->mnt_flags |= MNT_SHARED;
+}
+
+void clear_mnt_shared(struct vfsmount *mnt)
+{
+	mnt->mnt_flags &= ~MNT_SHARED;
+}
+
 static int __peer_group_id(struct vfsmount *mnt)
 {
 	struct vfsmount *m;
@@ -89,20 +100,18 @@ static int do_make_slave(struct vfsmount
 		list_for_each_entry(slave_mnt, &mnt->mnt_slave_list, mnt_slave)
 			slave_mnt->mnt_master = master;
 		list_move(&mnt->mnt_slave, &master->mnt_slave_list);
-		list_splice(&mnt->mnt_slave_list, master->mnt_slave_list.prev);
-		INIT_LIST_HEAD(&mnt->mnt_slave_list);
+		list_splice_init(&mnt->mnt_slave_list,
+				 master->mnt_slave_list.prev);
 	} else {
-		struct list_head *p = &mnt->mnt_slave_list;
-		while (!list_empty(p)) {
-                        slave_mnt = list_first_entry(p,
+		while (!list_empty(&mnt->mnt_slave_list)) {
+			slave_mnt = list_first_entry(&mnt->mnt_slave_list,
 					struct vfsmount, mnt_slave);
 			list_del_init(&slave_mnt->mnt_slave);
 			slave_mnt->mnt_master = NULL;
 		}
 	}
 	mnt->mnt_master = master;
-	CLEAR_MNT_SHARED(mnt);
-	INIT_LIST_HEAD(&mnt->mnt_slave_list);
+	clear_mnt_shared(mnt);
 	return 0;
 }
 
diff -puN fs/pnode.h~vfs-pnode-cleanup fs/pnode.h
--- a/fs/pnode.h~vfs-pnode-cleanup
+++ a/fs/pnode.h
@@ -14,7 +14,6 @@
 #define IS_MNT_SHARED(mnt) (mnt->mnt_flags & MNT_SHARED)
 #define IS_MNT_SLAVE(mnt) (mnt->mnt_master)
 #define IS_MNT_NEW(mnt)  (!mnt->mnt_ns)
-#define CLEAR_MNT_SHARED(mnt) (mnt->mnt_flags &= ~MNT_SHARED)
 #define IS_MNT_UNBINDABLE(mnt) (mnt->mnt_flags & MNT_UNBINDABLE)
 
 #define CL_EXPIRE    		0x01
@@ -24,12 +23,8 @@
 #define CL_PROPAGATION 		0x10
 #define CL_PRIVATE 		0x20
 
-static inline void set_mnt_shared(struct vfsmount *mnt)
-{
-	mnt->mnt_flags &= ~MNT_PNODE_MASK;
-	mnt->mnt_flags |= MNT_SHARED;
-}
-
+void set_mnt_shared(struct vfsmount *);
+void clear_mnt_shared(struct vfsmount *);
 void change_mnt_propagation(struct vfsmount *, int);
 int propagate_mnt(struct vfsmount *, struct dentry *, struct vfsmount *,
 		struct list_head *);
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

