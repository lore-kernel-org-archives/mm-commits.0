Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F438C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18AB621D7B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600474128;
	bh=V1LwCJ5m6vB8Va0mFpvekpABlY5mKsDkY+6S71QXlDw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=e0kRJYHFgmBplGQryyhukRHlE6IsMDuBV3qBTdw1by7HK4v5ycOyQdzDFgDaXsT5c
	 gsGnbpT1sQmgrbd61ZWyUegUTN/EPMS0XpScLptGELA0TzERdgNb19EXGLKDxxpNc8
	 lpb0qoq/Z3QNt1uzwhVMa+dA3F2qefI74l5tkit4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgISAIr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAIr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:08:47 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BF0721D43;
        Sat, 19 Sep 2020 00:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600474127;
        bh=V1LwCJ5m6vB8Va0mFpvekpABlY5mKsDkY+6S71QXlDw=;
        h=Date:From:To:Subject:From;
        b=rfqRbey46kOsTsJLTWK4OSJxaQ3hdbMJtqsEurA+ZTLAyyNhjox4L6f8OAoU8ln5z
         FUpehejsxihM24fLJNgG5F2gJ/mfiJasEf0wr4gqVfs+/QdBp3Ty8fRGkKeOMKz/Kd
         bwac8lDeTgp7h1BuaqihTPQGmrX97L/DQeO1mp9A=
Date:   Fri, 18 Sep 2020 17:08:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@lst.de
Subject:  + drm-i915-use-vmap-in-shmem_pin_map.patch added to -mm
 tree
Message-ID: <20200919000846.Ux4AO%akpm@linux-foundation.org>
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
(and could be added to vmap using a flag if actually required).

Link: https://lkml.kernel.org/r/20200918163724.2511-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gt/shmem_utils.c |   90 ++++++++++--------------
 1 file changed, 38 insertions(+), 52 deletions(-)

--- a/drivers/gpu/drm/i915/gt/shmem_utils.c~drm-i915-use-vmap-in-shmem_pin_map
+++ a/drivers/gpu/drm/i915/gt/shmem_utils.c
@@ -49,80 +49,66 @@ struct file *shmem_create_from_object(st
 	return file;
 }
 
-static size_t shmem_npte(struct file *file)
+static size_t shmem_npages(struct file *file)
 {
 	return file->f_mapping->host->i_size >> PAGE_SHIFT;
 }
 
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
+	const size_t n_pages = shmem_npages(file);
+	struct page **pages, *stack[32];
+	void *vaddr;
+	long i;
+
+	pages = stack;
+	if (n_pages > ARRAY_SIZE(stack)) {
+		pages = kvmalloc_array(n_pages, sizeof(*pages), GFP_KERNEL);
+		if (!pages)
 			return NULL;
 	}
 
-	area = alloc_vm_area(n_pte << PAGE_SHIFT, mem);
-	if (!area) {
-		if (mem != stack)
-			kvfree(mem);
-		return NULL;
-	}
-
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
+	vaddr = vmap(pages, n_pages, 0, PAGE_KERNEL);
+	if (!vaddr)
+		goto err_page;
 
+	if (pages != stack)
+		kvfree(pages);
 	mapping_set_unevictable(file->f_mapping);
-	return area->addr;
+	return vaddr;
 
 err_page:
-	if (mem != stack)
-		kvfree(mem);
-
-	__shmem_unpin_map(file, area->addr, pfn);
+	while (--i >= 0)
+		put_page(pages[i]);
+	if (pages != stack)
+		kvfree(pages);
 	return NULL;
 }
 
 void shmem_unpin_map(struct file *file, void *ptr)
 {
+	long i = shmem_npages(file);
+
 	mapping_clear_unevictable(file->f_mapping);
-	__shmem_unpin_map(file, ptr, shmem_npte(file));
+	vunmap(ptr);
+
+	for (i = 0; i < shmem_npages(file); i++) {
+		struct page *page;
+
+		page = shmem_read_mapping_page_gfp(file->f_mapping, i,
+						   GFP_KERNEL);
+		if (!WARN_ON(IS_ERR(page))) {
+			put_page(page);
+			put_page(page);
+		}
+	}
 }
 
 static int __shmem_rw(struct file *file, loff_t off,
_

Patches currently in -mm which might be from hch@lst.de are

zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
mm-add-a-vmap_pfn-function.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

