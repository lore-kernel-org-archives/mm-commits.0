Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606B9C43465
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 251EB22208
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600474125;
	bh=zcSSPYEZw8uqBx847eRu5sGdkmhxutylvKEx1l0KQKM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=awB7Zbti2eYZx2jdIXrZCBaSqr64hQNaVuJFUfV5Q/vgBryoprvPqmqcBBNLP8GNy
	 Ubz1TPcrvcY11AbX7RV2qLvu5sXRcIWl/LJaTwJn+3jowIzVYPhhEWNXp24UDdJ3RP
	 daoV/998tIUuKobv6wBTHfYNJPvg7nZNTsTBskk4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgISAIo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAIo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:08:44 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A41E221EC;
        Sat, 19 Sep 2020 00:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600474124;
        bh=zcSSPYEZw8uqBx847eRu5sGdkmhxutylvKEx1l0KQKM=;
        h=Date:From:To:Subject:From;
        b=weH0VwHI/yWX60tU6O/aJ8ZGrFWYtWIFVeXIo20G1hyh2dNIdCjbH8+24NtCgEol/
         GGQoo5/zd6iCr8zm1AXE+QbP3BoFyGjbU/0cuYWyTEqiE60ROg9WvO0EmQ4nNZ/bJs
         BSFgr/SmhlwfGcoamNzZOh4u+npz+NL1OLaKP0T0=
Date:   Fri, 18 Sep 2020 17:08:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hch@lst.de
Subject:  + mm-add-a-vmap_pfn-function.patch added to -mm tree
Message-ID: <20200919000843.ADe2T%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add a vmap_pfn function
has been added to the -mm tree.  Its filename is
     mm-add-a-vmap_pfn-function.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-a-vmap_pfn-function.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-a-vmap_pfn-function.patch

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
Subject: mm: add a vmap_pfn function

Add a proper helper to remap PFNs into kernel virtual space so that
drivers don't have to abuse alloc_vm_area and open coded PTE manipulation
for it.

Link: https://lkml.kernel.org/r/20200918163724.2511-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 
 mm/Kconfig              |    3 ++
 mm/vmalloc.c            |   45 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

--- a/include/linux/vmalloc.h~mm-add-a-vmap_pfn-function
+++ a/include/linux/vmalloc.h
@@ -121,6 +121,7 @@ extern void vfree_atomic(const void *add
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
+void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot);
 extern void vunmap(const void *addr);
 
 extern int remap_vmalloc_range_partial(struct vm_area_struct *vma,
--- a/mm/Kconfig~mm-add-a-vmap_pfn-function
+++ a/mm/Kconfig
@@ -815,6 +815,9 @@ config DEVICE_PRIVATE
 	  memory; i.e., memory that is only accessible from the device (or
 	  group of devices). You likely also want to select HMM_MIRROR.
 
+config VMAP_PFN
+	bool
+
 config FRAME_VECTOR
 	bool
 
--- a/mm/vmalloc.c~mm-add-a-vmap_pfn-function
+++ a/mm/vmalloc.c
@@ -2407,6 +2407,51 @@ void *vmap(struct page **pages, unsigned
 }
 EXPORT_SYMBOL(vmap);
 
+#ifdef CONFIG_VMAP_PFN
+struct vmap_pfn_data {
+	unsigned long	*pfns;
+	pgprot_t	prot;
+	unsigned int	idx;
+};
+
+static int vmap_pfn_apply(pte_t *pte, unsigned long addr, void *private)
+{
+	struct vmap_pfn_data *data = private;
+
+	if (WARN_ON_ONCE(pfn_valid(data->pfns[data->idx])))
+		return -EINVAL;
+	*pte = pte_mkspecial(pfn_pte(data->pfns[data->idx++], data->prot));
+	return 0;
+}
+
+/**
+ * vmap_pfn - map an array of PFNs into virtually contiguous space
+ * @pfns: array of PFNs
+ * @count: number of pages to map
+ * @prot: page protection for the mapping
+ *
+ * Maps @count PFNs from @pfns into contiguous kernel virtual space and returns
+ * the start address of the mapping.
+ */
+void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot)
+{
+	struct vmap_pfn_data data = { .pfns = pfns, .prot = pgprot_nx(prot) };
+	struct vm_struct *area;
+
+	area = get_vm_area_caller(count * PAGE_SIZE, VM_IOREMAP,
+			__builtin_return_address(0));
+	if (!area)
+		return NULL;
+	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
+			count * PAGE_SIZE, vmap_pfn_apply, &data)) {
+		free_vm_area(area);
+		return NULL;
+	}
+	return area->addr;
+}
+EXPORT_SYMBOL_GPL(vmap_pfn);
+#endif /* CONFIG_VMAP_PFN */
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node)
 {
_

Patches currently in -mm which might be from hch@lst.de are

zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch
mm-add-a-vmap_pfn-function.patch
drm-i915-use-vmap-in-shmem_pin_map.patch
drm-i915-use-vmap-in-i915_gem_object_map.patch
xen-xenbus-use-apply_to_page_range-directly-in-xenbus_map_ring_pv.patch
x86-xen-open-code-alloc_vm_area-in-arch_gnttab_valloc.patch

