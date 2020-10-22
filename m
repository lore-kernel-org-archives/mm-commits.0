Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F6AC388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FB5D24650
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408216;
	bh=izO8fnKMT1O4LcCXzgnYNS87yAdkaaSRQ4DuNjazc/o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0BIVagC35p0u/z2mt/Tne2ypqZ4m8Yeq6iGnRs41cwCflC7nTFx33raVUBJVIMKLp
	 wvz4ZzsYti/A57jkbD01oQeMIcsCQTAfBJ1UTaMow6dZbrAGloQQpVIGET7Mshxvk4
	 KEeyUFTfOSyXCA747azvrwa8Mj/u5g8dMOhJExJY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373261AbgJVXKP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373254AbgJVXKP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD9CA24654;
        Thu, 22 Oct 2020 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408214;
        bh=izO8fnKMT1O4LcCXzgnYNS87yAdkaaSRQ4DuNjazc/o=;
        h=Date:From:To:Subject:From;
        b=iY6Cvk0YruPGgDlIb/jzDG9MQSj2y/BRRTwPTHdjbNQ8tBAaB8KGNh8AqgsD2QQjw
         znkWHgD/vwc0nf+NLC9d1MhbSPkMes5G8yYVy6SpChqhTnsaQAmy0uSsFpMkFaRCqF
         EwB0YRrXCrbGhikBwCYHf0Ey5AH8FSb8Ee4fgayM=
Date:   Thu, 22 Oct 2020 16:10:13 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@intel.com, urezki@gmail.com,
        willy@infradead.org
Subject:  [merged] drm-i915-use-vmap-in-shmem_pin_map.patch removed
 from -mm tree
Message-ID: <20201022231013.t9Eh9_3EP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: use vmap in shmem_pin_map
has been removed from the -mm tree.  Its filename was
     drm-i915-use-vmap-in-shmem_pin_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


