From: akpm@osdl.org
Subject: - kvm-use-8-bit-reg-for-8-bit-variable.patch removed from -mm tree
Date: Mon, 22 Jan 2007 20:23:24 -0800
Message-ID: <200701230423.l0N4NOxp010839@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49009 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250AbXAWEX1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 23:23:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: use 8 bit reg for 8 bit variable
has been removed from the -mm tree.  Its filename was
     kvm-use-8-bit-reg-for-8-bit-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: use 8 bit reg for 8 bit variable
From: Avi Kivity <avi@qumranet.com>

CC [M]  drivers/kvm/vmx.o
{standard input}: Assembler messages:
{standard input}:3257: Error: bad register name `%sil'

gcc chose a bad register due to a wrong asm constraint.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/vmx.c~kvm-use-8-bit-reg-for-8-bit-variable drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-use-8-bit-reg-for-8-bit-variable
+++ a/drivers/kvm/vmx.c
@@ -1825,7 +1825,7 @@ again:
 #endif
 		"setbe %0 \n\t"
 		"popf \n\t"
-	      : "=r" (fail)
+	      : "=q" (fail)
 	      : "r"(vcpu->launched), "d"((unsigned long)HOST_RSP),
 		"c"(vcpu),
 		[rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-vm-exit-profiling-fix.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
kvm-use-8-bit-reg-for-8-bit-variable.patch
