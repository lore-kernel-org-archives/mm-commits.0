From: akpm@linux-foundation.org
Subject: - kvm-fix-lockup-on-32-bit-intel-hosts-with-nx-disabled-in-the.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:37:50 -0800
Message-ID: <200702022137.l12LboUG018541@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946112AbXBBVhx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:37:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: fix lockup on 32-bit intel hosts with nx disabled in the bios
has been removed from the -mm tree.  Its filename was
     kvm-fix-lockup-on-32-bit-intel-hosts-with-nx-disabled-in-the.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: fix lockup on 32-bit intel hosts with nx disabled in the bios
From: Avi Kivity <avi@qumranet.com>

Intel hosts, without long mode, and with nx support disabled in the bios
have an efer that is readable but not writable.  This causes a lockup on
switch to guest mode (even though it should exit with reason 34 according
to the documentation).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/kvm/vmx.c~kvm-fix-lockup-on-32-bit-intel-hosts-with-nx-disabled-in-the drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-fix-lockup-on-32-bit-intel-hosts-with-nx-disabled-in-the
+++ a/drivers/kvm/vmx.c
@@ -1116,6 +1116,8 @@ static int vmx_vcpu_setup(struct kvm_vcp
 
 		if (rdmsr_safe(index, &data_low, &data_high) < 0)
 			continue;
+		if (wrmsr_safe(index, data_low, data_high) < 0)
+			continue;
 		data = data_low | ((u64)data_high << 32);
 		vcpu->host_msrs[j].index = index;
 		vcpu->host_msrs[j].reserved = 0;
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
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
kvm-vmx-add-vcpu_clear.patch
kvm-cpu-hotplug-support.patch
kvm-host-suspend-resume-support.patch
