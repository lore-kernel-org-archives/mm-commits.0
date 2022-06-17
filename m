Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81683CCA47F
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379821AbiFQCtr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379801AbiFQCtl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFDC65406
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34DD3B826F8
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2564C3411A;
        Fri, 17 Jun 2022 02:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434174;
        bh=pWtc8Adjt4MjmtltyVgSnD6wjcZw4wOKqcXvNsVyDy0=;
        h=Date:To:From:Subject:From;
        b=FG2IP2f9BjKRg2uQfjo0eKU5RmUdCHJzuk2numlVHziK4y2/SdJstBq9ZRCqgPFC5
         /5JCXZRZMdOL/LgH47UvRO/jEbvLSzYJrscyV15yR3oRIXYB/5bzWocq6z2Mh/QTNU
         jq8oJ6Tu8vGrOSawKw5TvE7g6kaPqtZ9AtHq432E=
Date:   Thu, 16 Jun 2022 19:49:33 -0700
To:     mm-commits@vger.kernel.org, yee.lee@mediatek.com,
        catalin.marinas@arm.com, patrick.wang.shcn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-add-object_phys-flag-for-objects-allocated-with-physical-address.patch removed from -mm tree
Message-Id: <20220617024933.E2564C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmemleak: add OBJECT_PHYS flag for objects allocated with physical address
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-add-object_phys-flag-for-objects-allocated-with-physical-address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: mm: kmemleak: add OBJECT_PHYS flag for objects allocated with physical address
Date: Sat, 11 Jun 2022 11:55:49 +0800

Add OBJECT_PHYS flag for object.  This flag is used to identify the
objects allocated with physical address.  The create_object_phys()
function is added as well to set that flag and is used by
kmemleak_alloc_phys().

Link: https://lkml.kernel.org/r/20220611035551.1823303-3-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yee Lee <yee.lee@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-add-object_phys-flag-for-objects-allocated-with-physical-address
+++ a/mm/kmemleak.c
@@ -172,6 +172,8 @@ struct kmemleak_object {
 #define OBJECT_NO_SCAN		(1 << 2)
 /* flag set to fully scan the object when scan_area allocation failed */
 #define OBJECT_FULL_SCAN	(1 << 3)
+/* flag set for object allocated with physical address */
+#define OBJECT_PHYS		(1 << 4)
 
 #define HEX_PREFIX		"    "
 /* number of bytes to print per line; must be 16 or 32 */
@@ -574,8 +576,9 @@ static int __save_stack_trace(unsigned l
  * Create the metadata (struct kmemleak_object) corresponding to an allocated
  * memory block and add it to the object_list and object_tree_root.
  */
-static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
-					     int min_count, gfp_t gfp)
+static struct kmemleak_object *__create_object(unsigned long ptr, size_t size,
+					     int min_count, gfp_t gfp,
+					     bool is_phys)
 {
 	unsigned long flags;
 	struct kmemleak_object *object, *parent;
@@ -595,7 +598,7 @@ static struct kmemleak_object *create_ob
 	INIT_HLIST_HEAD(&object->area_list);
 	raw_spin_lock_init(&object->lock);
 	atomic_set(&object->use_count, 1);
-	object->flags = OBJECT_ALLOCATED;
+	object->flags = OBJECT_ALLOCATED | (is_phys ? OBJECT_PHYS : 0);
 	object->pointer = ptr;
 	object->size = kfence_ksize((void *)ptr) ?: size;
 	object->excess_ref = 0;
@@ -662,6 +665,20 @@ out:
 	return object;
 }
 
+/* Create kmemleak object which allocated with virtual address. */
+static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
+					     int min_count, gfp_t gfp)
+{
+	return __create_object(ptr, size, min_count, gfp, false);
+}
+
+/* Create kmemleak object which allocated with physical address. */
+static struct kmemleak_object *create_object_phys(unsigned long ptr, size_t size,
+					     int min_count, gfp_t gfp)
+{
+	return __create_object(ptr, size, min_count, gfp, true);
+}
+
 /*
  * Mark the object as not allocated and schedule RCU freeing via put_object().
  */
@@ -728,11 +745,11 @@ static void delete_object_part(unsigned
 	start = object->pointer;
 	end = object->pointer + object->size;
 	if (ptr > start)
-		create_object(start, ptr - start, object->min_count,
-			      GFP_KERNEL);
+		__create_object(start, ptr - start, object->min_count,
+			      GFP_KERNEL, object->flags & OBJECT_PHYS);
 	if (ptr + size < end)
-		create_object(ptr + size, end - ptr - size, object->min_count,
-			      GFP_KERNEL);
+		__create_object(ptr + size, end - ptr - size, object->min_count,
+			      GFP_KERNEL, object->flags & OBJECT_PHYS);
 
 	__delete_object(object);
 }
@@ -1129,9 +1146,14 @@ EXPORT_SYMBOL(kmemleak_no_scan);
  */
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, gfp_t gfp)
 {
+	pr_debug("%s(0x%pa, %zu)\n", __func__, &phys, size);
+
 	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
-		/* assume min_count 0 */
-		kmemleak_alloc(__va(phys), size, 0, gfp);
+		/*
+		 * Create object with OBJECT_PHYS flag and
+		 * assume min_count 0.
+		 */
+		create_object_phys((unsigned long)__va(phys), size, 0, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
 
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are


