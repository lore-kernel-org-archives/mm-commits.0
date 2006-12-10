From: akpm@osdl.org
Subject: - kvm-expose-msrs-to-userspace-v2.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:39 -0800
Message-ID: <200612100753.kBA7rdRs017741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760379AbWLJHxm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, uril@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Expose MSRs to userspace (v2)
has been removed from the -mm tree.  Its filename was
     kvm-expose-msrs-to-userspace-v2.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Expose MSRs to userspace (v2)
From: Avi Kivity <avi@qumranet.com>

Changes from v1:

 - get msrs and set msrs are now symmetric: both accept a list of msrs. it
   is now possible to retrieve a single msr.
 - a new KVM_GET_MSR_INDEX_LIST allows discovering which msrs are supported
   by kvm (previously this was integrated into KVM_GET_MSRS)
 - error handling is simpler and correcter
 - the implementation is collapsed into a single msr_io() function
 - avoid pointers in ioctl structs, instead use zero length arrays

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |  177 +++++++++++++++++----------------------
 include/linux/kvm.h    |   14 +--
 2 files changed, 89 insertions(+), 102 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-expose-msrs-to-userspace-v2 drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-expose-msrs-to-userspace-v2
+++ a/drivers/kvm/kvm_main.c
@@ -129,6 +129,8 @@ static const u32 vmx_msr_index[] = {
 #define MSR_IA32_VMX_EXIT_CTLS_MSR		0x483
 #define MSR_IA32_VMX_ENTRY_CTLS_MSR		0x484
 
+#define MAX_IO_MSRS 256
+
 #define CR0_RESEVED_BITS 0xffffffff1ffaffc0ULL
 #define LMSW_GUEST_MASK 0x0eULL
 #define CR4_RESEVED_BITS (~((1ULL << 11) - 1))
@@ -3151,7 +3153,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
- * and KVM_SET_MSRS.
+ * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
  */
 static u32 msrs_to_save[] = {
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
@@ -3162,110 +3164,91 @@ static u32 msrs_to_save[] = {
 	MSR_IA32_TIME_STAMP_COUNTER,
 };
 
-static int kvm_dev_ioctl_get_msrs(struct kvm *kvm, struct kvm_msrs *msrs)
+
+/*
+ * Adapt set_msr() to msr_io()'s calling convention
+ */
+static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
+{
+	return set_msr(vcpu, index, *data);
+}
+
+/*
+ * Read or write a bunch of msrs. All parameters are kernel addresses.
+ *
+ * @return number of msrs set successfully.
+ */
+static int __msr_io(struct kvm *kvm, struct kvm_msrs *msrs,
+		    struct kvm_msr_entry *entries,
+		    int (*do_msr)(struct kvm_vcpu *vcpu,
+				  unsigned index, u64 *data))
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_msr_entry *entry, *entries;
-	int rc;
-	u32 size, num_entries, i;
+	int i;
 
 	if (msrs->vcpu < 0 || msrs->vcpu >= KVM_MAX_VCPUS)
 		return -EINVAL;
 
-	num_entries = ARRAY_SIZE(msrs_to_save);
-	if (msrs->nmsrs < num_entries) {
-		/* inform actual number of entries */
-		msrs->nmsrs = num_entries;
-		return -EINVAL;
-	}
-
 	vcpu = vcpu_load(kvm, msrs->vcpu);
 	if (!vcpu)
 		return -ENOENT;
 
-	msrs->nmsrs = num_entries; /* update to actual number of entries */
-	size = msrs->nmsrs * sizeof(struct kvm_msr_entry);
-	rc = -E2BIG;
-	if (size > 4096)
-		goto out_vcpu;
-
-	rc = -ENOMEM;
-	entries = vmalloc(size);
-	if (entries == NULL)
-		goto out_vcpu;
-
-	memset(entries, 0, size);
-	rc = -EINVAL;
-	for (i=0; i<num_entries; i++) {
-		entry = &entries[i];
-		entry->index = msrs_to_save[i];
-		if (get_msr(vcpu, entry->index, &entry->data))
-			goto out_free;
-	}
-
-	rc = -EFAULT;
-	if (copy_to_user(msrs->entries, entries, size))
-		goto out_free;
-
-	rc = 0;
-out_free:
-	vfree(entries);
+	for (i = 0; i < msrs->nmsrs; ++i)
+		if (do_msr(vcpu, entries[i].index, &entries[i].data))
+			break;
 
-out_vcpu:
 	vcpu_put(vcpu);
 
-	return rc;
+	return i;
 }
 
-static int kvm_dev_ioctl_set_msrs(struct kvm *kvm, struct kvm_msrs *msrs)
-{
-	struct kvm_vcpu *vcpu;
-	struct kvm_msr_entry *entry, *entries;
-	int rc;
-	u32 size, num_entries, i;
+/*
+ * Read or write a bunch of msrs. Parameters are user addresses.
+ *
+ * @return number of msrs set successfully.
+ */
+static int msr_io(struct kvm *kvm, struct kvm_msrs __user *user_msrs,
+		  int (*do_msr)(struct kvm_vcpu *vcpu,
+				unsigned index, u64 *data),
+		  int writeback)
+{
+	struct kvm_msrs msrs;
+	struct kvm_msr_entry *entries;
+	int r, n;
+	unsigned size;
 
-	if (msrs->vcpu < 0 || msrs->vcpu >= KVM_MAX_VCPUS)
-		return -EINVAL;
+	r = -EFAULT;
+	if (copy_from_user(&msrs, user_msrs, sizeof msrs))
+		goto out;
 
-	num_entries = ARRAY_SIZE(msrs_to_save);
-	if (msrs->nmsrs < num_entries) {
-		msrs->nmsrs = num_entries; /* inform actual size */
-		return -EINVAL;
-	}
+	r = -E2BIG;
+	if (msrs.nmsrs >= MAX_IO_MSRS)
+		goto out;
 
-	vcpu = vcpu_load(kvm, msrs->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	r = -ENOMEM;
+	size = sizeof(struct kvm_msr_entry) * msrs.nmsrs;
+	entries = vmalloc(size);
+	if (!entries)
+		goto out;
 
-	size = msrs->nmsrs * sizeof(struct kvm_msr_entry);
-	rc = -E2BIG;
-	if (size > 4096)
-		goto out_vcpu;
+	r = -EFAULT;
+	if (copy_from_user(entries, user_msrs->entries, size))
+		goto out_free;
 
-	rc = -ENOMEM;
-	entries = vmalloc(size);
-	if (entries == NULL)
-		goto out_vcpu;
+	r = n = __msr_io(kvm, &msrs, entries, do_msr);
+	if (r < 0)
+		goto out_free;
 
-	rc = -EFAULT;
-	if (copy_from_user(entries, msrs->entries, size))
+	r = -EFAULT;
+	if (writeback && copy_to_user(user_msrs->entries, entries, size))
 		goto out_free;
 
-	rc = -EINVAL;
-	for (i=0; i<num_entries; i++) {
-		entry = &entries[i];
-		if (set_msr(vcpu, entry->index,  entry->data))
-			goto out_free;
-	}
+	r = n;
 
-	rc = 0;
 out_free:
 	vfree(entries);
-
-out_vcpu:
-	vcpu_put(vcpu);
-
-	return rc;
+out:
+	return r;
 }
 
 /*
@@ -3509,32 +3492,32 @@ static long kvm_dev_ioctl(struct file *f
 			goto out;
 		break;
 	}
-	case KVM_GET_MSRS: {
-		struct kvm_msrs kvm_msrs;
+	case KVM_GET_MSRS:
+		r = msr_io(kvm, (void __user *)arg, get_msr, 1);
+		break;
+	case KVM_SET_MSRS:
+		r = msr_io(kvm, (void __user *)arg, do_set_msr, 0);
+		break;
+	case KVM_GET_MSR_INDEX_LIST: {
+		struct kvm_msr_list __user *user_msr_list = (void __user *)arg;
+		struct kvm_msr_list msr_list;
+		unsigned n;
 
 		r = -EFAULT;
-		if (copy_from_user(&kvm_msrs, (void *)arg, sizeof kvm_msrs))
+		if (copy_from_user(&msr_list, user_msr_list, sizeof msr_list))
 			goto out;
-		r = kvm_dev_ioctl_get_msrs(kvm, &kvm_msrs);
-		if (r)
+		n = msr_list.nmsrs;
+		msr_list.nmsrs = ARRAY_SIZE(msrs_to_save);
+		if (copy_to_user(user_msr_list, &msr_list, sizeof msr_list))
 			goto out;
-		r = -EFAULT;
-		if (copy_to_user((void *)arg, &kvm_msrs, sizeof kvm_msrs))
+		r = -E2BIG;
+		if (n < ARRAY_SIZE(msrs_to_save))
 			goto out;
-		r = 0;
-		break;
-	}
-	case KVM_SET_MSRS: {
-		struct kvm_msrs kvm_msrs;
-
 		r = -EFAULT;
-		if (copy_from_user(&kvm_msrs, (void *)arg, sizeof kvm_msrs))
-			goto out;
-		r = kvm_dev_ioctl_set_msrs(kvm, &kvm_msrs);
-		if (r)
+		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
+				 sizeof msrs_to_save))
 			goto out;
 		r = 0;
-		break;
 	}
 	default:
 		;
diff -puN include/linux/kvm.h~kvm-expose-msrs-to-userspace-v2 include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-expose-msrs-to-userspace-v2
+++ a/include/linux/kvm.h
@@ -152,10 +152,13 @@ struct kvm_msrs {
 	__u32 vcpu;
 	__u32 nmsrs; /* number of msrs in entries */
 
-	union {
-		struct kvm_msr_entry __user *entries;
-		__u64 padding;
-	};
+	struct kvm_msr_entry entries[0];
+};
+
+/* for KVM_GET_MSR_INDEX_LIST */
+struct kvm_msr_list {
+	__u32 nmsrs; /* number of msrs in entries */
+	__u32 indices[0];
 };
 
 /* for KVM_TRANSLATE */
@@ -218,6 +221,7 @@ struct kvm_dirty_log {
 #define KVM_CREATE_VCPU           _IOW(KVMIO, 11, int /* vcpu_slot */)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 12, struct kvm_dirty_log)
 #define KVM_GET_MSRS              _IOWR(KVMIO, 13, struct kvm_msrs)
-#define KVM_SET_MSRS              _IOW(KVMIO, 14, struct kvm_msrs)
+#define KVM_SET_MSRS              _IOWR(KVMIO, 14, struct kvm_msrs)
+#define KVM_GET_MSR_INDEX_LIST    _IOWR(KVMIO, 15, struct kvm_msr_list)
 
 #endif
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

