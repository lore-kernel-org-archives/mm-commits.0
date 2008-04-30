From: akpm@linux-foundation.org
Subject: - drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:54 -0700
Message-ID: <200804300540.m3U5esvE029011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758568AbYD3GML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, len.brown@intel.com, rui.zhang@intel.com, sujith.thomas@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc: elide a non-zero test on a result that is never 0
has been removed from the -mm tree.  Its filename was
     drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc: elide a non-zero test on a result that is never 0
From: Julia Lawall <julia@diku.dk>

The function thermal_cooling_device_register always returns either a valid
pointer or a value made with ERR_PTR, so a test for non-zero on the result
will always succeed.

The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@a@
expression E, E1;
statement S,S1;
position p;
@@

E = thermal_cooling_device_register(...)
... when != E = E1
if@p (E) S else S1

@n@
position a.p;
expression E,E1;
statement S,S1;
@@

E = NULL
... when != E = E1
if@p (E) S else S1

@depends on !n@
expression E;
statement S,S1;
position a.p;
@@

* if@p (E)
  S else S1
//</smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Thomas Sujith <sujith.thomas@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/intel_menlow.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN drivers/misc/intel_menlow.c~drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0 drivers/misc/intel_menlow.c
--- a/drivers/misc/intel_menlow.c~drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0
+++ a/drivers/misc/intel_menlow.c
@@ -175,19 +175,17 @@ static int intel_menlow_memory_add(struc
 		goto end;
 	}
 
-	if (cdev) {
-		acpi_driver_data(device) = cdev;
-		result = sysfs_create_link(&device->dev.kobj,
-					&cdev->device.kobj, "thermal_cooling");
-		if (result)
-			goto unregister;
-
-		result = sysfs_create_link(&cdev->device.kobj,
-					&device->dev.kobj, "device");
-		if (result) {
-			sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
-			goto unregister;
-		}
+	acpi_driver_data(device) = cdev;
+	result = sysfs_create_link(&device->dev.kobj,
+				&cdev->device.kobj, "thermal_cooling");
+	if (result)
+		goto unregister;
+
+	result = sysfs_create_link(&cdev->device.kobj,
+				&device->dev.kobj, "device");
+	if (result) {
+		sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+		goto unregister;
 	}
 
  end:
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
git-acpi.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
git-cryptodev.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

