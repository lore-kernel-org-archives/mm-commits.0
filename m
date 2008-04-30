From: akpm@linux-foundation.org
Subject: - fs-hfsplus-proper-externs.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:16 -0700
Message-ID: <200804300539.m3U5dGpL028823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723AbYD3Fjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fs/hfsplus/: proper externs
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-proper-externs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/hfsplus/: proper externs
From: Adrian Bunk <bunk@kernel.org>

Add proper extern declarations for two structs in fs/hfsplus/hfsplus_fs.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h |    4 ++++
 fs/hfsplus/inode.c      |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/hfsplus/hfsplus_fs.h~fs-hfsplus-proper-externs fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~fs-hfsplus-proper-externs
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -311,6 +311,10 @@ int hfsplus_delete_cat(u32, struct inode
 int hfsplus_rename_cat(u32, struct inode *, struct qstr *,
 		       struct inode *, struct qstr *);
 
+/* dir.c */
+extern const struct inode_operations hfsplus_dir_inode_operations;
+extern const struct file_operations hfsplus_dir_operations;
+
 /* extents.c */
 int hfsplus_ext_cmp_key(const hfsplus_btree_key *, const hfsplus_btree_key *);
 void hfsplus_ext_write_extent(struct inode *);
diff -puN fs/hfsplus/inode.c~fs-hfsplus-proper-externs fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~fs-hfsplus-proper-externs
+++ a/fs/hfsplus/inode.c
@@ -278,9 +278,6 @@ static int hfsplus_file_release(struct i
 	return 0;
 }
 
-extern const struct inode_operations hfsplus_dir_inode_operations;
-extern struct file_operations hfsplus_dir_operations;
-
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
 	.truncate	= hfsplus_file_truncate,
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

