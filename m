From: akpm@linux-foundation.org
Subject: - sony-laptop-update-documentation-and-kconfig-help.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:20:51 -0700
Message-ID: <200704112320.l3BNKpDu017517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35944 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161429AbXDKXWO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, lenb@kernel.org, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     sony-laptop: update documentation and Kconfig help
has been removed from the -mm tree.  Its filename was
     sony-laptop-update-documentation-and-kconfig-help.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony-laptop: update documentation and Kconfig help
From: Mattia Dongili <malattia@linux.it>

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sony-laptop.txt |   25 ++++++++++++++++++-------
 drivers/misc/Kconfig          |    9 ++++-----
 2 files changed, 22 insertions(+), 12 deletions(-)

diff -puN Documentation/sony-laptop.txt~update-documentation-and-kconfig-help Documentation/sony-laptop.txt
--- a/Documentation/sony-laptop.txt~update-documentation-and-kconfig-help
+++ a/Documentation/sony-laptop.txt
@@ -3,12 +3,18 @@ Sony Notebook Control Driver (SNC) Readm
 	Copyright (C) 2004- 2005 Stelian Pop <stelian@popies.net>
 	Copyright (C) 2007 Mattia Dongili <malattia@linux.it>
 
-This mini-driver drives the SNC device present in the ACPI BIOS of
-the Sony Vaio laptops.
+This mini-driver drives the SNC and SPIC device present in the ACPI BIOS of the
+Sony Vaio laptops. This driver mixes both devices functions under the same
+(hopefully consistent) interface. This also means that the sonypi driver is
+obsoleted by sony-laptop now.
 
-It gives access to some extra laptop functionalities. In its current
-form, this driver let the user set or query the screen brightness
-through the backlight subsystem and remove/apply power to some devices.
+Fn keys (hotkeys):
+------------------
+Some models report hotkeys through the SNC or SPIC devices, such events are
+reported both through the ACPI subsystem as acpi events and through the INPUT
+subsystem. See the logs of acpid or /proc/acpi/event and
+/proc/bus/input/devices to find out what those events are and which input
+devices are created by the driver.
 
 Backlight control:
 ------------------
@@ -39,6 +45,8 @@ The files are:
 	audiopower		power on/off the internal sound card
 	lanpower		power on/off the internal ethernet card
 				(only in debug mode)
+	bluetoothpower		power on/off the internal bluetooth device
+	fanspeed		get/set the fan speed
 
 Note that some files may be missing if they are not supported
 by your particular laptop model.
@@ -76,9 +84,9 @@ The sony-laptop driver creates, for some
 current ones found on several Vaio models), an entry under
 /sys/devices/platform/sony-laptop, just like the 'cdpower' one.
 You can create other entries corresponding to your own laptop methods by
-further editing the source (see the 'sony_acpi_values' table, and add a new
+further editing the source (see the 'sony_nc_values' table, and add a new
 entry to this table with your get/set method names using the
-HANDLE_NAMES macro).
+SNC_HANDLE_NAMES macro).
 
 Your mission, should you accept it, is to try finding out what
 those entries are for, by reading/writing random values from/to those
@@ -87,6 +95,9 @@ files and find out what is the impact on
 Should you find anything interesting, please report it back to me,
 I will not disavow all knowledge of your actions :)
 
+See also http://www.linux.it/~malattia/wiki/index.php/Sony_drivers for other
+useful info.
+
 Bugs/Limitations:
 -----------------
 
diff -puN drivers/misc/Kconfig~update-documentation-and-kconfig-help drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~update-documentation-and-kconfig-help
+++ a/drivers/misc/Kconfig
@@ -112,12 +112,11 @@ config SONY_LAPTOP
 	depends on X86 && ACPI
 	select BACKLIGHT_CLASS_DEVICE
 	  ---help---
-	  This mini-driver drives the SNC device present in the ACPI BIOS of
-	  the Sony Vaio laptops.
+	  This mini-driver drives the SNC and SPIC devices present in the ACPI
+	  BIOS of the Sony Vaio laptops.
 
-	  It gives access to some extra laptop functionalities. In its current
-	  form, this driver let the user set or query the screen brightness
-	  through the backlight subsystem and remove/apply power to some
+	  It gives access to some extra laptop functionalities like Bluetooth,
+	  screen brightness control, Fn keys and allows powering on/off some
 	  devices.
 
 	  Read <file:Documentation/sony-laptop.txt> for more information.
_

Patches currently in -mm which might be from malattia@linux.it are

git-cpufreq.patch
