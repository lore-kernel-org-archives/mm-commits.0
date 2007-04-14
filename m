From: akpm@linux-foundation.org
Subject: + ams-driver-do-not-print-error-on-systems-without-apple-motion-sensor.patch added to -mm tree
Date: Fri, 13 Apr 2007 23:10:54 -0700
Message-ID: <200704140610.l3E6AsjF019977@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40359 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965356AbXDNGLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 14 Apr 2007 02:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, khali@linux-fr.org, linux-kernel@hansmi.ch, nicolas@boichat.ch, stelian@popies.net


The patch titled
     ams driver: do not print error on systems without apple motion sensor
has been added to the -mm tree.  Its filename is
     ams-driver-do-not-print-error-on-systems-without-apple-motion-sensor.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ams driver: do not print error on systems without apple motion sensor
From: Olaf Hering <olaf@aepfle.de>

It is not an error if a system has no ams hardware.  Do not clutter dmesg
in this case.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Stelian Pop <stelian@popies.net>
Cc: Michael Hanselmann <linux-kernel@hansmi.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ams/ams-core.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/hwmon/ams/ams-core.c~ams-driver-do-not-print-error-on-systems-without-apple-motion-sensor drivers/hwmon/ams/ams-core.c
--- a/drivers/hwmon/ams/ams-core.c~ams-driver-do-not-print-error-on-systems-without-apple-motion-sensor
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

git-powerpc.patch
ams-driver-do-not-print-error-on-systems-without-apple-motion-sensor.patch
git-kbuild.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
keep-track-of-network-interface-renaming.patch
