From: akpm@linux-foundation.org
Subject: - scsi-remove-private-implementation-of-get_unaligned_be32.patch removed from -mm tree
Date: Thu, 30 Oct 2008 10:21:01 -0700
Message-ID: <200810301721.m9UHL1Fp016526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbYJ3RVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 13:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: remove private implementation of get_unaligned_be32
has been removed from the -mm tree.  Its filename was
     scsi-remove-private-implementation-of-get_unaligned_be32.patch

This patch was dropped because of boredom

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: remove private implementation of get_unaligned_be32
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_expander.c |    9 +++++----
 include/scsi/scsi.h                |    6 ------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/libsas/sas_expander.c~scsi-remove-private-implementation-of-get_unaligned_be32 drivers/scsi/libsas/sas_expander.c
--- a/drivers/scsi/libsas/sas_expander.c~scsi-remove-private-implementation-of-get_unaligned_be32
+++ a/drivers/scsi/libsas/sas_expander.c
@@ -24,6 +24,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
+#include <asm/unaligned.h>
 
 #include "sas_internal.h"
 
@@ -541,10 +542,10 @@ int sas_smp_get_phy_events(struct sas_ph
 	if (!res)
 		goto out;
 
-	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
-	phy->running_disparity_error_count = scsi_to_u32(&resp[16]);
-	phy->loss_of_dword_sync_count = scsi_to_u32(&resp[20]);
-	phy->phy_reset_problem_count = scsi_to_u32(&resp[24]);
+	phy->invalid_dword_count = get_unaligned_be32(&resp[12]);
+	phy->running_disparity_error_count = get_unaligned_be32(&resp[16]);
+	phy->loss_of_dword_sync_count = get_unaligned_be32(&resp[20]);
+	phy->phy_reset_problem_count = get_unaligned_be32(&resp[24]);
 
  out:
 	kfree(resp);
diff -puN include/scsi/scsi.h~scsi-remove-private-implementation-of-get_unaligned_be32 include/scsi/scsi.h
--- a/include/scsi/scsi.h~scsi-remove-private-implementation-of-get_unaligned_be32
+++ a/include/scsi/scsi.h
@@ -527,10 +527,4 @@ static inline void set_driver_byte(struc
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
-static inline __u32 scsi_to_u32(__u8 *ptr)
-{
-	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
-}
