From: akpm@osdl.org
Subject: - kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:13 -0800
Message-ID: <200612100752.kBA7qDWV017634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59523 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760386AbWLJHwW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yaniv@qumranet.com, avi@qumranet.com, simon.kagstrom@bth.se, mm-commits@vger.kernel.org


The patch titled
     KVM: Fix segment state changes across processor mode switches
has been removed from the -mm tree.  Its filename was
     kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Fix segment state changes across processor mode switches
From: Yaniv Kamay <yaniv@qumranet.com>

A problem with Intel VT is that it performs very strict segment checks on
entry to vm86 mode.  These checks are much stricter than what the cpu
actually allows for real mode, which is a problem since we use vm86 mode to
virtualize real mode.

The problem scenario is something like:

- switch to real mode
  - here kvm mangles the segments to something that VT will like
- do something uninteresting
- switch to protected mode
- touch mangled segments
- blow up at unexpected values

Fix is as follows:

- switch to real mode
  - mangle segments, but save original values somethere
- do something uninteresting
- switch to protected mode
  - if segment selectors have not been changed, restore from saved values
- touch restored segments
- live happily ever after

Reported by: Simon Kagstrom <simon.kagstrom@bth.se>

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    3 ++-
 drivers/kvm/kvm_main.c |   30 +++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches
+++ a/drivers/kvm/kvm.h
@@ -191,10 +191,11 @@ struct kvm_vcpu {
 		int active;
 		u8 save_iopl;
 		struct {
+			u16 selector;
 			unsigned long base;
 			u32 limit;
 			u32 ar;
-		} tr;
+		} tr, es, ds, fs, gs;
 	} rmode;
 };
 
diff -puN drivers/kvm/kvm_main.c~kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches
+++ a/drivers/kvm/kvm_main.c
@@ -704,18 +704,27 @@ static void enter_pmode(struct kvm_vcpu 
 	update_exception_bitmap(vcpu);
 
 	#define FIX_PMODE_DATASEG(seg, save) {				\
-			vmcs_write16(GUEST_##seg##_SELECTOR, 0); 	\
-			vmcs_writel(GUEST_##seg##_BASE, 0); 		\
-			vmcs_write32(GUEST_##seg##_LIMIT, 0xffff);	\
-			vmcs_write32(GUEST_##seg##_AR_BYTES, 0x93);	\
+		if (vmcs_readl(GUEST_##seg##_BASE) == save.base) { \
+			vmcs_write16(GUEST_##seg##_SELECTOR, save.selector); \
+			vmcs_writel(GUEST_##seg##_BASE, save.base); \
+			vmcs_write32(GUEST_##seg##_LIMIT, save.limit); \
+			vmcs_write32(GUEST_##seg##_AR_BYTES, save.ar); \
+		} else { \
+			u32 dpl = (vmcs_read16(GUEST_##seg##_SELECTOR) & \
+				   SELECTOR_RPL_MASK) << AR_DPL_SHIFT; \
+			vmcs_write32(GUEST_##seg##_AR_BYTES, 0x93 | dpl); \
+		} \
 	}
 
-	FIX_PMODE_DATASEG(SS, vcpu->rmode.ss);
 	FIX_PMODE_DATASEG(ES, vcpu->rmode.es);
 	FIX_PMODE_DATASEG(DS, vcpu->rmode.ds);
 	FIX_PMODE_DATASEG(GS, vcpu->rmode.gs);
 	FIX_PMODE_DATASEG(FS, vcpu->rmode.fs);
 
+
+	vmcs_write16(GUEST_SS_SELECTOR, 0);
+	vmcs_write32(GUEST_SS_AR_BYTES, 0x93);
+
 	vmcs_write16(GUEST_CS_SELECTOR,
 		     vmcs_read16(GUEST_CS_SELECTOR) & ~SELECTOR_RPL_MASK);
 	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
@@ -751,19 +760,26 @@ static void enter_rmode(struct kvm_vcpu 
 	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | CR4_VME_MASK);
 	update_exception_bitmap(vcpu);
 
-	#define FIX_RMODE_SEG(seg, save) {				   \
+	#define FIX_RMODE_SEG(seg, save) { \
+		save.selector = vmcs_read16(GUEST_##seg##_SELECTOR); \
+		save.base = vmcs_readl(GUEST_##seg##_BASE); \
+		save.limit = vmcs_read32(GUEST_##seg##_LIMIT); \
+		save.ar = vmcs_read32(GUEST_##seg##_AR_BYTES); \
 		vmcs_write16(GUEST_##seg##_SELECTOR, 			   \
 					vmcs_readl(GUEST_##seg##_BASE) >> 4); \
 		vmcs_write32(GUEST_##seg##_LIMIT, 0xffff);		   \
 		vmcs_write32(GUEST_##seg##_AR_BYTES, 0xf3);		   \
 	}
 
+	vmcs_write16(GUEST_SS_SELECTOR, vmcs_readl(GUEST_SS_BASE) >> 4);
+	vmcs_write32(GUEST_SS_LIMIT, 0xffff);
+	vmcs_write32(GUEST_SS_AR_BYTES, 0xf3);
+
 	vmcs_write32(GUEST_CS_AR_BYTES, 0xf3);
 	vmcs_write16(GUEST_CS_SELECTOR, vmcs_readl(GUEST_CS_BASE) >> 4);
 
 	FIX_RMODE_SEG(ES, vcpu->rmode.es);
 	FIX_RMODE_SEG(DS, vcpu->rmode.ds);
-	FIX_RMODE_SEG(SS, vcpu->rmode.ss);
 	FIX_RMODE_SEG(GS, vcpu->rmode.gs);
 	FIX_RMODE_SEG(FS, vcpu->rmode.fs);
 }
_

Patches currently in -mm which might be from yaniv@qumranet.com are

kvm-userspace-interface.patch
kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches.patch
kvm-virtualization-infrastructure-fix-mmu-reset-locking-when-setting-cr0.patch
kvm-memory-slot-management.patch
kvm-vcpu-creation-and-maintenance.patch
kvm-vcpu-execution-loop.patch
kvm-define-exit-handlers.patch
kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator.patch
kvm-less-common-exit-handlers.patch
kvm-less-common-exit-handlers-handle-rdmsrmsr_efer.patch
kvm-mmu.patch
kvm-x86-emulator.patch
kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch

