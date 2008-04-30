From: akpm@linux-foundation.org
Subject: - make-__put_super-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:21 -0700
Message-ID: <200804300539.m3U5dLs8028839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbYD3Fji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make __put_super() static
has been removed from the -mm tree.  Its filename was
     make-__put_super-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make __put_super() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global __put_super() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c         |    2 +-
 include/linux/fs.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/super.c~make-__put_super-static fs/super.c
--- a/fs/super.c~make-__put_super-static
+++ a/fs/super.c
@@ -117,7 +117,7 @@ static inline void destroy_super(struct 
  * Drop a superblock's refcount.  Returns non-zero if the superblock was
  * destroyed.  The caller must hold sb_lock.
  */
-int __put_super(struct super_block *sb)
+static int __put_super(struct super_block *sb)
 {
 	int ret = 0;
 
diff -puN include/linux/fs.h~make-__put_super-static include/linux/fs.h
--- a/include/linux/fs.h~make-__put_super-static
+++ a/include/linux/fs.h
@@ -1521,7 +1521,6 @@ extern int get_sb_pseudo(struct file_sys
 	const struct super_operations *ops, unsigned long,
 	struct vfsmount *mnt);
 extern int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
-int __put_super(struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 void unnamed_dev_init(void);
 
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

