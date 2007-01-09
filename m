From: akpm@osdl.org
Subject: + driver-core-remove-device_is_registered-in.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:51:11 -0800
Message-ID: <200701092051.l09KpB4a014926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43032 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbXAIUv1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, greg@kroah.com


The patch titled
     driver core: remove device_is_registered() in device_move()
has been added to the -mm tree.  Its filename is
     driver-core-remove-device_is_registered-in.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver core: remove device_is_registered() in device_move()
From: Cornelia Huck <cornelia.huck@de.ibm.com>

device_is_registered() will always be false for a device with no bus.  Remove
this check and trust the caller to know what they're doing.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/base/core.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN drivers/base/core.c~driver-core-remove-device_is_registered-in drivers/base/core.c
--- a/drivers/base/core.c~driver-core-remove-device_is_registered-in
+++ a/drivers/base/core.c
@@ -1007,10 +1007,6 @@ int device_move(struct device *dev, stru
 	if (!dev)
 		return -EINVAL;
 
-	if (!device_is_registered(dev)) {
-		error = -EINVAL;
-		goto out;
-	}
 	new_parent = get_device(new_parent);
 	if (!new_parent) {
 		error = -EINVAL;
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

driver-core-per-subsystem-multithreaded-probing.patch
driver-core-dont-fail-attaching-the-device-if-it.patch
driver-core-remove-device_is_registered-in.patch
driver-core-allow-device_movedev-null.patch
