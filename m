From: akpm@linux-foundation.org
Subject: - i386-text-edit-lock-kprobes.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:26:14 -0700
Message-ID: <200707070030.l670UPTw029694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbXGGAas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@suse.de, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     i386 Text Edit Lock: kprobes
has been removed from the -mm tree.  Its filename was
     i386-text-edit-lock-kprobes.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: i386 Text Edit Lock: kprobes
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Kprobes can use the text edit lock to insure mutual exclusion when edition the
code and make sure the pages are writable.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <prasanna@in.ibm.com>
Cc: <ananth@in.ibm.com>
Cc: <anil.s.keshavamurthy@intel.com>
Cc: <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/kprobes.c |   30 ++++--------------------------
 1 files changed, 4 insertions(+), 26 deletions(-)

diff -puN arch/i386/kernel/kprobes.c~i386-text-edit-lock-kprobes arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c~i386-text-edit-lock-kprobes
+++ a/arch/i386/kernel/kprobes.c
@@ -169,42 +169,20 @@ int __kprobes arch_prepare_kprobe(struct
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	unsigned long addr = (unsigned long) p->addr;
-	int page_readonly = 0;
-
-	if (kernel_readonly_text(addr)) {
-		page_readonly = 1;
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
-		global_flush_tlb();
-	}
-
+	kernel_text_lock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	*p->addr = BREAKPOINT_INSTRUCTION;
+	kernel_text_unlock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
-
-	if (page_readonly) {
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
-		global_flush_tlb();
-	}
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	unsigned long addr = (unsigned long) p->addr;
-	int page_readonly = 0;
-
-	if (kernel_readonly_text(addr)) {
-		page_readonly = 1;
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
-		global_flush_tlb();
-	}
+	kernel_text_lock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	*p->addr = p->opcode;
+	kernel_text_unlock((unsigned long)p->addr, sizeof(kprobe_opcode_t));
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
-	if (page_readonly) {
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
-		global_flush_tlb();
-	}
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
i386-text-edit-lock-kprobes.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
