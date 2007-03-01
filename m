From: akpm@linux-foundation.org
Subject: + driver-core-add-missing-symlinks-error-handling.patch added to -mm tree
Date: Wed, 28 Feb 2007 22:27:05 -0800
Message-ID: <200703010627.l216R5fV006452@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57468 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687AbXCAG1L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 01:27:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de


The patch titled
     driver core: add missing symlinks error handling
has been added to the -mm tree.  Its filename is
     driver-core-add-missing-symlinks-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver core: add missing symlinks error handling
From: "Akinobu Mita" <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/core.c~driver-core-add-missing-symlinks-error-handling drivers/base/core.c
--- a/drivers/base/core.c~driver-core-add-missing-symlinks-error-handling
+++ a/drivers/base/core.c
@@ -665,6 +665,8 @@ int device_add(struct device *dev)
  GroupError:
 	device_remove_attrs(dev);
  AttrsError:
+	device_remove_links(dev, parent);
+
 	if (dev->devt_attr) {
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

driver-core-cleanup-device-links-code.patch
driver-core-add-missing-symlinks-error-handling.patch
driver-core-check-sysfs_create_link-errors.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
simplify-the-stacktrace-code.patch
