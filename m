From: akpm@linux-foundation.org
Subject: - kprobes-i386-fix-for-mark-ro-data.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:37:17 -0700
Message-ID: <200707191937.l6JJbHtE018442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965778AbXGSThh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:37:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prasanna@in.ibm.com, ak@suse.de, jkenisto@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kprobes: i386 fix for mark ro data
has been removed from the -mm tree.  Its filename was
     kprobes-i386-fix-for-mark-ro-data.patch

This patch was dropped because Andi's x86_64-mm-text-patch.patch broke it

------------------------------------------------------
Subject: Kprobes: i386 fix for mark ro data
From: "S. P. Prasanna" <prasanna@in.ibm.com>

Fix the problem of page protection introduced by CONFIG_DEBUG_RODATA. 
CONFIG_DEBUG_RODATA marks the text pages as read-only, hence kprobes is
unable to insert breakpoints in the kernel text.  This patch overrides the
page protection when adding or removing a probe for the i386 architecture.

Signed-off-by: Prasanna S P<prasanna@in.ibm.com>
Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/kprobes.c |   26 ++++++++++++++++++++++++++
 arch/i386/mm/init.c        |    2 ++
 include/asm-i386/kprobes.h |   12 ++++++++++++
 include/asm-i386/pgtable.h |    2 ++
 4 files changed, 42 insertions(+)

diff -puN arch/i386/kernel/kprobes.c~kprobes-i386-fix-for-mark-ro-data arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c~kprobes-i386-fix-for-mark-ro-data
+++ a/arch/i386/kernel/kprobes.c
@@ -169,16 +169,42 @@ int __kprobes arch_prepare_kprobe(struct
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
+	unsigned long addr = (unsigned long) p->addr;
+	int page_readonly = 0;
+
+	if (kernel_readonly_text(addr)) {
+		page_readonly = 1;
+		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
+		global_flush_tlb();
+	}
+
 	*p->addr = BREAKPOINT_INSTRUCTION;
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+
+	if (page_readonly) {
+		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
+		global_flush_tlb();
+	}
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
+	unsigned long addr = (unsigned long) p->addr;
+	int page_readonly = 0;
+
+	if (kernel_readonly_text(addr)) {
+		page_readonly = 1;
+		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
+		global_flush_tlb();
+	}
 	*p->addr = p->opcode;
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	if (page_readonly) {
+		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
+		global_flush_tlb();
+	}
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff -puN arch/i386/mm/init.c~kprobes-i386-fix-for-mark-ro-data arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~kprobes-i386-fix-for-mark-ro-data
+++ a/arch/i386/mm/init.c
@@ -45,6 +45,7 @@
 #include <asm/sections.h>
 #include <asm/paravirt.h>
 
+int kernel_text_is_ro;
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
@@ -809,6 +810,7 @@ void mark_rodata_ro(void)
 		change_page_attr(virt_to_page(start),
 		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
 		printk("Write protecting the kernel text: %luk\n", size >> 10);
+		kernel_text_is_ro = 1;
 	}
 #endif
 	start += size;
diff -puN include/asm-i386/kprobes.h~kprobes-i386-fix-for-mark-ro-data include/asm-i386/kprobes.h
--- a/include/asm-i386/kprobes.h~kprobes-i386-fix-for-mark-ro-data
+++ a/include/asm-i386/kprobes.h
@@ -26,6 +26,8 @@
  */
 #include <linux/types.h>
 #include <linux/ptrace.h>
+#include <linux/pfn.h>
+#include <asm-generic/sections.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
 
@@ -89,4 +91,14 @@ static inline void restore_interrupts(st
 
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
+extern int kernel_text_is_ro;
+static inline int kernel_readonly_text(unsigned long address)
+{
+
+	if (kernel_text_is_ro && ((address >= PFN_ALIGN(_text))
+				&& (address < PFN_ALIGN(_etext))))
+		return 1;
+
+	return 0;
+}
 #endif				/* _ASM_KPROBES_H */
diff -puN include/asm-i386/pgtable.h~kprobes-i386-fix-for-mark-ro-data include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~kprobes-i386-fix-for-mark-ro-data
+++ a/include/asm-i386/pgtable.h
@@ -159,6 +159,7 @@ void paging_init(void);
 extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
+#define __PAGE_KERNEL_RWX		(__PAGE_KERNEL_EXEC | _PAGE_RW)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
@@ -167,6 +168,7 @@ extern unsigned long long __PAGE_KERNEL,
 #define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX		__pgprot(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_RWX		__pgprot(__PAGE_KERNEL_RWX)
 #define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE)
 #define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
_

Patches currently in -mm which might be from prasanna@in.ibm.com are

origin.patch
kprobes-i386-fix-for-mark-ro-data.patch
