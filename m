Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7A0C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441853AbjLGANR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441805AbjLGANM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0103EAC
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:18 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3AEC433C8;
        Thu,  7 Dec 2023 00:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701907998;
        bh=wTZCZxdMUuk4qheiZ8s2LKH7pa4KoFYSV2+jZ89ZdhU=;
        h=Date:To:From:Subject:From;
        b=wzCLtQ/fRLeuyS1amUyHBkk4phnjndgOUPcc9qQcDJF/FE9f1KB9CZA+puZD/Qeoe
         VJTWo4R5z2Sqhx3QUheJzu/D+oGAaDVgPSMLlp9lUvZ9Gw4B+SH13qPLKt1AICYN2h
         IXjIUCXkpE6PQourrCXDYfVlUp/nKEQoZxDVdUfs=
Date:   Wed, 06 Dec 2023 16:13:18 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, geert+renesas@glider.be,
        catalin.marinas@arm.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch removed from -mm tree
Message-Id: <20231207001318.8E3AEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm/kmemleak: move the initialisation of object to __link_object"
has been removed from the -mm tree.  Its filename was
     revert-mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: Revert "mm/kmemleak: move the initialisation of object to __link_object"
Date: Wed, 15 Nov 2023 16:21:37 +0800

Patch series "Fix invalid wait context of set_track_prepare()".

Geert reported an invalid wait context[1] which is resulted by moving
set_track_prepare() inside kmemleak_lock.  This is not allowed because in
RT mode, the spinlocks can be preempted but raw_spinlocks can not, so it
is not allowd to acquire spinlocks while holding raw_spinlocks.  The
second patch fix same problem in kmemleak_update_trace().


This patch (of 2):

Move the initialisation of object back to__alloc_object() because
set_track_prepare() attempt to acquire zone->lock(spinlocks) while
__link_object is holding kmemleak_lock(raw_spinlocks).  This is not right
for RT mode.

This reverts commit 245245c2fffd00 ("mm/kmemleak: move the initialisation
of object to __link_object").

Link: https://lkml.kernel.org/r/20231115082138.2649870-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20231115082138.2649870-2-liushixin2@huawei.com
Fixes: 245245c2fffd ("mm/kmemleak: move the initialisation of object to __link_object")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/linux-mm/CAMuHMdWj0UzwNaxUvcocTfh481qRJpOWwXxsJCTJfu1oCqvgdA@mail.gmail.com/ [1]
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/mm/kmemleak.c~revert-mm-kmemleak-move-the-initialisation-of-object-to-__link_object
+++ a/mm/kmemleak.c
@@ -642,32 +642,16 @@ static struct kmemleak_object *__alloc_o
 	if (!object) {
 		pr_warn("Cannot allocate a kmemleak_object structure\n");
 		kmemleak_disable();
+		return NULL;
 	}
 
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
 	INIT_LIST_HEAD(&object->object_list);
 	INIT_LIST_HEAD(&object->gray_list);
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
 
@@ -692,6 +676,24 @@ static int __link_object(struct kmemleak
 	/* kernel backtrace */
 	object->trace_handle = set_track_prepare();
 
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
+	object->flags = OBJECT_ALLOCATED | (is_phys ? OBJECT_PHYS : 0);
+	object->pointer = ptr;
+	object->size = kfence_ksize((void *)ptr) ?: size;
+	object->min_count = min_count;
+	object->jiffies = jiffies;
+
 	untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
 	/*
 	 * Only update min_addr and max_addr with object
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

