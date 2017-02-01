From: akpm@linux-foundation.org
Subject: + mm-cma_alloc-allow-to-specify-gfp-mask.patch added to -mm tree
Date: Tue, 31 Jan 2017 16:58:53 -0800
Message-ID: <589132cd.heKJnKqfOpHLYE6k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdBAA6y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:58:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l.stach@pengutronix.de, agraf@suse.com, catalin.marinas@arm.com, chris@zankel.net, iamjoonsoo.kim@lge.com, mhocko@suse.com, pbonzini@redhat.com, ralf@linux-mips.org, rkrcmar@redhat.com, vbabka@suse.cz, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma_alloc: allow to specify GFP mask
has been added to the -mm tree.  Its filename is
     mm-cma_alloc-allow-to-specify-gfp-mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma_alloc-allow-to-specify-gfp-mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma_alloc-allow-to-specify-gfp-mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas Stach <l.stach@pengutronix.de>
Subject: mm: cma_alloc: allow to specify GFP mask

Most users of this interface just want to use it with the default
GFP_KERNEL flags, but for cases where DMA memory is allocated it may be
called from a different context.

No functional change yet, just passing through the flag to the underlying
alloc_contig_range function.

Link: http://lkml.kernel.org/r/20170127172328.18574-2-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_builtin.c |    3 ++-
 drivers/base/dma-contiguous.c        |    2 +-
 include/linux/cma.h                  |    3 ++-
 mm/cma.c                             |    5 +++--
 mm/cma_debug.c                       |    2 +-
 5 files changed, 9 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/kvm/book3s_hv_builtin.c~mm-cma_alloc-allow-to-specify-gfp-mask arch/powerpc/kvm/book3s_hv_builtin.c
--- a/arch/powerpc/kvm/book3s_hv_builtin.c~mm-cma_alloc-allow-to-specify-gfp-mask
+++ a/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -56,7 +56,8 @@ struct page *kvm_alloc_hpt(unsigned long
 {
 	VM_BUG_ON(order_base_2(nr_pages) < KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
 
-	return cma_alloc(kvm_cma, nr_pages, order_base_2(HPT_ALIGN_PAGES));
+	return cma_alloc(kvm_cma, nr_pages, order_base_2(HPT_ALIGN_PAGES),
+			 GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(kvm_alloc_hpt);
 
diff -puN drivers/base/dma-contiguous.c~mm-cma_alloc-allow-to-specify-gfp-mask drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~mm-cma_alloc-allow-to-specify-gfp-mask
+++ a/drivers/base/dma-contiguous.c
@@ -193,7 +193,7 @@ struct page *dma_alloc_from_contiguous(s
 	if (align > CONFIG_CMA_ALIGNMENT)
 		align = CONFIG_CMA_ALIGNMENT;
 
-	return cma_alloc(dev_get_cma_area(dev), count, align);
+	return cma_alloc(dev_get_cma_area(dev), count, align, GFP_KERNEL);
 }
 
 /**
diff -puN include/linux/cma.h~mm-cma_alloc-allow-to-specify-gfp-mask include/linux/cma.h
--- a/include/linux/cma.h~mm-cma_alloc-allow-to-specify-gfp-mask
+++ a/include/linux/cma.h
@@ -29,6 +29,7 @@ extern int __init cma_declare_contiguous
 extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					unsigned int order_per_bit,
 					struct cma **res_cma);
-extern struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align);
+extern struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align,
+			      gfp_t gfp_mask);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned int count);
 #endif
diff -puN mm/cma.c~mm-cma_alloc-allow-to-specify-gfp-mask mm/cma.c
--- a/mm/cma.c~mm-cma_alloc-allow-to-specify-gfp-mask
+++ a/mm/cma.c
@@ -362,7 +362,8 @@ err:
  * This function allocates part of contiguous memory on specific
  * contiguous memory area.
  */
-struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align)
+struct page *cma_alloc(struct cma *cma, size_t count, unsigned int align,
+		       gfp_t gfp_mask)
 {
 	unsigned long mask, offset;
 	unsigned long pfn = -1;
@@ -408,7 +409,7 @@ struct page *cma_alloc(struct cma *cma,
 		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
 		mutex_lock(&cma_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
-					 GFP_KERNEL);
+					 gfp_mask);
 		mutex_unlock(&cma_mutex);
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
diff -puN mm/cma_debug.c~mm-cma_alloc-allow-to-specify-gfp-mask mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma_alloc-allow-to-specify-gfp-mask
+++ a/mm/cma_debug.c
@@ -138,7 +138,7 @@ static int cma_alloc_mem(struct cma *cma
 	if (!mem)
 		return -ENOMEM;
 
-	p = cma_alloc(cma, count, 0);
+	p = cma_alloc(cma, count, 0, GFP_KERNEL);
 	if (!p) {
 		kfree(mem);
 		return -ENOMEM;
_

Patches currently in -mm which might be from l.stach@pengutronix.de are

mm-alloc_contig_range-allow-to-specify-gfp-mask.patch
mm-cma_alloc-allow-to-specify-gfp-mask.patch
mm-wire-up-gfp-flag-passing-in-dma_alloc_from_contiguous.patch

