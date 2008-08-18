From: akpm@linux-foundation.org
Subject: - ibmaem-update-the-documentation-to-reflect-the-current-name.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:07 -0700
Message-ID: <200808181940.m7IJe7m0008424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763243AbYHRTrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ibmaem: update the documentation to reflect the current name
has been removed from the -mm tree.  Its filename was
     ibmaem-update-the-documentation-to-reflect-the-current-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmaem: update the documentation to reflect the current name
From: "Darrick J. Wong" <djwong@us.ibm.com>

Minor documentation update to reflect the current full name of the power
management hardware interface and reflows the text a bit.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/ibmaem |   37 +++++++++++++++++------------------
 drivers/hwmon/ibmaem.c     |    6 ++---
 2 files changed, 22 insertions(+), 21 deletions(-)

diff -puN Documentation/hwmon/ibmaem~ibmaem-update-the-documentation-to-reflect-the-current-name Documentation/hwmon/ibmaem
--- a/Documentation/hwmon/ibmaem~ibmaem-update-the-documentation-to-reflect-the-current-name
+++ a/Documentation/hwmon/ibmaem
@@ -1,8 +1,11 @@
 Kernel driver ibmaem
 ======================
 
+This driver talks to the IBM Systems Director Active Energy Manager, known
+henceforth as AEM.
+
 Supported systems:
-  * Any recent IBM System X server with Active Energy Manager support.
+  * Any recent IBM System X server with AEM support.
     This includes the x3350, x3550, x3650, x3655, x3755, x3850 M2,
     x3950 M2, and certain HS2x/LS2x/QS2x blades.  The IPMI host interface
     driver ("ipmi-si") needs to be loaded for this driver to do anything.
@@ -14,24 +17,22 @@ Author: Darrick J. Wong
 Description
 -----------
 
-This driver implements sensor reading support for the energy and power
-meters available on various IBM System X hardware through the BMC.  All
-sensor banks will be exported as platform devices; this driver can talk
-to both v1 and v2 interfaces.  This driver is completely separate from the
-older ibmpex driver.
-
-The v1 AEM interface has a simple set of features to monitor energy use.
-There is a register that displays an estimate of raw energy consumption
-since the last BMC reset, and a power sensor that returns average power
-use over a configurable interval.
-
-The v2 AEM interface is a bit more sophisticated, being able to present
-a wider range of energy and power use registers, the power cap as
-set by the AEM software, and temperature sensors.
+This driver implements sensor reading support for the energy and power meters
+available on various IBM System X hardware through the BMC.  All sensor banks
+will be exported as platform devices; this driver can talk to both v1 and v2
+interfaces.  This driver is completely separate from the older ibmpex driver.
+
+The v1 AEM interface has a simple set of features to monitor energy use.  There
+is a register that displays an estimate of raw energy consumption since the
+last BMC reset, and a power sensor that returns average power use over a
+configurable interval.
+
+The v2 AEM interface is a bit more sophisticated, being able to present a wider
+range of energy and power use registers, the power cap as set by the AEM
+software, and temperature sensors.
 
 Special Features
 ----------------
 
-The "power_cap" value displays the current system power cap, as set by
-the Active Energy Manager software.  Setting the power cap from the host
-is not currently supported.
+The "power_cap" value displays the current system power cap, as set by the AEM
+software.  Setting the power cap from the host is not currently supported.
diff -puN drivers/hwmon/ibmaem.c~ibmaem-update-the-documentation-to-reflect-the-current-name drivers/hwmon/ibmaem.c
--- a/drivers/hwmon/ibmaem.c~ibmaem-update-the-documentation-to-reflect-the-current-name
+++ a/drivers/hwmon/ibmaem.c
@@ -1,6 +1,6 @@
 /*
- * A hwmon driver for the IBM Active Energy Manager temperature/power sensors
- * and capping functionality.
+ * A hwmon driver for the IBM System Director Active Energy Manager (AEM)
+ * temperature/power/energy sensors and capping functionality.
  * Copyright (C) 2008 IBM
  *
  * Author: Darrick J. Wong <djwong@us.ibm.com>
@@ -1104,7 +1104,7 @@ static void __exit aem_exit(void)
 }
 
 MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
-MODULE_DESCRIPTION("IBM Active Energy Manager power/temp sensor driver");
+MODULE_DESCRIPTION("IBM AEM power/temp/energy sensor driver");
 MODULE_LICENSE("GPL");
 
 module_init(aem_init);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch

