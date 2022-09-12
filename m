Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4120C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiILDgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiILDdy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C482A40B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77E3FB80C7E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22805C433D7;
        Mon, 12 Sep 2022 03:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953454;
        bh=l4xpfWZByhS+B31MS48O/Pko+t8TPOnoGJ9uccoIz+s=;
        h=Date:To:From:Subject:From;
        b=X3JqlI+bEbdN+GEMpl65HtlOWsrdFkIziGPyD1jjj9EDQzzn9fYTC2PdYY9Y02exU
         b4KhchZU9crAyGYCwkYsHbRYPWP6yyW+09wTh5a+bekAt8UL81cq2hXwtXqvS5M8Za
         EhSXRGbtDMCq17xOyQ+7IGm48pMtfC2JV9qRM8BM=
Date:   Sun, 11 Sep 2022 20:30:53 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        catalin.marinas@arm.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-make-create_object-return-void.patch removed from -mm tree
Message-Id: <20220912033054.22805C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: make create_object return void
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-make-create_object-return-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/kmemleak: make create_object return void
Date: Thu, 1 Sep 2022 10:30:07 +0800

No caller cares about the return value of create_object(), so make it
return void.

Link: https://lkml.kernel.org/r/20220901023007.3471887-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-make-create_object-return-void
+++ a/mm/kmemleak.c
@@ -604,9 +604,8 @@ static int __save_stack_trace(unsigned l
  * memory block and add it to the object_list and object_tree_root (or
  * object_phys_tree_root).
  */
-static struct kmemleak_object *__create_object(unsigned long ptr, size_t size,
-					     int min_count, gfp_t gfp,
-					     bool is_phys)
+static void __create_object(unsigned long ptr, size_t size,
+			    int min_count, gfp_t gfp, bool is_phys)
 {
 	unsigned long flags;
 	struct kmemleak_object *object, *parent;
@@ -618,7 +617,7 @@ static struct kmemleak_object *__create_
 	if (!object) {
 		pr_warn("Cannot allocate a kmemleak_object structure\n");
 		kmemleak_disable();
-		return NULL;
+		return;
 	}
 
 	INIT_LIST_HEAD(&object->object_list);
@@ -687,7 +686,6 @@ static struct kmemleak_object *__create_
 			 */
 			dump_object_info(parent);
 			kmem_cache_free(object_cache, object);
-			object = NULL;
 			goto out;
 		}
 	}
@@ -698,21 +696,20 @@ static struct kmemleak_object *__create_
 	list_add_tail_rcu(&object->object_list, &object_list);
 out:
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
-	return object;
 }
 
 /* Create kmemleak object which allocated with virtual address. */
-static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
-					     int min_count, gfp_t gfp)
+static void create_object(unsigned long ptr, size_t size,
+			  int min_count, gfp_t gfp)
 {
-	return __create_object(ptr, size, min_count, gfp, false);
+	__create_object(ptr, size, min_count, gfp, false);
 }
 
 /* Create kmemleak object which allocated with physical address. */
-static struct kmemleak_object *create_object_phys(unsigned long ptr, size_t size,
-					     int min_count, gfp_t gfp)
+static void create_object_phys(unsigned long ptr, size_t size,
+			       int min_count, gfp_t gfp)
 {
-	return __create_object(ptr, size, min_count, gfp, true);
+	__create_object(ptr, size, min_count, gfp, true);
 }
 
 /*
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-shuffle-convert-module_param_call-to-module_param_cb.patch
mm-kfence-convert-to-define_seq_attribute.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch

