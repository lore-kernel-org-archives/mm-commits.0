From: akpm@linux-foundation.org
Subject: - remove-unused-device_probe_drivers-function.patch removed from -mm tree
Date: Wed, 09 May 2007 17:46:47 -0700
Message-ID: <200705100046.l4A0klS2008298@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176AbXEJAqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 20:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw@f00f.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Remove unused device_probe_drivers function
has been removed from the -mm tree.  Its filename was
     remove-unused-device_probe_drivers-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unused device_probe_drivers function
From: Chris Wedgwood <cw@f00f.org>

Signed-off-by: Chris Wedgwood <cw@f00f.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dd.c |   13 -------------
 1 files changed, 13 deletions(-)

diff -puN drivers/base/dd.c~remove-unused-device_probe_drivers-function drivers/base/dd.c
--- a/drivers/base/dd.c~remove-unused-device_probe_drivers-function
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

Patches currently in -mm which might be from cw@f00f.org are

remove-unused-device_probe_drivers-function.patch
