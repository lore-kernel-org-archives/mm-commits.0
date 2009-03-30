From: akpm@linux-foundation.org
Subject: [merged] devpts-remove-get_init_pts_sb.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:29 -0700
Message-ID: <200903301907.n2UJ7T1i019373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759449AbZC3TL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:11:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, hpa@zytor.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devpts: remove get_init_pts_sb()
has been removed from the -mm tree.  Its filename was
     devpts-remove-get_init_pts_sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: remove get_init_pts_sb()
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

With mknod_ptmx() moved to devpts_get_sb(), init_pts_mount() becomes a
wrapper around get_init_pts_sb().  Remove get_init_pts_sb() and fold code
into init_pts_mount().

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff -puN fs/devpts/inode.c~devpts-remove-get_init_pts_sb fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-remove-get_init_pts_sb
+++ a/fs/devpts/inode.c
@@ -342,7 +342,11 @@ static int new_pts_mount(struct file_sys
 }
 
 /*
- * get_init_pts_sb()
+ * init_pts_mount()
+ *
+ *     Mount or remount the initial kernel mount of devpts. This type of
+ *     mount maintains the legacy, single-instance semantics, while the
+ *     kernel still allows multiple-instances.
  *
  *     This interface is needed to support multiple namespace semantics in
  *     devpts while preserving backward compatibility of the current 'single-
@@ -362,7 +366,7 @@ static int new_pts_mount(struct file_sys
  *     consistently selects the 'single-namespace' superblock even in the
  *     presence of the private namespace (i.e 'newinstance') super-blocks.
  */
-static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
+static int init_pts_mount(struct file_system_type *fs_type, int flags,
 		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
 {
 	struct super_block *s;
@@ -392,23 +396,6 @@ static int get_init_pts_sb(struct file_s
 	return 0;
 }
 
-/*
- * Mount or remount the initial kernel mount of devpts. This type of
- * mount maintains the legacy, single-instance semantics, while the
- * kernel still allows multiple-instances.
- */
-static int init_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
-{
-	int err;
-
-	err = get_init_pts_sb(fs_type, flags, data, opts, mnt);
-	if (err)
-		return err;
-
-	return err;
-}
