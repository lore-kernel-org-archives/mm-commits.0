From: akpm@linux-foundation.org
Subject: + enable-link-power-management-for-ata-drivers-fix.patch added to -mm tree
Date: Thu, 16 Aug 2007 12:22:20 -0700
Message-ID: <200708161922.l7GJMKCY002921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243AbXHPTW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 15:22:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


The patch titled
     Enable link power management for ata drivers (fix)
has been added to the -mm tree.  Its filename is
     enable-link-power-management-for-ata-drivers-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Enable link power management for ata drivers (fix)
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

change to KERN_INFO for failure to set pm policy

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-scsi.c~enable-link-power-management-for-ata-drivers-fix drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~enable-link-power-management-for-ata-drivers-fix
+++ a/drivers/ata/libata-scsi.c
@@ -3006,7 +3006,7 @@ int ata_scsi_set_link_pm_policy(struct a
  		 */
 		if ((dev->horkage & ATA_HORKAGE_IPM) ||
 			!(dev->flags & ATA_DFLAG_IPM)) {
-			ata_dev_printk(dev, KERN_ERR,
+			ata_dev_printk(dev, KERN_INFO,
 				"Unable to set Link PM policy\n");
 			ap->pm_policy = MAX_PERFORMANCE;
 		}
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-libata-all.patch
alpm-store-interrupt-value.patch
alpm-increase-number-of-allowable-device-flags.patch
alpm-increase-number-of-allowable-device-flags-fix.patch
alpm-enable-link-power-management-for-ata-drivers.patch
enable-link-power-management-for-ata-drivers-fix.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-check-for-an-support.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
libata-send-event-when-an-received.patch
acpiphp_ibm-add-missing-n.patch
