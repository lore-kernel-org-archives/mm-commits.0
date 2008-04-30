From: akpm@linux-foundation.org
Subject: - make-vfs_ioctl-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:23 -0700
Message-ID: <200804300539.m3U5dNBL028842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294AbYD3Fjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     make vfs_ioctl() static
has been removed from the -mm tree.  Its filename was
     make-vfs_ioctl-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make vfs_ioctl() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global vfs_ioctl() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c         |    4 ++--
 include/linux/fs.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ioctl.c~make-vfs_ioctl-static fs/ioctl.c
--- a/fs/ioctl.c~make-vfs_ioctl-static
+++ a/fs/ioctl.c
@@ -28,8 +28,8 @@
  *
  * Returns 0 on success, -errno on error.
  */
-long vfs_ioctl(struct file *filp, unsigned int cmd,
-	       unsigned long arg)
+static long vfs_ioctl(struct file *filp, unsigned int cmd,
+		      unsigned long arg)
 {
 	int error = -ENOTTY;
 
diff -puN include/linux/fs.h~make-vfs_ioctl-static include/linux/fs.h
--- a/include/linux/fs.h~make-vfs_ioctl-static
+++ a/include/linux/fs.h
@@ -1964,7 +1964,6 @@ extern int vfs_stat_fd(int dfd, char __u
 extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 
-extern long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
 
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

