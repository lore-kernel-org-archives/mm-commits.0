From: akpm@linux-foundation.org
Subject: + make-kvm-conform-to-sucky-rdmsr-interface.patch added to -mm tree
Date: Wed, 21 Mar 2007 22:22:56 -0800
Message-ID: <200703220622.l2M6MucA013866@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41051 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbXCVGXD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 02:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, avi@qumranet.com


The patch titled
     make KVM conform to sucky rdmsr interface
has been added to the -mm tree.  Its filename is
     make-kvm-conform-to-sucky-rdmsr-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make KVM conform to sucky rdmsr interface
From: Rusty Russell <rusty@rustcorp.com.au>

Grrr.... Andi refused to take my "rdmsr64" patch which moved to a
function-like interface for MSRs, dismissing it as pointless churn.

paravirt_ops cleanups changed a macro to an inline and spotted this
kvm bug.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/vmx.c~make-kvm-conform-to-sucky-rdmsr-interface drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~make-kvm-conform-to-sucky-rdmsr-interface
+++ a/drivers/kvm/vmx.c
@@ -1127,7 +1127,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 		u64 data;
 		int j = vcpu->nmsrs;
 
-		if (rdmsr_safe(index, &data_low, &data_high) < 0)
+		if (rdmsr_safe(index, data_low, data_high) < 0)
 			continue;
 		if (wrmsr_safe(index, data_low, data_high) < 0)
 			continue;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-the-host-code-lgko-pin-stack-page-optimization.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
cleanup-rationalize-paravirt-wrappers.patch
make-kvm-conform-to-sucky-rdmsr-interface.patch
lguest-clean-up-some-lreferences-inittext-warnings.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
use-x86_eflags_if-in-irqflagsh-lguest.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
