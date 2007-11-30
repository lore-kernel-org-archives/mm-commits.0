From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-suspend-fix-fix.patch added to -mm tree
Date: Fri, 30 Nov 2007 15:47:04 -0800
Message-ID: <200711302347.lAUNl4IJ030541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbXK3Xru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 18:47:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jirislaby@gmail.com, mhoffman@lightlink.com


The patch titled
     HWMON: coretemp, suspend fix (fix)
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-suspend-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: HWMON: coretemp, suspend fix (fix)
From: "Rafael J. Wysocki" <rjw@sisk.pl>

It's not permitted to unregister a device after devices have been suspended.
It causes deadlocks to appear on systems with coretemp hwmon loaded.  To avoid
this, we can make coretemp_cpu_callback() do nothing if the _FROZEN bit is set
in action.

Also, in other cases it's generally to late to unregister the coretemp device
if the CPU is already dead, so it should be unregistered on CPU_DOWN_PREPARE.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-suspend-fix-fix drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-suspend-fix-fix
+++ a/drivers/hwmon/coretemp.c
@@ -337,14 +337,11 @@ static int coretemp_cpu_callback(struct 
 
 	switch (action) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
 		coretemp_device_add(cpu);
-	case CPU_DOWN_FAILED_FROZEN:
 		break;
 	case CPU_DOWN_PREPARE:
 		coretemp_device_remove(cpu);
-	case CPU_DOWN_PREPARE_FROZEN:
 		break;
 	}
 	return NOTIFY_OK;
_

Patches currently in -mm which might be from rjw@sisk.pl are

isdn-bootup-crash-fix-2624-rc3-git1.patch
git-acpi.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
fix-proc-net-breakage.patch
hwmon-coretemp-suspend-fix.patch
hwmon-coretemp-suspend-fix-fix.patch
restore-missing-sysfs-max_cstate-attr.patch
page-allocator-clean-up-pcp-draining-functions.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
