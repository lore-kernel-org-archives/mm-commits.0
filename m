From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Sat, 04 Apr 2020 16:41:22 -0700
Message-ID: <20200404234122.GNkDKF9zy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgDDXlY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 4 Apr 2020 19:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   41 ++++++++++++++++++++++++++++++++++++--
 mm/memory.c             |   11 ++++++----
 2 files changed, 46 insertions(+), 6 deletions(-)

--- a/include/linux/huge_mm.h~linux-next-rejects
+++ a/include/linux/huge_mm.h
@@ -47,8 +47,45 @@ extern bool move_huge_pmd(struct vm_area
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot,
 			unsigned long cp_flags);
-vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
-vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
+vm_fault_t vmf_insert_pfn_pmd_prot(struct vm_fault *vmf, pfn_t pfn,
+				   pgprot_t pgprot, bool write);
+
+/**
+ * vmf_insert_pfn_pmd - insert a pmd size pfn
+ * @vmf: Structure describing the fault
+ * @pfn: pfn to insert
+ * @pgprot: page protection to use
+ * @write: whether it's a write fault
+ *
+ * Insert a pmd size pfn. See vmf_insert_pfn() for additional info.
+ *
+ * Return: vm_fault_t value.
+ */
+static inline vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn,
+					    bool write)
+{
+	return vmf_insert_pfn_pmd_prot(vmf, pfn, vmf->vma->vm_page_prot, write);
+}
+vm_fault_t vmf_insert_pfn_pud_prot(struct vm_fault *vmf, pfn_t pfn,
+				   pgprot_t pgprot, bool write);
+
+/**
+ * vmf_insert_pfn_pud - insert a pud size pfn
+ * @vmf: Structure describing the fault
+ * @pfn: pfn to insert
+ * @pgprot: page protection to use
+ * @write: whether it's a write fault
+ *
+ * Insert a pud size pfn. See vmf_insert_pfn() for additional info.
+ *
+ * Return: vm_fault_t value.
+ */
+static inline vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn,
+					    bool write)
+{
+	return vmf_insert_pfn_pud_prot(vmf, pfn, vmf->vma->vm_page_prot, write);
+}
+
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
--- a/mm/memory.c~linux-next-rejects
+++ a/mm/memory.c
@@ -3974,11 +3974,14 @@ static inline vm_fault_t wp_huge_pmd(str
 			return handle_userfault(vmf, VM_UFFD_WP);
 		return do_huge_pmd_wp_page(vmf, orig_pmd);
 	}
-	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+	if (vmf->vma->vm_ops->huge_fault) {
+		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 
-	/* COW handled on pte level: split pmd */
-	VM_BUG_ON_VMA(vmf->vma->vm_flags & VM_SHARED, vmf->vma);
+		if (!(ret & VM_FAULT_FALLBACK))
+			return ret;
+	}
+
+	/* COW or write-notify handled on pte level: split pmd. */
 	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
 
 	return VM_FAULT_FALLBACK;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-checkpatch-fixes.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
