From: akpm@linux-foundation.org
Subject: + i386-text-edit-lock-kprobes.patch added to -mm tree
Date: Thu, 05 Jul 2007 12:46:57 -0700
Message-ID: <200707051946.l65Jkvlt015357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758302AbXGETsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 15:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, ak@suse.de, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, prasanna@in.ibm.com


The patch titled
     i386 Text Edit Lock: kprobes
has been added to the -mm tree.  Its filename is
     i386-text-edit-lock-kprobes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
