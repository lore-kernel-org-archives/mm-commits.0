From: akpm@linux-foundation.org
Subject: + scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch added to -mm tree
Date: Thu, 08 May 2008 13:38:12 -0700
Message-ID: <200805082038.m48KcCAA004687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758328AbYEHUio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     scsi: aic79xx aic79xx_pci.c fix shadowed variables
has been added to the -mm tree.  Its filename is
     scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch

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
Subject: scsi: aic79xx aic79xx_pci.c fix shadowed variables
From: Harvey Harrison <harvey.harrison@gmail.com>

OK to just reuse the outer declaration as it is never used again.
drivers/scsi/aic7xxx/aic79xx_pci.c:340:12: warning: symbol 'devconfig' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_pci.c:299:12: originally declared here

targpcistat is always assigned just before use, remove the inner declaration.
drivers/scsi/aic7xxx/aic79xx_pci.c:486:9: warning: symbol 'targpcistat' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_pci.c:429:9: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_pci.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -337,8 +337,6 @@ ahd_pci_config(struct ahd_softc *ahd, co
 	 * 64bit bus (PCI64BIT set in devconfig).
 	 */
 	if ((ahd->flags & (AHD_39BIT_ADDRESSING|AHD_64BIT_ADDRESSING)) != 0) {
-		uint32_t devconfig;
-
 		if (bootverbose)
 			printf("%s: Enabling 39Bit Addressing\n",
 			       ahd_name(ahd));
@@ -483,8 +481,6 @@ ahd_pci_test_register_access(struct ahd_
 		goto fail;
 
 	if ((ahd_inb(ahd, INTSTAT) & PCIINT) != 0) {
-		u_int targpcistat;
-
 		ahd_set_modes(ahd, AHD_MODE_CFG, AHD_MODE_CFG);
 		targpcistat = ahd_inb(ahd, TARGPCISTAT);
 		if ((targpcistat & STA) != 0)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
misc-fix-integer-as-null-pointer-warnings.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
git-alsa-tiwai.patch
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
usb-fix-integer-as-null-pointer-sparse-warnings.patch
usb-use-get_unaligned_-helpers.patch
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
lib-add-ascii-hex-helper-functions.patch
lib-add-ascii-hex-helper-functions-update.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

