From: akpm@linux-foundation.org
Subject: - drivers-edac-turnon-edac-device-error-logging.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:05:35 -0800
Message-ID: <200802080805.m1885GP3014322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760519AbYBHITb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers-edac: turn on edac device error logging
has been removed from the -mm tree.  Its filename was
     drivers-edac-turnon-edac-device-error-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-edac: turn on edac device error logging
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

origin.patch
