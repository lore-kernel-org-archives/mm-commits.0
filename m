Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB817C25B45
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 18:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjJWSRF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjJWSRF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 14:17:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6525D8E
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 11:17:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FC7C433C7;
        Mon, 23 Oct 2023 18:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698085023;
        bh=N0EZWlqc6OBb6iMeK+muXvUJUu42zeAG5tUVPq0WtS8=;
        h=Date:To:From:Subject:From;
        b=uMxPPd0RhiK6eL0W0tKm8chbKm33aSzy3CSnoylAipOf3PBO4IiBH4gvb6UJTolFB
         LHrNyUE2ypTVJDk3IaW6b0O5ZnqNLvffHdCark+MY2fDF0eCaqNCzweALlkTxF9c/D
         QHz3spc6upshO8dzetIQ5GdrfsuItSkCpXY2w0/Q=
Date:   Mon, 23 Oct 2023 11:17:02 -0700
To:     mm-commits@vger.kernel.org, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch added to mm-unstable branch
Message-Id: <20231023181702.F2FC7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: move the initialisation of object to __link_object
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch

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
Subject: mm/kmemleak: move the initialisation of object to __link_object
Date: Mon, 23 Oct 2023 10:51:25 +0800

Leave __alloc_object() to just do the actual allocation and
__link_object() to do the full initialisation.

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
bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch
bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch
mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch
mm-kmemleak-split-__create_object-into-two-functions.patch
mm-kmemleak-use-mem_pool_free-to-free-object.patch
mm-kmemleak-add-__find_and_remove_object.patch
mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch
mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch

