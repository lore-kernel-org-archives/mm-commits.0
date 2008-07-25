From: akpm@linux-foundation.org
Subject: - fat-dirc-switch-to-struct-__fat_dirent.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:27 -0700
Message-ID: <200807252257.m6PMvReJ003189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756461AbYGYW6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat/dir.c: switch to struct __fat_dirent
has been removed from the -mm tree.  Its filename was
     fat-dirc-switch-to-struct-__fat_dirent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat/dir.c: switch to struct __fat_dirent
From: Adrian Bunk <bunk@kernel.org>

struct __fat_dirent is what was formerly the kernel struct dirent (that
was different from the userspace struct dirent).

Converting all fat users to struct __fat_dirent will allow us to get rid
of the conflicting struct dirent definition.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/fat/dir.c~fat-dirc-switch-to-struct-__fat_dirent fs/fat/dir.c
--- a/fs/fat/dir.c~fat-dirc-switch-to-struct-__fat_dirent
+++ a/fs/fat/dir.c
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
-#include <linux/dirent.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/compat.h>
@@ -715,7 +714,7 @@ efault:									   \
 	return -EFAULT;							   \
 }
 
-FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, dirent)
+FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, __fat_dirent)
 
 static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
 			     void __user *dirent, filldir_t filldir,
@@ -741,7 +740,7 @@ static int fat_ioctl_readdir(struct inod
 static int fat_dir_ioctl(struct inode *inode, struct file *filp,
 			 unsigned int cmd, unsigned long arg)
 {
-	struct dirent __user *d1 = (struct dirent __user *)arg;
+	struct __fat_dirent __user *d1 = (struct __fat_dirent __user *)arg;
 	int short_only, both;
 
 	switch (cmd) {
@@ -757,7 +756,7 @@ static int fat_dir_ioctl(struct inode *i
 		return fat_generic_ioctl(inode, filp, cmd, arg);
 	}
 
-	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct dirent[2])))
+	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct __fat_dirent[2])))
 		return -EFAULT;
 	/*
 	 * Yes, we don't need this put_user() absolutely. However old
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

