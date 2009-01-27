From: akpm@linux-foundation.org
Subject: + sata-blacklisting-of-systems-that-spin-off-disks-during-acpi-power-off.patch added to -mm tree
Date: Mon, 26 Jan 2009 21:07:20 -0800
Message-ID: <200901270507.n0R57KqM016586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbZA0FIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 00:08:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, alan@lxorguk.ukuu.org.uk, elendil@planet.nl, fweisbec@gmail.com, jeff@garzik.org, maciej.rutecki@gmail.com, tj@kernel.org


The patch titled
     sata: blacklisting of systems that spin off disks during ACPI power off
has been added to the -mm tree.  Its filename is
     sata-blacklisting-of-systems-that-spin-off-disks-during-acpi-power-off.patch

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
Subject: sata: blacklisting of systems that spin off disks during ACPI power off
From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce new libata flags ATA_FLAG_NO_POWEROFF_SPINDOWN and
ATA_FLAG_NO_HIBERNATE_SPINDOWN that, if set, will prevent disks from being
spun off during system power off and hibernation, respectively (to handle
the hibernation case we need the new system state SYSTEM_HIBERNATE_ENTER
that can be checked against by libata, in analogy with SYSTEM_POWER_OFF).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |   20 +++++++++++++++++---
 include/linux/libata.h    |    2 ++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff -puN drivers/ata/libata-scsi.c~sata-blacklisting-of-systems-that-spin-off-disks-during-acpi-power-off drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~sata-blacklisting-of-systems-that-spin-off-disks-during-acpi-power-off
+++ a/drivers/ata/libata-scsi.c
@@ -46,6 +46,7 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 
 #include "libata.h"
 
@@ -1303,6 +1304,17 @@ static unsigned int ata_scsi_start_stop_
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
 	} else {
+		/* Some odd clown BIOSen issue spindown on power off (ACPI S4
+		 * or S5) causing some drives to spin up and down again.
+		 */
+		if ((qc->ap->flags & ATA_FLAG_NO_POWEROFF_SPINDOWN) &&
+		    system_state == SYSTEM_POWER_OFF)
+			goto skip;
+
+		if ((qc->ap->flags & ATA_FLAG_NO_HIBERNATE_SPINDOWN) &&
+		     system_entering_hibernation())
+			goto skip;
+
 		/* XXX: This is for backward compatibility, will be
 		 * removed.  Read Documentation/feature-removal-schedule.txt
 		 * for more info.
@@ -1326,8 +1338,7 @@ static unsigned int ata_scsi_start_stop_
 				scmd->scsi_done = qc->scsidone;
 				qc->scsidone = ata_delayed_done;
 			}
-			scmd->result = SAM_STAT_GOOD;
-			return 1;
+			goto skip;
 		}
 
 		/* Issue ATA STANDBY IMMEDIATE command */
@@ -1343,10 +1354,13 @@ static unsigned int ata_scsi_start_stop_
 
 	return 0;
 
-invalid_fld:
+ invalid_fld:
 	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
 	return 1;
+ skip:
+	scmd->result = SAM_STAT_GOOD;
+	return 1;
 }
 
 
diff -puN include/linux/libata.h~sata-blacklisting-of-systems-that-spin-off-disks-during-acpi-power-off include/linux/libata.h
--- a/include/linux/libata.h~sata-blacklisting-of-systems-that-spin-off-disks-during-acpi-power-off
+++ a/include/linux/libata.h
@@ -187,6 +187,8 @@ enum {
 	ATA_FLAG_PIO_POLLING	= (1 << 9), /* use polling PIO if LLD
 					     * doesn't handle PIO interrupts */
 	ATA_FLAG_NCQ		= (1 << 10), /* host supports NCQ */
+	ATA_FLAG_NO_POWEROFF_SPINDOWN = (1 << 11), /* don't spindown before poweroff */
+	ATA_FLAG_NO_HIBERNATE_SPINDOWN = (1 << 12), /* don't spindown before hibernation */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
misc-dell-laptop-should-depend-on-power_supply.patch
hibernation-introduce-system_entering_hibernation.patch
dmi-introduce-dmi_first_match-to-make-the-interface-more-flexible.patch
sata-blacklisting-of-systems-that-spin-off-disks-during-acpi-power-off.patch
sata-ahci-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch
sata-sil-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch
sata-piix-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch
shrink_slab-handle-bad-shrinkers.patch

