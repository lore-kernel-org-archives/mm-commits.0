From: akpm@linux-foundation.org
Subject: + fat_valid_media-isnt-for-userspace.patch added to -mm tree
Date: Sun, 08 Jun 2008 17:37:01 -0700
Message-ID: <200806090037.m590b1Sp027775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345AbYFIAhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 20:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, caglar@pardus.org.tr, hirofumi@mail.parknet.co.jp, onur@pardus.org.tr


The patch titled
     fat_valid_media() isn't for userspace
has been added to the -mm tree.  Its filename is
     fat_valid_media-isnt-for-userspace.patch

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
Subject: fat_valid_media() isn't for userspace
From: Adrian Bunk <bunk@kernel.org>

Commit 73f20e58b1d586e9f6d3ddc3aad872829aca7743
(FAT_VALID_MEDIA(): remove pointless test)

wrongly added the new fat_valid_media() function to the userspace-visible
part of include/linux/msdos_fs.h

Move it to the part of include/linux/msdos_fs.h that is not exported to
userspace.

Reported-by: Onur Kucuk <onur@pardus.org.tr>
Reported-by: S.Caglar Onur <caglar@pardus.org.tr>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msdos_fs.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/msdos_fs.h~fat_valid_media-isnt-for-userspace include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fat_valid_media-isnt-for-userspace
+++ a/include/linux/msdos_fs.h
@@ -57,12 +57,6 @@
 #define MSDOS_DOT	".          "	/* ".", padded to MSDOS_NAME chars */
 #define MSDOS_DOTDOT	"..         "	/* "..", padded to MSDOS_NAME chars */
 
-/* media of boot sector */
-static inline int fat_valid_media(u8 media)
-{
-	return 0xf8 <= media || media == 0xf0;
-}
-
 #define FAT_FIRST_ENT(s, x)	((MSDOS_SB(s)->fat_bits == 32 ? 0x0FFFFF00 : \
 	MSDOS_SB(s)->fat_bits == 16 ? 0xFF00 : 0xF00) | (x))
 
@@ -334,6 +328,12 @@ static inline void fatwchar_to16(__u8 *d
 #endif
 }
 
+/* media of boot sector */
+static inline int fat_valid_media(u8 media)
+{
+	return 0xf8 <= media || media == 0xf0;
+}
+
 /* fat/cache.c */
 extern void fat_cache_inval_inode(struct inode *inode);
 extern int fat_get_cluster(struct inode *inode, int cluster,
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
if-0-ses_match_host.patch
git-xtensa.patch
fat_valid_media-isnt-for-userspace.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-include-linux-pm_legacyh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
remove-is_tty.patch
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

