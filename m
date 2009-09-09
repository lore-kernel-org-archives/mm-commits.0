From: akpm@linux-foundation.org
Subject: + vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch added to -mm tree
Date: Wed, 09 Sep 2009 14:26:47 -0700
Message-ID: <200909092126.n89LQl8M006382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbZIIV12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 17:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de, hugh.dickins@tiscali.co.uk, matthew@wil.cx, viro@zeniv.linux.org.uk


The patch titled
     vfs: no "(unreachable)" prefix for SYSVIPC maps in /proc/PID/maps
has been added to the -mm tree.  Its filename is
     vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: no "(unreachable)" prefix for SYSVIPC maps in /proc/PID/maps
From: Miklos Szeredi <mszeredi@suse.cz>

The patch

  "vfs: fix d_path() for unreachable paths"

generally changed d_path() to report unreachable paths with a special
prefix.  This has an effect on /proc/${PID}/maps as well for memory maps
set up with shmem_file_setup() or hugetlb_file_setup().  These functions
set up unlinked files under a kernel-private vfsmount.  Since this
vfsmount is unreachable from userspace, these maps will be reported with
the "(unreachable)" prefix.

This is undesirable, because it changes the kernel ABI and might break
applications for no good reason.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   17 +++++++++++++++++
 mm/shmem.c           |   17 +++++++++++++++++
 2 files changed, 34 insertions(+)

diff -puN fs/hugetlbfs/inode.c~vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps
+++ a/fs/hugetlbfs/inode.c
@@ -906,6 +906,21 @@ static struct file_system_type hugetlbfs
 
 static struct vfsmount *hugetlbfs_vfsmount;
 
+/*
+ * Do a special d_dname function so that these are not prefixed by
+ * "(unreachable)".
+ */
+static char *hugetlb_unlinked_d_dname(struct dentry *dentry, char *buf,
+				      int buflen)
+{
+	return dynamic_dname(dentry, buf, buflen, "/%s (deleted)",
+			     dentry->d_name.name);
+}
+
+static struct dentry_operations hugetlb_unlinked_dentry_operations = {
+	.d_dname = hugetlb_unlinked_d_dname,
+};
+
 static int can_do_hugetlb_shm(void)
 {
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
@@ -943,6 +958,8 @@ struct file *hugetlb_file_setup(const ch
 	if (!dentry)
 		goto out_shm_unlock;
 
+	dentry->d_op = &hugetlb_unlinked_dentry_operations;
+
 	error = -ENOSPC;
 	inode = hugetlbfs_get_inode(root->d_sb, current_fsuid(),
 				current_fsgid(), S_IFREG | S_IRWXUGO, 0);
diff -puN mm/shmem.c~vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps mm/shmem.c
--- a/mm/shmem.c~vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps
+++ a/mm/shmem.c
@@ -2604,6 +2604,21 @@ int shmem_unuse(swp_entry_t entry, struc
 
 /* common code */
 
+/*
+ * Do a special d_dname function so that these are not prefixed by
+ * "(unreachable)".
+ */
+static char *shmem_unlinked_d_dname(struct dentry *dentry, char *buf,
+				    int buflen)
+{
+	return dynamic_dname(dentry, buf, buflen, "/%s (deleted)",
+			     dentry->d_name.name);
+}
+
+static struct dentry_operations shmem_unlinked_dentry_operations = {
+	.d_dname = shmem_unlinked_d_dname,
+};
+
 /**
  * shmem_file_setup - get an unlinked file living in tmpfs
  * @name: name for dentry (to be seen in /proc/<pid>/maps
@@ -2636,6 +2651,8 @@ struct file *shmem_file_setup(const char
 	if (!dentry)
 		goto put_memory;
 
+	dentry->d_op = &shmem_unlinked_dentry_operations;
+
 	error = -ENFILE;
 	file = get_empty_filp();
 	if (!file)
_

Patches currently in -mm which might be from mszeredi@suse.cz are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-fix-d_path-for-unreachable-paths.patch
vfs-seq_file-add-helpers-for-data-filling.patch
vfs-revert-proc-mounts-to-old-behavior-for-unreachable-mountpoints.patch
vfs-no-unreachable-prefix-for-sysvipc-maps-in-proc-pid-maps.patch

