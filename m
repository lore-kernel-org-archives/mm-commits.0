Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8036C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80CCB21789
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674169;
	bh=KlyYF+YSs+NO6QUwIiHRjTb72HvtPRdhuDzkrz0fdpA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BGZOBCklInH0zEY0q2Zxg6BrdvyeBG0vMExtzuABCUfhDTs8jKJHsUF17B+g1QOB7
	 5lO2yyn5qUUesbc3nGAz7WszlpDZuIKHf4Z82wYJaQk2Cox6X/PahweUEYS9iVDsx6
	 dwhYYqcVx/KBwZHNRkB7ortvbetq0fjeMV1kPi7o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJBV33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgJBV33 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:29 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5F222137B;
        Fri,  2 Oct 2020 21:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674168;
        bh=KlyYF+YSs+NO6QUwIiHRjTb72HvtPRdhuDzkrz0fdpA=;
        h=Date:From:To:Subject:From;
        b=zycgzNnl8Iab3cIbz+axCciPUi/G1TP7koq6+eEqNsbtCiV7tKog4CxfNeUYUynTi
         PNr3Ixjxrcsuk7GsLzrgTOq21Ad8FuIuTAbvQj37RFNCSzon/Suvy+IBAPb1B+QRtJ
         RgJ9hifVv4ql9wquCjf4yPDNkY2eIPjPIsTQgj9I=
Date:   Fri, 02 Oct 2020 14:29:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        tvrtko.ursulin@intel.com, sstabellini@kernel.org,
        rodrigo.vivi@intel.com, peterz@infradead.org, ngupta@vflare.org,
        minchan@kernel.org, matthew.auld@intel.com,
        joonas.lahtinen@linux.intel.com, jgross@suse.com,
        jani.nikula@linux.intel.com, chris@chris-wilson.co.uk,
        boris.ostrovsky@oracle.com, hch@lst.de
Subject:  + mm-remove-alloc_vm_area.patch added to -mm tree
Message-ID: <20201002212927.uLZ-i%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove alloc_vm_area
has been added to the -mm tree.  Its filename is
     mm-remove-alloc_vm_area.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-alloc_vm_area.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-alloc_vm_area.patch

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

Patches currently in -mm which might be from hch@lst.de are

mm-add-a-vm_map_put_pages-flag-for-vmap.patch
mm-add-a-vmap_pfn-function.patch
mm-allow-a-null-fn-callback-in-apply_to_page_range.patch
zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-stop-using-kmap-in-i915_gem_object_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch
mm-remove-alloc_vm_area.patch
mm-cleanup-the-gfp_mask-handling-in-__vmalloc_area_node.patch
mm-remove-the-filename-in-the-top-of-file-comment-in-vmallocc.patch

