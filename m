Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67656CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbjJRPkx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjJRPkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:40:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27601114
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:40:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A29C433C7;
        Wed, 18 Oct 2023 15:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643647;
        bh=wHgePsoWfycHI1fc8LU/moGZef57+tBJW0e1oevl71c=;
        h=Date:To:From:Subject:From;
        b=SYD4dBo79BEcY7azReO7zWH6QommJ0dAo4wE7zqAp85q42nbR+Om+0nOzyDJLfUov
         ee9EPTLCcSeYRkJh8q4hcpAwkBjitj/dgQJPOwhTB8cKq5TPVXbn2VwARspMgiGpqT
         2liBHG/XKSdk+SXut/eY9CsVZQMXiAcui8n+gSMo=
Date:   Wed, 18 Oct 2023 08:40:47 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-use-mem_pool_free-to-free-object.patch added to mm-unstable branch
Message-Id: <20231018154047.B4A29C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: use mem_pool_free() to free object
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-use-mem_pool_free-to-free-object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-use-mem_pool_free-to-free-object.patch

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
Subject: mm: kmemleak: use mem_pool_free() to free object
Date: Wed, 18 Oct 2023 18:29:50 +0800

The kmemleak object is allocated by mem_pool_alloc(), which could be from
slab or mem_pool[], so it's not suitable using __kmem_cache_free() to free
the object, use __mem_pool_free() instead.

Link: https://lkml.kernel.org/r/20231018102952.3339837-6-liushixin2@huawei.com
Fixes: 0647398a8c7b ("mm: kmemleak: simple memory allocation pool for kmemleak objects")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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
bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch
bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch
mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch
mm-kmemleak-split-__create_object-into-two-functions.patch
mm-kmemleak-use-mem_pool_free-to-free-object.patch
mm-kmemleak-add-__find_and_remove_object.patch
mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch

