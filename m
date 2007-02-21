From: akpm@linux-foundation.org
Subject: + driver-core-refcounting-fix.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:45:35 -0800
Message-ID: <200702212045.l1LKjZCs025361@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161172AbXBUUpn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:45:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: efault@gmx.de, greg@kroah.com


The patch titled
     driver core: refcounting fix
has been added to the -mm tree.  Its filename is
     driver-core-refcounting-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver core: refcounting fix
From: Mike Galbraith <efault@gmx.de>

Fix a reference counting bug exposed by commit
725522b5453dd680412f2b6463a988e4fd148757.  If driver.mod_name exists, we
take a reference in module_add_driver(), and never release it.  Undo that
reference in module_remove_driver().

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN kernel/module.c~driver-core-refcounting-fix kernel/module.c
--- a/kernel/module.c~driver-core-refcounting-fix
+++ a/kernel/module.c
@@ -2425,6 +2425,12 @@ void module_remove_driver(struct device_
 			kfree(driver_name);
 		}
 	}
+	/*
+	 * Undo the additional reference we added in module_add_driver()
+	 * via kset_find_obj()
+	 */
+	if (drv->mod_name)
+		kobject_put(&drv->kobj);
 }
 EXPORT_SYMBOL(module_remove_driver);
 #endif
_

Patches currently in -mm which might be from efault@gmx.de are

driver-core-refcounting-fix.patch
readahead-call-scheme.patch
