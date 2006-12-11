From: akpm@osdl.org
Subject: + kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:20:32 -0800
Message-ID: <200612112020.kBBKKWgc006089@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937644AbWLKUU4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:20:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: MMU: Ignore pcd, pwt, and pat bits on ptes
has been added to the -mm tree.  Its filename is
     kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: MMU: Ignore pcd, pwt, and pat bits on ptes
From: Avi Kivity <avi@qumranet.com>

The pcd, pwt, and pat bits on page table entries affect the cpu cache.  Since
the cache is a host resource, the guest should not be able to control it. 
Moreover, the meaning of these bits changes depending on whether pat is
enabled or not.

So, force these bits to zero on shadow page table entries at all times.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c         |   17 ++---------------
 drivers/kvm/paging_tmpl.h |   20 +++++++-------------
 2 files changed, 9 insertions(+), 28 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes
+++ a/drivers/kvm/mmu.c
@@ -61,22 +61,9 @@
 
 
 #define PT32_PTE_COPY_MASK \
-	(PT_PRESENT_MASK | PT_PWT_MASK | PT_PCD_MASK | \
-	PT_ACCESSED_MASK | PT_DIRTY_MASK | PT_PAT_MASK | \
-	PT_GLOBAL_MASK )
-
-#define PT32_NON_PTE_COPY_MASK \
-	(PT_PRESENT_MASK | PT_PWT_MASK | PT_PCD_MASK | \
-	PT_ACCESSED_MASK | PT_DIRTY_MASK)
-
-
-#define PT64_PTE_COPY_MASK \
-	(PT64_NX_MASK | PT32_PTE_COPY_MASK)
-
-#define PT64_NON_PTE_COPY_MASK \
-	(PT64_NX_MASK | PT32_NON_PTE_COPY_MASK)
-
+	(PT_PRESENT_MASK | PT_ACCESSED_MASK | PT_DIRTY_MASK | PT_GLOBAL_MASK)
 
+#define PT64_PTE_COPY_MASK (PT64_NX_MASK | PT32_PTE_COPY_MASK)
 
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
diff -puN drivers/kvm/paging_tmpl.h~kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes
+++ a/drivers/kvm/paging_tmpl.h
@@ -32,7 +32,6 @@
 	#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_MASK(level) PT64_LEVEL_MASK(level)
 	#define PT_PTE_COPY_MASK PT64_PTE_COPY_MASK
-	#define PT_NON_PTE_COPY_MASK PT64_NON_PTE_COPY_MASK
 #elif PTTYPE == 32
 	#define pt_element_t u32
 	#define guest_walker guest_walker32
@@ -43,7 +42,6 @@
 	#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 	#define PT_LEVEL_MASK(level) PT32_LEVEL_MASK(level)
 	#define PT_PTE_COPY_MASK PT32_PTE_COPY_MASK
-	#define PT_NON_PTE_COPY_MASK PT32_NON_PTE_COPY_MASK
 #else
 	#error Invalid PTTYPE value
 #endif
@@ -105,9 +103,7 @@ static void FNAME(set_pde)(struct kvm_vc
 	if (PTTYPE == 32 && is_cpuid_PSE36())
 		gaddr |= (guest_pde & PT32_DIR_PSE36_MASK) <<
 			(32 - PT32_DIR_PSE36_SHIFT);
-	*shadow_pte = (guest_pde & (PT_NON_PTE_COPY_MASK | PT_GLOBAL_MASK)) |
-		          ((guest_pde & PT_DIR_PAT_MASK) >>
-			            (PT_DIR_PAT_SHIFT - PT_PAT_SHIFT));
+	*shadow_pte = guest_pde & PT_PTE_COPY_MASK;
 	set_pte_common(vcpu, shadow_pte, gaddr,
 		       guest_pde & PT_DIRTY_MASK, access_bits);
 }
@@ -162,6 +158,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 		u32 index = SHADOW_PT_INDEX(addr, level);
 		u64 *shadow_ent = ((u64 *)__va(shadow_addr)) + index;
 		pt_element_t *guest_ent;
+		u64 shadow_pte;
 
 		if (is_present_pte(*shadow_ent) || is_io_pte(*shadow_ent)) {
 			if (level == PT_PAGE_TABLE_LEVEL)
@@ -204,14 +201,11 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 		shadow_addr = kvm_mmu_alloc_page(vcpu, shadow_ent);
 		if (!VALID_PAGE(shadow_addr))
 			return ERR_PTR(-ENOMEM);
-		if (!kvm_arch_ops->is_long_mode(vcpu) && level == 3)
-			*shadow_ent = shadow_addr |
-				(*guest_ent & (PT_PRESENT_MASK | PT_PWT_MASK | PT_PCD_MASK));
-		else {
-			*shadow_ent = shadow_addr |
-				(*guest_ent & PT_NON_PTE_COPY_MASK);
-			*shadow_ent |= (PT_WRITABLE_MASK | PT_USER_MASK);
-		}
+		shadow_pte = shadow_addr | PT_PRESENT_MASK;
+		if (vcpu->mmu.root_level > 3 || level != 3)
+			shadow_pte |= PT_ACCESSED_MASK
+				| PT_WRITABLE_MASK | PT_USER_MASK;
+		*shadow_ent = shadow_pte;
 		prev_shadow_ent = shadow_ent;
 	}
 }
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-add-missing-include.patch
kvm-put-kvm-in-a-new-virtualization-menu.patch
kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch
kvm-replace-__x86_64__-with-config_x86_64.patch
kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch
kvm-move-find_vmx_entry-to-vmxc.patch
kvm-remove-extranous-put_cpu-from-vcpu_put.patch
kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes.patch
kvm-add-maintainers-entry.patch

