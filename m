From: akpm@osdl.org
Subject: - make-platform_device_add_data-accept-a-const-pointer.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:00 -0800
Message-ID: <200612130656.kBD6u0Sd030682@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57882 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965036AbWLMG4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scottwood@freescale.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Make platform_device_add_data accept a const pointer
has been removed from the -mm tree.  Its filename was
     make-platform_device_add_data-accept-a-const-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make platform_device_add_data accept a const pointer
From: Scott Wood <scottwood@freescale.com>

platform_device_add_data() makes a copy of the data that is given to it,
and thus the parameter can be const.  This removes a warning when data
from get_property() on powerpc is handed to platform_device_add_data(),
as get_property() returns a const pointer.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/base/platform.c         |    2 +-
 include/linux/platform_device.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/platform.c~make-platform_device_add_data-accept-a-const-pointer drivers/base/platform.c
--- a/drivers/base/platform.c~make-platform_device_add_data-accept-a-const-pointer
+++ a/drivers/base/platform.c
@@ -212,7 +212,7 @@ EXPORT_SYMBOL_GPL(platform_device_add_re
  *	pointer.  The memory associated with the platform data will be freed
  *	when the platform device is released.
  */
-int platform_device_add_data(struct platform_device *pdev, void *data, size_t size)
+int platform_device_add_data(struct platform_device *pdev, const void *data, size_t size)
 {
 	void *d;
 
diff -puN include/linux/platform_device.h~make-platform_device_add_data-accept-a-const-pointer include/linux/platform_device.h
--- a/include/linux/platform_device.h~make-platform_device_add_data-accept-a-const-pointer
+++ a/include/linux/platform_device.h
@@ -39,7 +39,7 @@ extern struct platform_device *platform_
 
 extern struct platform_device *platform_device_alloc(const char *name, unsigned int id);
 extern int platform_device_add_resources(struct platform_device *pdev, struct resource *res, unsigned int num);
-extern int platform_device_add_data(struct platform_device *pdev, void *data, size_t size);
+extern int platform_device_add_data(struct platform_device *pdev, const void *data, size_t size);
 extern int platform_device_add(struct platform_device *pdev);
 extern void platform_device_del(struct platform_device *pdev);
 extern void platform_device_put(struct platform_device *pdev);
_

Patches currently in -mm which might be from scottwood@freescale.com are

origin.patch

