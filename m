From: akpm@linux-foundation.org
Subject: + drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:44:17 -0700
Message-ID: <200803252244.m2PMiHgd017400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbYCYWpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, lenb@kernel.org


The patch titled
     drivers/acpi: elide a non-zero test on a result that is never 0
has been added to the -mm tree.  Its filename is
     drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0.patch

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
Subject: drivers/acpi: elide a non-zero test on a result that is never 0
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
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/fan.c            |   34 +++++++++++++++-----------------
 drivers/acpi/processor_core.c |   30 +++++++++++++---------------
 drivers/acpi/video.c          |   28 ++++++++++++--------------
 3 files changed, 43 insertions(+), 49 deletions(-)

diff -puN drivers/acpi/fan.c~drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0 drivers/acpi/fan.c
--- a/drivers/acpi/fan.c~drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0
+++ a/drivers/acpi/fan.c
@@ -260,24 +260,22 @@ static int acpi_fan_add(struct acpi_devi
 		result = PTR_ERR(cdev);
 		goto end;
 	}
-	if (cdev) {
-		printk(KERN_INFO PREFIX
-			"%s is registered as cooling_device%d\n",
-			device->dev.bus_id, cdev->id);
-
-		acpi_driver_data(device) = cdev;
-		result = sysfs_create_link(&device->dev.kobj,
-					   &cdev->device.kobj,
-					   "thermal_cooling");
-		if (result)
-			return result;
-
-		result = sysfs_create_link(&cdev->device.kobj,
-					   &device->dev.kobj,
-					   "device");
-		if (result)
-			return result;
-	}
+	printk(KERN_INFO PREFIX
+		"%s is registered as cooling_device%d\n",
+		device->dev.bus_id, cdev->id);
+
+	acpi_driver_data(device) = cdev;
+	result = sysfs_create_link(&device->dev.kobj,
+				   &cdev->device.kobj,
+				   "thermal_cooling");
+	if (result)
+		return result;
+
+	result = sysfs_create_link(&cdev->device.kobj,
+				   &device->dev.kobj,
+				   "device");
+	if (result)
+		return result;
 
 	result = acpi_fan_add_fs(device);
 	if (result)
diff -puN drivers/acpi/processor_core.c~drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0 drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0
+++ a/drivers/acpi/processor_core.c
@@ -674,22 +674,20 @@ static int __cpuinit acpi_processor_star
 		result = PTR_ERR(pr->cdev);
 		goto end;
 	}
-	if (pr->cdev) {
-		printk(KERN_INFO PREFIX
-			"%s is registered as cooling_device%d\n",
-			device->dev.bus_id, pr->cdev->id);
-
-		result = sysfs_create_link(&device->dev.kobj,
-					   &pr->cdev->device.kobj,
-					   "thermal_cooling");
-		if (result)
-			return result;
-		result = sysfs_create_link(&pr->cdev->device.kobj,
-					   &device->dev.kobj,
-					   "device");
-		if (result)
-			return result;
-	}
+	printk(KERN_INFO PREFIX
+		"%s is registered as cooling_device%d\n",
+		device->dev.bus_id, pr->cdev->id);
+
+	result = sysfs_create_link(&device->dev.kobj,
+				   &pr->cdev->device.kobj,
+				   "thermal_cooling");
+	if (result)
+		return result;
+	result = sysfs_create_link(&pr->cdev->device.kobj,
+				   &device->dev.kobj,
+				   "device");
+	if (result)
+		return result;
 
 	if (pr->flags.throttling) {
 		printk(KERN_INFO PREFIX "%s [%s] (supports",
diff -puN drivers/acpi/video.c~drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0 drivers/acpi/video.c
--- a/drivers/acpi/video.c~drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0
+++ a/drivers/acpi/video.c
@@ -734,21 +734,19 @@ static void acpi_video_device_find_cap(s
 		if (IS_ERR(device->cdev))
 			return;
 
-		if (device->cdev) {
-			printk(KERN_INFO PREFIX
-				"%s is registered as cooling_device%d\n",
-				device->dev->dev.bus_id, device->cdev->id);
-			result = sysfs_create_link(&device->dev->dev.kobj,
-					  &device->cdev->device.kobj,
-					  "thermal_cooling");
-			if (result)
-				printk(KERN_ERR PREFIX "Create sysfs link\n");
-			result = sysfs_create_link(&device->cdev->device.kobj,
-					  &device->dev->dev.kobj,
-					  "device");
-                        if (result)
-				printk(KERN_ERR PREFIX "Create sysfs link\n");
-		}
+		printk(KERN_INFO PREFIX
+			"%s is registered as cooling_device%d\n",
+			device->dev->dev.bus_id, device->cdev->id);
+		result = sysfs_create_link(&device->dev->dev.kobj,
+				  &device->cdev->device.kobj,
+				  "thermal_cooling");
+		if (result)
+			printk(KERN_ERR PREFIX "Create sysfs link\n");
+		result = sysfs_create_link(&device->cdev->device.kobj,
+				  &device->dev->dev.kobj,
+				  "device");
+		if (result)
+			printk(KERN_ERR PREFIX "Create sysfs link\n");
 	}
 	if (device->cap._DCS && device->cap._DSS){
 		static int count = 0;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-acpi-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
fs-gfs2-test-for-is_err-rather-than-0.patch
git-udf.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch
git-ocfs2.patch
fs-ocfs2-aopsc-test-for-is_err-rather-than-0.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

