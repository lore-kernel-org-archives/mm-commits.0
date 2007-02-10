From: akpm@linux-foundation.org
Subject: - remove-a-couple-final-references-to-obsolete-verify_area.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:27:19 -0800
Message-ID: <200702100527.l1A5RJdl004668@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36834 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbXBJF1i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, hskinnemoen@atmel.com, jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Remove a couple final references to obsolete verify_area()
has been removed from the -mm tree.  Its filename was
     remove-a-couple-final-references-to-obsolete-verify_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove a couple final references to obsolete verify_area()
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove a couple final references to the obsolete verify_area() call, which
was long ago replaced by access_ok().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-avr32/checksum.h |    2 +-
 include/asm-avr32/uaccess.h  |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN include/asm-avr32/checksum.h~remove-a-couple-final-references-to-obsolete-verify_area include/asm-avr32/checksum.h
--- a/include/asm-avr32/checksum.h~remove-a-couple-final-references-to-obsolete-verify_area
+++ a/include/asm-avr32/checksum.h
@@ -38,7 +38,7 @@ __wsum csum_partial_copy_generic(const v
  *	passed in an incorrect kernel address to one of these functions.
  *
  *	If you use these functions directly please don't forget the
- *	verify_area().
+ *	access_ok().
  */
 static inline
 __wsum csum_partial_copy_nocheck(const void *src, void *dst,
diff -puN include/asm-avr32/uaccess.h~remove-a-couple-final-references-to-obsolete-verify_area include/asm-avr32/uaccess.h
--- a/include/asm-avr32/uaccess.h~remove-a-couple-final-references-to-obsolete-verify_area
+++ a/include/asm-avr32/uaccess.h
@@ -68,12 +68,6 @@ static inline void set_fs(mm_segment_t s
 
 #define access_ok(type, addr, size) (likely(__range_ok(addr, size) == 0))
 
-static inline int
-verify_area(int type, const void __user *addr, unsigned long size)
-{
-	return access_ok(type, addr, size) ? 0 : -EFAULT;
-}
-
 /* Generic arbitrary sized copy. Return the number of bytes NOT copied */
 extern __kernel_size_t __copy_user(void *to, const void *from,
 				   __kernel_size_t n);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
git-input.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
remove-final-references-to-deprecated-map_anon-page-protection-flag.patch
uml-fix-apparent-config_64_bit-typo.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-paride_parport.patch
fix-apparent-typo-config_lockdep_debug.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
