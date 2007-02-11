From: akpm@linux-foundation.org
Subject: - remove-the-last-reference-to-rwlock_is_locked-macro.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:29 -0800
Message-ID: <200702112254.l1BMsTW2016235@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbXBKWyi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:54:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Remove the last reference to rwlock_is_locked() macro.
has been removed from the -mm tree.  Its filename was
     remove-the-last-reference-to-rwlock_is_locked-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove the last reference to rwlock_is_locked() macro.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the lone, remaining reference to the long-deceased
rwlock_is_locked() macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/spinlock.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-arm/spinlock.h~remove-the-last-reference-to-rwlock_is_locked-macro include/asm-arm/spinlock.h
--- a/include/asm-arm/spinlock.h~remove-the-last-reference-to-rwlock_is_locked-macro
+++ a/include/asm-arm/spinlock.h
@@ -85,7 +85,6 @@ static inline void __raw_spin_unlock(raw
  * Write locks are easy - we just set bit 31.  When unlocking, we can
  * just write zero since the lock is exclusively held.
  */
-#define rwlock_is_locked(x)	(*((volatile unsigned int *)(x)) != 0)
 
 static inline void __raw_write_lock(raw_rwlock_t *rw)
 {
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
