From: akpm@osdl.org
Subject: - kvm-fix-null-and-c99-init-sparse-warnings.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:56:07 -0800
Message-ID: <200612100756.kBA7u7BY017926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760594AbWLJH4O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:56:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: fix NULL and C99 init sparse warnings
has been removed from the -mm tree.  Its filename was
     kvm-fix-null-and-c99-init-sparse-warnings.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: fix NULL and C99 init sparse warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse NULL and C99 struct init warnings in kvm:

drivers/kvm/vmx.c:62:2: warning: obsolete array initializer, use C99 syntax
drivers/kvm/vmx.c:63:2: warning: obsolete array initializer, use C99 syntax
drivers/kvm/vmx.c:64:2: warning: obsolete array initializer, use C99 syntax
drivers/kvm/vmx.c:65:2: warning: obsolete array initializer, use C99 syntax
drivers/kvm/vmx.c:66:2: warning: obsolete array initializer, use C99 syntax
drivers/kvm/vmx.c:67:2: warning: obsolete array initializer, use C99 syntax
drivers/kvm/vmx.c:68:2: warning: obsolete array initializer, use C99 syntax
drivers/kvm/vmx.c:69:2: warning: obsolete array initializer, use C99 syntax
drivers/kvm/vmx.c:116:32: warning: Using plain integer as NULL pointer
drivers/kvm/vmx.c:559:10: warning: Using plain integer as NULL pointer
drivers/kvm/kvm.h:385:57: warning: Using plain integer as NULL pointer
drivers/kvm/kvm.h:385:57: warning: Using plain integer as NULL pointer
drivers/kvm/kvm.h:385:57: warning: Using plain integer as NULL pointer
drivers/kvm/vmx.c:1293:33: warning: Using plain integer as NULL pointer
drivers/kvm/vmx.c:1917:16: warning: Using plain integer as NULL pointer
drivers/kvm/mmu.c:321:34: warning: Using plain integer as NULL pointer
drivers/kvm/mmu.c:387:47: warning: Using plain integer as NULL pointer
drivers/kvm/mmu.c:548:47: warning: Using plain integer as NULL pointer
drivers/kvm/mmu.c:566:47: warning: Using plain integer as NULL pointer
drivers/kvm/x86_emulate.c:686:20: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h         |    2 +-
 drivers/kvm/mmu.c         |    8 ++++----
 drivers/kvm/vmx.c         |   18 +++++++++---------
 drivers/kvm/x86_emulate.c |    2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-fix-null-and-c99-init-sparse-warnings drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-fix-null-and-c99-init-sparse-warnings
+++ a/drivers/kvm/kvm.h
@@ -400,7 +400,7 @@ unsigned long segment_base(u16 selector)
 static inline struct page *_gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
-	return (slot) ? slot->phys_mem[gfn - slot->base_gfn] : 0;
+	return (slot) ? slot->phys_mem[gfn - slot->base_gfn] : NULL;
 }
 
 static inline int is_pae(struct kvm_vcpu *vcpu)
diff -puN drivers/kvm/mmu.c~kvm-fix-null-and-c99-init-sparse-warnings drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-fix-null-and-c99-init-sparse-warnings
+++ a/drivers/kvm/mmu.c
@@ -318,7 +318,7 @@ static void nonpaging_flush(struct kvm_v
 	pgprintk("nonpaging_flush\n");
 	ASSERT(VALID_PAGE(root));
 	release_pt_page_64(vcpu, root, vcpu->mmu.shadow_root_level);
-	root = kvm_mmu_alloc_page(vcpu, 0);
+	root = kvm_mmu_alloc_page(vcpu, NULL);
 	ASSERT(VALID_PAGE(root));
 	vcpu->mmu.root_hpa = root;
 	if (is_paging(vcpu))
@@ -385,7 +385,7 @@ static int nonpaging_init_context(struct
 	context->free = nonpaging_free;
 	context->root_level = PT32E_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
-	context->root_hpa = kvm_mmu_alloc_page(vcpu, 0);
+	context->root_hpa = kvm_mmu_alloc_page(vcpu, NULL);
 	ASSERT(VALID_PAGE(context->root_hpa));
 	kvm_arch_ops->set_cr3(vcpu, context->root_hpa);
 	return 0;
@@ -547,7 +547,7 @@ static int paging64_init_context(struct 
 	context->free = paging_free;
 	context->root_level = PT64_ROOT_LEVEL;
 	context->shadow_root_level = PT64_ROOT_LEVEL;
-	context->root_hpa = kvm_mmu_alloc_page(vcpu, 0);
+	context->root_hpa = kvm_mmu_alloc_page(vcpu, NULL);
 	ASSERT(VALID_PAGE(context->root_hpa));
 	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
 		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
@@ -565,7 +565,7 @@ static int paging32_init_context(struct 
 	context->free = paging_free;
 	context->root_level = PT32_ROOT_LEVEL;
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
-	context->root_hpa = kvm_mmu_alloc_page(vcpu, 0);
+	context->root_hpa = kvm_mmu_alloc_page(vcpu, NULL);
 	ASSERT(VALID_PAGE(context->root_hpa));
 	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
 		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
diff -puN drivers/kvm/vmx.c~kvm-fix-null-and-c99-init-sparse-warnings drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-fix-null-and-c99-init-sparse-warnings
+++ a/drivers/kvm/vmx.c
@@ -46,11 +46,11 @@ static struct vmcs_descriptor {
 } vmcs_descriptor;
 
 #define VMX_SEGMENT_FIELD(seg)					\
-	[VCPU_SREG_##seg] {                                     \
-		GUEST_##seg##_SELECTOR,				\
-		GUEST_##seg##_BASE,			   	\
-		GUEST_##seg##_LIMIT,			   	\
-		GUEST_##seg##_AR_BYTES,			   	\
+	[VCPU_SREG_##seg] = {                                   \
+		.selector = GUEST_##seg##_SELECTOR,		\
+		.base = GUEST_##seg##_BASE,		   	\
+		.limit = GUEST_##seg##_LIMIT,		   	\
+		.ar_bytes = GUEST_##seg##_AR_BYTES,	   	\
 	}
 
 static struct kvm_vmx_segment_field {
@@ -113,7 +113,7 @@ static void __vcpu_clear(void *arg)
 	if (vcpu->cpu == cpu)
 		vmcs_clear(vcpu->vmcs);
 	if (per_cpu(current_vmcs, cpu) == vcpu->vmcs)
-		per_cpu(current_vmcs, cpu) = 0;
+		per_cpu(current_vmcs, cpu) = NULL;
 }
 
 static unsigned long vmcs_readl(unsigned long field)
@@ -556,7 +556,7 @@ static struct vmcs *alloc_vmcs_cpu(int c
 
 	pages = alloc_pages_node(node, GFP_KERNEL, vmcs_descriptor.order);
 	if (!pages)
-		return 0;
+		return NULL;
 	vmcs = page_address(pages);
 	memset(vmcs, 0, vmcs_descriptor.size);
 	vmcs->revision_id = vmcs_descriptor.revision_id; /* vmcs revision id */
@@ -1290,7 +1290,7 @@ static int handle_rmode_exception(struct
 		return 0;
 
 	if (vec == GP_VECTOR && err_code == 0)
-		if (emulate_instruction(vcpu, 0, 0, 0) == EMULATE_DONE)
+		if (emulate_instruction(vcpu, NULL, 0, 0) == EMULATE_DONE)
 			return 1;
 	return 0;
 }
@@ -1914,7 +1914,7 @@ static void vmx_free_vmcs(struct kvm_vcp
 	if (vcpu->vmcs) {
 		on_each_cpu(__vcpu_clear, vcpu, 0, 1);
 		free_vmcs(vcpu->vmcs);
-		vcpu->vmcs = 0;
+		vcpu->vmcs = NULL;
 	}
 }
 
diff -puN drivers/kvm/x86_emulate.c~kvm-fix-null-and-c99-init-sparse-warnings drivers/kvm/x86_emulate.c
--- a/drivers/kvm/x86_emulate.c~kvm-fix-null-and-c99-init-sparse-warnings
+++ a/drivers/kvm/x86_emulate.c
@@ -698,7 +698,7 @@ done_prefixes:
 		if (mode == X86EMUL_MODE_PROT64 &&
 		    override_base != &ctxt->fs_base &&
 		    override_base != &ctxt->gs_base)
-			override_base = 0;
+			override_base = NULL;
 
 		if (override_base)
 			modrm_ea += *override_base;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
ucb1400_ts-depends-snd_ac97_bus.patch
ipc-procfs-sysctl-mixups.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
git-net.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
codingstyle-updates.patch
freezerh-uses-task_struct-fields.patch
geode-crypto-is-pci-device.patch
ipmi-remove-zero-inits.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-userspace-interface.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

