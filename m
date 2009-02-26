From: akpm@linux-foundation.org
Subject: [merged] pata_it821x-resume-from-hibernation-fails-with-raid-volume.patch removed from -mm tree
Date: Thu, 26 Feb 2009 11:30:41 -0800
Message-ID: <200902261930.n1QJUfYo014456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbZBZTbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 14:31:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     pata_it821x: resume from hibernation fails with RAID volume
has been removed from the -mm tree.  Its filename was
     pata_it821x-resume-from-hibernation-fails-with-raid-volume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_it821x: resume from hibernation fails with RAID volume
From: Ondrej Zary <linux@rainbow-software.org>

Hibernation didn't work for me since I started to use IT8212 controller. 
I did some debugging (booting with no_console_suspend init=/bin/sh).

Found that resume fails (2.6.28) with "serial number mismatch 'some
garbage' != 'some other garbage'" and "revalidation failed" messages. 
That's because the controller firmware fills different serial number in
the IDENTIFY every boot.

The patch below fixes the resume simply clearing the serial number.  The
proper fix would be probably to fill in the serial number of the RAID
volume instead.  I assume that there must be something like that stored on
the drives but I don't know where.

Fix resume on pata_it821x RAID volume by clearing the serial number in
IDENTIFY data, which is otherwise different on each boot.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_it821x.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/ata/pata_it821x.c~pata_it821x-resume-from-hibernation-fails-with-raid-volume drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~pata_it821x-resume-from-hibernation-fails-with-raid-volume
+++ a/drivers/ata/pata_it821x.c
@@ -557,6 +557,9 @@ static unsigned int it821x_read_id(struc
 		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
 		id[86] |= 0x0400;	/* LBA48 on */
 		id[ATA_ID_MAJOR_VER] |= 0x1F;
+		/* Clear the serial number because it's different each boot
+		   which breaks validation on resume */
+		memset(&id[ATA_ID_SERNO], 0x20, ATA_ID_SERNO_LEN);
 	}
 	return err_mask;
 }
_

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch
agpgart-detected-ali-m-chipset-with-m1621.patch

