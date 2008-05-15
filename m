From: akpm@linux-foundation.org
Subject: + b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one-update.patch added to -mm tree
Date: Thu, 15 May 2008 15:40:47 -0700
Message-ID: <200805152240.m4FMelfH014063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbYEOWll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 18:41:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, linville@tuxdriver.com, mb@bu3sch.de


The patch titled
     b43: use the bitrev helpers rather than rolling a private one (update)
has been added to the -mm tree.  Its filename is
     b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one-update.patch

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
Subject: b43: use the bitrev helpers rather than rolling a private one (update)
From: Harvey Harrison <harvey.harrison@gmail.com>

The 4-bit reversal flip_4bit is replaced with the bitrev helper
bitrev8 and a 4-bit shift.  The B43_WARN is moved to the location
where a register is read from for checking there.  The other caller
explicitly passes an array index which is guaranteed to be within range
and so a B43_WARN is not added there.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Reviewed-by: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/phy.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/wireless/b43/phy.c~b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one-update drivers/net/wireless/b43/phy.c
--- a/drivers/net/wireless/b43/phy.c~b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one-update
+++ a/drivers/net/wireless/b43/phy.c
@@ -84,6 +84,7 @@ const u8 b43_radio_channel_codes_bg[] = 
 	72, 84,
 };
 
+#define bitrev4(tmp) (bitrev8(tmp) >> 4)
 static void b43_phy_initg(struct b43_wldev *dev);
 
 static void generate_rfatt_list(struct b43_wldev *dev,
@@ -2876,12 +2877,12 @@ b43_radio_interference_mitigation_enable
 		radio_stacksave(0x0078);
 		tmp = (b43_radio_read16(dev, 0x0078) & 0x001E);
 		B43_WARN_ON(tmp > 15);
-		flipped = bitrev8(tmp) >> 4;
+		flipped = bitrev4(tmp);
 		if (flipped < 10 && flipped >= 8)
 			flipped = 7;
 		else if (flipped >= 10)
 			flipped -= 3;
-		flipped = (bitrev8(flipped) >> 3) | 0x0020;
+		flipped = (bitrev4(flipped) << 1) | 0x0020;
 		b43_radio_write16(dev, 0x0078, flipped);
 
 		b43_calc_nrssi_threshold(dev);
@@ -3514,7 +3515,7 @@ u16 b43_radio_init2050(struct b43_wldev 
 	tmp1 >>= 9;
 
 	for (i = 0; i < 16; i++) {
-		radio78 = (bitrev8(i) >> 3) | 0x0020;
+		radio78 = (bitrev4(i) << 1) | 0x0020;
 		b43_radio_write16(dev, 0x78, radio78);
 		udelay(10);
 		for (j = 0; j < 16; j++) {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
lib-create-common-ascii-hex-array.patch
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
b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one.patch
b43-use-the-bitrev-helpers-rather-than-rolling-a-private-one-update.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

