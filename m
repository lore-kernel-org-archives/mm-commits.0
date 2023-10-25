Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF62BC25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjJYXuQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbjJYXtI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E2F10CC
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE081C433C9;
        Wed, 25 Oct 2023 23:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277737;
        bh=pW3wQaeC0HfO16iueVqMxlNvfJGkz00y+w9ghpWhG9Y=;
        h=Date:To:From:Subject:From;
        b=O8JT8eeVzlLHa8aFLRzQ0Y2a+IvlUFGKpyCVWctCKf51vKc1pnmcBfmPiw4ZtgfB6
         U3wvbbKs9IeHwyoUvttJaCpvBoPZ54HRyaYmH6aJ7UXcsKkjlly37zffLDcStqG9b/
         dN2a4ou4t81/1DQASDgGyOEeTt1SnxeNnBgwIw28=
Date:   Wed, 25 Oct 2023 16:48:57 -0700
To:     mm-commits@vger.kernel.org, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch removed from -mm tree
Message-Id: <20231025234857.AE081C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: move the initialisation of object to __link_object
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/kmemleak: move the initialisation of object to __link_object
Date: Mon, 23 Oct 2023 10:51:25 +0800

In patch (mm: kmemleak: split __create_object into two functions), the
initialisation of object has been splited in two places.  Catalin said it
feels a bit weird and error prone.  So leave __alloc_object() to just do
the actual allocation and let __link_object() do the full initialisation.

Link: https://lkml.kernel.org/r/20231023025125.90972-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-move-the-initialisation-of-object-to-__link_object
+++ a/mm/kmemleak.c
@@ -642,16 +642,32 @@ static struct kmemleak_object *__alloc_o
 	if (!object) {
 		pr_warn("Cannot allocate a kmemleak_object structure\n");
 		kmemleak_disable();
-		return NULL;
 	}
 
+	return object;
+}
+
+static int __link_object(struct kmemleak_object *object, unsigned long ptr,
+			 size_t size, int min_count, bool is_phys)
+{
+
+	struct kmemleak_object *parent;
+	struct rb_node **link, *rb_parent;
+	unsigned long untagged_ptr;
+	unsigned long untagged_objp;
+
 	INIT_LIST_HEAD(&object->object_list);
 	INIT_LIST_HEAD(&object->gray_list);
 	INIT_HLIST_HEAD(&object->area_list);
 	raw_spin_lock_init(&object->lock);
 	atomic_set(&object->use_count, 1);
+	object->flags = OBJECT_ALLOCATED | (is_phys ? OBJECT_PHYS : 0);
+	object->pointer = ptr;
+	object->size = kfence_ksize((void *)ptr) ?: size;
 	object->excess_ref = 0;
+	object->min_count = min_count;
 	object->count = 0;			/* white color initially */
+	object->jiffies = jiffies;
 	object->checksum = 0;
 	object->del_state = 0;
 
@@ -676,24 +692,6 @@ static struct kmemleak_object *__alloc_o
 	/* kernel backtrace */
 	object->trace_handle = set_track_prepare();
 
-	return object;
-}
-
-static int __link_object(struct kmemleak_object *object, unsigned long ptr,
-			 size_t size, int min_count, bool is_phys)
-{
-
-	struct kmemleak_object *parent;
-	struct rb_node **link, *rb_parent;
-	unsigned long untagged_ptr;
-	unsigned long untagged_objp;
-
-	object->flags = OBJECT_ALLOCATED | (is_phys ? OBJECT_PHYS : 0);
-	object->pointer = ptr;
-	object->size = kfence_ksize((void *)ptr) ?: size;
-	object->min_count = min_count;
-	object->jiffies = jiffies;
-
 	untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
 	/*
 	 * Only update min_addr and max_addr with object
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

