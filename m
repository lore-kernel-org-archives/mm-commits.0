From: akpm@osdl.org
Subject: - kvm-improve-reporting-of-vmwrite-errors.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:11 -0800
Message-ID: <200701070800.l0780B2v013165@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40994 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483AbXAGIAP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Improve reporting of vmwrite errors
has been removed from the -mm tree.  Its filename was
     kvm-improve-reporting-of-vmwrite-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Improve reporting of vmwrite errors
From: Avi Kivity <avi@qumranet.com>

This will allow us to see the root cause when a vmwrite error happens.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-improve-reporting-of-vmwrite-errors drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-improve-reporting-of-vmwrite-errors
+++ a/drivers/kvm/vmx.c
@@ -152,15 +152,21 @@ static u64 vmcs_read64(unsigned long fie
 #endif
 }
 
+static noinline void vmwrite_error(unsigned long field, unsigned long value)
+{
+	printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
+	       field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
+	dump_stack();
+}
+
 static void vmcs_writel(unsigned long field, unsigned long value)
 {
 	u8 error;
 
 	asm volatile (ASM_VMX_VMWRITE_RAX_RDX "; setna %0"
 		       : "=q"(error) : "a"(value), "d"(field) : "cc" );
-	if (error)
-		printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
-		       field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
+	if (unlikely(error))
+		vmwrite_error(field, value);
 }
 
 static void vmcs_write16(unsigned long field, u16 value)
_

Patches currently in -mm which might be from avi@qumranet.com are
