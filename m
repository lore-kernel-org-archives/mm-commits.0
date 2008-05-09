From: akpm@linux-foundation.org
Subject: - ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch removed from -mm tree
Date: Fri, 09 May 2008 14:47:06 -0700
Message-ID: <200805092147.m49Ll6NY027184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbYEIV4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ide-tape: use clamp_t() rather than nested min_t()/max_t()
has been removed from the -mm tree.  Its filename was
     ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ide-tape: use clamp_t() rather than nested min_t()/max_t()
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-tape.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/ide/ide-tape.c~ide-tape-use-clamp_t-rather-than-nested-min_t-max_t drivers/ide/ide-tape.c
--- a/drivers/ide/ide-tape.c~ide-tape-use-clamp_t-rather-than-nested-min_t-max_t
+++ a/drivers/ide/ide-tape.c
@@ -2746,9 +2746,8 @@ static void idetape_setup(ide_drive_t *d
 	 * Ensure that the number we got makes sense; limit it within
 	 * IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
 	 */
-	tape->best_dsc_rw_freq = max_t(unsigned long,
-				min_t(unsigned long, t, IDETAPE_DSC_RW_MAX),
-				IDETAPE_DSC_RW_MIN);
+	tape->best_dsc_rw_freq = clamp_t(unsigned long, t, IDETAPE_DSC_RW_MIN,
+					 IDETAPE_DSC_RW_MAX);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
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
lib-add-ascii-hex-helper-functions.patch
lib-add-ascii-hex-helper-functions-update.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

