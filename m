From: akpm@osdl.org
Subject: - kvm-add-time-stamp-counter-msr-and-accessors.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:32 -0800
Message-ID: <200612100753.kBA7rWiJ017733@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760472AbWLJHxe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uril@qumranet.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Add time stamp counter msr and accessors
has been removed from the -mm tree.  Its filename was
     kvm-add-time-stamp-counter-msr-and-accessors.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Add time stamp counter msr and accessors
From: Uri Lublin <uril@qumranet.com>

Add a couple of accessors for the time stamp counter, and expose the tsc msr.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   40 ++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-add-time-stamp-counter-msr-and-accessors drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-time-stamp-counter-msr-and-accessors
+++ a/drivers/kvm/kvm_main.c
@@ -121,6 +121,7 @@ static const u32 vmx_msr_index[] = {
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
+#define MSR_IA32_TIME_STAMP_COUNTER		0x010
 #define MSR_IA32_FEATURE_CONTROL 		0x03a
 #define MSR_IA32_VMX_BASIC_MSR   		0x480
 #define MSR_IA32_VMX_PINBASED_CTLS_MSR		0x481
@@ -716,6 +717,31 @@ static void inject_gp(struct kvm_vcpu *v
 		     INTR_INFO_VALID_MASK);
 }
 
+/*
+ * reads and returns guest's timestamp counter "register"
+ * guest_tsc = host_tsc + tsc_offset    -- 21.3
+ */
+static u64 guest_read_tsc(void)
+{
+	u64 host_tsc, tsc_offset;
+
+	rdtscll(host_tsc);
+	tsc_offset = vmcs_read64(TSC_OFFSET);
+	return host_tsc + tsc_offset;
+}
+
+/*
+ * writes 'guest_tsc' into guest's timestamp counter "register"
+ * guest_tsc = host_tsc + tsc_offset ==> tsc_offset = guest_tsc - host_tsc
+ */
+static void guest_write_tsc(u64 guest_tsc)
+{
+	u64 host_tsc;
+
+	rdtscll(host_tsc);
+	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
+}
+
 static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->rmode.active)
@@ -1179,7 +1205,6 @@ static int kvm_vcpu_setup(struct kvm_vcp
 	struct descriptor_table dt;
 	int i;
 	int ret;
-	u64 tsc;
 	int nr_good_msrs;
 
 
@@ -1249,8 +1274,7 @@ static int kvm_vcpu_setup(struct kvm_vcp
 	vmcs_write64(IO_BITMAP_A, 0);
 	vmcs_write64(IO_BITMAP_B, 0);
 
-	rdtscll(tsc);
-	vmcs_write64(TSC_OFFSET, -tsc);
+	guest_write_tsc(0);
 
 	vmcs_write64(VMCS_LINK_POINTER, -1ull); /* 22.3.1.5 */
 
@@ -2302,6 +2326,9 @@ static int handle_rdmsr(struct kvm_vcpu 
 		data = vcpu->shadow_efer;
 		break;
 #endif
+	case MSR_IA32_TIME_STAMP_COUNTER:
+		data = guest_read_tsc();
+		break;
 	case MSR_IA32_SYSENTER_CS:
 		data = vmcs_read32(GUEST_SYSENTER_CS);
 		break;
@@ -2379,8 +2406,6 @@ static void set_efer(struct kvm_vcpu *vc
 
 #endif
 
-#define MSR_IA32_TIME_STAMP_COUNTER 0x10
-
 static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
@@ -2424,10 +2449,7 @@ static int handle_wrmsr(struct kvm_vcpu 
 		break;
 #endif
 	case MSR_IA32_TIME_STAMP_COUNTER: {
-		u64 tsc;
-
-		rdtscll(tsc);
-		vmcs_write64(TSC_OFFSET, data - tsc);
+		guest_write_tsc(data);
 		break;
 	}
 	case MSR_IA32_UCODE_REV:
_

Patches currently in -mm which might be from uril@qumranet.com are

kvm-userspace-interface.patch
kvm-add-time-stamp-counter-msr-and-accessors.patch
kvm-expose-msrs-to-userspace.patch
kvm-expose-msrs-to-userspace-v2.patch

