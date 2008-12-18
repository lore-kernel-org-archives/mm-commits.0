From: akpm@linux-foundation.org
Subject: + driver-core-fix-duplicate-removal-of-driver-link-in-__device_release_driver.patch added to -mm tree
Date: Wed, 17 Dec 2008 22:23:32 -0800
Message-ID: <200812180623.mBI6NWjV006205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325AbYLRGXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 01:23:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom.leiming@gmail.com, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     driver core: fix duplicate removal of driver link in __device_release_driver
has been added to the -mm tree.  Its filename is
     driver-core-fix-duplicate-removal-of-driver-link-in-__device_release_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver core: fix duplicate removal of driver link in __device_release_driver
From: Ming Lei <tom.leiming@gmail.com>

In __device_release_driver(), driver_sysfs_remove() has removed the driver
link under device dir in sysfs, but sysfs_remove_link() is called again to
do such thing.  Remove the duplicate call to sys_remove_link().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dd.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/base/dd.c~driver-core-fix-duplicate-removal-of-driver-link-in-__device_release_driver drivers/base/dd.c
--- a/drivers/base/dd.c~driver-core-fix-duplicate-removal-of-driver-link-in-__device_release_driver
+++ a/drivers/base/dd.c
@@ -298,7 +298,6 @@ static void __device_release_driver(stru
 	drv = dev->driver;
 	if (drv) {
 		driver_sysfs_remove(dev);
-		sysfs_remove_link(&dev->kobj, "driver");
 
 		if (dev->bus)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

linux-next.patch
driver-core-fix-duplicate-removal-of-driver-link-in-__device_release_driver.patch

