From: akpm@linux-foundation.org
Subject: - apple-smc-driver-do-not-print-error-on-systems-without-apple-motion-sensor.patch removed from -mm tree
Date: Thu, 03 May 2007 18:01:10 -0700
Message-ID: <200705040101.l4411APn026287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767563AbXEDBBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 21:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, khali@linux-fr.org, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     apple-smc-driver: do not print error on systems without apple motion sensor
has been removed from the -mm tree.  Its filename was
     apple-smc-driver-do-not-print-error-on-systems-without-apple-motion-sensor.patch

This patch was dropped because it was folded into apple-smc-driver-hardware-monitoring-and-control.patch

------------------------------------------------------
Subject: apple-smc-driver: do not print error on systems without apple motion sensor
From: Olaf Hering <olaf@aepfle.de>

It is not an error if a system has no ams hardware.  Do not clutter dmesg
in this case.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ams/ams-core.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/hwmon/ams/ams-core.c~apple-smc-driver-do-not-print-error-on-systems-without-apple-motion-sensor drivers/hwmon/ams/ams-core.c
--- a/drivers/hwmon/ams/ams-core.c~apple-smc-driver-do-not-print-error-on-systems-without-apple-motion-sensor
+++ a/drivers/hwmon/ams/ams-core.c
@@ -219,9 +219,6 @@ int __init ams_init(void)
 		/* Found PMU motion sensor */
 		return ams_pmu_init(np);
 #endif
-
-	printk(KERN_ERR "ams: No motion sensor found.\n");
-
 	return -ENODEV;
 }
 
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
git-kbuild.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
keep-track-of-network-interface-renaming.patch
