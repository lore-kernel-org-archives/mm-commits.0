From: akpm@linux-foundation.org
Subject: + fat-dirc-switch-to-struct-__fat_dirent.patch added to -mm tree
Date: Mon, 30 Jun 2008 20:34:12 -0700
Message-ID: <200807010334.m613YCgS007136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbYGADe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 23:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, hirofumi@mail.parknet.co.jp


The patch titled
     fat/dir.c: switch to struct __fat_dirent
has been added to the -mm tree.  Its filename is
     fat-dirc-switch-to-struct-__fat_dirent.patch

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
firmware-fix-the-request_firmware-dummy.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
scsi-make-struct-scsi_hosttarget_type-static.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
mm-page_allocc-cleanups.patch
mm-make-register_page_bootmem_info_section-static.patch
remove-include-asm-h8300-keyboardh.patch
alpha-remove-the-unused-alpha_core_agp-option.patch
remove-include-linux-pm_legacyh.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
video-sis-remove-compat-code.patch
drivers-video-amifbc-cleanups.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
fat-dirc-switch-to-struct-__fat_fs_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
remove-is_tty.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
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
reiser4.patch

