From: akpm@linux-foundation.org
Subject: - lguest-compile-hypervisors-into-the-lg-module-directly.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:14:47 -0700
Message-ID: <200703292314.l2TNEltG014722@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934364AbXC2XOx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: compile hypervisor.S into the lg module directly
has been removed from the -mm tree.  Its filename was
     lguest-compile-hypervisors-into-the-lg-module-directly.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lguest: compile hypervisor.S into the lg module directly
From: Rusty Russell <rusty@rustcorp.com.au>

Because of legacy-induced blindness, I insisted on separately building the
hypervisor.S switcher code (which is mapped at 0xFFC0000 in host and guest). 
However, the lguest64 patches showed the error of my ways: it has no
relocations, so it can be linked into the module like normal then remapped.

The only downside is that we can no longer use sizeof(hypervisor_blob), so we
need to allocate our page-array dynamically.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/Makefile     |   17 --------
 arch/i386/lguest/core.c       |   63 ++++++++++++++++++--------------
 arch/i386/lguest/hypervisor.S |   10 ++---
 3 files changed, 43 insertions(+), 47 deletions(-)

diff -puN arch/i386/lguest/Makefile~lguest-compile-hypervisors-into-the-lg-module-directly arch/i386/lguest/Makefile
--- a/arch/i386/lguest/Makefile~lguest-compile-hypervisors-into-the-lg-module-directly
+++ a/arch/i386/lguest/Makefile
@@ -4,19 +4,4 @@ obj-$(CONFIG_LGUEST_GUEST) += lguest.o l
 # Host requires the other files, which can be a module.
 obj-$(CONFIG_LGUEST)	+= lg.o
 lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
-	segments.o io.o lguest_user.o
-
-# We use top 4MB for hypervisor. */
-HYPE_ADDR := 0xFFC00000
-# The data is only 1k (256 interrupt handler pointers)
-HYPE_DATA_SIZE := 1024
-CFLAGS += -DHYPE_ADDR="$(HYPE_ADDR)" -DHYPE_DATA_SIZE="$(HYPE_DATA_SIZE)"
-
-$(obj)/core.o: $(obj)/hypervisor-blob.c
-# This links the hypervisor in the right place and turns it into a C array.
-$(obj)/hypervisor-raw: $(obj)/hypervisor.o
-	@$(LD) -static -Tdata=`printf %#x $$(($(HYPE_ADDR)))` -Ttext=`printf %#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE)))` -o $@ $< && $(OBJCOPY) -O binary $@
-$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
-	@od -tx1 -An -v $< | sed -e 's/^ /0x/' -e 's/$$/,/' -e 's/ /,0x/g' > $@
-
-clean-files := hypervisor-blob.c hypervisor-raw
+	segments.o io.o lguest_user.o hypervisor.o
diff -puN arch/i386/lguest/core.c~lguest-compile-hypervisors-into-the-lg-module-directly arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c~lguest-compile-hypervisors-into-the-lg-module-directly
+++ a/arch/i386/lguest/core.c
@@ -19,17 +19,21 @@
 #include <asm/i387.h>
 #include "lg.h"
 
-/* This is our hypervisor, compiled from hypervisor.S. */
-static char __initdata hypervisor_blob[] = {
-#include "hypervisor-blob.c"
-};
+/* Found in hypervisor.S */
+extern char start_hyper_text[], end_hyper_text[], switch_to_guest[];
+extern unsigned long default_idt_entries[];
 
 /* Every guest maps the core hypervisor blob. */
-#define SHARED_HYPERVISOR_PAGES DIV_ROUND_UP(sizeof(hypervisor_blob),PAGE_SIZE)
+#define SHARED_HYPERVISOR_PAGES \
+	DIV_ROUND_UP(end_hyper_text - start_hyper_text, PAGE_SIZE)
+/* Pages for hypervisor itself, then two pages per cpu */
+#define TOTAL_HYPE_PAGES (SHARED_HYPERVISOR_PAGES + 2 * NR_CPUS)
+
+/* We map at -4M for ease of mapping into the guest (one PTE page). */
+#define HYPE_ADDR 0xFFC00000
 
 static struct vm_struct *hypervisor_vma;
-/* Pages for hypervisor itself, then two pages per cpu */
-static struct page *hype_page[SHARED_HYPERVISOR_PAGES+2*NR_CPUS];
+static struct page **hype_page;
 
 static int cpu_had_pge;
 static struct {
@@ -43,16 +47,10 @@ static DEFINE_PER_CPU(struct lguest *, l
 #define MAX_LGUEST_GUESTS 16
 struct lguest lguests[MAX_LGUEST_GUESTS];
 
-/* IDT entries are at start of hypervisor. */
-static const unsigned long *lguest_default_idt_entries(void)
-{
-	return (void *)HYPE_ADDR;
-}
-
-/* Next is switch_to_guest */
-static void *__lguest_switch_to_guest(void)
+/* Offset from where hypervisor.S was compiled to where we've copied it */
+static unsigned long hype_offset(void)
 {
-	return (void *)HYPE_ADDR + HYPE_DATA_SIZE;
+	return HYPE_ADDR - (unsigned long)start_hyper_text;
 }
 
 /* This cpu's struct lguest_pages. */
@@ -65,9 +63,15 @@ static struct lguest_pages *lguest_pages
 static __init int map_hypervisor(void)
 {
 	int i, err;
-	struct page **pagep = hype_page;
+	struct page **pagep;
 
-	for (i = 0; i < ARRAY_SIZE(hype_page); i++) {
+	hype_page = kmalloc(sizeof(hype_page[0])*TOTAL_HYPE_PAGES, GFP_KERNEL);
+	if (!hype_page) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < TOTAL_HYPE_PAGES; i++) {
 		unsigned long addr = get_zeroed_page(GFP_KERNEL);
 		if (!addr) {
 			err = -ENOMEM;
@@ -76,7 +80,7 @@ static __init int map_hypervisor(void)
 		hype_page[i] = virt_to_page(addr);
 	}
 
-	hypervisor_vma = __get_vm_area(ARRAY_SIZE(hype_page) * PAGE_SIZE,
+	hypervisor_vma = __get_vm_area(TOTAL_HYPE_PAGES * PAGE_SIZE,
 				       VM_ALLOC, HYPE_ADDR, VMALLOC_END);
 	if (!hypervisor_vma) {
 		err = -ENOMEM;
@@ -84,12 +88,18 @@ static __init int map_hypervisor(void)
 		goto free_pages;
 	}
 
+	pagep = hype_page;
 	err = map_vm_area(hypervisor_vma, PAGE_KERNEL, &pagep);
 	if (err) {
 		printk("lguest: map_vm_area failed: %i\n", err);
 		goto free_vma;
 	}
-	memcpy(hypervisor_vma->addr, hypervisor_blob, sizeof(hypervisor_blob));
+	memcpy(hypervisor_vma->addr, start_hyper_text,
+	       end_hyper_text - start_hyper_text);
+
+	/* Fix up IDT entries to point into copied text. */
+	for (i = 0; i < IDT_ENTRIES; i++)
+		default_idt_entries[i] += hype_offset();
 
 	for_each_possible_cpu(i) {
 		struct lguest_pages *pages = lguest_pages(i);
@@ -107,7 +117,7 @@ static __init int map_hypervisor(void)
 		/* No I/O for you! */
 		state->guest_tss.io_bitmap_base = sizeof(state->guest_tss);
 		setup_default_gdt_entries(state);
-		setup_default_idt_entries(state, lguest_default_idt_entries());
+		setup_default_idt_entries(state, default_idt_entries);
 
 		/* Setup LGUEST segments on all cpus */
 		get_cpu_gdt_table(i)[GDT_ENTRY_LGUEST_CS] = FULL_EXEC_SEGMENT;
@@ -115,7 +125,7 @@ static __init int map_hypervisor(void)
 	}
 
 	/* Initialize entry point into hypervisor. */
-	lguest_entry.offset = (long)__lguest_switch_to_guest();
+	lguest_entry.offset = (long)switch_to_guest + hype_offset();
 	lguest_entry.segment = LGUEST_CS;
 
 	printk("lguest: mapped hypervisor at %p\n", hypervisor_vma->addr);
@@ -124,10 +134,12 @@ static __init int map_hypervisor(void)
 free_vma:
 	vunmap(hypervisor_vma->addr);
 free_pages:
-	i = ARRAY_SIZE(hype_page);
+	i = TOTAL_HYPE_PAGES;
 free_some_pages:
 	for (--i; i >= 0; i--)
 		__free_pages(hype_page[i], 0);
+	kfree(hype_page);
+out:
 	return err;
 }
 
@@ -136,7 +148,7 @@ static void unmap_hypervisor(void)
 	unsigned int i;
 
 	vunmap(hypervisor_vma->addr);
-	for (i = 0; i < ARRAY_SIZE(hype_page); i++)
+	for (i = 0; i < TOTAL_HYPE_PAGES; i++)
 		__free_pages(hype_page[i], 0);
 }
 
@@ -277,8 +289,7 @@ static void copy_in_guest_info(struct lg
 
 	/* Copy direct trap entries. */
 	if (lg->changed & CHANGED_IDT)
-		copy_traps(lg, pages->state.guest_idt,
-			   lguest_default_idt_entries());
+		copy_traps(lg, pages->state.guest_idt, default_idt_entries);
 
 	/* Copy all GDT entries but the TSS. */
 	if (lg->changed & CHANGED_GDT)
diff -puN arch/i386/lguest/hypervisor.S~lguest-compile-hypervisors-into-the-lg-module-directly arch/i386/lguest/hypervisor.S
--- a/arch/i386/lguest/hypervisor.S~lguest-compile-hypervisors-into-the-lg-module-directly
+++ a/arch/i386/lguest/hypervisor.S
@@ -10,11 +10,11 @@
 #include "lg.h"
 
 .text
-ENTRY(_start) /* ld complains unless _start is defined. */
+ENTRY(start_hyper_text)
 
 /* %eax points to lguest pages for this CPU.  %ebx contains cr3 value.
    All normal registers can be clobbered! */
-switch_to_guest:
+ENTRY(switch_to_guest)
 	/* Save host segments on host stack. */
 	pushl	%es
 	pushl	%ds
@@ -143,8 +143,8 @@ deliver_to_host:
  * host.  Unfortunately we can't tell them apart except by entry
  * point, so we need 256 entry points.
  */
-irq_stubs:
 .data
+.global default_idt_entries
 default_idt_entries:
 .text
 	IRQ_STUBS 0 1 return_to_host		/* First two traps */
@@ -155,5 +155,5 @@ default_idt_entries:
 	IRQ_STUB 128 return_to_host		/* System call (overridden) */
 	IRQ_STUBS 129 255 deliver_to_host	/* Other real interrupts */
 
-/* Everything after this is used for the lguest_state structs. */
-ALIGN
+.text
+ENTRY(end_hyper_text)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
i386-account-for-module-percpu-space-separately-from-kernel.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
ignore-vgacon-if-hardware-not-present.patch
