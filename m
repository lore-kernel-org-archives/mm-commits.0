From: akpm@osdl.org
Subject: + kvm-mmu-implement-simple-reverse-mapping.patch added to -mm tree
Date: Thu, 04 Jan 2007 11:11:30 -0800
Message-ID: <200701041911.l04JBUbq028274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:44905 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817AbXADTLt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 14:11:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: MMU: Implement simple reverse mapping
has been added to the -mm tree.  Its filename is
     kvm-mmu-implement-simple-reverse-mapping.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Implement simple reverse mapping
From: Avi Kivity <avi@qumranet.com>

Keep in each host page frame's page->private a pointer to the shadow pte which
maps it.  If there are multiple shadow ptes mapping the page, set bit 0 of
page->private, and use the rest as a pointer to a linked list of all such
mappings.

Reverse mappings are needed because we when we cache shadow page tables, we
must protect the guest page tables from being modified by the guest, as that
would invalidate the cached ptes.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h         |    1 
 drivers/kvm/kvm_main.c    |    1 
 drivers/kvm/mmu.c         |  152 ++++++++++++++++++++++++++++++++----
 drivers/kvm/paging_tmpl.h |    1 
 4 files changed, 142 insertions(+), 13 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-mmu-implement-simple-reverse-mapping drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-mmu-implement-simple-reverse-mapping
+++ a/drivers/kvm/kvm.h
@@ -236,6 +236,7 @@ struct kvm {
 	struct kvm_vcpu vcpus[KVM_MAX_VCPUS];
 	int memory_config_version;
 	int busy;
+	unsigned long rmap_overflow;
 };
 
 struct kvm_stat {
diff -puN drivers/kvm/kvm_main.c~kvm-mmu-implement-simple-reverse-mapping drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-implement-simple-reverse-mapping
+++ a/drivers/kvm/kvm_main.c
@@ -638,6 +638,7 @@ raced:
 						     | __GFP_ZERO);
 			if (!new.phys_mem[i])
 				goto out_free;
+ 			new.phys_mem[i]->private = 0;
 		}
 	}
 
diff -puN drivers/kvm/mmu.c~kvm-mmu-implement-simple-reverse-mapping drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-implement-simple-reverse-mapping
+++ a/drivers/kvm/mmu.c
@@ -27,6 +27,7 @@
 #include "kvm.h"
 
 #define pgprintk(x...) do { } while (0)
+#define rmap_printk(x...) do { } while (0)
 
 #define ASSERT(x)							\
 	if (!(x)) {							\
@@ -125,6 +126,13 @@
 #define PT_DIRECTORY_LEVEL 2
 #define PT_PAGE_TABLE_LEVEL 1
 
+#define RMAP_EXT 4
+
+struct kvm_rmap_desc {
+	u64 *shadow_ptes[RMAP_EXT];
+	struct kvm_rmap_desc *more;
+};
+
 static int is_write_protection(struct kvm_vcpu *vcpu)
 {
 	return vcpu->cr0 & CR0_WP_MASK;
@@ -150,6 +158,120 @@ static int is_io_pte(unsigned long pte)
 	return pte & PT_SHADOW_IO_MARK;
 }
 
+static int is_rmap_pte(u64 pte)
+{
+	return (pte & (PT_WRITABLE_MASK | PT_PRESENT_MASK))
+		== (PT_WRITABLE_MASK | PT_PRESENT_MASK);
+}
+
+/*
+ * Reverse mapping data structures:
+ *
+ * If page->private bit zero is zero, then page->private points to the
+ * shadow page table entry that points to page_address(page).
+ *
+ * If page->private bit zero is one, (then page->private & ~1) points
+ * to a struct kvm_rmap_desc containing more mappings.
+ */
+static void rmap_add(struct kvm *kvm, u64 *spte)
+{
+	struct page *page;
+	struct kvm_rmap_desc *desc;
+	int i;
+
+	if (!is_rmap_pte(*spte))
+		return;
+	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+	if (!page->private) {
+		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
+		page->private = (unsigned long)spte;
+	} else if (!(page->private & 1)) {
+		rmap_printk("rmap_add: %p %llx 1->many\n", spte, *spte);
+		desc = kzalloc(sizeof *desc, GFP_NOWAIT);
+		if (!desc)
+			BUG(); /* FIXME: return error */
+		desc->shadow_ptes[0] = (u64 *)page->private;
+		desc->shadow_ptes[1] = spte;
+		page->private = (unsigned long)desc | 1;
+	} else {
+		rmap_printk("rmap_add: %p %llx many->many\n", spte, *spte);
+		desc = (struct kvm_rmap_desc *)(page->private & ~1ul);
+		while (desc->shadow_ptes[RMAP_EXT-1] && desc->more)
+			desc = desc->more;
+		if (desc->shadow_ptes[RMAP_EXT-1]) {
+			desc->more = kzalloc(sizeof *desc->more, GFP_NOWAIT);
+			if (!desc->more)
+				BUG(); /* FIXME: return error */
+			desc = desc->more;
+		}
+		for (i = 0; desc->shadow_ptes[i]; ++i)
+			;
+		desc->shadow_ptes[i] = spte;
+	}
+}
+
+static void rmap_desc_remove_entry(struct page *page,
+				   struct kvm_rmap_desc *desc,
+				   int i,
+				   struct kvm_rmap_desc *prev_desc)
+{
+	int j;
+
+	for (j = RMAP_EXT - 1; !desc->shadow_ptes[j] && j > i; --j)
+		;
+	desc->shadow_ptes[i] = desc->shadow_ptes[j];
+	desc->shadow_ptes[j] = 0;
+	if (j != 0)
+		return;
+	if (!prev_desc && !desc->more)
+		page->private = (unsigned long)desc->shadow_ptes[0];
+	else
+		if (prev_desc)
+			prev_desc->more = desc->more;
+		else
+			page->private = (unsigned long)desc->more | 1;
+	kfree(desc);
+}
+
+static void rmap_remove(struct kvm *kvm, u64 *spte)
+{
+	struct page *page;
+	struct kvm_rmap_desc *desc;
+	struct kvm_rmap_desc *prev_desc;
+	int i;
+
+	if (!is_rmap_pte(*spte))
+		return;
+	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+	if (!page->private) {
+		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
+		BUG();
+	} else if (!(page->private & 1)) {
+		rmap_printk("rmap_remove:  %p %llx 1->0\n", spte, *spte);
+		if ((u64 *)page->private != spte) {
+			printk(KERN_ERR "rmap_remove:  %p %llx 1->BUG\n",
+			       spte, *spte);
+			BUG();
+		}
+		page->private = 0;
+	} else {
+		rmap_printk("rmap_remove:  %p %llx many->many\n", spte, *spte);
+		desc = (struct kvm_rmap_desc *)(page->private & ~1ul);
+		prev_desc = NULL;
+		while (desc) {
+			for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; ++i)
+				if (desc->shadow_ptes[i] == spte) {
+					rmap_desc_remove_entry(page, desc, i,
+							       prev_desc);
+					return;
+				}
+			prev_desc = desc;
+			desc = desc->more;
+		}
+		BUG();
+	}
+}
+
 static void kvm_mmu_free_page(struct kvm_vcpu *vcpu, hpa_t page_hpa)
 {
 	struct kvm_mmu_page *page_head = page_header(page_hpa);
@@ -229,27 +351,27 @@ hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, 
 static void release_pt_page_64(struct kvm_vcpu *vcpu, hpa_t page_hpa,
 			       int level)
 {
+	u64 *pos;
+	u64 *end;
+
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(page_hpa));
 	ASSERT(level <= PT64_ROOT_LEVEL && level > 0);
 
-	if (level == 1)
-		memset(__va(page_hpa), 0, PAGE_SIZE);
-	else {
-		u64 *pos;
-		u64 *end;
-
-		for (pos = __va(page_hpa), end = pos + PT64_ENT_PER_PAGE;
-		     pos != end; pos++) {
-			u64 current_ent = *pos;
+	for (pos = __va(page_hpa), end = pos + PT64_ENT_PER_PAGE;
+	     pos != end; pos++) {
+		u64 current_ent = *pos;
 
-			*pos = 0;
-			if (is_present_pte(current_ent))
+		if (is_present_pte(current_ent)) {
+			if (level != 1)
 				release_pt_page_64(vcpu,
 						  current_ent &
 						  PT64_BASE_ADDR_MASK,
 						  level - 1);
+			else
+				rmap_remove(vcpu->kvm, pos);
 		}
+		*pos = 0;
 	}
 	kvm_mmu_free_page(vcpu, page_hpa);
 }
@@ -275,6 +397,7 @@ static int nonpaging_map(struct kvm_vcpu
 			page_header_update_slot(vcpu->kvm, table, v);
 			table[index] = p | PT_PRESENT_MASK | PT_WRITABLE_MASK |
 								PT_USER_MASK;
+			rmap_add(vcpu->kvm, &table[index]);
 			return 0;
 		}
 
@@ -437,6 +560,7 @@ static inline void set_pte_common(struct
 	} else {
 		*shadow_pte |= paddr;
 		page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
+		rmap_add(vcpu->kvm, shadow_pte);
 	}
 }
 
@@ -489,6 +613,7 @@ static void paging_inval_page(struct kvm
 		u64 *table = __va(page_addr);
 
 		if (level == PT_PAGE_TABLE_LEVEL ) {
+			rmap_remove(vcpu->kvm, &table[index]);
 			table[index] = 0;
 			return;
 		}
@@ -679,8 +804,9 @@ void kvm_mmu_slot_remove_write_access(st
 		pt = __va(page->page_hpa);
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
 			/* avoid RMW */
-			if (pt[i] & PT_WRITABLE_MASK)
+			if (pt[i] & PT_WRITABLE_MASK) {
+				rmap_remove(kvm, &pt[i]);
 				pt[i] &= ~PT_WRITABLE_MASK;
-
+			}
 	}
 }
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-implement-simple-reverse-mapping drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-implement-simple-reverse-mapping
+++ a/drivers/kvm/paging_tmpl.h
@@ -261,6 +261,7 @@ static int FNAME(fix_write_pf)(struct kv
 	mark_page_dirty(vcpu->kvm, gfn);
 	*shadow_ent |= PT_WRITABLE_MASK;
 	*guest_ent |= PT_DIRTY_MASK;
+	rmap_add(vcpu->kvm, shadow_ent);
 
 	return 1;
 }
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-fix-gfp_kernel-alloc-in-atomic-section-bug.patch
kvm-use-raw_smp_processor_id-instead-of-smp_processor_id-where-applicable.patch
kvm-recover-after-an-arch-module-load-failure.patch
kvm-improve-interrupt-response.patch
kvm-prevent-stale-bits-in-cr0-and-cr4.patch
kvm-mmu-implement-simple-reverse-mapping.patch
kvm-mmu-teach-the-page-table-walker-to-track-guest-page-table-gfns.patch
kvm-mmu-load-the-pae-pdptrs-on-cr3-change-like-the-processor-does.patch
kvm-mmu-fold-fetch_guest-into-init_walker.patch
kvm-mu-special-treatment-for-shadow-pae-root-pages.patch
kvm-mmu-use-the-guest-pdptrs-instead-of-mapping-cr3-in-pae-mode.patch
kvm-mmu-make-the-shadow-page-tables-also-special-case-pae.patch
kvm-mmu-make-kvm_mmu_alloc_page-return-a-kvm_mmu_page-pointer.patch
kvm-mmu-shadow-page-table-caching.patch
kvm-mmu-write-protect-guest-pages-when-a-shadow-is-created-for-them.patch
kvm-mmu-let-the-walker-extract-the-target-page-gfn-from-the-pte.patch
kvm-mmu-support-emulated-writes-into-ram.patch
kvm-mmu-zap-shadow-page-table-entries-on-writes-to-guest-page-tables.patch
kvm-mmu-if-emulating-an-instruction-fails-try-unprotecting-the-page.patch
kvm-mmu-implement-child-shadow-unlinking.patch
kvm-mmu-kvm_mmu_put_page-only-removes-one-link-to-the-page.patch
kvm-mmu-oom-handling.patch
kvm-mmu-remove-invlpg-interception.patch
kvm-mmu-remove-release_pt_page_64.patch
kvm-mmu-handle-misaligned-accesses-to-write-protected-guest-page-tables.patch
kvm-mmu-ove-is_empty_shadow_page-above-kvm_mmu_free_page.patch
kvm-mmu-ensure-freed-shadow-pages-are-clean.patch
kvm-mmu-if-an-empty-shadow-page-is-not-empty-report-more-info.patch
kvm-mmu-page-table-write-flood-protection.patch
kvm-mmu-never-free-a-shadow-page-actively-serving-as-a-root.patch
kvm-mmu-fix-cmpxchg8b-emulation.patch
kvm-mmu-treat-user-mode-faults-as-a-hint-that-a-page-is-no-longer-a-page-table.patch
kvm-mmu-free-pages-on-kvm-destruction.patch
kvm-mmu-replace-atomic-allocations-by-preallocated-objects.patch
kvm-mmu-detect-oom-conditions-and-propagate-error-to-userspace.patch
kvm-mmu-flush-guest-tlb-when-reducing-permissions-on-a-pte.patch
kvm-mmu-destroy-mmu-while-we-still-have-a-vcpu-left.patch
kvm-mmu-add-audit-code-to-check-mappings-etc-are-correct.patch
