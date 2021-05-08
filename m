Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBEDC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9611F6142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhEHWof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhEHWoe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95AC06141E;
        Sat,  8 May 2021 22:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513812;
        bh=c2+N7YjgJKK6uivjdKk52xAh2n3Eg3WMvyo59stSp3E=;
        h=Date:From:To:Subject:From;
        b=1VMJI3KUmcNPagbQ6V6zWsW2z2scGFF6j4roXkV1/aWuM/PaIdh1n3khCmUhIhasV
         Yw475hfKqrGvBtZ//N7T5RD3Of/fqxTRjAFy3sKz8OwY3/BO4aWfYXMN6g36HRCOkf
         RFpVy8uI6xZn8/DWetm35bCG1r3wmsBnG2vLw6pY=
Date:   Sat, 08 May 2021 15:43:32 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        shuah@kernel.org, urezki@gmail.com, willy@infradead.org
Subject:  [merged] mm-vmalloc-refactor-the-preloading-loagic.patch
 removed from -mm tree
Message-ID: <20210508224332.FROoYNq54%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: refactor the preloading loagic
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-refactor-the-preloading-loagic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: refactor the preloading loagic

Instead of keeping open-coded style, move the code related to preloading
into a separate function.  Therefore introduce the preload_this_cpu_lock()
routine that prelaods a current CPU with one extra vmap_area object.

There is no functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20210402202237.20334-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   60 ++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-refactor-the-preloading-loagic
+++ a/mm/vmalloc.c
@@ -1430,6 +1430,29 @@ static void free_vmap_area(struct vmap_a
 	spin_unlock(&free_vmap_area_lock);
 }
 
+static inline void
+preload_this_cpu_lock(spinlock_t *lock, gfp_t gfp_mask, int node)
+{
+	struct vmap_area *va = NULL;
+
+	/*
+	 * Preload this CPU with one extra vmap_area object. It is used
+	 * when fit type of free area is NE_FIT_TYPE. It guarantees that
+	 * a CPU that does an allocation is preloaded.
+	 *
+	 * We do it in non-atomic context, thus it allows us to use more
+	 * permissive allocation masks to be more stable under low memory
+	 * condition and high memory pressure.
+	 */
+	if (!this_cpu_read(ne_fit_preload_node))
+		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
+
+	spin_lock(lock);
+
+	if (va && __this_cpu_cmpxchg(ne_fit_preload_node, NULL, va))
+		kmem_cache_free(vmap_area_cachep, va);
+}
+
 /*
  * Allocate a region of KVA of the specified size and alignment, within the
  * vstart and vend.
@@ -1439,7 +1462,7 @@ static struct vmap_area *alloc_vmap_area
 				unsigned long vstart, unsigned long vend,
 				int node, gfp_t gfp_mask)
 {
-	struct vmap_area *va, *pva;
+	struct vmap_area *va;
 	unsigned long addr;
 	int purged = 0;
 	int ret;
@@ -1465,43 +1488,14 @@ static struct vmap_area *alloc_vmap_area
 	kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
 
 retry:
-	/*
-	 * Preload this CPU with one extra vmap_area object. It is used
-	 * when fit type of free area is NE_FIT_TYPE. Please note, it
-	 * does not guarantee that an allocation occurs on a CPU that
-	 * is preloaded, instead we minimize the case when it is not.
-	 * It can happen because of cpu migration, because there is a
-	 * race until the below spinlock is taken.
-	 *
-	 * The preload is done in non-atomic context, thus it allows us
-	 * to use more permissive allocation masks to be more stable under
-	 * low memory condition and high memory pressure. In rare case,
-	 * if not preloaded, GFP_NOWAIT is used.
-	 *
-	 * Set "pva" to NULL here, because of "retry" path.
-	 */
-	pva = NULL;
-
-	if (!this_cpu_read(ne_fit_preload_node))
-		/*
-		 * Even if it fails we do not really care about that.
-		 * Just proceed as it is. If needed "overflow" path
-		 * will refill the cache we allocate from.
-		 */
-		pva = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
-
-	spin_lock(&free_vmap_area_lock);
-
-	if (pva && __this_cpu_cmpxchg(ne_fit_preload_node, NULL, pva))
-		kmem_cache_free(vmap_area_cachep, pva);
+	preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);
+	addr = __alloc_vmap_area(size, align, vstart, vend);
+	spin_unlock(&free_vmap_area_lock);
 
 	/*
 	 * If an allocation fails, the "vend" address is
 	 * returned. Therefore trigger the overflow path.
 	 */
-	addr = __alloc_vmap_area(size, align, vstart, vend);
-	spin_unlock(&free_vmap_area_lock);
-
 	if (unlikely(addr == vend))
 		goto overflow;
 
_

Patches currently in -mm which might be from urezki@gmail.com are


