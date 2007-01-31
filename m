From: akpm@osdl.org
Subject: + kvm-fix-lockup-on-32-bit-intel-hosts-with-nx-disabled-in-the.patch added to -mm tree
Date: Wed, 31 Jan 2007 10:43:28 -0800
Message-ID: <200701311843.l0VIhSJm023377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42522 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933310AbXAaSo0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 13:44:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: fix lockup on 32-bit intel hosts with nx disabled in the bios
has been added to the -mm tree.  Its filename is
     kvm-fix-lockup-on-32-bit-intel-hosts-with-nx-disabled-in-the.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
kvm-fix-lockup-on-32-bit-intel-hosts-with-nx-disabled-in-the.patch
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
