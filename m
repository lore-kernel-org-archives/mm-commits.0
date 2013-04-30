From: akpm@linux-foundation.org
Subject: [merged] resource-add-release_mem_region_adjustable.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:16 -0700
Message-ID: <20130430184916.91FB15A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:58793 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3StS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:18 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so85118qea.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, jiang.liu@huawei.com, linuxram@us.ibm.com, rientjes@google.com, tangchen@cn.fujitsu.com, tmac@hp.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: resource: add release_mem_region_adjustable()
has been removed from the -mm tree.  Its filename was
     resource-add-release_mem_region_adjustable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: resource: add release_mem_region_adjustable()

Add release_mem_region_adjustable(), which releases a requested region
from a currently busy memory resource.  This interface adjusts the matched
memory resource accordingly even if the requested region does not match
exactly but still fits into.

This new interface is intended for memory hot-delete.  During bootup,
memory resources are inserted from the boot descriptor table, such as EFI
Memory Table and e820.  Each memory resource entry usually covers the
whole contigous memory range.  Memory hot-delete request, on the other
hand, may target to a particular range of memory resource, and its size
can be much smaller than the whole contiguous memory.  Since the existing
release interfaces like __release_region() require a requested region to
be exactly matched to a resource entry, they do not allow a partial
resource to be released.

This new interface is restrictive (i.e.  release under certain
conditions), which is consistent with other release interfaces,
__release_region() and __release_resource().  Additional release
conditions, such as an overlapping region to a resource entry, can be
supported after they are confirmed as valid cases.

There is no change to the existing interfaces since their restriction
is valid for I/O resources.

[akpm@linux-foundation.org: use GFP_ATOMIC under write_lock()]
[akpm@linux-foundation.org: switch back to GFP_KERNEL, less buggily]
[akpm@linux-foundation.org: remove unneeded and wrong kfree(), per Toshi]
Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by : Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
Cc: T Makphaibulchoke <tmac@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    4 +
 kernel/resource.c      |  103 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+)

diff -puN include/linux/ioport.h~resource-add-release_mem_region_adjustable include/linux/ioport.h
--- a/include/linux/ioport.h~resource-add-release_mem_region_adjustable
+++ a/include/linux/ioport.h
@@ -192,6 +192,10 @@ extern struct resource * __request_regio
 extern int __check_region(struct resource *, resource_size_t, resource_size_t);
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
+#ifdef CONFIG_MEMORY_HOTREMOVE
+extern int release_mem_region_adjustable(struct resource *, resource_size_t,
+				resource_size_t);
+#endif
 
 static inline int __deprecated check_region(resource_size_t s,
 						resource_size_t n)
diff -puN kernel/resource.c~resource-add-release_mem_region_adjustable kernel/resource.c
--- a/kernel/resource.c~resource-add-release_mem_region_adjustable
+++ a/kernel/resource.c
@@ -1021,6 +1021,109 @@ void __release_region(struct resource *p
 }
 EXPORT_SYMBOL(__release_region);
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+/**
+ * release_mem_region_adjustable - release a previously reserved memory region
+ * @parent: parent resource descriptor
+ * @start: resource start address
+ * @size: resource region size
+ *
+ * This interface is intended for memory hot-delete.  The requested region
+ * is released from a currently busy memory resource.  The requested region
+ * must either match exactly or fit into a single busy resource entry.  In
+ * the latter case, the remaining resource is adjusted accordingly.
+ * Existing children of the busy memory resource must be immutable in the
+ * request.
+ *
+ * Note:
+ * - Additional release conditions, such as overlapping region, can be
+ *   supported after they are confirmed as valid cases.
+ * - When a busy memory resource gets split into two entries, the code
+ *   assumes that all children remain in the lower address entry for
+ *   simplicity.  Enhance this logic when necessary.
+ */
+int release_mem_region_adjustable(struct resource *parent,
+			resource_size_t start, resource_size_t size)
+{
+	struct resource **p;
+	struct resource *res;
+	struct resource *new_res;
+	resource_size_t end;
+	int ret = -EINVAL;
+
+	end = start + size - 1;
+	if ((start < parent->start) || (end > parent->end))
+		return ret;
+
+	/* The kzalloc() result gets checked later */
+	new_res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+
+	p = &parent->child;
+	write_lock(&resource_lock);
+
+	while ((res = *p)) {
+		if (res->start >= end)
+			break;
+
+		/* look for the next resource if it does not fit into */
+		if (res->start > start || res->end < end) {
+			p = &res->sibling;
+			continue;
+		}
+
+		if (!(res->flags & IORESOURCE_MEM))
+			break;
+
+		if (!(res->flags & IORESOURCE_BUSY)) {
+			p = &res->child;
+			continue;
+		}
+
+		/* found the target resource; let's adjust accordingly */
+		if (res->start == start && res->end == end) {
+			/* free the whole entry */
+			*p = res->sibling;
+			kfree(res);
+			ret = 0;
+		} else if (res->start == start && res->end != end) {
+			/* adjust the start */
+			ret = __adjust_resource(res, end + 1,
+						res->end - end);
+		} else if (res->start != start && res->end == end) {
+			/* adjust the end */
+			ret = __adjust_resource(res, res->start,
+						start - res->start);
+		} else {
+			/* split into two entries */
+			if (!new_res) {
+				ret = -ENOMEM;
+				break;
+			}
+			new_res->name = res->name;
+			new_res->start = end + 1;
+			new_res->end = res->end;
+			new_res->flags = res->flags;
+			new_res->parent = res->parent;
+			new_res->sibling = res->sibling;
+			new_res->child = NULL;
+
+			ret = __adjust_resource(res, res->start,
+						start - res->start);
+			if (ret)
+				break;
+			res->sibling = new_res;
+			new_res = NULL;
+		}
+
+		break;
+	}
+
+	write_unlock(&resource_lock);
+	kfree(new_res);
+	return ret;
+}
+#endif	/* CONFIG_MEMORY_HOTREMOVE */
+
 /*
  * Managed region resource
  */
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
linux-next.patch

