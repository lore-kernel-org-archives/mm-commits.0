Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475C8C43467
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13CA221582
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976513;
	bh=K3HEs8+uulq4zNfuTiInv60TjFABgs0nKl3bYhfpbnk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=n6UU2rO/tCfZDmk71aKciFZTRI+rXGClOfe8e9ltnsIWn1JyBoekc+IIHG5B2gyNV
	 fEwARxcuTrggT0nUdg8ILf4yq0+hMQoReKHx3rdJLabF3yovhQZc/TG5H4bLFkZiOB
	 3DPj5dhe1nio1R3f8yNxhkCulW558+MVO+1drfYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439912AbgJQXPM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C976E20EDD;
        Sat, 17 Oct 2020 23:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976511;
        bh=K3HEs8+uulq4zNfuTiInv60TjFABgs0nKl3bYhfpbnk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fDsFUAhF+RhMEG5bHGWb2ejWWvVUbSPWj3KmK13UvgUlvbqHhzXf7BrFdt/BGM345
         NTbkVZq6ib3mJAXsfmud1/Ql86g5DEWUpofUoJraF+2i/UfhfuHJhLWo7UUjfbVpCE
         ZV19AYvmxX+Ucna3NLZelMPqzrlVqMy7H/qZWkXU=
Date:   Sat, 17 Oct 2020 16:15:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boris.ostrovsky@oracle.com,
        chris@chris-wilson.co.uk, hch@lst.de, jani.nikula@linux.intel.com,
        jgross@suse.com, joonas.lahtinen@linux.intel.com,
        linux-mm@kvack.org, matthew.auld@intel.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, torvalds@linux-foundation.org,
        tvrtko.ursulin@intel.com, urezki@gmail.com, willy@infradead.org
Subject:  [patch 29/40] mm: add a vmap_pfn function
Message-ID: <20201017231510.EY4VsFGOW%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: add a vmap_pfn function

Add a proper helper to remap PFNs into kernel virtual space so that
drivers don't have to abuse alloc_vm_area and open coded PTE manipulation
for it.

Link: https://lkml.kernel.org/r/20201002122204.1534411-4-hch@lst.de
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

 include/linux/vmalloc.h |    1 
 mm/Kconfig              |    3 ++
 mm/vmalloc.c            |   45 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

--- a/include/linux/vmalloc.h~mm-add-a-vmap_pfn-function
+++ a/include/linux/vmalloc.h
@@ -122,6 +122,7 @@ extern void vfree_atomic(const void *add
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
+void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot);
 extern void vunmap(const void *addr);
 
 extern int remap_vmalloc_range_partial(struct vm_area_struct *vma,
--- a/mm/Kconfig~mm-add-a-vmap_pfn-function
+++ a/mm/Kconfig
@@ -816,6 +816,9 @@ config DEVICE_PRIVATE
 	  memory; i.e., memory that is only accessible from the device (or
 	  group of devices). You likely also want to select HMM_MIRROR.
 
+config VMAP_PFN
+	bool
+
 config FRAME_VECTOR
 	bool
 
--- a/mm/vmalloc.c~mm-add-a-vmap_pfn-function
+++ a/mm/vmalloc.c
@@ -2413,6 +2413,51 @@ void *vmap(struct page **pages, unsigned
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
