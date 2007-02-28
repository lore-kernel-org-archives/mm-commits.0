From: akpm@linux-foundation.org
Subject: - kvm-use-page_private-set_page_private-apis.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:41 -0800
Message-ID: <200702282354.l1SNsfoY031210@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbXB1Xys (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus.rechberger@amd.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Use page_private()/set_page_private() apis
has been removed from the -mm tree.  Its filename was
     kvm-use-page_private-set_page_private-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Use page_private()/set_page_private() apis
From: Markus Rechberger <markus.rechberger@amd.com>

Besides using an established api, this allows using kvm in older kernels.

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |    2 +-
 drivers/kvm/mmu.c      |   36 ++++++++++++++++++------------------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-use-page_private-set_page_private-apis drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-use-page_private-set_page_private-apis
+++ a/drivers/kvm/kvm.h
@@ -523,7 +523,7 @@ static inline struct kvm_mmu_page *page_
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
 
-	return (struct kvm_mmu_page *)page->private;
+	return (struct kvm_mmu_page *)page_private(page);
 }
 
 static inline u16 read_fs(void)
diff -puN drivers/kvm/kvm_main.c~kvm-use-page_private-set_page_private-apis drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-use-page_private-set_page_private-apis
+++ a/drivers/kvm/kvm_main.c
@@ -670,7 +670,7 @@ raced:
 						     | __GFP_ZERO);
 			if (!new.phys_mem[i])
 				goto out_free;
- 			new.phys_mem[i]->private = 0;
+			set_page_private(new.phys_mem[i],0);
 		}
 	}
 
diff -puN drivers/kvm/mmu.c~kvm-use-page_private-set_page_private-apis drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-use-page_private-set_page_private-apis
+++ a/drivers/kvm/mmu.c
@@ -298,18 +298,18 @@ static void rmap_add(struct kvm_vcpu *vc
 	if (!is_rmap_pte(*spte))
 		return;
 	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
-	if (!page->private) {
+	if (!page_private(page)) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
-		page->private = (unsigned long)spte;
-	} else if (!(page->private & 1)) {
+		set_page_private(page,(unsigned long)spte);
+	} else if (!(page_private(page) & 1)) {
 		rmap_printk("rmap_add: %p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_rmap_desc(vcpu);
-		desc->shadow_ptes[0] = (u64 *)page->private;
+		desc->shadow_ptes[0] = (u64 *)page_private(page);
 		desc->shadow_ptes[1] = spte;
-		page->private = (unsigned long)desc | 1;
+		set_page_private(page,(unsigned long)desc | 1);
 	} else {
 		rmap_printk("rmap_add: %p %llx many->many\n", spte, *spte);
-		desc = (struct kvm_rmap_desc *)(page->private & ~1ul);
+		desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
 		while (desc->shadow_ptes[RMAP_EXT-1] && desc->more)
 			desc = desc->more;
 		if (desc->shadow_ptes[RMAP_EXT-1]) {
@@ -337,12 +337,12 @@ static void rmap_desc_remove_entry(struc
 	if (j != 0)
 		return;
 	if (!prev_desc && !desc->more)
-		page->private = (unsigned long)desc->shadow_ptes[0];
+		set_page_private(page,(unsigned long)desc->shadow_ptes[0]);
 	else
 		if (prev_desc)
 			prev_desc->more = desc->more;
 		else
-			page->private = (unsigned long)desc->more | 1;
+			set_page_private(page,(unsigned long)desc->more | 1);
 	mmu_free_rmap_desc(vcpu, desc);
 }
 
@@ -356,20 +356,20 @@ static void rmap_remove(struct kvm_vcpu 
 	if (!is_rmap_pte(*spte))
 		return;
 	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
-	if (!page->private) {
+	if (!page_private(page)) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
-	} else if (!(page->private & 1)) {
+	} else if (!(page_private(page) & 1)) {
 		rmap_printk("rmap_remove:  %p %llx 1->0\n", spte, *spte);
-		if ((u64 *)page->private != spte) {
+		if ((u64 *)page_private(page) != spte) {
 			printk(KERN_ERR "rmap_remove:  %p %llx 1->BUG\n",
 			       spte, *spte);
 			BUG();
 		}
-		page->private = 0;
+		set_page_private(page,0);
 	} else {
 		rmap_printk("rmap_remove:  %p %llx many->many\n", spte, *spte);
-		desc = (struct kvm_rmap_desc *)(page->private & ~1ul);
+		desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
 			for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; ++i)
@@ -398,11 +398,11 @@ static void rmap_write_protect(struct kv
 	BUG_ON(!slot);
 	page = gfn_to_page(slot, gfn);
 
-	while (page->private) {
-		if (!(page->private & 1))
-			spte = (u64 *)page->private;
+	while (page_private(page)) {
+		if (!(page_private(page) & 1))
+			spte = (u64 *)page_private(page);
 		else {
-			desc = (struct kvm_rmap_desc *)(page->private & ~1ul);
+			desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
 			spte = desc->shadow_ptes[0];
 		}
 		BUG_ON(!spte);
@@ -1218,7 +1218,7 @@ static int alloc_mmu_pages(struct kvm_vc
 		INIT_LIST_HEAD(&page_header->link);
 		if ((page = alloc_page(GFP_KERNEL)) == NULL)
 			goto error_1;
-		page->private = (unsigned long)page_header;
+		set_page_private(page, (unsigned long)page_header);
 		page_header->page_hpa = (hpa_t)page_to_pfn(page) << PAGE_SHIFT;
 		memset(__va(page_header->page_hpa), 0, PAGE_SIZE);
 		list_add(&page_header->link, &vcpu->free_pages);
_

Patches currently in -mm which might be from markus.rechberger@amd.com are

git-kvm.patch
pcmcia-pccard-deadlock-fix.patch
