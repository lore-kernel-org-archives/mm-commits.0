From: akpm@linux-foundation.org
Subject: - lib-add-ascii-hex-helper-functions-update.patch removed from -mm tree
Date: Mon, 12 May 2008 17:24:30 -0700
Message-ID: <200805130024.m4D0OUUt016545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbYEMAZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:25:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: add ascii hex helper functions (update)
has been removed from the -mm tree.  Its filename was
     lib-add-ascii-hex-helper-functions-update.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: add ascii hex helper functions (update)
From: Harvey Harrison <harvey.harrison@gmail.com>

Please add this version, I missed a git add on include/linux/kernel.h
and as such misses the declarations of the the u8/u16/u32/u64 functions.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~lib-add-ascii-hex-helper-functions-update include/linux/kernel.h
--- a/include/linux/kernel.h~lib-add-ascii-hex-helper-functions-update
+++ a/include/linux/kernel.h
@@ -272,10 +272,16 @@ extern void print_hex_dump_bytes(const c
 			const void *buf, size_t len);
 
 extern const char hex_asc[];
-extern int hex_to_int(char c);
+int hex_char_to_int(char ch);
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
 #define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
 
+int hex_to_val(const char *buf, unsigned long *val, unsigned int maxchars);
+int hex_to_u8(const char *buf, u8 *val);
+int hex_to_u16(const char *buf, u16 *val);
+int hex_to_u32(const char *buf, u32 *val);
+int hex_to_u64(const char *buf, u64 *val);
+
 #define pr_emerg(fmt, arg...) \
 	printk(KERN_EMERG fmt, ##arg)
 #define pr_alert(fmt, arg...) \
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

mmc-make-one-bit-signed-bitfields-unsigned.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-add-ascii-hex-helper-functions-update.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

