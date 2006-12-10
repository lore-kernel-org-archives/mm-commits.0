From: akpm@osdl.org
Subject: - kvm-expose-interrupt-bitmap.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:29 -0800
Message-ID: <200612100753.kBA7rTgL017727@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760466AbWLJHxb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uril@qumranet.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Expose interrupt bitmap
has been removed from the -mm tree.  Its filename was
     kvm-expose-interrupt-bitmap.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Expose interrupt bitmap
From: Uri Lublin <uril@qumranet.com>

Expose all not-yet-delivered interrupts to userspace.  This allows a guest to
be saved and resumed even if some interrupts are yet pending.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    3 ++-
 drivers/kvm/kvm_main.c |   12 +++++++++++-
 include/linux/kvm.h    |   14 ++++++++++----
 3 files changed, 23 insertions(+), 6 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-expose-interrupt-bitmap drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-expose-interrupt-bitmap
+++ a/drivers/kvm/kvm.h
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 
 #include "vmx.h"
+#include <linux/kvm.h>
 
 #define CR0_PE_MASK (1ULL << 0)
 #define CR0_TS_MASK (1ULL << 3)
@@ -164,7 +165,7 @@ struct kvm_vcpu {
 	int   cpu;
 	int   launched;
 	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
-#define NR_IRQ_WORDS (256 / BITS_PER_LONG)
+#define NR_IRQ_WORDS KVM_IRQ_BITMAP_SIZE(unsigned long)
 	unsigned long irq_pending[NR_IRQ_WORDS];
 	unsigned long regs[NR_VCPU_REGS]; /* for rsp: vcpu_load_rsp_rip() */
 	unsigned long rip;      /* needs vcpu_load_rsp_rip() */
diff -puN drivers/kvm/kvm_main.c~kvm-expose-interrupt-bitmap drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-expose-interrupt-bitmap
+++ a/drivers/kvm/kvm_main.c
@@ -3005,7 +3005,8 @@ static int kvm_dev_ioctl_get_sregs(struc
 	sregs->efer = vcpu->shadow_efer;
 	sregs->apic_base = vcpu->apic_base;
 
-	sregs->pending_int = vcpu->irq_summary != 0;
+	memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
+	       sizeof sregs->interrupt_bitmap);
 
 	vcpu_put(vcpu);
 
@@ -3039,6 +3040,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 {
 	struct kvm_vcpu *vcpu;
 	int mmu_reset_needed = 0;
+	int i;
 
 	if (sregs->vcpu < 0 || sregs->vcpu >= KVM_MAX_VCPUS)
 		return -EINVAL;
@@ -3088,6 +3090,14 @@ static int kvm_dev_ioctl_set_sregs(struc
 
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
+
+	memcpy(vcpu->irq_pending, sregs->interrupt_bitmap,
+	       sizeof vcpu->irq_pending);
+	vcpu->irq_summary = 0;
+	for (i = 0; i < NR_IRQ_WORDS; ++i)
+		if (vcpu->irq_pending[i])
+			__set_bit(i, &vcpu->irq_summary);
+
 	vcpu_put(vcpu);
 
 	return 0;
diff -puN include/linux/kvm.h~kvm-expose-interrupt-bitmap include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-expose-interrupt-bitmap
+++ a/include/linux/kvm.h
@@ -11,6 +11,15 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
+/*
+ * Architectural interrupt line count, and the size of the bitmap needed
+ * to hold them.
+ */
+#define KVM_NR_INTERRUPTS 256
+#define KVM_IRQ_BITMAP_SIZE_BYTES    ((KVM_NR_INTERRUPTS + 7) / 8)
+#define KVM_IRQ_BITMAP_SIZE(type)    (KVM_IRQ_BITMAP_SIZE_BYTES / sizeof(type))
+
+
 /* for KVM_CREATE_MEMORY_REGION */
 struct kvm_memory_region {
 	__u32 slot;
@@ -129,10 +138,7 @@ struct kvm_sregs {
 	__u64 cr0, cr2, cr3, cr4, cr8;
 	__u64 efer;
 	__u64 apic_base;
-
-	/* out (KVM_GET_SREGS) */
-	__u32 pending_int;
-	__u32 padding2;
+	__u64 interrupt_bitmap[KVM_IRQ_BITMAP_SIZE(__u64)];
 };
 
 /* for KVM_TRANSLATE */
_

Patches currently in -mm which might be from uril@qumranet.com are

kvm-userspace-interface.patch
kvm-expose-interrupt-bitmap.patch
kvm-add-time-stamp-counter-msr-and-accessors.patch
kvm-expose-msrs-to-userspace.patch
kvm-expose-msrs-to-userspace-v2.patch

