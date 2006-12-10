From: akpm@osdl.org
Subject: + kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:14:30 -0800
Message-ID: <200612101914.kBAJEU43000466@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762506AbWLJTOd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:14:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Clean up AMD SVM debug registers load and unload
has been added to the -mm tree.  Its filename is
     kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Clean up AMD SVM debug registers load and unload
From: Avi Kivity <avi@qumranet.com>

By letting gcc choose the temporary register for us, we lose arch dependency
and some ugliness.  Conceivably gcc will also generate marginally better code.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |   51 ++++++--------------------------------------
 1 file changed, 8 insertions(+), 43 deletions(-)

diff -puN drivers/kvm/svm.c~kvm-clean-up-amd-svm-debug-registers-load-and-unload drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-clean-up-amd-svm-debug-registers-load-and-unload
+++ a/drivers/kvm/svm.c
@@ -1345,53 +1345,18 @@ static void kvm_reput_irq(struct kvm_vcp
 
 static void save_db_regs(unsigned long *db_regs)
 {
-#ifdef __x86_64__
-	asm ("mov %%dr0, %%rax \n\t"
-	     "mov %%rax, %[dr0] \n\t"
-	     "mov %%dr1, %%rax \n\t"
-	     "mov %%rax, %[dr1] \n\t"
-	     "mov %%dr2, %%rax \n\t"
-	     "mov %%rax, %[dr2] \n\t"
-	     "mov %%dr3, %%rax \n\t"
-	     "mov %%rax, %[dr3] \n\t"
-	     : [dr0] "=m"(db_regs[0]),
-	       [dr1] "=m"(db_regs[1]),
-	       [dr2] "=m"(db_regs[2]),
-	       [dr3] "=m"(db_regs[3])
-	     : : "rax");
-#else
-	asm ("mov %%dr0, %%eax \n\t"
-	     "mov %%eax, %[dr0] \n\t"
-	     "mov %%dr1, %%eax \n\t"
-	     "mov %%eax, %[dr1] \n\t"
-	     "mov %%dr2, %%eax \n\t"
-	     "mov %%eax, %[dr2] \n\t"
-	     "mov %%dr3, %%eax \n\t"
-	     "mov %%eax, %[dr3] \n\t"
-	     : [dr0] "=m"(db_regs[0]),
-	       [dr1] "=m"(db_regs[1]),
-	       [dr2] "=m"(db_regs[2]),
-	       [dr3] "=m"(db_regs[3])
-	     : : "eax");
-#endif
+	asm volatile ("mov %%dr0, %0" : "=r"(db_regs[0]));
+	asm volatile ("mov %%dr1, %0" : "=r"(db_regs[1]));
+	asm volatile ("mov %%dr2, %0" : "=r"(db_regs[2]));
+	asm volatile ("mov %%dr3, %0" : "=r"(db_regs[3]));
 }
 
 static void load_db_regs(unsigned long *db_regs)
 {
-	asm volatile ("mov %[dr0], %%dr0 \n\t"
-	     "mov %[dr1], %%dr1 \n\t"
-	     "mov %[dr2], %%dr2 \n\t"
-	     "mov %[dr3], %%dr3 \n\t"
-	     :
-	     : [dr0] "r"(db_regs[0]),
-	       [dr1] "r"(db_regs[1]),
-	       [dr2] "r"(db_regs[2]),
-	       [dr3] "r"(db_regs[3])
-#ifdef __x86_64__
-	     : "rax");
-#else
-	     : "eax");
-#endif
+	asm volatile ("mov %0, %%dr0" : : "r"(db_regs[0]));
+	asm volatile ("mov %0, %%dr1" : : "r"(db_regs[1]));
+	asm volatile ("mov %0, %%dr2" : : "r"(db_regs[2]));
+	asm volatile ("mov %0, %%dr3" : : "r"(db_regs[3]));
 }
 
 static int svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-add-missing-include.patch
kvm-put-kvm-in-a-new-virtualization-menu.patch
kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch
kvm-replace-__x86_64__-with-config_x86_64.patch

