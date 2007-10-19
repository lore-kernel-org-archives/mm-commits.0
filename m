From: akpm@linux-foundation.org
Subject: + drivers-edac-turnon-edac-device-error-logging.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:18:01 -0700
Message-ID: <200710192118.l9JLI1Zc020508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764826AbXJSVSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk


The patch titled
     drivers-edac: turnon edac device error logging
has been added to the -mm tree.  Its filename is
     drivers-edac-turnon-edac-device-error-logging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: turnon edac device error logging
From: Doug Thompson <dougthompson@xmission.com>

ENABLE the 'logging' of CE and UE events for the EDAC_DEVICE class of error
harvester in EDAC

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/edac/edac_device.c~drivers-edac-turnon-edac-device-error-logging drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-turnon-edac-device-error-logging
+++ a/drivers/edac/edac_device.c
@@ -155,6 +155,10 @@ struct edac_device_ctl_info *edac_device
 	dev_ctl->instances = dev_inst;
 	dev_ctl->pvt_info = pvt;
 
+	/* Default logging of CEs and UEs */
+	dev_ctl->log_ce = 1;
+	dev_ctl->log_ue = 1;
+
 	/* Name of this edac device */
 	snprintf(dev_ctl->name,sizeof(dev_ctl->name),"%s",edac_device_name);
 
_

Patches currently in -mm which might be from dougthompson@xmission.com are

null-terminate-the-pci_device_ids-in-pasemi_edac.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
