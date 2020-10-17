Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E515C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 667D121556
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976526;
	bh=sAiTG+S/mBKS2my6tWraPLhSa9rfatLBXJs4lzVUxQI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=TLqrRhpKQ9aj+UEwzc12zbw/jFGxI4/MlDUjNjrY4YjY6oiwMtU7bzfYkWrIN3fK6
	 exWDNLeJQFO0jbwlTWBQPLboUHtMbBZMkDUINrcTG4g0x+kuDwJM3GitStnMACweHX
	 /3HmA0zD8IJNUB8rRSaCpT3Gea7/4x9v5ickTw+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439915AbgJQXPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 749FB212CC;
        Sat, 17 Oct 2020 23:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976522;
        bh=sAiTG+S/mBKS2my6tWraPLhSa9rfatLBXJs4lzVUxQI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q77/iBd5qudymV3144AfXEh51ZrQygaksUt+k7ZA6fjdQeeFkGE6DufJGZzAbLYSe
         Qr1IzGupnmxEOJXt9CnS7GlU5w0tywWIa8wYJ+ktwkXBSujfv2AITeeiUweWlA7URK
         AQymucRCUf53i8bHyXbKskzRugNZXq6P6Y3Qo50Y=
Date:   Sat, 17 Oct 2020 16:15:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boris.ostrovsky@oracle.com,
        chris@chris-wilson.co.uk, hch@lst.de, jani.nikula@linux.intel.com,
        jgross@suse.com, joonas.lahtinen@linux.intel.com,
        linux-mm@kvack.org, matthew.auld@intel.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, torvalds@linux-foundation.org,
        tvrtko.ursulin@intel.com, urezki@gmail.com, willy@infradead.org
Subject:  [patch 32/40] drm/i915: use vmap in shmem_pin_map
Message-ID: <20201017231521.9DF7wjUfG%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
