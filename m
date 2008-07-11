From: akpm@linux-foundation.org
Subject: + gru-driver-v3-page-faults-exceptions-gru-virtual-physical-translation.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:44:25 -0700
Message-ID: <200807111850.m6BIo6Yg031236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755996AbYGKSuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, hch@lst.de


The patch titled
     GRU virtual -> physical translation
has been added to the -mm tree.  Its filename is
     gru-driver-v3-page-faults-exceptions-gru-virtual-physical-translation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU virtual -> physical translation
From: Jack Steiner <steiner@sgi.com>

Open code the equivalent to follow_page(). This eliminates the
requirement for an EXPORT of follow_page(). In addition, the code
is optimized for the specific case that is needed by the GRU and only
supports architectures supported by the GRU (ia64 & x86_64).

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |   54 +++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 9 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-driver-v3-page-faults-exceptions-gru-virtual-physical-translation drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-driver-v3-page-faults-exceptions-gru-virtual-physical-translation
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -213,20 +213,56 @@ static int non_atomic_pte_lookup(struct 
 	return 0;
 }
 
+/*
+ *
+ * atomic_pte_lookup
+ *
+ * Convert a user virtual address to a physical address
+ * Only supports Intel large pages (2MB only) on x86_64.
+ *	ZZZ - hugepage support is incomplete
+ */
 static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
-			     int write, unsigned long *paddr, int *pageshift)
+	int write, unsigned long *paddr, int *pageshift)
 {
-	struct page *page;
+	pgd_t *pgdp;
+	pmd_t *pmdp;
+	pud_t *pudp;
+	pte_t pte;
+
+	WARN_ON(irqs_disabled());		/* ZZZ debug */
+
+	local_irq_disable();
+	pgdp = pgd_offset(vma->vm_mm, vaddr);
+	if (unlikely(pgd_none(*pgdp)))
+		goto err;
+
+	pudp = pud_offset(pgdp, vaddr);
+	if (unlikely(pud_none(*pudp)))
+		goto err;
+
+	pmdp = pmd_offset(pudp, vaddr);
+	if (unlikely(pmd_none(*pmdp)))
+		goto err;
+#ifdef CONFIG_X86_64
+	if (unlikely(pmd_large(*pmdp)))
+		pte = *(pte_t *) pmdp;
+	else
+#endif
+		pte = *pte_offset_kernel(pmdp, vaddr);
 
-	/* ZZZ Need to handle HUGE pages */
-	if (is_vm_hugetlb_page(vma))
-		return -EFAULT;
-	*pageshift = PAGE_SHIFT;
-	page = follow_page(vma, vaddr, (write ? FOLL_WRITE : 0));
-	if (!page)
+	local_irq_enable();
+
+	if (unlikely(!pte_present(pte) ||
+		     (write && (!pte_write(pte) || !pte_dirty(pte)))))
 		return 1;
-	*paddr = page_to_phys(page);
+
+	*paddr = pte_pfn(pte) << PAGE_SHIFT;
+	*pageshift = is_vm_hugetlb_page(vma) ? HPAGE_SHIFT : PAGE_SHIFT;
 	return 0;
+
+err:
+	local_irq_enable();
+	return 1;
 }
 
 /*
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-hardware-data-structures.patch
gru-driver-v3-gru-instructions-macros.patch
gru-driver-v3-driver-internal-header-files.patch
gru-driver-v3-kernel-services-header-files.patch
gru-driver-v3-driver-initialization-file-vma-ops.patch
gru-driver-v3-page-faults-exceptions.patch
gru-driver-v3-page-faults-exceptions-gru-virtual-physical-translation.patch
gru-driver-v3-kernel-services-provide-by-driver.patch
gru-driver-v3-resource-management.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
gru-driver-v3-proc-interfaces.patch
gru-driver-v3-tlb-flushing-mmuops-callouts.patch
gru-driver-v3-driver-makefile.patch
gru-driver-v3-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v3-driver-misc-makefile-kconfig-changes.patch

