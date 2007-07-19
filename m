From: akpm@linux-foundation.org
Subject: - kprobes-x86_64-fix-for-mark-ro-data.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:35:53 -0700
Message-ID: <200707191935.l6JJZrvA018366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S939542AbXGSTgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prasanna@in.ibm.com, ak@suse.de, jkenisto@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kprobes: x86_64 fix for mark ro data
has been removed from the -mm tree.  Its filename was
     kprobes-x86_64-fix-for-mark-ro-data.patch

This patch was dropped because Andi's x86_64-mm-text-patch.patch broek it

------------------------------------------------------
Subject: Kprobes: x86_64 fix for mark ro data
From: "S. P. Prasanna" <prasanna@in.ibm.com>

Fix the problem of page protection introduced by CONFIG_DEBUG_RODATA for
x86_64 architecture.  As per Andi Kleen's suggestion, the kernel text pages
are marked writeable only for a short duration to insert or remove the
breakpoints.

Signed-off-by: Prasanna S P<prasanna@in.ibm.com>
Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/kprobes.c |   26 ++++++++++++++++++++++++++
 arch/x86_64/mm/init.c        |    6 +++++-
 include/asm-x86_64/kprobes.h |   10 ++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/kprobes.c~kprobes-x86_64-fix-for-mark-ro-data arch/x86_64/kernel/kprobes.c
--- a/arch/x86_64/kernel/kprobes.c~kprobes-x86_64-fix-for-mark-ro-data
+++ a/arch/x86_64/kernel/kprobes.c
@@ -209,16 +209,42 @@ static void __kprobes arch_copy_kprobe(s
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
+	unsigned long addr = (unsigned long)p->addr;
+	int page_readonly = 0;
+
+	if (kernel_readonly_text(addr)) {
+		change_page_attr_addr(addr, 1, PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+		page_readonly = 1;
+	}
 	*p->addr = BREAKPOINT_INSTRUCTION;
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	if (page_readonly) {
+		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
+		global_flush_tlb();
+	}
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
+	unsigned long addr = (unsigned long)p->addr;
+	int page_readonly = 0;
+
+	if (kernel_readonly_text(addr)) {
+		change_page_attr_addr(addr, 1, PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+		page_readonly = 1;
+	}
+
 	*p->addr = p->opcode;
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+
+	if (page_readonly) {
+		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
+		global_flush_tlb();
+	}
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff -puN arch/x86_64/mm/init.c~kprobes-x86_64-fix-for-mark-ro-data arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~kprobes-x86_64-fix-for-mark-ro-data
+++ a/arch/x86_64/mm/init.c
@@ -48,6 +48,7 @@
 #define Dprintk(x...)
 #endif
 
+int kernel_text_is_ro;
 const struct dma_mapping_ops* dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
@@ -600,10 +601,13 @@ void mark_rodata_ro(void)
 {
 	unsigned long start = (unsigned long)_stext, end;
 
+	kernel_text_is_ro = 1;
 #ifdef CONFIG_HOTPLUG_CPU
 	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() > 1)
+	if (num_possible_cpus() > 1) {
 		start = (unsigned long)_etext;
+		kernel_text_is_ro = 0;
+	}
 #endif
 
 #ifdef CONFIG_KPROBES
diff -puN include/asm-x86_64/kprobes.h~kprobes-x86_64-fix-for-mark-ro-data include/asm-x86_64/kprobes.h
--- a/include/asm-x86_64/kprobes.h~kprobes-x86_64-fix-for-mark-ro-data
+++ a/include/asm-x86_64/kprobes.h
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
+#include <asm-generic/sections.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
 
@@ -87,4 +88,13 @@ extern int kprobe_handler(struct pt_regs
 
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
+extern int kernel_text_is_ro;
+static inline int kernel_readonly_text(unsigned long address)
+{
+	if (kernel_text_is_ro && ((address >= (unsigned long)_stext)
+					&& (address < (unsigned long) _etext)))
+		return 1;
+
+	return 0;
+}
 #endif				/* _ASM_KPROBES_H */
_

Patches currently in -mm which might be from prasanna@in.ibm.com are

origin.patch
kprobes-i386-fix-for-mark-ro-data.patch
