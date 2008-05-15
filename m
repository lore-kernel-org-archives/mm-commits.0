From: akpm@linux-foundation.org
Subject: + ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch added to -mm tree
Date: Thu, 15 May 2008 14:37:26 -0700
Message-ID: <200805152137.m4FLbQe3011748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbYEOVi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, bunk@kernel.org


The patch titled
     ibmaem: Fix 64-bit division on 32-bit platforms (update)
has been added to the -mm tree.  Its filename is
     ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmaem: Fix 64-bit division on 32-bit platforms (update)
From: "Darrick J. Wong" <djwong@us.ibm.com>

> To avoid these kind of doubts may I suggest using the time
> conversion definitions of include/linux/time.h?
>
> It would be much easier to understand the intention with
> NSEC_PER_SEC, USEC_PER_SEC etc (comments would also help)

Ok, here's an updated version that makes the conversions a bit clearer.
Tested and run on i386/x86-64.
---
ibmaem: Fix 64-bit division on 32-bit platforms

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ibmaem.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/hwmon/ibmaem.c~ibmaem-fix-64-bit-division-on-32-bit-platforms-update drivers/hwmon/ibmaem.c
--- a/drivers/hwmon/ibmaem.c~ibmaem-fix-64-bit-division-on-32-bit-platforms-update
+++ a/drivers/hwmon/ibmaem.c
@@ -32,6 +32,7 @@
 #include <linux/sched.h>
 #include <linux/platform_device.h>
 #include <linux/math64.h>
+#include <linux/time.h>
 
 #define REFRESH_INTERVAL	(HZ)
 #define IPMI_TIMEOUT		(30 * HZ)
@@ -82,6 +83,7 @@
 
 #define AEM_DEFAULT_POWER_INTERVAL 1000
 #define AEM_MIN_POWER_INTERVAL	200
+#define UJ_PER_MJ		1000L
 
 static DEFINE_IDR(aem_idr);
 static DEFINE_SPINLOCK(aem_idr_lock);
@@ -842,7 +844,7 @@ static ssize_t aem_show_power(struct dev
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct aem_data *data = dev_get_drvdata(dev);
-	u64 before, after, time;
+	u64 before, after, delta, time;
 	signed long leftover;
 	struct timespec b, a;
 
@@ -865,10 +867,9 @@ static ssize_t aem_show_power(struct dev
 	mutex_unlock(&data->lock);
 
 	time = timespec_to_ns(&a) - timespec_to_ns(&b);
-	time = div_u64(time, 1000);
+	delta = (after - before) * UJ_PER_MJ;
 
-	return sprintf(buf, "%llu\n",
-		       div64_u64((after - before) * 1000000000, time));
+	return sprintf(buf, "%llu\n", div64_u64(delta * NSEC_PER_SEC, time));
 }
 
 /* Display energy use */
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
i5k_amb-support-intel-5400-chipset.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch
ibmaem-overview-of-the-driver.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch

