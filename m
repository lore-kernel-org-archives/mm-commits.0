From: akpm@osdl.org
Subject: - kvm-expose-msrs-to-userspace.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:35 -0800
Message-ID: <200612100753.kBA7rZhM017736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760481AbWLJHxo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uril@qumranet.com, arnd@arndb.de, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Expose MSRs to userspace
has been removed from the -mm tree.  Its filename was
     kvm-expose-msrs-to-userspace.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Expose MSRs to userspace
From: Uri Lublin <uril@qumranet.com>

Expose the model-specific registers to userspace.  Primarily useful for
save/resume.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    6 
 drivers/kvm/kvm_main.c |  240 +++++++++++++++++++++++++++++++++------
 include/linux/kvm.h    |   19 +++
 3 files changed, 225 insertions(+), 40 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-expose-msrs-to-userspace drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-expose-msrs-to-userspace
+++ a/drivers/kvm/kvm.h
@@ -106,11 +106,7 @@ struct vmcs {
 	char data[0];
 };
 
-struct vmx_msr_entry {
-	u32 index;
-	u32 reserved;
-	u64 data;
-};
+#define vmx_msr_entry kvm_msr_entry
 
 struct kvm_vcpu;
 
diff -puN drivers/kvm/kvm_main.c~kvm-expose-msrs-to-userspace drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-expose-msrs-to-userspace
+++ a/drivers/kvm/kvm_main.c
@@ -2300,21 +2300,22 @@ static int handle_cpuid(struct kvm_vcpu 
 	return 0;
 }
 
-static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+/*
+ * Reads an msr value (of 'msr_index') into 'pdata'.
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+static int get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
-	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
-	struct vmx_msr_entry *msr = find_msr_entry(vcpu, ecx);
 	u64 data;
+	struct vmx_msr_entry *msr;
 
-#ifdef KVM_DEBUG
-	if (guest_cpl() != 0) {
-		vcpu_printf(vcpu, "%s: not supervisor\n", __FUNCTION__);
-		inject_gp(vcpu);
-		return 1;
+	if (!pdata) {
+		printk(KERN_ERR "BUG: get_msr called with NULL pdata\n");
+		return -EINVAL;
 	}
-#endif
 
-	switch (ecx) {
+	switch (msr_index) {
 #ifdef __x86_64__
 	case MSR_FS_BASE:
 		data = vmcs_readl(GUEST_FS_BASE);
@@ -2356,11 +2357,25 @@ static int handle_rdmsr(struct kvm_vcpu 
 		data = vcpu->apic_base;
 		break;
 	default:
-		if (msr) {
-			data = msr->data;
-			break;
+		msr = find_msr_entry(vcpu, msr_index);
+		if (!msr) {
+			printk(KERN_ERR "kvm: unhandled rdmsr: %x\n", msr_index);
+			return 1;
 		}
-		printk(KERN_ERR "kvm: unhandled rdmsr: %x\n", ecx);
+		data = msr->data;
+		break;
+	}
+
+	*pdata = data;
+	return 0;
+}
+
+static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
+	u64 data;
+
+	if (get_msr(vcpu, ecx, &data)) {
 		inject_gp(vcpu);
 		return 1;
 	}
@@ -2406,22 +2421,16 @@ static void set_efer(struct kvm_vcpu *vc
 
 #endif
 
-static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+
+/*
+ * Writes msr value into into the appropriate "register".
+ * Returns 0 on success, non-0 otherwise.
+ * Assumes vcpu_load() was already called.
+ */
+static int set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
-	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
 	struct vmx_msr_entry *msr;
-	u64 data = (vcpu->regs[VCPU_REGS_RAX] & -1u)
-		| ((u64)(vcpu->regs[VCPU_REGS_RDX] & -1u) << 32);
-
-#ifdef KVM_DEBUG
-	if (guest_cpl() != 0) {
-		vcpu_printf(vcpu, "%s: not supervisor\n", __FUNCTION__);
-		inject_gp(vcpu);
-		return 1;
-	}
-#endif
-
-	switch (ecx) {
+	switch (msr_index) {
 #ifdef __x86_64__
 	case MSR_FS_BASE:
 		vmcs_writel(GUEST_FS_BASE, data);
@@ -2442,7 +2451,7 @@ static int handle_wrmsr(struct kvm_vcpu 
 #ifdef __x86_64
 	case MSR_EFER:
 		set_efer(vcpu, data);
-		return 1;
+		break;
 	case MSR_IA32_MC0_STATUS:
 		printk(KERN_WARNING "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n"
 			    , __FUNCTION__, data);
@@ -2460,16 +2469,31 @@ static int handle_wrmsr(struct kvm_vcpu 
 		vcpu->apic_base = data;
 		break;
 	default:
-		msr = find_msr_entry(vcpu, ecx);
-		if (msr) {
-			msr->data = data;
-			break;
+		msr = find_msr_entry(vcpu, msr_index);
+		if (!msr) {
+			printk(KERN_ERR "kvm: unhandled wrmsr: 0x%x\n", msr_index);
+			return 1;
 		}
-		printk(KERN_ERR "kvm: unhandled wrmsr: %x\n", ecx);
+		msr->data = data;
+		break;
+	}
+
+	return 0;
+}
+
+static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
+	u64 data = (vcpu->regs[VCPU_REGS_RAX] & -1u)
+		| ((u64)(vcpu->regs[VCPU_REGS_RDX] & -1u) << 32);
+
+	if (set_msr(vcpu, ecx, data) != 0) {
 		inject_gp(vcpu);
 		return 1;
 	}
-	skip_emulated_instruction(vcpu);
+
+	if (ecx != MSR_EFER)
+		skip_emulated_instruction(vcpu);
 	return 1;
 }
 
@@ -3126,6 +3150,125 @@ static int kvm_dev_ioctl_set_sregs(struc
 }
 
 /*
+ * List of msr numbers which we expose to userspace through KVM_GET_MSRS
+ * and KVM_SET_MSRS.
+ */
+static u32 msrs_to_save[] = {
+	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
+	MSR_K6_STAR,
+#ifdef __x86_64__
+	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
+#endif
+	MSR_IA32_TIME_STAMP_COUNTER,
+};
+
+static int kvm_dev_ioctl_get_msrs(struct kvm *kvm, struct kvm_msrs *msrs)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_msr_entry *entry, *entries;
+	int rc;
+	u32 size, num_entries, i;
+
+	if (msrs->vcpu < 0 || msrs->vcpu >= KVM_MAX_VCPUS)
+		return -EINVAL;
+
+	num_entries = ARRAY_SIZE(msrs_to_save);
+	if (msrs->nmsrs < num_entries) {
+		/* inform actual number of entries */
+		msrs->nmsrs = num_entries;
+		return -EINVAL;
+	}
+
+	vcpu = vcpu_load(kvm, msrs->vcpu);
+	if (!vcpu)
+		return -ENOENT;
+
+	msrs->nmsrs = num_entries; /* update to actual number of entries */
+	size = msrs->nmsrs * sizeof(struct kvm_msr_entry);
+	rc = -E2BIG;
+	if (size > 4096)
+		goto out_vcpu;
+
+	rc = -ENOMEM;
+	entries = vmalloc(size);
+	if (entries == NULL)
+		goto out_vcpu;
+
+	memset(entries, 0, size);
+	rc = -EINVAL;
+	for (i=0; i<num_entries; i++) {
+		entry = &entries[i];
+		entry->index = msrs_to_save[i];
+		if (get_msr(vcpu, entry->index, &entry->data))
+			goto out_free;
+	}
+
+	rc = -EFAULT;
+	if (copy_to_user(msrs->entries, entries, size))
+		goto out_free;
+
+	rc = 0;
+out_free:
+	vfree(entries);
+
+out_vcpu:
+	vcpu_put(vcpu);
+
+	return rc;
+}
+
+static int kvm_dev_ioctl_set_msrs(struct kvm *kvm, struct kvm_msrs *msrs)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_msr_entry *entry, *entries;
+	int rc;
+	u32 size, num_entries, i;
+
+	if (msrs->vcpu < 0 || msrs->vcpu >= KVM_MAX_VCPUS)
+		return -EINVAL;
+
+	num_entries = ARRAY_SIZE(msrs_to_save);
+	if (msrs->nmsrs < num_entries) {
+		msrs->nmsrs = num_entries; /* inform actual size */
+		return -EINVAL;
+	}
+
+	vcpu = vcpu_load(kvm, msrs->vcpu);
+	if (!vcpu)
+		return -ENOENT;
+
+	size = msrs->nmsrs * sizeof(struct kvm_msr_entry);
+	rc = -E2BIG;
+	if (size > 4096)
+		goto out_vcpu;
+
+	rc = -ENOMEM;
+	entries = vmalloc(size);
+	if (entries == NULL)
+		goto out_vcpu;
+
+	rc = -EFAULT;
+	if (copy_from_user(entries, msrs->entries, size))
+		goto out_free;
+
+	rc = -EINVAL;
+	for (i=0; i<num_entries; i++) {
+		entry = &entries[i];
+		if (set_msr(vcpu, entry->index,  entry->data))
+			goto out_free;
+	}
+
+	rc = 0;
+out_free:
+	vfree(entries);
+
+out_vcpu:
+	vcpu_put(vcpu);
+
+	return rc;
+}
+
+/*
  * Translate a guest virtual address to a guest physical address.
  */
 static int kvm_dev_ioctl_translate(struct kvm *kvm, struct kvm_translation *tr)
@@ -3366,6 +3509,33 @@ static long kvm_dev_ioctl(struct file *f
 			goto out;
 		break;
 	}
+	case KVM_GET_MSRS: {
+		struct kvm_msrs kvm_msrs;
+
+		r = -EFAULT;
+		if (copy_from_user(&kvm_msrs, (void *)arg, sizeof kvm_msrs))
+			goto out;
+		r = kvm_dev_ioctl_get_msrs(kvm, &kvm_msrs);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user((void *)arg, &kvm_msrs, sizeof kvm_msrs))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_MSRS: {
+		struct kvm_msrs kvm_msrs;
+
+		r = -EFAULT;
+		if (copy_from_user(&kvm_msrs, (void *)arg, sizeof kvm_msrs))
+			goto out;
+		r = kvm_dev_ioctl_set_msrs(kvm, &kvm_msrs);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		;
 	}
diff -puN include/linux/kvm.h~kvm-expose-msrs-to-userspace include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-expose-msrs-to-userspace
+++ a/include/linux/kvm.h
@@ -141,6 +141,23 @@ struct kvm_sregs {
 	__u64 interrupt_bitmap[KVM_IRQ_BITMAP_SIZE(__u64)];
 };
 
+struct kvm_msr_entry {
+	__u32 index;
+	__u32 reserved;
+	__u64 data;
+};
+
+/* for KVM_GET_MSRS and KVM_SET_MSRS */
+struct kvm_msrs {
+	__u32 vcpu;
+	__u32 nmsrs; /* number of msrs in entries */
+
+	union {
+		struct kvm_msr_entry __user *entries;
+		__u64 padding;
+	};
+};
+
 /* for KVM_TRANSLATE */
 struct kvm_translation {
 	/* in */
@@ -200,5 +217,7 @@ struct kvm_dirty_log {
 #define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 10, struct kvm_memory_region)
 #define KVM_CREATE_VCPU           _IOW(KVMIO, 11, int /* vcpu_slot */)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 12, struct kvm_dirty_log)
+#define KVM_GET_MSRS              _IOWR(KVMIO, 13, struct kvm_msrs)
+#define KVM_SET_MSRS              _IOW(KVMIO, 14, struct kvm_msrs)
 
 #endif
_

Patches currently in -mm which might be from uril@qumranet.com are

kvm-userspace-interface.patch
kvm-expose-msrs-to-userspace.patch
kvm-expose-msrs-to-userspace-v2.patch

