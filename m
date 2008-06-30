From: akpm@linux-foundation.org
Subject: + remove-the-in-kernel-struct-dirent64.patch added to -mm tree
Date: Mon, 30 Jun 2008 13:46:12 -0700
Message-ID: <200806302046.m5UKkC1V024588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760614AbYF3Ur2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 16:47:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, hirofumi@mail.parknet.co.jp, hpa@kernel.org


The patch titled
     remove the in-kernel struct dirent{,64}
has been added to the -mm tree.  Its filename is
     remove-the-in-kernel-struct-dirent64.patch

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
Subject: remove the in-kernel struct dirent{,64}
From: Adrian Bunk <bunk@kernel.org>

The kernel struct dirent{,64} were different from the ones in
userspace.

Even worse, we exported the kernel ones to userspace.

But after the fat usages are fixed we can remove the conflicting
kernel versions.

Reviewed-by: H. Peter Anvin <hpa@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild   |    1 -
 include/linux/dirent.h |   20 --------------------
 2 files changed, 21 deletions(-)

diff -puN include/linux/Kbuild~remove-the-in-kernel-struct-dirent64 include/linux/Kbuild
--- a/include/linux/Kbuild~remove-the-in-kernel-struct-dirent64
+++ a/include/linux/Kbuild
@@ -189,7 +189,6 @@ unifdef-y += connector.h
 unifdef-y += cuda.h
 unifdef-y += cyclades.h
 unifdef-y += dccp.h
-unifdef-y += dirent.h
 unifdef-y += dlm.h
 unifdef-y += dlm_plock.h
 unifdef-y += edd.h
diff -puN include/linux/dirent.h~remove-the-in-kernel-struct-dirent64 include/linux/dirent.h
--- a/include/linux/dirent.h~remove-the-in-kernel-struct-dirent64
+++ a/include/linux/dirent.h
@@ -1,23 +1,6 @@
 #ifndef _LINUX_DIRENT_H
 #define _LINUX_DIRENT_H
 
-struct dirent {
-	long		d_ino;
-	__kernel_off_t	d_off;
-	unsigned short	d_reclen;
-	char		d_name[256]; /* We must not include limits.h! */
-};
-
-struct dirent64 {
-	__u64		d_ino;
-	__s64		d_off;
-	unsigned short	d_reclen;
-	unsigned char	d_type;
-	char		d_name[256];
-};
-
-#ifdef __KERNEL__
-
 struct linux_dirent64 {
 	u64		d_ino;
 	s64		d_off;
@@ -26,7 +9,4 @@ struct linux_dirent64 {
 	char		d_name[0];
 };
 
-#endif	/* __KERNEL__ */
-
-
 #endif
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
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_fs_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
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
reiser4.patch

