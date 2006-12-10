From: akpm@osdl.org
Subject: - kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:55 -0800
Message-ID: <200612100755.kBA7tt7w017912@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760585AbWLJHz5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: AMD SVM: Avoid three more new instructions
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: AMD SVM: Avoid three more new instructions
From: Avi Kivity <avi@qumranet.com>

The clgi, stgi, and invlpga instructions are all too new to unleash on
the world's assemblers.  Replace them with the opcode sequences.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    6 +++---
 drivers/kvm/svm.h |    3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/kvm/svm.c~kvm-amd-svm-implementation-avoid-three-more-new-instructions drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-amd-svm-implementation-avoid-three-more-new-instructions
+++ a/drivers/kvm/svm.c
@@ -102,17 +102,17 @@ static inline void push_irq(struct kvm_v
 
 static inline void clgi(void)
 {
-	asm volatile ("clgi");
+	asm volatile (SVM_CLGI);
 }
 
 static inline void stgi(void)
 {
-	asm volatile ("stgi");
+	asm volatile (SVM_STGI);
 }
 
 static inline void invlpga(unsigned long addr, u32 asid)
 {
-	asm volatile ("invlpga" :: "a"(addr), "c"(asid));
+	asm volatile (SVM_INVLPGA :: "a"(addr), "c"(asid));
 }
 
 static inline unsigned long read_cr2(void)
diff -puN drivers/kvm/svm.h~kvm-amd-svm-implementation-avoid-three-more-new-instructions drivers/kvm/svm.h
--- a/drivers/kvm/svm.h~kvm-amd-svm-implementation-avoid-three-more-new-instructions
+++ a/drivers/kvm/svm.h
@@ -307,6 +307,9 @@ struct __attribute__ ((__packed__)) vmcb
 #define SVM_VMLOAD ".byte 0x0f, 0x01, 0xda"
 #define SVM_VMRUN  ".byte 0x0f, 0x01, 0xd8"
 #define SVM_VMSAVE ".byte 0x0f, 0x01, 0xdb"
+#define SVM_CLGI   ".byte 0x0f, 0x01, 0xdd"
+#define SVM_STGI   ".byte 0x0f, 0x01, 0xdc"
+#define SVM_INVLPGA ".byte 0x0f, 0x01, 0xdf"
 
 #endif
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

