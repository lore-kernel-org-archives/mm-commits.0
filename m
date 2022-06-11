Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2559C43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 21:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiFKVFb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 17:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFKVF0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 17:05:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47A93E5E8
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 14:05:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70F5560FC6
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 21:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C359DC34116;
        Sat, 11 Jun 2022 21:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654981524;
        bh=pbCW1llvRMpJAMd6XNHysA7MA9nhbJ6002Qmamon+tU=;
        h=Date:To:From:Subject:From;
        b=cGQTGLAME4f/mVCHa7fR4fOwJIh1u7hQSUKEXFiolZqUSe6OL8KDAzIA0Bng7gY8y
         xB5dER7RViB2G30T+TVF+I53yk32ro7VW1KRgQHlz9er+wgnRhfZxq5Z09FKNxsQDn
         fp7gxeCpZ55OpXFjsh3RT4Y5Sm4OoBlBVWC40vHc=
Date:   Sat, 11 Jun 2022 14:05:24 -0700
To:     mm-commits@vger.kernel.org, yee.lee@mediatek.com,
        catalin.marinas@arm.com, patrick.wang.shcn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-add-object_phys-flag-for-objects-allocated-with-physical-address.patch added to mm-unstable branch
Message-Id: <20220611210524.C359DC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: add OBJECT_PHYS flag for objects allocated with physical address
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-add-object_phys-flag-for-objects-allocated-with-physical-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-add-object_phys-flag-for-objects-allocated-with-physical-address.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-kmemleak-remove-kmemleak_not_leak_phys-and-the-min_count-argument-to-kmemleak_alloc_phys.patch
mm-kmemleak-add-object_phys-flag-for-objects-allocated-with-physical-address.patch
mm-kmemleak-add-rbtree-and-store-physical-address-for-objects-allocated-with-pa.patch
mm-kmemleak-check-physical-address-when-scan.patch

