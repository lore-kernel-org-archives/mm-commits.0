From: akpm@linux-foundation.org
Subject: - scsi-le_add_cpu-conversion.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:19:02 -0700
Message-ID: <200803312019.m2VKJ2mU024174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757420AbYCaU3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, Mark_Salyzyn@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     scsi: le*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     scsi-le_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: James.Bottomley@HansenPartnership.com
Acked-by: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commsup.c |    2 +-
 drivers/scsi/ips.c             |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aacraid/commsup.c~scsi-le_add_cpu-conversion drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~scsi-le_add_cpu-conversion
+++ a/drivers/scsi/aacraid/commsup.c
@@ -594,7 +594,7 @@ void aac_consumer_free(struct aac_dev * 
 	if (le32_to_cpu(*q->headers.consumer) >= q->entries)
 		*q->headers.consumer = cpu_to_le32(1);
 	else
-		*q->headers.consumer = cpu_to_le32(le32_to_cpu(*q->headers.consumer)+1);
+		le32_add_cpu(q->headers.consumer, 1);
 
 	if (wasfull) {
 		switch (qid) {
diff -puN drivers/scsi/ips.c~scsi-le_add_cpu-conversion drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~scsi-le_add_cpu-conversion
+++ a/drivers/scsi/ips.c
@@ -3664,9 +3664,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * 
 			scb->cmd.basic_io.sg_count = scb->sg_len;
 
 			if (scb->cmd.basic_io.lba)
-				scb->cmd.basic_io.lba =
-				    cpu_to_le32(le32_to_cpu
-						(scb->cmd.basic_io.lba) +
+				le32_add_cpu(&scb->cmd.basic_io.lba,
 						le16_to_cpu(scb->cmd.basic_io.
 							    sector_count));
 			else
@@ -3712,9 +3710,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * 
 			scb->cmd.basic_io.sg_count = scb->sg_len;
 
 			if (scb->cmd.basic_io.lba)
-				scb->cmd.basic_io.lba =
-				    cpu_to_le32(le32_to_cpu
-						(scb->cmd.basic_io.lba) +
+				le32_add_cpu(&scb->cmd.basic_io.lba,
 						le16_to_cpu(scb->cmd.basic_io.
 							    sector_count));
 			else
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-jfs.patch
git-udf.patch
git-net.patch
ntfs-le_add_cpu-conversion.patch
git-sched.patch
git-scsi-misc.patch
git-cryptodev.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
ufs-remove-unused-fs64_add-and-fs64_sub.patch
reiserfs-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch

