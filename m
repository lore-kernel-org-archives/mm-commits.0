From: akpm@linux-foundation.org
Subject: + resource-add-__adjust_resource-for-internal-use.patch added to -mm tree
Date: Wed, 10 Apr 2013 14:44:24 -0700
Message-ID: <20130410214424.F091C31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:57290 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936728Ab3DJVo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 17:44:26 -0400
Received: by mail-ie0-f202.google.com with SMTP id x12so146204ief.3
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 14:44:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: toshi.kani@hp.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, linuxram@us.ibm.com, rientjes@google.com, tangchen@cn.fujitsu.com, tmac@hp.com, wency@cn.fujitsu.com


The patch titled
     Subject: resource: add __adjust_resource() for internal use
has been added to the -mm tree.  Its filename is
     resource-add-__adjust_resource-for-internal-use.patch

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
Subject: resource: add __adjust_resource() for internal use

Add __adjust_resource(), which is called by adjust_resource() internally
after the resource_lock is held.  There is no interface change to
adjust_resource().  This change allows other functions to call
__adjust_resource() internally while the resource_lock is held.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: T Makphaibulchoke <tmac@hp.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN kernel/resource.c~resource-add-__adjust_resource-for-internal-use kernel/resource.c
--- a/kernel/resource.c~resource-add-__adjust_resource-for-internal-use
+++ a/kernel/resource.c
@@ -706,24 +706,13 @@ void insert_resource_expand_to_fit(struc
 	write_unlock(&resource_lock);
 }
 
-/**
- * adjust_resource - modify a resource's start and size
- * @res: resource to modify
- * @start: new start value
- * @size: new size
- *
- * Given an existing resource, change its start and size to match the
- * arguments.  Returns 0 on success, -EBUSY if it can't fit.
- * Existing children of the resource are assumed to be immutable.
- */
-int adjust_resource(struct resource *res, resource_size_t start, resource_size_t size)
+static int __adjust_resource(struct resource *res, resource_size_t start,
+				resource_size_t size)
 {
 	struct resource *tmp, *parent = res->parent;
 	resource_size_t end = start + size - 1;
 	int result = -EBUSY;
 
-	write_lock(&resource_lock);
-
 	if (!parent)
 		goto skip;
 
@@ -751,6 +740,26 @@ skip:
 	result = 0;
 
  out:
+	return result;
+}
+
+/**
+ * adjust_resource - modify a resource's start and size
+ * @res: resource to modify
+ * @start: new start value
+ * @size: new size
+ *
+ * Given an existing resource, change its start and size to match the
+ * arguments.  Returns 0 on success, -EBUSY if it can't fit.
+ * Existing children of the resource are assumed to be immutable.
+ */
+int adjust_resource(struct resource *res, resource_size_t start,
+			resource_size_t size)
+{
+	int result;
+
+	write_lock(&resource_lock);
+	result = __adjust_resource(res, start, size);
 	write_unlock(&resource_lock);
 	return result;
 }
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch
mm-walk_memory_range-fix-typo-in-comment.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch

