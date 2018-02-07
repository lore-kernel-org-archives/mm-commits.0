From: akpm@linux-foundation.org
Subject: [merged]
 kernel-resource-iomem_is_exclusive-can-be-boolean.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 11:59:50 -0800
Message-ID: <20180207195950.dSwCQDIMZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754659AbeBGT7v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: iomem_is_exclusive can be boolean
has been removed from the -mm tree.  Its filename was
     kernel-resource-iomem_is_exclusive-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: kernel/resource: iomem_is_exclusive can be boolean

Make iomem_is_exclusive return bool due to this particular function only
using either one or zero as its return value.

No functional change.

Link: http://lkml.kernel.org/r/1513266622-15860-5-git-send-email-baiyaowei@cmss.chinamobile.com
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    2 +-
 kernel/resource.c      |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/ioport.h~kernel-resource-iomem_is_exclusive-can-be-boolean include/linux/ioport.h
--- a/include/linux/ioport.h~kernel-resource-iomem_is_exclusive-can-be-boolean
+++ a/include/linux/ioport.h
@@ -265,7 +265,7 @@ extern struct resource * __devm_request_
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
-extern int iomem_is_exclusive(u64 addr);
+extern bool iomem_is_exclusive(u64 addr);
 
 extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
diff -puN kernel/resource.c~kernel-resource-iomem_is_exclusive-can-be-boolean kernel/resource.c
--- a/kernel/resource.c~kernel-resource-iomem_is_exclusive-can-be-boolean
+++ a/kernel/resource.c
@@ -1563,17 +1563,17 @@ static int strict_iomem_checks;
 
 /*
  * check if an address is reserved in the iomem resource tree
- * returns 1 if reserved, 0 if not reserved.
+ * returns true if reserved, false if not reserved.
  */
-int iomem_is_exclusive(u64 addr)
+bool iomem_is_exclusive(u64 addr)
 {
 	struct resource *p = &iomem_resource;
-	int err = 0;
+	bool err = false;
 	loff_t l;
 	int size = PAGE_SIZE;
 
 	if (!strict_iomem_checks)
-		return 0;
+		return false;
 
 	addr = addr & PAGE_MASK;
 
@@ -1596,7 +1596,7 @@ int iomem_is_exclusive(u64 addr)
 			continue;
 		if (IS_ENABLED(CONFIG_IO_STRICT_DEVMEM)
 				|| p->flags & IORESOURCE_EXCLUSIVE) {
-			err = 1;
+			err = true;
 			break;
 		}
 	}
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are


