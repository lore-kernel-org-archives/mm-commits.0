From: akpm@linux-foundation.org
Subject: - vfs-mountinfo-show-dominating-group-id.patch removed from -mm tree
Date: Wed, 26 Mar 2008 15:00:18 -0700
Message-ID: <200803262200.m2QM0Ie5004041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761007AbYCZWAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 18:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: mountinfo show dominating group id
has been removed from the -mm tree.  Its filename was
     vfs-mountinfo-show-dominating-group-id.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: mountinfo show dominating group id
From: Miklos Szeredi <mszeredi@suse.cz>

Show peer group ID of nearest dominating group that has intersection
with the mount's namespace.

See the the documentation update for details.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   11 ++++++---
 fs/namespace.c                     |   24 +++++++++++++-------
 fs/pnode.c                         |   32 +++++++++++++++++++++++++++
 fs/pnode.h                         |    1 
 4 files changed, 57 insertions(+), 11 deletions(-)

diff -puN Documentation/filesystems/proc.txt~vfs-mountinfo-show-dominating-group-id Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~vfs-mountinfo-show-dominating-group-id
+++ a/Documentation/filesystems/proc.txt
@@ -2367,15 +2367,20 @@ MNTOPTS: per mount options
 SBOPTS: per super block options
 PROPAGATION: propagation type
 
-propagation type: <propagation_flag>[:<peergrpid>][,...]
+propagation type: <propagation_flag>[:<peergrpid>[:<domgrpid>]][,...]
 	note: 'shared' flag is followed by the id of this mount's peer group
-	      'slave' flag is followed by the peer group id of its master mount
+	      'slave' flag is followed by the peer group id of its master mount,
+	      	      optionally followed by the id of the closest dominant(*)
+		      peer group in the same namespace, if one exists.
 	      'private' flag stands by itself
 	      'unbindable' flag stands by itself
 
+(*) A dominant peer group is an ancestor of this mount in the
+propagation tree, in other words, this mount receives propagation from
+the dominant peer group, but not the other way round.
+
 For more information see:
 
   Documentation/filesystems/sharedsubtree.txt
 
-
 ------------------------------------------------------------------------------
diff -puN fs/namespace.c~vfs-mountinfo-show-dominating-group-id fs/namespace.c
--- a/fs/namespace.c~vfs-mountinfo-show-dominating-group-id
+++ a/fs/namespace.c
@@ -810,16 +810,24 @@ static int show_mountinfo(struct seq_fil
 	show_sb_opts(m, sb);
 	if (sb->s_op->show_options)
 		err = sb->s_op->show_options(m, mnt);
-	if (IS_MNT_SHARED(mnt)) {
-		seq_printf(m, " shared:%i", get_peer_group_id(mnt));
-		if (IS_MNT_SLAVE(mnt))
-			seq_printf(m, ",slave:%i", get_master_id(mnt));
-	} else if (IS_MNT_SLAVE(mnt)) {
-		seq_printf(m, " slave:%i", get_master_id(mnt));
+	seq_putc(m, ' ');
+	if (IS_MNT_SHARED(mnt) || IS_MNT_SLAVE(mnt)) {
+		if (IS_MNT_SHARED(mnt))
+			seq_printf(m, "shared:%i", get_peer_group_id(mnt));
+		if (IS_MNT_SLAVE(mnt)) {
+			int dominator_id = get_dominator_id_same_ns(mnt);
+
+			if (IS_MNT_SHARED(mnt))
+				seq_putc(m, ',');
+
+			seq_printf(m, "slave:%i", get_master_id(mnt));
+			if (dominator_id != -1)
+				seq_printf(m, ":%i", dominator_id);
+		}
 	} else if (IS_MNT_UNBINDABLE(mnt)) {
-		seq_printf(m, " unbindable");
+		seq_printf(m, "unbindable");
 	} else {
-		seq_printf(m, " private");
+		seq_printf(m, "private");
 	}
 	seq_putc(m, '\n');
 	return err;
diff -puN fs/pnode.c~vfs-mountinfo-show-dominating-group-id fs/pnode.c
--- a/fs/pnode.c~vfs-mountinfo-show-dominating-group-id
+++ a/fs/pnode.c
@@ -88,6 +88,38 @@ int get_master_id(struct vfsmount *mnt)
 	return id;
 }
 
+static struct vfsmount *get_peer_in_ns(struct vfsmount *mnt,
+				       struct mnt_namespace *ns)
+{
+	struct vfsmount *m = mnt;
+
+	do {
+		if (m->mnt_ns == ns)
+			return m;
+		m = next_peer(m);
+	} while (m != mnt);
+
+	return NULL;
+}
+
+int get_dominator_id_same_ns(struct vfsmount *mnt)
+{
+	int id = -1;
+	struct vfsmount *m;
+
+	spin_lock(&vfsmount_lock);
+	for (m = mnt->mnt_master; m != NULL; m = m->mnt_master) {
+		struct vfsmount *d = get_peer_in_ns(m, mnt->mnt_ns);
+		if (d) {
+			id = d->mnt_pgid;
+			break;
+		}
+	}
+	spin_unlock(&vfsmount_lock);
+
+	return id;
+}
+
 static int do_make_slave(struct vfsmount *mnt)
 {
 	struct vfsmount *peer_mnt = mnt, *master = mnt->mnt_master;
diff -puN fs/pnode.h~vfs-mountinfo-show-dominating-group-id fs/pnode.h
--- a/fs/pnode.h~vfs-mountinfo-show-dominating-group-id
+++ a/fs/pnode.h
@@ -33,4 +33,5 @@ int propagate_umount(struct list_head *)
 int propagate_mount_busy(struct vfsmount *, int);
 int get_peer_group_id(struct vfsmount *);
 int get_master_id(struct vfsmount *);
+int get_dominator_id_same_ns(struct vfsmount *);
 #endif /* _LINUX_PNODE_H */
_

Patches currently in -mm which might be from mszeredi@suse.cz are

mm-rotate_reclaimable_page-cleanup.patch
vfs-mountinfo-mm-fix.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
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

