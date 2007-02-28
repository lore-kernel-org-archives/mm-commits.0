From: akpm@linux-foundation.org
Subject: - kvm-use-array_size-macro-instead-of-manual-calculation.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:38 -0800
Message-ID: <200702282354.l1SNscY1031207@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48510 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746AbXB1Xym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, avi@qumranet.com, dor.laor@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Use ARRAY_SIZE macro instead of manual calculation
has been removed from the -mm tree.  Its filename was
     kvm-use-array_size-macro-instead-of-manual-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Use ARRAY_SIZE macro instead of manual calculation
From: Ahmed S. Darwish <darwish.07@gmail.com>

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_svm.h |    3 ++-
 drivers/kvm/svm.c     |    5 +++--
 drivers/kvm/vmx.c     |    3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/kvm_svm.h~kvm-use-array_size-macro-instead-of-manual-calculation drivers/kvm/kvm_svm.h
--- a/drivers/kvm/kvm_svm.h~kvm-use-array_size-macro-instead-of-manual-calculation
+++ a/drivers/kvm/kvm_svm.h
@@ -1,6 +1,7 @@
 #ifndef __KVM_SVM_H
 #define __KVM_SVM_H
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <asm/msr.h>
@@ -18,7 +19,7 @@ static const u32 host_save_msrs[] = {
 	MSR_IA32_LASTBRANCHTOIP, MSR_IA32_LASTINTFROMIP,MSR_IA32_LASTINTTOIP,*/
 };
 
-#define NR_HOST_SAVE_MSRS (sizeof(host_save_msrs) / sizeof(*host_save_msrs))
+#define NR_HOST_SAVE_MSRS ARRAY_SIZE(host_save_msrs)
 #define NUM_DB_REGS 4
 
 struct vcpu_svm {
diff -puN drivers/kvm/svm.c~kvm-use-array_size-macro-instead-of-manual-calculation drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-use-array_size-macro-instead-of-manual-calculation
+++ a/drivers/kvm/svm.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
@@ -75,7 +76,7 @@ struct svm_init_data {
 
 static u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
-#define NUM_MSR_MAPS (sizeof(msrpm_ranges) / sizeof(*msrpm_ranges))
+#define NUM_MSR_MAPS ARRAY_SIZE(msrpm_ranges)
 #define MSRS_RANGE_SIZE 2048
 #define MSRS_IN_RANGE (MSRS_RANGE_SIZE * 8 / 2)
 
@@ -1297,7 +1298,7 @@ static int handle_exit(struct kvm_vcpu *
 		       __FUNCTION__, vcpu->svm->vmcb->control.exit_int_info,
 		       exit_code);
 
-	if (exit_code >= sizeof(svm_exit_handlers) / sizeof(*svm_exit_handlers)
+	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
 	    || svm_exit_handlers[exit_code] == 0) {
 		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 		printk(KERN_ERR "%s: 0x%x @ 0x%llx cr0 0x%lx rflags 0x%llx\n",
diff -puN drivers/kvm/vmx.c~kvm-use-array_size-macro-instead-of-manual-calculation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-use-array_size-macro-instead-of-manual-calculation
+++ a/drivers/kvm/vmx.c
@@ -19,6 +19,7 @@
 #include "vmx.h"
 #include "kvm_vmx.h"
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
@@ -75,7 +76,7 @@ static const u32 vmx_msr_index[] = {
 #endif
 	MSR_EFER, MSR_K6_STAR,
 };
-#define NR_VMX_MSR (sizeof(vmx_msr_index) / sizeof(*vmx_msr_index))
+#define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
 static inline int is_page_fault(u32 intr_info)
 {
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-avr32.patch
git-drm.patch
git-kvm.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
