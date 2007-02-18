From: akpm@linux-foundation.org
Subject: + bus_remove_driver-fix.patch added to -mm tree
Date: Sun, 18 Feb 2007 00:43:06 -0800
Message-ID: <200702180843.l1I8h6A8013600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161128AbXBRInL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Feb 2007 03:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: efault@gmx.de, greg@kroah.com


The patch titled
     bus_remove_driver() fix
has been added to the -mm tree.  Its filename is
     bus_remove_driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bus_remove_driver() fix
From: Mike Galbraith <efault@gmx.de>

The reason it's hanging is that nobody releases the driver, so we wait
forever in driver_unregister().  With the below, box boots fine...

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/bus.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/base/bus.c~bus_remove_driver-fix drivers/base/bus.c
--- a/drivers/base/bus.c~bus_remove_driver-fix
+++ a/drivers/base/bus.c
@@ -588,6 +588,7 @@ void bus_remove_driver(struct device_dri
 	driver_detach(drv);
 	module_remove_driver(drv);
 	kobject_unregister(&drv->kobj);
+	driver_release(&drv->kobj);
 	put_bus(drv->bus);
 }
 
_

Patches currently in -mm which might be from efault@gmx.de are

bus_remove_driver-fix.patch
readahead-call-scheme.patch
