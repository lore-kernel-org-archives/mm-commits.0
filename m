Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D161CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjJRPkN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjJRPkN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:40:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5907114
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:40:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C87CC433C7;
        Wed, 18 Oct 2023 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643610;
        bh=XALKrEwolOVtK9y7tf55wVnLDeAOxwAQcisUDXJwlws=;
        h=Date:To:From:Subject:From;
        b=ed4R0s3Uks5zClUFIdUWeMXUuV91VcY01PoBkOKJhDlLn0XmRNuB3Jz02jijvdLlG
         xyeTRVRFks/fNcvXTreW4/pXXFWEyeCiHJW6fkF8tVTjF5SBtruPpP4M+It7A/v0JO
         2bjUCqBwbRxnSDSr+CWSt83R8UVz0lhhCqgbQgvk=
Date:   Wed, 18 Oct 2023 08:40:09 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-split-__create_object-into-two-functions.patch added to mm-unstable branch
Message-Id: <20231018154010.5C87CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: split __create_object into two functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-split-__create_object-into-two-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-split-__create_object-into-two-functions.patch

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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: kmemleak: split __create_object into two functions
Date: Wed, 18 Oct 2023 18:29:49 +0800

__create_object() consists of two part, the first part allocate a kmemleak
object and initialize it, the second part insert it into object tree. 
This function need kmemleak_lock but actually only the second part need
lock.

Split it into two functions, the first function __alloc_object only
allocate a kmemleak object, and the second function __link_object() will
initialize the object and insert it into object tree, use the
kmemleak_lock to protect __link_object() only.

Link: https://lkml.kernel.org/r/20231018102952.3339837-5-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   61 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 21 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-split-__create_object-into-two-functions
+++ a/mm/kmemleak.c
@@ -623,25 +623,15 @@ static noinline depot_stack_handle_t set
 	return trace_handle;
 }
 
-/*
- * Create the metadata (struct kmemleak_object) corresponding to an allocated
- * memory block and add it to the object_list and object_tree_root (or
- * object_phys_tree_root).
- */
-static void __create_object(unsigned long ptr, size_t size,
-			    int min_count, gfp_t gfp, bool is_phys)
+static struct kmemleak_object * __alloc_object(gfp_t gfp)
 {
-	unsigned long flags;
-	struct kmemleak_object *object, *parent;
-	struct rb_node **link, *rb_parent;
-	unsigned long untagged_ptr;
-	unsigned long untagged_objp;
+	struct kmemleak_object *object;
 
 	object = mem_pool_alloc(gfp);
 	if (!object) {
 		pr_warn("Cannot allocate a kmemleak_object structure\n");
 		kmemleak_disable();
-		return;
+		return NULL;
 	}
 
 	INIT_LIST_HEAD(&object->object_list);
@@ -649,13 +639,8 @@ static void __create_object(unsigned lon
 	INIT_HLIST_HEAD(&object->area_list);
 	raw_spin_lock_init(&object->lock);
 	atomic_set(&object->use_count, 1);
-	object->flags = OBJECT_ALLOCATED | (is_phys ? OBJECT_PHYS : 0);
-	object->pointer = ptr;
-	object->size = kfence_ksize((void *)ptr) ?: size;
 	object->excess_ref = 0;
-	object->min_count = min_count;
 	object->count = 0;			/* white color initially */
-	object->jiffies = jiffies;
 	object->checksum = 0;
 	object->del_state = 0;
 
@@ -680,7 +665,23 @@ static void __create_object(unsigned lon
 	/* kernel backtrace */
 	object->trace_handle = set_track_prepare();
 
-	raw_spin_lock_irqsave(&kmemleak_lock, flags);
+	return object;
+}
+
+static void __link_object(struct kmemleak_object *object, unsigned long ptr,
+			  size_t size, int min_count, bool is_phys)
+{
+
+	struct kmemleak_object *parent;
+	struct rb_node **link, *rb_parent;
+	unsigned long untagged_ptr;
+	unsigned long untagged_objp;
+
+	object->flags = OBJECT_ALLOCATED | (is_phys ? OBJECT_PHYS : 0);
+	object->pointer = ptr;
+	object->size = kfence_ksize((void *)ptr) ?: size;
+	object->min_count = min_count;
+	object->jiffies = jiffies;
 
 	untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
 	/*
@@ -711,14 +712,32 @@ static void __create_object(unsigned lon
 			 */
 			dump_object_info(parent);
 			kmem_cache_free(object_cache, object);
-			goto out;
+			return;
 		}
 	}
 	rb_link_node(&object->rb_node, rb_parent, link);
 	rb_insert_color(&object->rb_node, is_phys ? &object_phys_tree_root :
 					  &object_tree_root);
 	list_add_tail_rcu(&object->object_list, &object_list);
-out:
+}
+
+/*
+ * Create the metadata (struct kmemleak_object) corresponding to an allocated
+ * memory block and add it to the object_list and object_tree_root (or
+ * object_phys_tree_root).
+ */
+static void __create_object(unsigned long ptr, size_t size,
+				int min_count, gfp_t gfp, bool is_phys)
+{
+	struct kmemleak_object *object;
+	unsigned long flags;
+
+	object = __alloc_object(gfp);
+	if (!object)
+		return;
+
+	raw_spin_lock_irqsave(&kmemleak_lock, flags);
+	__link_object(object, ptr, size, min_count, is_phys);
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
 }
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch
bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch
bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch
mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch
mm-kmemleak-split-__create_object-into-two-functions.patch
mm-kmemleak-use-mem_pool_free-to-free-object.patch
mm-kmemleak-add-__find_and_remove_object.patch
mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch

