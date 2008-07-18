From: akpm@linux-foundation.org
Subject: - resource-add-resource_type-and-ioresource_type_bits.patch removed from -mm tree
Date: Fri, 18 Jul 2008 15:25:31 -0700
Message-ID: <200807182225.m6IMPVVF001676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbYGRW0c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 18:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     resource: add resource_type() and IORESOURCE_TYPE_BITS
has been removed from the -mm tree.  Its filename was
     resource-add-resource_type-and-ioresource_type_bits.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resource: add resource_type() and IORESOURCE_TYPE_BITS
From: Magnus Damm <magnus.damm@gmail.com>

Introduce resource_type() and IORESOURCE_TYPE_BITS, this is the ground work
that allows us to squeeze in more resource types.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c |   31 +++++++++++++++++--------------
 include/linux/ioport.h  |    7 ++++++-
 2 files changed, 23 insertions(+), 15 deletions(-)

diff -puN drivers/base/platform.c~resource-add-resource_type-and-ioresource_type_bits drivers/base/platform.c
--- a/drivers/base/platform.c~resource-add-resource_type-and-ioresource_type_bits
+++ a/drivers/base/platform.c
@@ -42,10 +42,8 @@ struct resource *platform_get_resource(s
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];
 
-		if ((r->flags & (IORESOURCE_IO|IORESOURCE_MEM|
-				 IORESOURCE_IRQ|IORESOURCE_DMA)) == type)
-			if (num-- == 0)
-				return r;
+		if (type == resource_type(r) && num-- == 0)
+			return r;
 	}
 	return NULL;
 }
@@ -78,10 +76,8 @@ struct resource *platform_get_resource_b
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];
 
-		if ((r->flags & (IORESOURCE_IO|IORESOURCE_MEM|
-				 IORESOURCE_IRQ|IORESOURCE_DMA)) == type)
-			if (!strcmp(r->name, name))
-				return r;
+		if (type == resource_type(r) && !strcmp(r->name, name))
+			return r;
 	}
 	return NULL;
 }
@@ -259,9 +255,9 @@ int platform_device_add(struct platform_
 
 		p = r->parent;
 		if (!p) {
-			if (r->flags & IORESOURCE_MEM)
+			if (resource_type(r) == IORESOURCE_MEM)
 				p = &iomem_resource;
-			else if (r->flags & IORESOURCE_IO)
+			else if (resource_type(r) == IORESOURCE_IO)
 				p = &ioport_resource;
 		}
 
@@ -282,9 +278,14 @@ int platform_device_add(struct platform_
 		return ret;
 
  failed:
-	while (--i >= 0)
-		if (pdev->resource[i].flags & (IORESOURCE_MEM|IORESOURCE_IO))
-			release_resource(&pdev->resource[i]);
+	while (--i >= 0) {
+		struct resource *r = &pdev->resource[i];
+		unsigned long type = resource_type(r);
+
+		if (type == IORESOURCE_MEM || type == IORESOURCE_IO)
+			release_resource(r);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(platform_device_add);
@@ -306,7 +307,9 @@ void platform_device_del(struct platform
 
 		for (i = 0; i < pdev->num_resources; i++) {
 			struct resource *r = &pdev->resource[i];
-			if (r->flags & (IORESOURCE_MEM|IORESOURCE_IO))
+			unsigned long type = resource_type(r);
+
+			if (type == IORESOURCE_MEM || type == IORESOURCE_IO)
 				release_resource(r);
 		}
 	}
diff -puN include/linux/ioport.h~resource-add-resource_type-and-ioresource_type_bits include/linux/ioport.h
--- a/include/linux/ioport.h~resource-add-resource_type-and-ioresource_type_bits
+++ a/include/linux/ioport.h
@@ -34,7 +34,8 @@ struct resource_list {
  */
 #define IORESOURCE_BITS		0x000000ff	/* Bus-specific bits */
 
-#define IORESOURCE_IO		0x00000100	/* Resource type */
+#define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
+#define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
 #define IORESOURCE_IRQ		0x00000400
 #define IORESOURCE_DMA		0x00000800
@@ -123,6 +124,10 @@ static inline resource_size_t resource_s
 {
 	return res->end - res->start + 1;
 }
+static inline unsigned long resource_type(struct resource *res)
+{
+	return res->flags & IORESOURCE_TYPE_BITS;
+}
 
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

linux-next.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-resource_type-and-ioresource_type_bits-fix.patch
resource-use-new-resource-type-changes.patch
resource-add-new-ioresource_clk-type.patch

