Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D643C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6922A2311D
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600474135;
	bh=t8zDA+XSksiJ9QhhId4PTG1KAHgiDTz/eZrG5zywOCg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=N1enXiqup2goT9aFiisEwNeco/b5njwa0xQPSDfgS2gw9X3P8Xy/EAfbAdTQRqco/
	 di5cx+2wkeUS2RfwgcX4ji1tHrAGC1DN/kdlY9ZDb+2B4aUOzoLgE71wEQbNtri0iF
	 cBdDNG/4cBFO/56hWGnx7P9tYOTwfl+thIP/Z17U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgISAIz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAIy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:08:54 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175D3221EC;
        Sat, 19 Sep 2020 00:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600474134;
        bh=t8zDA+XSksiJ9QhhId4PTG1KAHgiDTz/eZrG5zywOCg=;
        h=Date:From:To:Subject:From;
        b=GYQ0+wfIQdpE4UXG1AQ2IN8b0cCorAMy5mUK2MFmWpFqlUTEpjb7yMI5dUSD65D3E
         26Ayr9pVM+XACBekBoXBNoXkFcFeLfhXWYWV9GdU4MsOgy6oi5nj+we+imdtJMcgE3
         K0+jC9IxQ0FkqrteCUApcnx03xzx3N6TgZwQiYI0=
Date:   Fri, 18 Sep 2020 17:08:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@lst.de
Subject:  +
 x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch added to -mm tree
Message-ID: <20200919000853.KbgmB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/xen: open code alloc_vm_area in arch_gnttab_valloc
has been added to the -mm tree.  Its filename is
     x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: x86/xen: open code alloc_vm_area in arch_gnttab_valloc

Open code alloc_vm_area in the last remaining caller.

Link: https://lkml.kernel.org/r/20200918163724.2511-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/grant-table.c |   27 ++++++++++++++-----
 include/linux/vmalloc.h    |    5 ---
 mm/nommu.c                 |    7 -----
 mm/vmalloc.c               |   48 -----------------------------------
 4 files changed, 21 insertions(+), 66 deletions(-)

--- a/arch/x86/xen/grant-table.c~x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc
+++ a/arch/x86/xen/grant-table.c
@@ -90,19 +90,32 @@ void arch_gnttab_unmap(void *shared, uns
 	}
 }
 
+static int gnttab_apply(pte_t *pte, unsigned long addr, void *data)
+{
+	pte_t ***p = data;
+
+	**p = pte;
+	(*p)++;
+	return 0;
+}
+
 static int arch_gnttab_valloc(struct gnttab_vm_area *area, unsigned nr_frames)
 {
 	area->ptes = kmalloc_array(nr_frames, sizeof(*area->ptes), GFP_KERNEL);
 	if (area->ptes == NULL)
 		return -ENOMEM;
-
-	area->area = alloc_vm_area(PAGE_SIZE * nr_frames, area->ptes);
-	if (area->area == NULL) {
-		kfree(area->ptes);
-		return -ENOMEM;
-	}
-
+	area->area = get_vm_area(PAGE_SIZE * nr_frames, VM_IOREMAP);
+	if (!area->area)
+		goto out_free_ptes;
+	if (apply_to_page_range(&init_mm, (unsigned long)area->area->addr,
+			PAGE_SIZE * nr_frames, gnttab_apply, &area->ptes))
+		goto out_free_vm_area;
 	return 0;
+out_free_vm_area:
+	free_vm_area(area->area);
+out_free_ptes:
+	kfree(area->ptes);
+	return -ENOMEM;
 }
 
 static void arch_gnttab_vfree(struct gnttab_vm_area *area)
--- a/include/linux/vmalloc.h~x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc
+++ a/include/linux/vmalloc.h
@@ -168,6 +168,7 @@ extern struct vm_struct *__get_vm_area_c
 					unsigned long flags,
 					unsigned long start, unsigned long end,
 					const void *caller);
+void free_vm_area(struct vm_struct *area);
 extern struct vm_struct *remove_vm_area(const void *addr);
 extern struct vm_struct *find_vm_area(const void *addr);
 
@@ -203,10 +204,6 @@ static inline void set_vm_flush_reset_pe
 }
 #endif
 
-/* Allocate/destroy a 'vmalloc' VM area. */
-extern struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes);
-extern void free_vm_area(struct vm_struct *area);
-
 /* for /dev/kmem */
 extern long vread(char *buf, char *addr, unsigned long count);
 extern long vwrite(char *buf, char *addr, unsigned long count);
--- a/mm/nommu.c~x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc
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
--- a/mm/vmalloc.c~x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc
+++ a/mm/vmalloc.c
@@ -3077,54 +3077,6 @@ int remap_vmalloc_range(struct vm_area_s
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

Patches currently in -mm which might be from hch@lst.de are

zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
mm-add-a-vmap_pfn-function.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

