From: akpm@linux-foundation.org
Subject: + fix-compiler-warning-in-ddc.patch added to -mm tree
Date: Mon, 21 May 2007 13:24:27 -0700
Message-ID: <200705212024.l4LKOR15019161@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934970AbXEUU0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: denver@ossguy.com, greg@kroah.com


The patch titled
     fix compiler warning in dd.c
has been added to the -mm tree.  Its filename is
     fix-compiler-warning-in-ddc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix compiler warning in dd.c
From: "Denver Gingerich" <denver@ossguy.com>

Correct the following compiler warning:
warning: 'device_probe_drivers' defined but not used

Verified that there are no device_probe_drivers() calls in the kernel tree.

Signed-off-by: Denver Gingerich <denver@ossguy.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dd.c |   13 -------------
 1 files changed, 13 deletions(-)

diff -puN drivers/base/dd.c~fix-compiler-warning-in-ddc drivers/base/dd.c
--- a/drivers/base/dd.c~fix-compiler-warning-in-ddc
+++ a/drivers/base/dd.c
@@ -207,19 +207,6 @@ static int __device_attach(struct device
 	return driver_probe_device(drv, dev);
 }
 
-static int device_probe_drivers(void *data)
-{
-	struct device *dev = data;
-	int ret = 0;
-
-	if (dev->bus) {
-		down(&dev->sem);
-		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-		up(&dev->sem);
-	}
-	return ret;
-}
-
 /**
  *	device_attach - try to attach device to a driver.
  *	@dev:	device.
_

Patches currently in -mm which might be from denver@ossguy.com are

fix-compiler-warning-in-ddc.patch
fix-compiler-warning-in-fixedc.patch
fix-compiler-warnings-in-acornc.patch
