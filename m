From: akpm@linux-foundation.org
Subject: - ibmaem-overview-of-the-driver.patch removed from -mm tree
Date: Fri, 23 May 2008 12:22:41 -0700
Message-ID: <200805231922.m4NJMgv0005115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbYEWTXU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 15:23:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mhoffman@lightlink.com, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     ibmaem: overview of the driver
has been removed from the -mm tree.  Its filename was
     ibmaem-overview-of-the-driver.patch

This patch was dropped because it was folded into ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmaem: overview of the driver
From: "Darrick J. Wong" <djwong@us.ibm.com>

A brief overview of what this driver does

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/ibmaem |   37 +++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff -puN /dev/null Documentation/hwmon/ibmaem
--- /dev/null
+++ a/Documentation/hwmon/ibmaem
@@ -0,0 +1,37 @@
+Kernel driver ibmaem
+======================
+
+Supported systems:
+  * Any recent IBM System X server with Active Energy Manager support.
+    This includes the x3350, x3550, x3650, x3655, x3755, x3850 M2,
+    x3950 M2, and certain HS2x/LS2x/QS2x blades.  The IPMI host interface
+    driver ("ipmi-si") needs to be loaded for this driver to do anything.
+    Prefix: 'ibmaem'
+    Datasheet: Not available
+
+Author: Darrick J. Wong
+
+Description
+-----------
+
+This driver implements sensor reading support for the energy and power
+meters available on various IBM System X hardware through the BMC.  All
+sensor banks will be exported as platform devices; this driver can talk
+to both v1 and v2 interfaces.  This driver is completely separate from the
+older ibmpex driver.
+
+The v1 AEM interface has a simple set of features to monitor energy use.
+There is a register that displays an estimate of raw energy consumption
+since the last BMC reset, and a power sensor that returns average power
+use over a configurable interval.
+
+The v2 AEM interface is a bit more sophisticated, being able to present
+a wider range of energy and power use registers, the power cap as
+set by the AEM software, and temperature sensors.
+
+Special Features
+----------------
+
+The "power_cap" value displays the current system power cap, as set by
+the Active Energy Manager software.  Setting the power cap from the host
+is not currently supported.
_

Patches currently in -mm which might be from djwong@us.ibm.com are

i5k_amb-support-intel-5400-chipset.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware.patch
ibmaem-overview-of-the-driver.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
linux-next.patch

