From: akpm@linux-foundation.org
Subject: - lib-export-bitrev16.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:57 -0700
Message-ID: <200806081947.m58JlvS9017459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbYFHTsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, akinobu.mita@gmail.com, hidave.darkstar@gmail.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     lib: export bitrev16
has been removed from the -mm tree.  Its filename was
     lib-export-bitrev16.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: export bitrev16
From: Harvey Harrison <harvey.harrison@gmail.com>

Bluetooth will be able to use this.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitrev.h |    1 +
 lib/bitrev.c           |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/bitrev.h~lib-export-bitrev16 include/linux/bitrev.h
--- a/include/linux/bitrev.h~lib-export-bitrev16
+++ a/include/linux/bitrev.h
@@ -10,6 +10,7 @@ static inline u8 bitrev8(u8 byte)
 	return byte_rev_table[byte];
 }
 
+extern u16 bitrev16(u16 in);
 extern u32 bitrev32(u32 in);
 
 #endif /* _LINUX_BITREV_H */
diff -puN lib/bitrev.c~lib-export-bitrev16 lib/bitrev.c
--- a/lib/bitrev.c~lib-export-bitrev16
+++ a/lib/bitrev.c
@@ -42,10 +42,11 @@ const u8 byte_rev_table[256] = {
 };
 EXPORT_SYMBOL_GPL(byte_rev_table);
 
-static __always_inline u16 bitrev16(u16 x)
+u16 bitrev16(u16 x)
 {
 	return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
 }
+EXPORT_SYMBOL(bitrev16);
 
 /**
  * bitrev32 - reverse the order of bits in a u32 value
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-cp2101c-fix-sparse-signedness-mismatch-warnings.patch
usb-speedtchc-fix-sparse-shadowed-variable-warning.patch
usb-digi_accelportc-trivial-sparse-lock-annotation.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

