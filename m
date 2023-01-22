Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CDAC54EB4
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjAVBV0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjAVBVZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C800B24495
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F749B80880
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15038C433D2;
        Sun, 22 Jan 2023 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350481;
        bh=iLOiAspJ4juPZa3fl4ldXzqGjp6aZWNvvyiHKIhg2sA=;
        h=Date:To:From:Subject:From;
        b=dNRjBU0hxxTuG/VNxLSLPON1O93fM4+8vxjAuJrtDnl5PKSethwA7iW6HAA59bzNg
         5GlVzW7dCFXgxpdb5utfX8iCuuRTso+ha8FlmqgekI1WEV9M/yWavlbCM4Mv416kP/
         +vobtZv6AtZsYwVK7sz1FZhVumMl4xStB0KOGNGM=
Date:   Sat, 21 Jan 2023 17:21:20 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch added to mm-unstable branch
Message-Id: <20230122012121.15038C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move vmalloc_init and free_work down in vmalloc.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: move vmalloc_init and free_work down in vmalloc.c
Date: Sat, 21 Jan 2023 08:10:45 +0100

Move these two functions around a bit to avoid forward declarations.

Link: https://lkml.kernel.org/r/20230121071051.1143058-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-move-vmalloc_init-and-free_work-down-in-vmallocc
+++ a/mm/vmalloc.c
@@ -89,17 +89,6 @@ struct vfree_deferred {
 };
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
-static void __vunmap(const void *, int);
-
-static void free_work(struct work_struct *w)
-{
-	struct vfree_deferred *p = container_of(w, struct vfree_deferred, wq);
-	struct llist_node *t, *llnode;
-
-	llist_for_each_safe(llnode, t, llist_del_all(&p->list))
-		__vunmap((void *)llnode, 1);
-}
-
 /*** Page table manipulation functions ***/
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
@@ -2449,48 +2438,6 @@ static void vmap_init_free_space(void)
 	}
 }
 
-void __init vmalloc_init(void)
-{
-	struct vmap_area *va;
-	struct vm_struct *tmp;
-	int i;
-
-	/*
-	 * Create the cache for vmap_area objects.
-	 */
-	vmap_area_cachep = KMEM_CACHE(vmap_area, SLAB_PANIC);
-
-	for_each_possible_cpu(i) {
-		struct vmap_block_queue *vbq;
-		struct vfree_deferred *p;
-
-		vbq = &per_cpu(vmap_block_queue, i);
-		spin_lock_init(&vbq->lock);
-		INIT_LIST_HEAD(&vbq->free);
-		p = &per_cpu(vfree_deferred, i);
-		init_llist_head(&p->list);
-		INIT_WORK(&p->wq, free_work);
-	}
-
-	/* Import existing vmlist entries. */
-	for (tmp = vmlist; tmp; tmp = tmp->next) {
-		va = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-		if (WARN_ON_ONCE(!va))
-			continue;
-
-		va->va_start = (unsigned long)tmp->addr;
-		va->va_end = va->va_start + tmp->size;
-		va->vm = tmp;
-		insert_vmap_area(va, &vmap_area_root, &vmap_area_list);
-	}
-
-	/*
-	 * Now we can initialize a free vmap space.
-	 */
-	vmap_init_free_space();
-	vmap_initialized = true;
-}
-
 static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
 	struct vmap_area *va, unsigned long flags, const void *caller)
 {
@@ -2769,6 +2716,15 @@ static void __vunmap(const void *addr, i
 	kfree(area);
 }
 
+static void delayed_vfree_work(struct work_struct *w)
+{
+	struct vfree_deferred *p = container_of(w, struct vfree_deferred, wq);
+	struct llist_node *t, *llnode;
+
+	llist_for_each_safe(llnode, t, llist_del_all(&p->list))
+		__vunmap((void *)llnode, 1);
+}
+
 /**
  * vfree_atomic - release memory allocated by vmalloc()
  * @addr:	  memory base address
@@ -4315,3 +4271,46 @@ static int __init proc_vmalloc_init(void
 module_init(proc_vmalloc_init);
 
 #endif
+
+void __init vmalloc_init(void)
+{
+	struct vmap_area *va;
+	struct vm_struct *tmp;
+	int i;
+
+	/*
+	 * Create the cache for vmap_area objects.
+	 */
+	vmap_area_cachep = KMEM_CACHE(vmap_area, SLAB_PANIC);
+
+	for_each_possible_cpu(i) {
+		struct vmap_block_queue *vbq;
+		struct vfree_deferred *p;
+
+		vbq = &per_cpu(vmap_block_queue, i);
+		spin_lock_init(&vbq->lock);
+		INIT_LIST_HEAD(&vbq->free);
+		p = &per_cpu(vfree_deferred, i);
+		init_llist_head(&p->list);
+		INIT_WORK(&p->wq, delayed_vfree_work);
+	}
+
+	/* Import existing vmlist entries. */
+	for (tmp = vmlist; tmp; tmp = tmp->next) {
+		va = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
+		if (WARN_ON_ONCE(!va))
+			continue;
+
+		va->va_start = (unsigned long)tmp->addr;
+		va->va_end = va->va_start + tmp->size;
+		va->vm = tmp;
+		insert_vmap_area(va, &vmap_area_root, &vmap_area_list);
+	}
+
+	/*
+	 * Now we can initialize a free vmap space.
+	 */
+	vmap_init_free_space();
+	vmap_initialized = true;
+}
+
_

Patches currently in -mm which might be from hch@lst.de are

revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch
mm-reject-vmap-with-vm_flush_reset_perms.patch
mm-remove-__vfree.patch
mm-remove-__vfree_deferred.patch
mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch
mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch
mm-move-__remove_vm_area-out-of-va_remove_mappings.patch
mm-use-remove_vm_area-in-__vunmap.patch
mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch
mm-split-__vunmap.patch
mm-refactor-va_remove_mappings.patch

