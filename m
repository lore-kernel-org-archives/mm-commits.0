From: akpm@linux-foundation.org
Subject: - ibmaem-fix-64-bit-division-on-32-bit-platforms.patch removed from -mm tree
Date: Fri, 23 May 2008 12:22:33 -0700
Message-ID: <200805231922.m4NJMX6M005107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbYEWTWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 15:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ibmaem: Fix 64-bit division on 32-bit platforms
has been removed from the -mm tree.  Its filename was
     ibmaem-fix-64-bit-division-on-32-bit-platforms.patch

This patch was dropped because it was folded into ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmaem: Fix 64-bit division on 32-bit platforms
From: "Darrick J. Wong" <djwong@us.ibm.com>

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ibmaem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/ibmaem.c~ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-fix-64-bit-division-on-32-bit-platforms drivers/hwmon/ibmaem.c
--- a/drivers/hwmon/ibmaem.c~ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-fix-64-bit-division-on-32-bit-platforms
+++ a/drivers/hwmon/ibmaem.c
@@ -31,6 +31,7 @@
 #include <linux/idr.h>
 #include <linux/sched.h>
 #include <linux/platform_device.h>
+#include <linux/math64.h>
 
 #define REFRESH_INTERVAL	(HZ)
 #define IPMI_TIMEOUT		(30 * HZ)
@@ -864,9 +865,10 @@ static ssize_t aem_show_power(struct dev
 	mutex_unlock(&data->lock);
 
 	time = timespec_to_ns(&a) - timespec_to_ns(&b);
-	time /= 1000;
+	time = div_u64(time, 1000);
 
-	return sprintf(buf, "%llu\n", (after - before) * 1000000000 / time);
+	return sprintf(buf, "%llu\n",
+		       div64_u64((after - before) * 1000000000, time));
 }
 
 /* Display energy use */
_

Patches currently in -mm which might be from djwong@us.ibm.com are

i5k_amb-support-intel-5400-chipset.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch
ibmaem-overview-of-the-driver.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
linux-next.patch

