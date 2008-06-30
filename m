From: akpm@linux-foundation.org
Subject: + drivers-video-amifbc-cleanups.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:36:17 -0700
Message-ID: <200806302136.m5ULaJb5026627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933051AbYF3VhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, geert@linux-m68k.org


The patch titled
     drivers/video/amifb.c cleanups
has been added to the -mm tree.  Its filename is
     drivers-video-amifbc-cleanups.patch

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
Subject: drivers/video/amifb.c cleanups
From: Adrian Bunk <bunk@kernel.org>

This patch contains the following cleanups:
- make the needlessly global amifb_init() static
- rename cleanup_module() to amifb_exit(),
  make it static __exit,
  use module_exit(),
  there's no need to #ifdef MODULE it

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/amifb.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/video/amifb.c~drivers-video-amifbc-cleanups drivers/video/amifb.c
--- a/drivers/video/amifb.c~drivers-video-amifbc-cleanups
+++ a/drivers/video/amifb.c
@@ -1136,7 +1136,6 @@ static int amifb_ioctl(struct fb_info *i
 	 * Interface to the low level console driver
 	 */
 
-int amifb_init(void);
 static void amifb_deinit(void);
 
 	/*
@@ -2248,7 +2247,7 @@ static inline void chipfree(void)
 	 * Initialisation
 	 */
 
-int __init amifb_init(void)
+static int __init amifb_init(void)
 {
 	int tag, i, err = 0;
 	u_long chipptr;
@@ -3793,16 +3792,14 @@ static void ami_rebuild_copper(void)
 	}
 }
 
-
-module_init(amifb_init);
-
-#ifdef MODULE
-MODULE_LICENSE("GPL");
-
-void cleanup_module(void)
+static void __exit amifb_exit(void)
 {
 	unregister_framebuffer(&fb_info);
 	amifb_deinit();
 	amifb_video_off();
 }
-#endif /* MODULE */
+
+module_init(amifb_init);
+module_exit(amifb_exit);
+
+MODULE_LICENSE("GPL");
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
drivers-video-amifbc-cleanups.patch
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
make-macfb_setup-static.patch
reiser4.patch

