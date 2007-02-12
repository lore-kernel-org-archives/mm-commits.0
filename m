From: akpm@linux-foundation.org
Subject: - kvm-vmx-add-vcpu_clear.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:04 -0800
Message-ID: <200702122249.l1CMn4Mu014078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45600 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030379AbXBLWtI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: VMX: add vcpu_clear()
has been removed from the -mm tree.  Its filename was
     kvm-vmx-add-vcpu_clear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: VMX: add vcpu_clear()
From: Avi Kivity <avi@qumranet.com>

Like the inline code it replaces, this function decaches the vmcs from the cpu
it last executed on.  in addition:

 - vcpu_clear() works if the last cpu is also the cpu we're running on
 - it is faster on larger smps by virtue of using smp_call_function_single()

Includes fix from Ingo Molnar.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/vmx.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-vmx-add-vcpu_clear drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-vmx-add-vcpu_clear
+++ a/drivers/kvm/vmx.c
@@ -125,6 +125,15 @@ static void __vcpu_clear(void *arg)
 		per_cpu(current_vmcs, cpu) = NULL;
 }
 
+static void vcpu_clear(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->cpu != raw_smp_processor_id() && vcpu->cpu != -1)
+		smp_call_function_single(vcpu->cpu, __vcpu_clear, vcpu, 0, 1);
+	else
+		__vcpu_clear(vcpu);
+	vcpu->launched = 0;
+}
+
 static unsigned long vmcs_readl(unsigned long field)
 {
 	unsigned long value;
@@ -202,10 +211,8 @@ static struct kvm_vcpu *vmx_vcpu_load(st
 
 	cpu = get_cpu();
 
-	if (vcpu->cpu != cpu) {
-		smp_call_function(__vcpu_clear, vcpu, 0, 1);
-		vcpu->launched = 0;
-	}
+	if (vcpu->cpu != cpu)
+		vcpu_clear(vcpu);
 
 	if (per_cpu(current_vmcs, cpu) != vcpu->vmcs) {
 		u8 error;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
