From: akpm@osdl.org
Subject: + kvm-fix-asm-constraints-with-config_frame_pointer=n.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:07:47 -0800
Message-ID: <200701112107.l0BL7ltN003064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbXAKVIo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:08:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: fix asm constraints with CONFIG_FRAME_POINTER=n
has been added to the -mm tree.  Its filename is
     kvm-fix-asm-constraints-with-config_frame_pointer=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: fix asm constraints with CONFIG_FRAME_POINTER=n
From: Avi Kivity <avi@qumranet.com>

A "g" constraint may place a local variable in an %rsp-relative memory operand.
but if your assembly changes %rsp, the operand points to the wrong location.

An "r" constraint fixes that.

Thanks to Ingo Molnar for neatly bisecting the problem.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/vmx.c~kvm-fix-asm-constraints-with-config_frame_pointer=n drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-fix-asm-constraints-with-config_frame_pointer=n
+++ a/drivers/kvm/vmx.c
@@ -1825,7 +1825,7 @@ again:
 #endif
 		"setbe %0 \n\t"
 		"popf \n\t"
-	      : "=g" (fail)
+	      : "=r" (fail)
 	      : "r"(vcpu->launched), "d"((unsigned long)HOST_RSP),
 		"c"(vcpu),
 		[rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-vm-exit-profiling.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-asm-constraints-with-config_frame_pointer=n.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
