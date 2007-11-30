From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-suspend-fix.patch added to -mm tree
Date: Fri, 30 Nov 2007 13:36:36 -0800
Message-ID: <200711302136.lAULaakJ025617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066AbXK3Vgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 16:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhoffman@lightlink.com, jirislaby@gmail.com, rjw@sisk.pl


The patch titled
     HWMON: coretemp, suspend fix
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-suspend-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: HWMON: coretemp, suspend fix
From: Mark M. Hoffman <mhoffman@lightlink.com>

coretemp, suspend fix

It's not permitted to unregister device/cpu if frozen and going to sleep.
It causes deadlock on systems, where coretemp hwmon is loaded. Do it only
in non-freezed states instead.

Cc: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-suspend-fix drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-suspend-fix
+++ a/drivers/hwmon/coretemp.c
@@ -338,11 +338,13 @@ static int coretemp_cpu_callback(struct 
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED:
 		coretemp_device_add(cpu);
+	case CPU_DOWN_FAILED_FROZEN:
 		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_DOWN_PREPARE:
 		coretemp_device_remove(cpu);
+	case CPU_DOWN_PREPARE_FROZEN:
 		break;
 	}
 	return NOTIFY_OK;
_

Patches currently in -mm which might be from mhoffman@lightlink.com are

small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
git-hwmon.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
applesmc-sensors-set-for-macbook2.patch
hwmon-coretemp-suspend-fix.patch
