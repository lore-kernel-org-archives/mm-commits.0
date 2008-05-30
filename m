From: akpm@linux-foundation.org
Subject: - media-use-get_unaligned_-helpers.patch removed from -mm tree
Date: Fri, 30 May 2008 15:38:36 -0700
Message-ID: <200805302238.m4UMcar4014839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbYE3WjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     media: use get_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     media-use-get_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: media: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-si470x.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/media/radio/radio-si470x.c~media-use-get_unaligned_-helpers drivers/media/radio/radio-si470x.c
--- a/drivers/media/radio/radio-si470x.c~media-use-get_unaligned_-helpers
+++ a/drivers/media/radio/radio-si470x.c
@@ -521,8 +521,7 @@ static int si470x_get_register(struct si
 	retval = si470x_get_report(radio, (void *) &buf, sizeof(buf));
 
 	if (retval >= 0)
-		radio->registers[regnr] = be16_to_cpu(get_unaligned(
-			(unsigned short *) &buf[1]));
+		radio->registers[regnr] = get_unaligned_be16(&buf[1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -561,9 +560,8 @@ static int si470x_get_all_registers(stru
 
 	if (retval >= 0)
 		for (regnr = 0; regnr < RADIO_REGISTER_NUM; regnr++)
-			radio->registers[regnr] = be16_to_cpu(get_unaligned(
-				(unsigned short *)
-				&buf[regnr * RADIO_REGISTER_SIZE + 1]));
+			radio->registers[regnr] = get_unaligned_be16(
+				&buf[regnr * RADIO_REGISTER_SIZE + 1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -593,9 +591,8 @@ static int si470x_get_rds_registers(stru
 
 	if (retval >= 0)
 		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
-			radio->registers[STATUSRSSI + regnr] =
-				be16_to_cpu(get_unaligned((unsigned short *)
-				&buf[regnr * RADIO_REGISTER_SIZE + 1]));
+			radio->registers[STATUSRSSI + regnr] = get_unaligned_be16(
+				&buf[regnr * RADIO_REGISTER_SIZE + 1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-cp2101c-fix-sparse-signedness-mismatch-warnings.patch
usb-speedtchc-fix-sparse-shadowed-variable-warning.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
asm-generic-int-ll64h-always-provide-__su64.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

