From: akpm@linux-foundation.org
Subject: - fs-freevxfs-proper-externs.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:19 -0700
Message-ID: <200804300539.m3U5dJ6N028835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448AbYD3Fjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fs/freevxfs/: proper externs
has been removed from the -mm tree.  Its filename was
     fs-freevxfs-proper-externs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/freevxfs/: proper externs
From: Adrian Bunk <bunk@kernel.org>

Move the extern declarations of several structs to vxfs_extern.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_extern.h |    5 +++++
 fs/freevxfs/vxfs_immed.c  |    1 +
 fs/freevxfs/vxfs_inode.c  |    5 -----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/freevxfs/vxfs_extern.h~fs-freevxfs-proper-externs fs/freevxfs/vxfs_extern.h
--- a/fs/freevxfs/vxfs_extern.h~fs-freevxfs-proper-externs
+++ a/fs/freevxfs/vxfs_extern.h
@@ -50,7 +50,11 @@ extern daddr_t			vxfs_bmap1(struct inode
 /* vxfs_fshead.c */
 extern int			vxfs_read_fshead(struct super_block *);
 
+/* vxfs_immed.c */
+extern const struct inode_operations vxfs_immed_symlink_iops;
+
 /* vxfs_inode.c */
+extern const struct address_space_operations vxfs_immed_aops;
 extern struct kmem_cache	*vxfs_inode_cachep;
 extern void			vxfs_dumpi(struct vxfs_inode_info *, ino_t);
 extern struct inode *		vxfs_get_fake_inode(struct super_block *,
@@ -69,6 +73,7 @@ extern const struct file_operations	vxfs
 extern int			vxfs_read_olt(struct super_block *, u_long);
 
 /* vxfs_subr.c */
+extern const struct address_space_operations vxfs_aops;
 extern struct page *		vxfs_get_page(struct address_space *, u_long);
 extern void			vxfs_put_page(struct page *);
 extern struct buffer_head *	vxfs_bread(struct inode *, int);
diff -puN fs/freevxfs/vxfs_immed.c~fs-freevxfs-proper-externs fs/freevxfs/vxfs_immed.c
--- a/fs/freevxfs/vxfs_immed.c~fs-freevxfs-proper-externs
+++ a/fs/freevxfs/vxfs_immed.c
@@ -35,6 +35,7 @@
 #include <linux/namei.h>
 
 #include "vxfs.h"
+#include "vxfs_extern.h"
 #include "vxfs_inode.h"
 
 
diff -puN fs/freevxfs/vxfs_inode.c~fs-freevxfs-proper-externs fs/freevxfs/vxfs_inode.c
--- a/fs/freevxfs/vxfs_inode.c~fs-freevxfs-proper-externs
+++ a/fs/freevxfs/vxfs_inode.c
@@ -41,11 +41,6 @@
 #include "vxfs_extern.h"
 
 
-extern const struct address_space_operations vxfs_aops;
-extern const struct address_space_operations vxfs_immed_aops;
-
-extern const struct inode_operations vxfs_immed_symlink_iops;
-
 struct kmem_cache		*vxfs_inode_cachep;
 
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

