Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E8FC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D7521655
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976543;
	bh=b/g7PZWr2XIH7jw8iEs5veTtxGNAQJ6dqDkXNF/nooY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=k6IIOz5lwnD12dbltXgV4OlqMLm1q63p7oaVbM5VS/kCxJIIxzRwnk01S6FX7XSvi
	 GLVd+djheEX4/qeNXP5PBq2Sb71vudDsodAgH39hMOVoHQamhVjLggQ9mT+sGgjeIJ
	 rLhckSu8KuQAGvWQp31QUx2mHu1+sL4K1aHSzdSg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439920AbgJQXPm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5247322202;
        Sat, 17 Oct 2020 23:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976541;
        bh=b/g7PZWr2XIH7jw8iEs5veTtxGNAQJ6dqDkXNF/nooY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EcfRqKbm7EpxHs1yM8zpICU2Tg0AE46f0EcOl5GMoKPqD2YlKQLmrvByucXgOMFZm
         1fjUVPkafv7hvRQJ+NW9B15zSu+eaB+tuN9pMDy807e1SahtevW1GVmAtvDWXF/UxG
         oBESTxyh/nXkRq5am3Hc0oVe6Xt7J7pjkx4FkNv8=
Date:   Sat, 17 Oct 2020 16:15:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boris.ostrovsky@oracle.com,
        chris@chris-wilson.co.uk, hch@lst.de, jani.nikula@linux.intel.com,
        jgross@suse.com, joonas.lahtinen@linux.intel.com,
        linux-mm@kvack.org, matthew.auld@intel.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, torvalds@linux-foundation.org,
        tvrtko.ursulin@intel.com, urezki@gmail.com, willy@infradead.org
Subject:  [patch 37/40] mm: remove alloc_vm_area
Message-ID: <20201017231539.rqXa9tuF3%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: remove alloc_vm_area

All users are gone now.

Link: https://lkml.kernel.org/r/20201002122204.1534411-12-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    5 ---
 mm/nommu.c              |    7 -----
 mm/vmalloc.c            |   48 --------------------------------------
 3 files changed, 1 insertion(+), 59 deletions(-)

--- a/include/linux/vmalloc.h~mm-remove-alloc_vm_area
+++ a/include/linux/vmalloc.h
@@ -169,6 +169,7 @@ extern struct vm_struct *__get_vm_area_c
 					unsigned long flags,
 					unsigned long start, unsigned long end,
 					const void *caller);
+void free_vm_area(struct vm_struct *area);
 extern struct vm_struct *remove_vm_area(const void *addr);
 extern struct vm_struct *find_vm_area(const void *addr);
 
@@ -204,10 +205,6 @@ static inline void set_vm_flush_reset_pe
 }
 #endif
 
-/* Allocate/destroy a 'vmalloc' VM area. */
-extern struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes);
-extern void free_vm_area(struct vm_struct *area);
-
 /* for /dev/kmem */
 extern long vread(char *buf, char *addr, unsigned long count);
 extern long vwrite(char *buf, char *addr, unsigned long count);
--- a/mm/nommu.c~mm-remove-alloc_vm_area
+++ a/mm/nommu.c
@@ -354,13 +354,6 @@ void vm_unmap_aliases(void)
 }
 EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 
-struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes)
-{
-	BUG();
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(alloc_vm_area);
-
 void free_vm_area(struct vm_struct *area)
 {
 	BUG();
--- a/mm/vmalloc.c~mm-remove-alloc_vm_area
+++ a/mm/vmalloc.c
@@ -3083,54 +3083,6 @@ int remap_vmalloc_range(struct vm_area_s
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
 
-static int f(pte_t *pte, unsigned long addr, void *data)
-{
-	pte_t ***p = data;
-
-	if (p) {
-		*(*p) = pte;
-		(*p)++;
-	}
-	return 0;
-}
-
-/**
- * alloc_vm_area - allocate a range of kernel address space
- * @size:	   size of the area
- * @ptes:	   returns the PTEs for the address space
- *
- * Returns:	NULL on failure, vm_struct on success
- *
- * This function reserves a range of kernel address space, and
- * allocates pagetables to map that range.  No actual mappings
- * are created.
- *
- * If @ptes is non-NULL, pointers to the PTEs (in init_mm)
- * allocated for the VM area are returned.
- */
-struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes)
-{
-	struct vm_struct *area;
-
-	area = get_vm_area_caller(size, VM_IOREMAP,
-				__builtin_return_address(0));
-	if (area == NULL)
-		return NULL;
-
-	/*
-	 * This ensures that page tables are constructed for this region
-	 * of kernel virtual address space and mapped into init_mm.
-	 */
-	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
-				size, f, ptes ? &ptes : NULL)) {
-		free_vm_area(area);
-		return NULL;
-	}
-
-	return area;
-}
-EXPORT_SYMBOL_GPL(alloc_vm_area);
-
 void free_vm_area(struct vm_struct *area)
 {
 	struct vm_struct *ret;
_
