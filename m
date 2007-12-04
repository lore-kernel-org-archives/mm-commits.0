From: akpm@linux-foundation.org
Subject: - hwmon-coretemp-suspend-fix.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:43 -0800
Message-ID: <200712040738.lB47chBR006923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbXLDHtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:49:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhoffman@lightlink.com, jirislaby@gmail.com, rjw@sisk.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     HWMON: coretemp, suspend fix
has been removed from the -mm tree.  Its filename was
     hwmon-coretemp-suspend-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-suspend-fix drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-suspend-fix
+++ a/drivers/hwmon/coretemp.c
@@ -337,11 +337,10 @@ static int coretemp_cpu_callback(struct 
 
 	switch (action) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED:
 		coretemp_device_add(cpu);
 		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_DOWN_PREPARE:
 		coretemp_device_remove(cpu);
 		break;
 	}
_

Patches currently in -mm which might be from mhoffman@lightlink.com are

git-acpi.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
git-hwmon.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
applesmc-sensors-set-for-macbook2.patch
