Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD90C25B70
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbjJYXuN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjJYXtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDC9D7A
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1D1C433C7;
        Wed, 25 Oct 2023 23:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277735;
        bh=7zgeugRBNMsd5pomnchP8UDNzXcofZxPksqCQbWtSz8=;
        h=Date:To:From:Subject:From;
        b=QvuamV/sFjp+f2Mi2LvMrXv6f88GIMPXjuCOGROyJ7BQ2bjM3J7teIqE3QsqHac+6
         oo+jVlurfAn8nqZUam7K2D/lkOKzyicDB+gnXEdRyZZBK5hiI7j3rpu4znQG2Nx1th
         z0lxoTyar7lUXyTzT2r9PKvb0DmVeyyQ8pXyo1/0=
Date:   Wed, 25 Oct 2023 16:48:54 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-use-mem_pool_free-to-free-object.patch removed from -mm tree
Message-Id: <20231025234855.0E1D1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmemleak: use mem_pool_free() to free object
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-use-mem_pool_free-to-free-object.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: kmemleak: use mem_pool_free() to free object
Date: Wed, 18 Oct 2023 18:29:50 +0800

The kmemleak object is allocated by mem_pool_alloc(), which could be from
slab or mem_pool[], so it's not suitable using __kmem_cache_free() to free
the object, use __mem_pool_free() instead.

Link: https://lkml.kernel.org/r/20231018102952.3339837-6-liushixin2@huawei.com
Fixes: 0647398a8c7b ("mm: kmemleak: simple memory allocation pool for kmemleak objects")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-mem_pool_free-to-free-object
+++ a/mm/kmemleak.c
@@ -668,8 +668,8 @@ static struct kmemleak_object *__alloc_o
 	return object;
 }
 
-static void __link_object(struct kmemleak_object *object, unsigned long ptr,
-			  size_t size, int min_count, bool is_phys)
+static int __link_object(struct kmemleak_object *object, unsigned long ptr,
+			 size_t size, int min_count, bool is_phys)
 {
 
 	struct kmemleak_object *parent;
@@ -711,14 +711,15 @@ static void __link_object(struct kmemlea
 			 * be freed while the kmemleak_lock is held.
 			 */
 			dump_object_info(parent);
-			kmem_cache_free(object_cache, object);
-			return;
+			return -EEXIST;
 		}
 	}
 	rb_link_node(&object->rb_node, rb_parent, link);
 	rb_insert_color(&object->rb_node, is_phys ? &object_phys_tree_root :
 					  &object_tree_root);
 	list_add_tail_rcu(&object->object_list, &object_list);
+
+	return 0;
 }
 
 /*
@@ -731,14 +732,17 @@ static void __create_object(unsigned lon
 {
 	struct kmemleak_object *object;
 	unsigned long flags;
+	int ret;
 
 	object = __alloc_object(gfp);
 	if (!object)
 		return;
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
-	__link_object(object, ptr, size, min_count, is_phys);
+	ret = __link_object(object, ptr, size, min_count, is_phys);
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+	if (ret)
+		mem_pool_free(object);
 }
 
 /* Create kmemleak object which allocated with virtual address. */
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

