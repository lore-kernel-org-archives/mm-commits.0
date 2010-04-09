From: akpm@linux-foundation.org
Subject: [merged] scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch removed from -mm tree
Date: Fri, 09 Apr 2010 10:52:48 -0400
Message-ID: <201004091754.o39HsILm002184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab0DIRyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 13:54:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, anil_ravindranath@pmc-sierra.com, mm-commits@vger.kernel.org


The patch titled
     scsi/pmcraid: redundant check in pmcraid_check_ioctl_buffer()?
has been removed from the -mm tree.  Its filename was
     scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi/pmcraid: redundant check in pmcraid_check_ioctl_buffer()?
From: Roel Kluin <roel.kluin@gmail.com>

struct pmcraid_ioctl_header member buffer_length is unsigned, so this
check appears redundant.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pmcraid.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/scsi/pmcraid.c~scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c~scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer
+++ a/drivers/scsi/pmcraid.c
@@ -3751,12 +3751,6 @@ static int pmcraid_check_ioctl_buffer(
 		return -EINVAL;
 	}
 
-	/* buffer length can't be negetive */
-	if (hdr->buffer_length < 0) {
-		pmcraid_err("ioctl: invalid buffer length specified\n");
-		return -EINVAL;
-	}
