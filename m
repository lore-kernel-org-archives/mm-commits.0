From: akpm@linux-foundation.org
Subject: + pata_it821x-resume-from-hibernation-fails-with-raid-volume.patch added to -mm tree
Date: Thu, 05 Feb 2009 12:00:18 -0800
Message-ID: <200902052000.n15K0IVt008706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972AbZBEUBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 15:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org


The patch titled
     pata_it821x: resume from hibernation fails with RAID volume
has been added to the -mm tree.  Its filename is
     pata_it821x-resume-from-hibernation-fails-with-raid-volume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
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

pata_it821x-resume-from-hibernation-fails-with-raid-volume.patch

