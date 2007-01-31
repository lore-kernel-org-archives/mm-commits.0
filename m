From: akpm@osdl.org
Subject: + kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:36:51 -0800
Message-ID: <200701310036.l0V0aplH002569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58806 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbXAaAg7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     kvm: Fix mismatch between 32-bit and 64-bit abi
has been added to the -mm tree.  Its filename is
     kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: Fix mismatch between 32-bit and 64-bit abi
From: Avi Kivity <avi@qumranet.com>

Unfortunately requiring a version bump.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/kvm.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/kvm.h~kvm-fix-mismatch-between-32-bit-and-64-bit-abi include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-fix-mismatch-between-32-bit-and-64-bit-abi
+++ a/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 2
+#define KVM_API_VERSION 3
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -187,6 +187,7 @@ struct kvm_translation {
 	__u8  valid;
 	__u8  writeable;
 	__u8  usermode;
+	__u8  pad[5];
 };
 
 /* for KVM_INTERRUPT */
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
kvm-optimize-inline-assembly.patch
kvm-fix-asm-constraint-for-lldt-instruction.patch
kvm-fix-gva_to_gpa.patch
kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch
kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch
kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch
kvm-two-way-apic-tpr-synchronization.patch
kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch
kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch
kvm-fix-vcpu-freeing-bug.patch
