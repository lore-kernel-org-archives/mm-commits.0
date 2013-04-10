From: akpm@linux-foundation.org
Subject: + resource-add-release_mem_region_adjustable.patch added to -mm tree
Date: Wed, 10 Apr 2013 14:44:27 -0700
Message-ID: <20130410214428.000F65A4252@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:44813 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936811Ab3DJVoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 17:44:30 -0400
Received: by mail-ie0-f201.google.com with SMTP id a11so227781iee.4
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 14:44:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: toshi.kani@hp.com, jiang.liu@huawei.com, linuxram@us.ibm.com, rientjes@google.com, tangchen@cn.fujitsu.com, tmac@hp.com, wency@cn.fujitsu.com


The patch titled
     Subject: resource: add release_mem_region_adjustable()
has been added to the -mm tree.  Its filename is
     resource-add-release_mem_region_adjustable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by : Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: T Makphaibulchoke <tmac@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    4 +
 kernel/resource.c      |  100 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff -puN include/linux/ioport.h~resource-add-release_mem_region_adjustable include/linux/ioport.h
--- a/include/linux/ioport.h~resource-add-release_mem_region_adjustable
+++ a/include/linux/ioport.h
@@ -192,6 +192,10 @@ extern struct resource * __request_regio
 extern int __check_region(struct resource *, resource_size_t, resource_size_t);
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
+#ifdef CONFIG_MEMORY_HOTPLUG
+extern int release_mem_region_adjustable(struct resource *, resource_size_t,
+				resource_size_t);
+#endif
 
 static inline int __deprecated check_region(resource_size_t s,
 						resource_size_t n)
diff -puN kernel/resource.c~resource-add-release_mem_region_adjustable kernel/resource.c
--- a/kernel/resource.c~resource-add-release_mem_region_adjustable
+++ a/kernel/resource.c
@@ -1021,6 +1021,106 @@ void __release_region(struct resource *p
 }
 EXPORT_SYMBOL(__release_region);
 
+#ifdef CONFIG_MEMORY_HOTPLUG
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
+	struct resource *res, *new;
+	resource_size_t end;
+	int ret = -EINVAL;
+
+	end = start + size - 1;
+	if ((start < parent->start) || (end > parent->end))
+		return ret;
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
+			new = kzalloc(sizeof(struct resource), GFP_KERNEL);
+			if (!new) {
+				ret = -ENOMEM;
+				break;
+			}
+			new->name = res->name;
+			new->start = end + 1;
+			new->end = res->end;
+			new->flags = res->flags;
+			new->parent = res->parent;
+			new->sibling = res->sibling;
+			new->child = NULL;
+
+			ret = __adjust_resource(res, res->start,
+						start - res->start);
+			if (ret) {
+				kfree(new);
+				break;
+			}
+			res->sibling = new;
+		}
+
+		break;
+	}
+
+	write_unlock(&resource_lock);
+	return ret;
+}
+#endif	/* CONFIG_MEMORY_HOTPLUG */
+
 /*
  * Managed region resource
  */
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch
mm-walk_memory_range-fix-typo-in-comment.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch

