From: akpm@linux-foundation.org
Subject: + fix-warning-in-device_add_attrs.patch added to -mm tree
Date: Wed, 07 Feb 2007 12:35:33 -0800
Message-ID: <200702072035.l17KZXIR026405@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161193AbXBGUft (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 15:35:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, greg@kroah.com


The patch titled
     Fix warning in device_add_attrs
has been added to the -mm tree.  Its filename is
     fix-warning-in-device_add_attrs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix warning in device_add_attrs
From: Jean Delvare <khali@linux-fr.org>

Fix the following warning which I see with gcc 3.2:
drivers/base/core.c: In function `device_add_attrs':
drivers/base/core.c:251: warning: `i' might be used uninitialized in this function
It's a false positive, but it can be worked around easily, and the new
code makes rather more sense.

[akpm@linux-foundation.org: rework it for changes in Greg's tree and -mm]
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/bus.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/base/bus.c~fix-warning-in-device_add_attrs drivers/base/bus.c
--- a/drivers/base/bus.c~fix-warning-in-device_add_attrs
+++ a/drivers/base/bus.c
@@ -324,27 +324,25 @@ int bus_for_each_drv(struct bus_type * b
 	return error;
 }
 
-static int device_add_attrs(struct bus_type * bus, struct device * dev)
+static int device_add_attrs(struct bus_type *bus, struct device *dev)
 {
 	int error = 0;
 	int i;
 
-	if (bus->dev_attrs) {
-		for (i = 0; attr_name(bus->dev_attrs[i]); i++) {
-			error = device_create_file(dev,&bus->dev_attrs[i]);
-			if (error)
-				goto Err;
+	if (!bus->dev_attrs)
+		return 0;
+
+	for (i = 0; attr_name(bus->dev_attrs[i]); i++) {
+		error = device_create_file(dev,&bus->dev_attrs[i]);
+		if (error) {
+			while (--i >= 0)
+				device_remove_file(dev, &bus->dev_attrs[i]);
+			break;
 		}
 	}
- Done:
 	return error;
- Err:
-	while (--i >= 0)
-		device_remove_file(dev,&bus->dev_attrs[i]);
-	goto Done;
 }
 
-
 static void device_remove_attrs(struct bus_type * bus, struct device * dev)
 {
 	int i;
_

Patches currently in -mm which might be from khali@linux-fr.org are

git-alsa.patch
fix-warning-in-device_add_attrs.patch
matroxfb-use-kzalloc.patch
