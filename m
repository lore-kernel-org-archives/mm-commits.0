Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD158C4363D
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9609208C7
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674156;
	bh=D+odAPunAbTgfiYEV4XCpHPsJ+LGVFXGYAC9aYYBwO4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gjygusuI8U8+WkOOCj/+ICOlqNtGvQTZicwXdAIEaJ+PhM+PJFyVDpsBgD3ueIHxc
	 cgoy+rKClGTvo1ZXUouygp7R1O80eNVzw9Ts5TmIMUrobWgkmeJuamwUZ59DDbuxNT
	 IemDtXkgpEFs9JlVzVmGuPotEzvqkdd2wjtFdiBQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgJBV3Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBV3Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:16 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C052720796;
        Fri,  2 Oct 2020 21:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674154;
        bh=D+odAPunAbTgfiYEV4XCpHPsJ+LGVFXGYAC9aYYBwO4=;
        h=Date:From:To:Subject:From;
        b=gKhvm+oyIZMTkN/egatGRWNQ3DKaQJihl740zst6T8gFw1v8+t9mYd7YYoXXJ6yiw
         P78AzwOybf4zhm1uFhL0eYeJQ9gI3XgRC8hNrXiMVRysqZMZbi0do27Ht/Gcr2hLtq
         Ef5F5d67Q7sR0KEzui0pTnozV4cbSzK9hsrTwvUk=
Date:   Fri, 02 Oct 2020 14:29:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        tvrtko.ursulin@intel.com, sstabellini@kernel.org,
        rodrigo.vivi@intel.com, peterz@infradead.org, ngupta@vflare.org,
        minchan@kernel.org, matthew.auld@intel.com,
        joonas.lahtinen@linux.intel.com, jgross@suse.com,
        jani.nikula@linux.intel.com, chris@chris-wilson.co.uk,
        boris.ostrovsky@oracle.com, hch@lst.de
Subject:  + drm-i915-use-vmap-in-shmem_pin_map.patch added to -mm
 tree
Message-ID: <20201002212913.TyE-i%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: use vmap in shmem_pin_map
has been added to the -mm tree.  Its filename is
     drm-i915-use-vmap-in-shmem_pin_map.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drm-i915-use-vmap-in-shmem_pin_map.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drm-i915-use-vmap-in-shmem_pin_map.patch

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
Subject: drm/i915: use vmap in shmem_pin_map

shmem_pin_map somewhat awkwardly reimplements vmap using alloc_vm_area and
manual pte setup.  The only practical difference is that alloc_vm_area
prefeaults the vmalloc area PTEs, which doesn't seem to be required here
(and could be added to vmap using a flag if actually required).  Switch to
use vmap, and use vfree to free both the vmalloc mapping and the page
array, as well as dropping the references to each page.

Link: https://lkml.kernel.org/r/20201002122204.1534411-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
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
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gt/shmem_utils.c |   78 +++++-------------------
 1 file changed, 19 insertions(+), 59 deletions(-)

--- a/drivers/gpu/drm/i915/gt/shmem_utils.c~drm-i915-use-vmap-in-shmem_pin_map
+++ a/drivers/gpu/drm/i915/gt/shmem_utils.c
@@ -49,80 +49,40 @@ struct file *shmem_create_from_object(st
 	return file;
 }
 
-static size_t shmem_npte(struct file *file)
-{
-	return file->f_mapping->host->i_size >> PAGE_SHIFT;
-}
-
-static void __shmem_unpin_map(struct file *file, void *ptr, size_t n_pte)
-{
-	unsigned long pfn;
-
-	vunmap(ptr);
-
-	for (pfn = 0; pfn < n_pte; pfn++) {
-		struct page *page;
-
-		page = shmem_read_mapping_page_gfp(file->f_mapping, pfn,
-						   GFP_KERNEL);
-		if (!WARN_ON(IS_ERR(page))) {
-			put_page(page);
-			put_page(page);
-		}
-	}
-}
-
 void *shmem_pin_map(struct file *file)
 {
-	const size_t n_pte = shmem_npte(file);
-	pte_t *stack[32], **ptes, **mem;
-	struct vm_struct *area;
-	unsigned long pfn;
-
-	mem = stack;
-	if (n_pte > ARRAY_SIZE(stack)) {
-		mem = kvmalloc_array(n_pte, sizeof(*mem), GFP_KERNEL);
-		if (!mem)
-			return NULL;
-	}
-
-	area = alloc_vm_area(n_pte << PAGE_SHIFT, mem);
-	if (!area) {
-		if (mem != stack)
-			kvfree(mem);
+	struct page **pages;
+	size_t n_pages, i;
+	void *vaddr;
+
+	n_pages = file->f_mapping->host->i_size >> PAGE_SHIFT;
+	pages = kvmalloc_array(n_pages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
 		return NULL;
-	}
 
-	ptes = mem;
-	for (pfn = 0; pfn < n_pte; pfn++) {
-		struct page *page;
-
-		page = shmem_read_mapping_page_gfp(file->f_mapping, pfn,
-						   GFP_KERNEL);
-		if (IS_ERR(page))
+	for (i = 0; i < n_pages; i++) {
+		pages[i] = shmem_read_mapping_page_gfp(file->f_mapping, i,
+						       GFP_KERNEL);
+		if (IS_ERR(pages[i]))
 			goto err_page;
-
-		**ptes++ = mk_pte(page,  PAGE_KERNEL);
 	}
 
-	if (mem != stack)
-		kvfree(mem);
-
+	vaddr = vmap(pages, n_pages, VM_MAP_PUT_PAGES, PAGE_KERNEL);
+	if (!vaddr)
+		goto err_page;
 	mapping_set_unevictable(file->f_mapping);
-	return area->addr;
-
+	return vaddr;
 err_page:
-	if (mem != stack)
-		kvfree(mem);
-
-	__shmem_unpin_map(file, area->addr, pfn);
+	while (--i >= 0)
+		put_page(pages[i]);
+	kvfree(pages);
 	return NULL;
 }
 
 void shmem_unpin_map(struct file *file, void *ptr)
 {
 	mapping_clear_unevictable(file->f_mapping);
-	__shmem_unpin_map(file, ptr, shmem_npte(file));
+	vfree(ptr);
 }
 
 static int __shmem_rw(struct file *file, loff_t off,
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

