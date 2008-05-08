From: akpm@linux-foundation.org
Subject: + scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch added to -mm tree
Date: Thu, 08 May 2008 13:38:10 -0700
Message-ID: <200805082038.m48KcBIM004684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758015AbYEHUim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     scsi: aic79xx_core fix shadowed variables, add statics
has been added to the -mm tree.  Its filename is
     scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch

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
Subject: scsi: aic79xx_core fix shadowed variables, add statics
From: Harvey Harrison <harvey.harrison@gmail.com>

Redeclared within different if/else blocks, safe to reuse the
original from beginning of function.
drivers/scsi/aic7xxx/aic79xx_core.c:2475:10: warning: symbol 'scbid' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_core.c:2399:10: originally declared here
drivers/scsi/aic7xxx/aic79xx_core.c:2586:10: warning: symbol 'scbid' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_core.c:2399:10: originally declared here
drivers/scsi/aic7xxx/aic79xx_core.c:2587:15: warning: symbol 'scb' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_core.c:2393:13: originally declared here

Use caminfo for the outer declaration, the redeclared version is
iterating over all initiator/target pairs (devices) which.
drivers/scsi/aic7xxx/aic79xx_core.c:8857:23: warning: symbol 'devinfo' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_core.c:8711:21: originally declared here

Forward declaration was already marked static, make the definition match.
drivers/scsi/aic7xxx/aic79xx_core.c:3693:1: warning: symbol 'ahd_devlimited_syncrate' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~scsi-aic79xx_core-fix-shadowed-variables-add-statics drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~scsi-aic79xx_core-fix-shadowed-variables-add-statics
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2472,8 +2472,6 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 		if ((ahd->bugs & AHD_CLRLQO_AUTOCLR_BUG) != 0)
 			ahd_outb(ahd, CLRLQOINT1, 0);
 	} else if ((status & SELTO) != 0) {
-		u_int  scbid;
-
 		/* Stop the selection */
 		ahd_outb(ahd, SCSISEQ0, 0);
 
@@ -2583,9 +2581,6 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 		case BUSFREE_DFF0:
 		case BUSFREE_DFF1:
 		{
-			u_int	scbid;
-			struct	scb *scb;
-
 			mode = busfreetime == BUSFREE_DFF0
 			     ? AHD_MODE_DFF0 : AHD_MODE_DFF1;
 			ahd_set_modes(ahd, mode, mode);
@@ -3689,7 +3684,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u
  * by the capabilities of the bus connectivity of and sync settings for
  * the target.
  */
-void
+static void
 ahd_devlimited_syncrate(struct ahd_softc *ahd,
 			struct ahd_initiator_tinfo *tinfo,
 			u_int *period, u_int *ppr_options, role_t role)
@@ -8708,7 +8703,7 @@ ahd_reset_current_bus(struct ahd_softc *
 int
 ahd_reset_channel(struct ahd_softc *ahd, char channel, int initiate_reset)
 {
-	struct	ahd_devinfo devinfo;
+	struct	ahd_devinfo caminfo;
 	u_int	initiator;
 	u_int	target;
 	u_int	max_scsiid;
@@ -8729,7 +8724,7 @@ ahd_reset_channel(struct ahd_softc *ahd,
 
 	ahd->pending_device = NULL;
 
-	ahd_compile_devinfo(&devinfo,
+	ahd_compile_devinfo(&caminfo,
 			    CAM_TARGET_WILDCARD,
 			    CAM_TARGET_WILDCARD,
 			    CAM_LUN_WILDCARD,
@@ -8868,7 +8863,7 @@ ahd_reset_channel(struct ahd_softc *ahd,
 	}
 
 	/* Notify the XPT that a bus reset occurred */
-	ahd_send_async(ahd, devinfo.channel, CAM_TARGET_WILDCARD,
+	ahd_send_async(ahd, caminfo.channel, CAM_TARGET_WILDCARD,
 		       CAM_LUN_WILDCARD, AC_BUS_RESET);
 
 	ahd_restart(ahd);
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

