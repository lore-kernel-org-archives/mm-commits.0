From: akpm@osdl.org
Subject: - kvm-memory-slot-management.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:22 -0800
Message-ID: <200612100752.kBA7qMoM017643@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760388AbWLJHwZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, yaniv@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: memory slot management
has been removed from the -mm tree.  Its filename was
     kvm-memory-slot-management.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: kvm: memory slot management
From: Avi Kivity <avi@qumranet.com>

kvm defines memory in "slots", more or less corresponding to the DIMM slots.

this allows us to:
 - avoid the VGA hole at 640K
 - add a pci framebuffer at runtime
 - hotplug memory

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |  227 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 227 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-memory-slot-management drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-memory-slot-management
+++ a/drivers/kvm/kvm_main.c
@@ -1058,6 +1058,211 @@ static void vcpu_put_rsp_rip(struct kvm_
 	vmcs_writel(GUEST_RIP, vcpu->rip);
 }
 
+/*
+ * Allocate some memory and give it an address in the guest physical address
+ * space.
+ *
+ * Discontiguous memory is allowed, mostly for framebuffers.
+ */
+static int kvm_dev_ioctl_set_memory_region(struct kvm *kvm,
+					   struct kvm_memory_region *mem)
+{
+	int r;
+	gfn_t base_gfn;
+	unsigned long npages;
+	unsigned long i;
+	struct kvm_memory_slot *memslot;
+	struct kvm_memory_slot old, new;
+	int memory_config_version;
+
+	r = -EINVAL;
+	/* General sanity checks */
+	if (mem->memory_size & (PAGE_SIZE - 1))
+		goto out;
+	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
+		goto out;
+	if (mem->slot >= KVM_MEMORY_SLOTS)
+		goto out;
+	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
+		goto out;
+
+	memslot = &kvm->memslots[mem->slot];
+	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
+	npages = mem->memory_size >> PAGE_SHIFT;
+
+	if (!npages)
+		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
+
+raced:
+	spin_lock(&kvm->lock);
+
+	memory_config_version = kvm->memory_config_version;
+	new = old = *memslot;
+
+	new.base_gfn = base_gfn;
+	new.npages = npages;
+	new.flags = mem->flags;
+
+	/* Disallow changing a memory slot's size. */
+	r = -EINVAL;
+	if (npages && old.npages && npages != old.npages)
+		goto out_unlock;
+
+	/* Check for overlaps */
+	r = -EEXIST;
+	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
+		struct kvm_memory_slot *s = &kvm->memslots[i];
+
+		if (s == memslot)
+			continue;
+		if (!((base_gfn + npages <= s->base_gfn) ||
+		      (base_gfn >= s->base_gfn + s->npages)))
+			goto out_unlock;
+	}
+	/*
+	 * Do memory allocations outside lock.  memory_config_version will
+	 * detect any races.
+	 */
+	spin_unlock(&kvm->lock);
+
+	/* Deallocate if slot is being removed */
+	if (!npages)
+		new.phys_mem = 0;
+
+	/* Free page dirty bitmap if unneeded */
+	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
+		new.dirty_bitmap = 0;
+
+	r = -ENOMEM;
+
+	/* Allocate if a slot is being created */
+	if (npages && !new.phys_mem) {
+		new.phys_mem = vmalloc(npages * sizeof(struct page *));
+
+		if (!new.phys_mem)
+			goto out_free;
+
+		memset(new.phys_mem, 0, npages * sizeof(struct page *));
+		for (i = 0; i < npages; ++i) {
+			new.phys_mem[i] = alloc_page(GFP_HIGHUSER);
+			if (!new.phys_mem[i])
+				goto out_free;
+		}
+	}
+
+	/* Allocate page dirty bitmap if needed */
+	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
+		unsigned dirty_bytes = ALIGN(npages, BITS_PER_LONG) / 8;
+
+		new.dirty_bitmap = vmalloc(dirty_bytes);
+		if (!new.dirty_bitmap)
+			goto out_free;
+		memset(new.dirty_bitmap, 0, dirty_bytes);
+	}
+
+	spin_lock(&kvm->lock);
+
+	if (memory_config_version != kvm->memory_config_version) {
+		spin_unlock(&kvm->lock);
+		kvm_free_physmem_slot(&new, &old);
+		goto raced;
+	}
+
+	r = -EAGAIN;
+	if (kvm->busy)
+		goto out_unlock;
+
+	if (mem->slot >= kvm->nmemslots)
+		kvm->nmemslots = mem->slot + 1;
+
+	*memslot = new;
+	++kvm->memory_config_version;
+
+	spin_unlock(&kvm->lock);
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		struct kvm_vcpu *vcpu;
+
+		vcpu = vcpu_load(kvm, i);
+		if (!vcpu)
+			continue;
+		kvm_mmu_reset_context(vcpu);
+		vcpu_put(vcpu);
+	}
+
+	kvm_free_physmem_slot(&old, &new);
+	return 0;
+
+out_unlock:
+	spin_unlock(&kvm->lock);
+out_free:
+	kvm_free_physmem_slot(&new, &old);
+out:
+	return r;
+}
+
+/*
+ * Get (and clear) the dirty memory log for a memory slot.
+ */
+static int kvm_dev_ioctl_get_dirty_log(struct kvm *kvm,
+				       struct kvm_dirty_log *log)
+{
+	struct kvm_memory_slot *memslot;
+	int r, i;
+	int n;
+	unsigned long any = 0;
+
+	spin_lock(&kvm->lock);
+
+	/*
+	 * Prevent changes to guest memory configuration even while the lock
+	 * is not taken.
+	 */
+	++kvm->busy;
+	spin_unlock(&kvm->lock);
+	r = -EINVAL;
+	if (log->slot >= KVM_MEMORY_SLOTS)
+		goto out;
+
+	memslot = &kvm->memslots[log->slot];
+	r = -ENOENT;
+	if (!memslot->dirty_bitmap)
+		goto out;
+
+	n = ALIGN(memslot->npages, 8) / 8;
+
+	for (i = 0; !any && i < n; ++i)
+		any = memslot->dirty_bitmap[i];
+
+	r = -EFAULT;
+	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
+		goto out;
+
+
+	if (any) {
+		spin_lock(&kvm->lock);
+		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		spin_unlock(&kvm->lock);
+		memset(memslot->dirty_bitmap, 0, n);
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			struct kvm_vcpu *vcpu = vcpu_load(kvm, i);
+
+			if (!vcpu)
+				continue;
+			flush_guest_tlb(vcpu);
+			vcpu_put(vcpu);
+		}
+	}
+
+	r = 0;
+
+out:
+	spin_lock(&kvm->lock);
+	--kvm->busy;
+	spin_unlock(&kvm->lock);
+	return r;
+}
+
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
@@ -1220,6 +1425,28 @@ static long kvm_dev_ioctl(struct file *f
 	int r = -EINVAL;
 
 	switch (ioctl) {
+	case KVM_SET_MEMORY_REGION: {
+		struct kvm_memory_region kvm_mem;
+
+		r = -EFAULT;
+		if (copy_from_user(&kvm_mem, (void *)arg, sizeof kvm_mem))
+			goto out;
+		r = kvm_dev_ioctl_set_memory_region(kvm, &kvm_mem);
+		if (r)
+			goto out;
+		break;
+	}
+	case KVM_GET_DIRTY_LOG: {
+		struct kvm_dirty_log log;
+
+		r = -EFAULT;
+		if (copy_from_user(&log, (void *)arg, sizeof log))
+			goto out;
+		r = kvm_dev_ioctl_get_dirty_log(kvm, &log);
+		if (r)
+			goto out;
+		break;
+	}
 	default:
 		;
 	}
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-memory-slot-management.patch
kvm-memory-slot-management-zero-guest-memory-before-use.patch
kvm-vcpu-creation-and-maintenance.patch
kvm-vcpu-creation-and-maintenance-segment-access-cleanup.patch
kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to.patch
kvm-vcpu-execution-loop.patch
kvm-define-exit-handlers.patch
kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator.patch
kvm-less-common-exit-handlers.patch
kvm-less-common-exit-handlers-handle-rdmsrmsr_efer.patch
kvm-mmu.patch
kvm-mmu-mmu-honor-global-bit-on-huge-pages.patch
kvm-x86-emulator.patch
kvm-x86-emulator-x86-emulator-handle-smsw.patch
kvm-clarify-licensing.patch
kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch
kvm-plumbing.patch
kvm-dynamically-determine-which-msrs-to-load-and-save.patch
kvm-fix-calculation-of-initial-value-of-rdx-register.patch
kvm-avoid-using-vmx-instruction-directly.patch
kvm-avoid-using-vmx-instruction-directly-fix-asm-constraints.patch
kvm-expose-interrupt-bitmap.patch
kvm-add-time-stamp-counter-msr-and-accessors.patch
kvm-expose-msrs-to-userspace.patch
kvm-expose-msrs-to-userspace-v2.patch
kvm-create-kvm-intelko-module.patch
kvm-make-dev-registration-happen-when-the-arch.patch
kvm-make-hardware-detection-an-arch-operation.patch
kvm-make-the-per-cpu-enable-disable-functions-arch.patch
kvm-make-the-hardware-setup-operations-non-percpu.patch
kvm-make-the-guest-debugger-an-arch-operation.patch
kvm-make-msr-accessors-arch-operations.patch
kvm-make-the-segment-accessors-arch-operations.patch
kvm-cache-guest-cr4-in-vcpu-structure.patch
kvm-cache-guest-cr0-in-vcpu-structure.patch
kvm-add-get_segment_base-arch-accessor.patch
kvm-add-idt-and-gdt-descriptor-accessors.patch
kvm-make-syncing-the-register-file-to-the-vcpu.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-move-the-vmx-exit-handlers-to-vmxc.patch
kvm-make-vcpu_setup-an-arch-operation.patch
kvm-make-__set_cr0-and-dependencies-arch-operations.patch
kvm-make-__set_cr4-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
kvm-make-set_cr3-and-tlb-flushing-arch-operations.patch
kvm-make-inject_page_fault-an-arch-operation.patch
kvm-make-inject_gp-an-arch-operation.patch
kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation.patch
kvm-use-the-general-purpose-register-accessors-rather.patch
kvm-move-the-vmx-tsc-accessors-to-vmxc.patch
kvm-access-rflags-through-an-arch-operation.patch
kvm-move-the-vmx-segment-field-definitions-to-vmxc.patch
kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits.patch
kvm-add-a-set_cr0_no_modeswitch-arch-accessor.patch
kvm-make-vcpu_load-and-vcpu_put-arch-operations.patch
kvm-make-vcpu-creation-and-destruction-arch-operations.patch
kvm-move-vmcs-static-variables-to-vmxc.patch
kvm-make-is_long_mode-an-arch-operation.patch
kvm-use-the-tlb-flush-arch-operation-instead-of-an.patch
kvm-remove-guest_cpl.patch
kvm-move-vmcs-accessors-to-vmxc.patch
kvm-move-vmx-helper-inlines-to-vmxc.patch
kvm-remove-vmx-includes-from-arch-independent-code.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

