From: akpm@linux-foundation.org
Subject: - mmc-make-one-bit-signed-bitfields-unsigned.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:16 -0700
Message-ID: <200805132133.m4DLXGEL000803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761635AbYEMVdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: make one-bit signed bitfields unsigned
has been removed from the -mm tree.  Its filename was
     mmc-make-one-bit-signed-bitfields-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: make one-bit signed bitfields unsigned
From: Harvey Harrison <harvey.harrison@gmail.com>

Otherwise it can only take the values 0/-1 which doesn't seem to
have been intended.

drivers/mmc/host/sdhci.h:190:20: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.h~mmc-make-one-bit-signed-bitfields-unsigned drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~mmc-make-one-bit-signed-bitfields-unsigned
+++ a/drivers/mmc/host/sdhci.h
@@ -187,7 +187,7 @@ struct sdhci_host {
 	struct mmc_request	*mrq;		/* Current request */
 	struct mmc_command	*cmd;		/* Current command */
 	struct mmc_data		*data;		/* Current data request */
-	int			data_early:1;	/* Data finished before cmd */
+	unsigned int		data_early:1;	/* Data finished before cmd */
 
 	struct scatterlist	*cur_sg;	/* We're working on this */
 	int			num_sg;		/* Entries left */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
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
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-create-common-ascii-hex-array.patch
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
mn10300-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

