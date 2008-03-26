From: akpm@linux-foundation.org
Subject: + vfs-mountinfo-show-dominating-group-id.patch added to -mm tree
Date: Wed, 26 Mar 2008 15:04:47 -0700
Message-ID: <200803262204.m2QM4l8B004234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448AbYCZWFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 18:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: mountinfo: show dominating group id
has been added to the -mm tree.  Its filename is
     vfs-mountinfo-show-dominating-group-id.patch

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
Subject: vfs: mountinfo: show dominating group id
From: Miklos Szeredi <mszeredi@suse.cz>

Show peer group ID of nearest dominating group that has intersection with the
mount's namespace.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    6 +++
 fs/namespace.c                     |    9 ++++-
 fs/pnode.c                         |   45 +++++++++++++++++++++++++++
 fs/pnode.h                         |    1 
 4 files changed, 59 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~vfs-mountinfo-show-dominating-group-id Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~vfs-mountinfo-show-dominating-group-id
+++ a/Documentation/filesystems/proc.txt
@@ -2375,8 +2375,14 @@ possible optional fields are:
 
 shared:X  mount is shared in peer group X
 master:X  mount is slave to peer group X
+propagate_from:X  mount is slave and receives propagation from peer group X (*)
 unbindable  mount is unbindable
 
+(*) X is the closest dominant peer group under the process's root.  If
+X is the immediate master of the mount, or if there's no dominant peer
+group under the same root, then only the "master:X" field is present
+and not the "propagate_from:X" field.
+
 For more information on mount propagation see:
 
   Documentation/filesystems/sharedsubtree.txt
diff -puN fs/namespace.c~vfs-mountinfo-show-dominating-group-id fs/namespace.c
--- a/fs/namespace.c~vfs-mountinfo-show-dominating-group-id
+++ a/fs/namespace.c
@@ -861,8 +861,13 @@ static int show_mountinfo(struct seq_fil
 	/* Tagged fields ("foo:X" or "bar") */
 	if (IS_MNT_SHARED(mnt))
 		seq_printf(m, " shared:%i", mnt->mnt_group_id);
-	if (IS_MNT_SLAVE(mnt))
-		seq_printf(m, " master:%i", mnt->mnt_master->mnt_group_id);
+	if (IS_MNT_SLAVE(mnt)) {
+		int master = mnt->mnt_master->mnt_group_id;
+		int dominator = get_dominator_id_same_root(mnt, &p->root);
+		seq_printf(m, " master:%i", master);
+		if (dominator && dominator != master)
+			seq_printf(m, " propagate_from:%i", dominator);
+	}
 	if (IS_MNT_UNBINDABLE(mnt))
 		seq_puts(m, " unbindable");
 
diff -puN fs/pnode.c~vfs-mountinfo-show-dominating-group-id fs/pnode.c
--- a/fs/pnode.c~vfs-mountinfo-show-dominating-group-id
+++ a/fs/pnode.c
@@ -28,6 +28,51 @@ static inline struct vfsmount *next_slav
 	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
 }
 
+/*
+ * Return true if path is reachable from root
+ *
+ * Caller must hold vfsmount_lock
+ */
+static bool is_path_reachable(struct vfsmount *mnt, struct dentry *dentry,
+			 const struct path *root)
+{
+	while (mnt != root->mnt && mnt->mnt_parent != mnt) {
+		dentry = mnt->mnt_mountpoint;
+		mnt = mnt->mnt_parent;
+	}
+	return mnt == root->mnt && is_subdir(dentry, root->dentry);
+}
+
+static struct vfsmount *get_peer_under_root(struct vfsmount *mnt,
+					    struct mnt_namespace *ns,
+					    const struct path *root)
+{
+	struct vfsmount *m = mnt;
+
+	do {
+		/* Check the namespace first for optimization */
+		if (m->mnt_ns == ns && is_path_reachable(m, m->mnt_root, root))
+			return m;
+
+		m = next_peer(m);
+	} while (m != mnt);
+
+	return NULL;
+}
+
+int get_dominator_id_same_root(struct vfsmount *mnt, const struct path *root)
+{
+	struct vfsmount *m;
+
+	for (m = mnt->mnt_master; m != NULL; m = m->mnt_master) {
+		struct vfsmount *d = get_peer_under_root(m, mnt->mnt_ns, root);
+		if (d)
+			return d->mnt_group_id;
+	}
+
+	return 0;
+}
+
 static int do_make_slave(struct vfsmount *mnt)
 {
 	struct vfsmount *peer_mnt = mnt, *master = mnt->mnt_master;
diff -puN fs/pnode.h~vfs-mountinfo-show-dominating-group-id fs/pnode.h
--- a/fs/pnode.h~vfs-mountinfo-show-dominating-group-id
+++ a/fs/pnode.h
@@ -36,4 +36,5 @@ int propagate_mnt(struct vfsmount *, str
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
 void mnt_release_group_id(struct vfsmount *);
+int get_dominator_id_same_root(struct vfsmount *mnt, const struct path *root);
 #endif /* _LINUX_PNODE_H */
_

Patches currently in -mm which might be from mszeredi@suse.cz are

mm-rotate_reclaimable_page-cleanup.patch
vfs-mountinfo-add-dentry_path.patch
vfs-mountinfo-add-seq_file_root.patch
vfs-mountinfo-add-mount-id.patch
vfs-mountinfo-add-mount-peer-group-id.patch
vfs-mountinfo-allow-using-process-root.patch
vfs-mountinfo-add-proc-pid-mountinfo.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-mountinfo-mm-fix.patch
vfs-remove-lives_below_in_same_fs.patch
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
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch

