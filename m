From: akpm@osdl.org
Subject: - driver-core-remove-device_is_registered-in.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:45:45 -0800
Message-ID: <200701222045.l0MKjj5n001493@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50184 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520AbXAVUpw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:45:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     driver core: remove device_is_registered() in device_move()
has been removed from the -mm tree.  Its filename was
     driver-core-remove-device_is_registered-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-s390.patch
