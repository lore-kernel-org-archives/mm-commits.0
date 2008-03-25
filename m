From: akpm@linux-foundation.org
Subject: + drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:48:16 -0700
Message-ID: <200803252248.m2PMmGAo017479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972AbYCYWsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, len.brown@intel.com, rui.zhang@intel.com, sujith.thomas@intel.com


The patch titled
     drivers/misc: elide a non-zero test on a result that is never 0
has been added to the -mm tree.  Its filename is
     drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch

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

