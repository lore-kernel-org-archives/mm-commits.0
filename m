From: akpm@osdl.org
Subject: - kvm-amd-svm-add-data-structures.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:49 -0800
Message-ID: <200612100755.kBA7tnbU017903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583AbWLJHzv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, yaniv@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: AMD SVM: Add data structures
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-add-data-structures.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: AMD SVM: Add data structures
From: Avi Kivity <avi@qumranet.com>

This adds the AMD specific vcpu structure.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h     |    5 +++-
 drivers/kvm/kvm_svm.h |   42 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm.h~kvm-amd-svm-add-data-structures drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-amd-svm-add-data-structures
+++ a/drivers/kvm/kvm.h
@@ -166,7 +166,10 @@ enum {
 
 struct kvm_vcpu {
 	struct kvm *kvm;
-	struct vmcs *vmcs;
+	union {
+		struct vmcs *vmcs;
+		struct vcpu_svm *svm;
+	};
 	struct mutex mutex;
 	int   cpu;
 	int   launched;
diff -puN /dev/null drivers/kvm/kvm_svm.h
--- /dev/null
+++ a/drivers/kvm/kvm_svm.h
@@ -0,0 +1,42 @@
+#ifndef __KVM_SVM_H
+#define __KVM_SVM_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <asm/msr.h>
+
+#include "svm.h"
+#include "kvm.h"
+
+static const u32 host_save_msrs[] = {
+	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
+	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
+	MSR_IA32_DEBUGCTLMSR, /*MSR_IA32_LASTBRANCHFROMIP,
+	MSR_IA32_LASTBRANCHTOIP, MSR_IA32_LASTINTFROMIP,MSR_IA32_LASTINTTOIP,*/
+	MSR_FS_BASE, MSR_GS_BASE,
+};
+
+#define NR_HOST_SAVE_MSRS (sizeof(host_save_msrs) / sizeof(*host_save_msrs))
+#define NUM_DB_REGS 4
+
+struct vcpu_svm {
+	struct vmcb *vmcb;
+	unsigned long vmcb_pa;
+	struct svm_cpu_data *svm_data;
+	uint64_t asid_generation;
+
+	unsigned long cr0;
+	unsigned long cr4;
+	unsigned long db_regs[NUM_DB_REGS];
+
+	u64 next_rip;
+
+	u64 host_msrs[NR_HOST_SAVE_MSRS];
+	unsigned long host_cr2;
+	unsigned long host_db_regs[NUM_DB_REGS];
+	unsigned long host_dr6;
+	unsigned long host_dr7;
+};
+
+#endif
+
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

