From: akpm@linux-foundation.org
Subject: - fs-block_devc-i_bdev-mustnt-be-inline.patch removed from -mm tree
Date: Thu, 01 May 2008 01:16:06 -0700
Message-ID: <200805010816.m418G6hn027826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbYEAIQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 04:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs/block_dev.c:I_BDEV() mustn't be inline
has been removed from the -mm tree.  Its filename was
     fs-block_devc-i_bdev-mustnt-be-inline.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/block_dev.c:I_BDEV() mustn't be inline
From: Adrian Bunk <bunk@kernel.org>

Fix the following build error with UML and gcc 4.3:

/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c: In function `blkdev_get_block':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:42: sorry, unimplemented: inlining failed in call to `I_BDEV': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:119: sorry, unimplemented: called from here
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:42: sorry, unimplemented: inlining failed in call to `I_BDEV': function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/block_dev.c:131: sorry, unimplemented: called from here

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/block_dev.c~fs-block_devc-i_bdev-mustnt-be-inline fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-i_bdev-mustnt-be-inline
+++ a/fs/block_dev.c
@@ -38,11 +38,10 @@ static inline struct bdev_inode *BDEV_I(
 	return container_of(inode, struct bdev_inode, vfs_inode);
 }
 
-inline struct block_device *I_BDEV(struct inode *inode)
+struct block_device *I_BDEV(struct inode *inode)
 {
 	return &BDEV_I(inode)->bdev;
 }
-
 EXPORT_SYMBOL(I_BDEV);
 
 static sector_t max_block(struct block_device *bdev)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-marker_debug-static.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
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
reiser4.patch

