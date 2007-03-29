From: akpm@linux-foundation.org
Subject: - lguest-kconfig-and-headers.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:14:27 -0700
Message-ID: <200703292314.l2TNER9w014698@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42396 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934370AbXC2XRu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:17:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     lguest: Kconfig and headers
has been removed from the -mm tree.  Its filename was
     lguest-kconfig-and-headers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lguest: Kconfig and headers
From: Rusty Russell <rusty@rustcorp.com.au>

Unfortunately, we don't have the build infrastructure for "private"
asm-offsets.h files, so there's a not-so-neat include in
arch/i386/kernel/asm-offsets.c.

The four headers are:
asm/lguest.h:
	Things the guest needs to know (hypercall numbers, etc).
asm/lguest_device.h:
	Things lguest devices need to know (lguest bus registration)
asm/lguest_user.h:
	Things that the lguest userspace utility needs (/dev/lguest
	and some devices)
arch/i386/lguest/lg.h:
	Internal header for the lg module (which consists of 8 files).

[bunk@stusta.de: LGUEST must depend on NET]
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig                |   21 ++
 arch/i386/kernel/asm-offsets.c   |   19 ++
 arch/i386/lguest/lg.h            |  253 +++++++++++++++++++++++++++++
 include/asm-i386/lguest.h        |   84 +++++++++
 include/asm-i386/lguest_device.h |   31 +++
 include/asm-i386/lguest_user.h   |   86 +++++++++
 6 files changed, 494 insertions(+)

diff -puN arch/i386/Kconfig~lguest-kconfig-and-headers arch/i386/Kconfig
--- a/arch/i386/Kconfig~lguest-kconfig-and-headers
+++ a/arch/i386/Kconfig
@@ -255,6 +255,27 @@ config ES7000_CLUSTERED_APIC
 
 source "arch/i386/Kconfig.cpu"
 
+config LGUEST
+	tristate "Linux hypervisor example code"
+	depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
+	select LGUEST_GUEST
+	select HVC_DRIVER
+	---help---
+	  This is a very simple module which allows you to run
+	  multiple instances of the same Linux kernel, using the
+	  "lguest" command found in the Documentation/lguest directory.
+	  Note that "lguest" is pronounced to rhyme with "fell quest",
+	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
+
+	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
+
+config LGUEST_GUEST
+	bool
+	help
+	  The guest needs code built-in, even if the host has lguest
+	  support as a module.  The drivers are tiny, so we build them
+	  in too.
+
 config HPET_TIMER
 	bool "HPET Timer Support"
 	help
diff -puN arch/i386/kernel/asm-offsets.c~lguest-kconfig-and-headers arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~lguest-kconfig-and-headers
+++ a/arch/i386/kernel/asm-offsets.c
@@ -16,6 +16,10 @@
 #include <asm/thread_info.h>
 #include <asm/elf.h>
 #include <asm/pda.h>
+#ifdef CONFIG_LGUEST_GUEST
+#include <asm/lguest.h>
+#include "../lguest/lg.h"
+#endif
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -114,4 +118,19 @@ void foo(void)
 	OFFSET(PARAVIRT_iret, paravirt_ops, iret);
 	OFFSET(PARAVIRT_read_cr0, paravirt_ops, read_cr0);
 #endif
+
+#ifdef CONFIG_LGUEST_GUEST
+	BLANK();
+	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
+	OFFSET(LGUEST_STATE_host_stackptr, lguest_state, host.stackptr);
+	OFFSET(LGUEST_STATE_host_pgdir, lguest_state, host.pgdir);
+	OFFSET(LGUEST_STATE_host_gdt, lguest_state, host.gdt);
+	OFFSET(LGUEST_STATE_host_idt, lguest_state, host.idt);
+	OFFSET(LGUEST_STATE_regs, lguest_state, regs);
+	OFFSET(LGUEST_STATE_gdt, lguest_state, gdt);
+	OFFSET(LGUEST_STATE_idt, lguest_state, idt);
+	OFFSET(LGUEST_STATE_gdt_table, lguest_state, gdt_table);
+	OFFSET(LGUEST_STATE_trapnum, lguest_state, regs.trapnum);
+	OFFSET(LGUEST_STATE_errcode, lguest_state, regs.errcode);
+#endif
 }
diff -puN /dev/null arch/i386/lguest/lg.h
--- /dev/null
+++ a/arch/i386/lguest/lg.h
@@ -0,0 +1,253 @@
+#ifndef _LGUEST_H
+#define _LGUEST_H
+
+#include <asm/desc.h>
+/* 64k ought to be enough for anybody! */
+#define HYPERVISOR_MAP_ORDER 16
+#define HYPERVISOR_PAGES ((1 << HYPERVISOR_MAP_ORDER)/PAGE_SIZE)
+
+#define GDT_ENTRY_LGUEST_CS	10
+#define GDT_ENTRY_LGUEST_DS	11
+#define LGUEST_CS		(GDT_ENTRY_LGUEST_CS * 8)
+#define LGUEST_DS		(GDT_ENTRY_LGUEST_DS * 8)
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/stringify.h>
+#include <linux/binfmts.h>
+#include <linux/futex.h>
+#include <asm/lguest.h>
+#include <asm/lguest_user.h>
+#include <asm/semaphore.h>
+#include "irq_vectors.h"
+
+#define GUEST_DPL 1
+
+struct lguest_regs
+{
+	/* Manually saved part. */
+	u32 cr3;
+	u32 ebx, ecx, edx;
+	u32 esi, edi, ebp;
+	u32 gs;
+	u32 eax;
+	u32 fs, ds, es;
+	u32 trapnum, errcode;
+	/* Trap pushed part */
+	u32 eip;
+	u32 cs;
+	u32 eflags;
+	u32 esp;
+	u32 ss;
+};
+
+__exit void free_pagetables(void);
+__init int init_pagetables(struct page *hype_pages);
+
+/* Full 4G segment descriptors, suitable for CS and DS. */
+#define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
+#define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
+
+/* Simplified version of IDT. */
+struct host_trap
+{
+	unsigned long addr;
+	int disable_interrupts;
+};
+
+struct lguest_dma_info
+{
+	struct list_head list;
+	union futex_key key;
+	unsigned long dmas;
+	u16 next_dma;
+	u16 num_dmas;
+	u16 guestid;
+	u8 interrupt; 	/* 0 when not registered */
+};
+
+struct pgdir
+{
+	u32 cr3;
+	u32 *pgdir;
+};
+
+/* The private info the thread maintains about the guest. */
+struct lguest
+{
+	struct lguest_state *state;
+	struct lguest_data __user *lguest_data;
+	struct task_struct *tsk;
+	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
+	u16 guestid;
+	u32 pfn_limit;
+	u32 page_offset;
+	u32 cr2;
+	int timer_on;
+	int halted;
+	int ts;
+	u32 gpf_eip;
+	u32 last_timer;
+	u32 next_hcall;
+	u16 tls_limits[GDT_ENTRY_TLS_ENTRIES];
+
+	/* We keep a small number of these. */
+	u32 pgdidx;
+	struct pgdir pgdirs[4];
+	void *trap_page;
+
+	/* Cached wakeup: we hold a reference to this task. */
+	struct task_struct *wake;
+
+	unsigned long noirq_start, noirq_end;
+	int dma_is_pending;
+	unsigned long pending_dma; /* struct lguest_dma */
+	unsigned long pending_addr; /* address they're sending to */
+
+	unsigned int stack_pages;
+
+	struct lguest_dma_info dma[LGUEST_MAX_DMA];
+
+	/* Dead? */
+	const char *dead;
+
+	/* We intercept page fault (demand shadow paging & cr2 saving)
+	   protection fault (in/out emulation, TLS handling) and
+	   device not available (TS handling). */
+	struct host_trap page_trap, gpf_trap, fpu_trap;
+
+	/* Virtual interrupts */
+	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
+	struct host_trap interrupt[LGUEST_IRQS];
+};
+
+extern struct page *hype_pages; /* Contiguous pages. */
+extern struct lguest lguests[];
+extern struct mutex lguest_lock;
+
+/* core.c: */
+/* Entry points in hypervisor */
+const unsigned long *__lguest_default_idt_entries(void);
+struct lguest_state *__lguest_states(void);
+u32 lhread_u32(struct lguest *lg, u32 addr);
+void lhwrite_u32(struct lguest *lg, u32 val, u32 addr);
+void lhread(struct lguest *lg, void *buf, u32 addr, unsigned bytes);
+void lhwrite(struct lguest *lg, u32 addr, const void *buf, unsigned bytes);
+int lguest_address_ok(const struct lguest *lg, unsigned long addr);
+int run_guest(struct lguest *lg, char *__user user);
+int find_free_guest(void);
+
+/* interrupts_and_traps.c: */
+void maybe_do_interrupt(struct lguest *lg);
+int reflect_trap(struct lguest *lg, const struct host_trap *trap, int has_err);
+void check_bug_kill(struct lguest *lg);
+void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
+
+/* segments.c: */
+void load_guest_gdt(struct lguest *lg, u32 table, u32 num);
+void guest_load_tls(struct lguest *lg,
+		    const struct desc_struct __user *tls_array);
+
+int init_guest_pagetable(struct lguest *lg, u32 pgtable);
+void free_guest_pagetable(struct lguest *lg);
+void guest_new_pagetable(struct lguest *lg, u32 pgtable);
+void guest_set_pud(struct lguest *lg, unsigned long cr3, u32 i);
+void guest_pagetable_clear_all(struct lguest *lg);
+void guest_pagetable_flush_user(struct lguest *lg);
+void guest_set_pte(struct lguest *lg, unsigned long cr3,
+		   unsigned long vaddr, u32 val);
+void map_trap_page(struct lguest *info);
+int demand_page(struct lguest *info, u32 cr2, int write);
+void pin_stack_pages(struct lguest *lg);
+
+int lguest_device_init(void);
+void lguest_device_remove(void);
+void lguest_io_init(void);
+u32 bind_dma(struct lguest *lg,
+	     unsigned long addr, unsigned long udma, u16 numdmas,u8 interrupt);
+int send_dma(struct lguest *info, unsigned long addr,
+	     unsigned long udma);
+void release_all_dma(struct lguest *lg);
+unsigned long get_dma_buffer(struct lguest *lg, unsigned long addr,
+			     unsigned long *interrupt);
+
+void set_wakeup_process(struct lguest *lg, struct task_struct *p);
+int do_async_hcalls(struct lguest *info);
+int hypercall(struct lguest *info, struct lguest_regs *regs);
+
+#define kill_guest(lg, fmt...)					\
+do {								\
+	if (!(lg)->dead) {					\
+		(lg)->dead = kasprintf(GFP_ATOMIC, fmt);	\
+		if (!(lg)->dead)				\
+			(lg)->dead = (void *)1;			\
+	}							\
+} while(0)
+
+static inline unsigned long guest_pa(struct lguest *lg, unsigned long vaddr)
+{
+	return vaddr - lg->page_offset;
+}
+
+/* Hardware-defined TSS structure. */
+struct x86_tss
+{
+	unsigned short	back_link,__blh;
+	unsigned long	esp0;
+	unsigned short	ss0,__ss0pad;
+	unsigned long	esp1;
+	unsigned short	ss1,__ss1pad;
+	unsigned long	esp2;
+	unsigned short	ss2,__ss2pad;
+	unsigned long	cr3;
+	unsigned long	eip;
+	unsigned long	eflags;
+	unsigned long	eax,ecx,edx,ebx;
+	unsigned long	esp; /* We actually use this one to save esp. */
+	unsigned long	ebp;
+	unsigned long	esi;
+	unsigned long	edi;
+	unsigned short	es, __espad;
+	unsigned short	cs, __cspad;
+	unsigned short	ss, __sspad;
+	unsigned short	ds, __dspad;
+	unsigned short	fs, __fspad;
+	unsigned short	gs, __gspad;
+	unsigned short	ldt, __ldtpad;
+	unsigned short	trace, io_bitmap_base;
+};
+
+int fixup_gdt_table(struct desc_struct *gdt, unsigned int num,
+		    struct lguest_regs *regs, struct x86_tss *tss);
+
+struct lguest_host_state
+{
+	struct Xgt_desc_struct	gdt;
+	struct Xgt_desc_struct	idt;
+	unsigned long		pgdir;
+	unsigned long		stackptr;
+};
+
+/* This sits in the high-mapped shim. */
+struct lguest_state
+{
+	/* Task struct. */
+	struct x86_tss tss;
+
+	/* Gate descriptor table. */
+	struct Xgt_desc_struct gdt;
+	struct desc_struct gdt_table[GDT_ENTRIES];
+
+	/* Interrupt descriptor table. */
+	struct Xgt_desc_struct idt;
+	struct desc_struct idt_table[IDT_ENTRIES];
+
+	/* Host state we store while the guest runs. */
+	struct lguest_host_state host;
+
+	/* This is the stack on which we push our regs. */
+	struct lguest_regs regs;
+};
+#endif	/* __ASSEMBLY__ */
+#endif	/* _LGUEST_H */
diff -puN /dev/null include/asm-i386/lguest.h
--- /dev/null
+++ a/include/asm-i386/lguest.h
@@ -0,0 +1,84 @@
+/* Things the lguest guest needs to know. */
+#ifndef _ASM_LGUEST_H
+#define _ASM_LGUEST_H
+
+#define LGUEST_MAGIC_EBP 0x4C687970
+#define LGUEST_MAGIC_EDI 0x652D4D65
+#define LGUEST_MAGIC_ESI 0xFFFFFFFF
+
+#define LHCALL_FLUSH_ASYNC	0
+#define LHCALL_LGUEST_INIT	1
+#define LHCALL_CRASH		2
+#define LHCALL_LOAD_GDT		3
+#define LHCALL_NEW_PGTABLE	4
+#define LHCALL_FLUSH_TLB	5
+#define LHCALL_LOAD_IDT_ENTRY	6
+#define LHCALL_SET_STACK	7
+#define LHCALL_TS		8
+#define LHCALL_TIMER_READ	9
+#define LHCALL_TIMER_START	10
+#define LHCALL_HALT		11
+#define LHCALL_GET_WALLCLOCK	12
+#define LHCALL_BIND_DMA		13
+#define LHCALL_SEND_DMA		14
+#define LHCALL_SET_PTE		15
+#define LHCALL_SET_UNKNOWN_PTE	16
+#define LHCALL_SET_PUD		17
+#define LHCALL_LOAD_TLS		18
+
+#define LGUEST_TRAP_ENTRY 0x1F
+
+static inline unsigned long
+hcall(unsigned long call,
+      unsigned long arg1, unsigned long arg2, unsigned long arg3)
+{
+	asm volatile("int $" __stringify(LGUEST_TRAP_ENTRY)
+		     : "=a"(call)
+		     : "a"(call), "d"(arg1), "b"(arg2), "c"(arg3)
+		     : "memory");
+	return call;
+}
+
+void async_hcall(unsigned long call,
+		 unsigned long arg1, unsigned long arg2, unsigned long arg3);
+
+#define LGUEST_IRQS 32
+
+#define LHCALL_RING_SIZE 64
+struct hcall_ring
+{
+	u32 eax, edx, ebx, ecx;
+};
+
+/* All the good stuff happens here: guest registers it with LGUEST_INIT */
+struct lguest_data
+{
+/* Fields which change during running: */
+	/* 512 == enabled (same as eflags) */
+	unsigned int irq_enabled;
+	/* Blocked interrupts. */
+	DECLARE_BITMAP(interrupts, LGUEST_IRQS);
+
+	/* Last (userspace) address we got a GPF & reloaded gs. */
+	unsigned int gs_gpf_eip;
+
+	/* Virtual address of page fault. */
+	unsigned long cr2;
+
+	/* Async hypercall ring.  0xFF == done, 0 == pending. */
+	u8 hcall_status[LHCALL_RING_SIZE];
+	struct hcall_ring hcalls[LHCALL_RING_SIZE];
+
+/* Fields initialized by the hypervisor at boot: */
+	/* Memory not to try to access */
+	unsigned long reserve_mem;
+	/* ID of this guest (used by network driver to set ethernet address) */
+	u16 guestid;
+
+/* Fields initialized by the guest at boot: */
+	/* Instruction range to suppress interrupts even if enabled */
+	unsigned long noirq_start, noirq_end;
+};
+extern struct lguest_data lguest_data;
+extern struct lguest_device_desc *lguest_devices; /* Just past max_pfn */
+#endif	/* _ASM_LGUEST_H */
diff -puN /dev/null include/asm-i386/lguest_device.h
--- /dev/null
+++ a/include/asm-i386/lguest_device.h
@@ -0,0 +1,31 @@
+#ifndef _ASM_LGUEST_DEVICE_H
+#define _ASM_LGUEST_DEVICE_H
+/* Everything you need to know about lguest devices. */
+#include <linux/device.h>
+#include <asm/lguest.h>
+#include <asm/lguest_user.h>
+
+struct lguest_device {
+	/* Unique busid, and index into lguest_page->devices[] */
+	/* By convention, each device can use irq index+1 if it wants to. */
+	unsigned int index;
+
+	struct device dev;
+
+	/* Driver can hang data off here. */
+	void *private;
+};
+
+struct lguest_driver {
+	const char *name;
+	struct module *owner;
+	u16 device_type;
+	int (*probe)(struct lguest_device *dev);
+	void (*remove)(struct lguest_device *dev);
+
+	struct device_driver drv;
+};
+
+extern int register_lguest_driver(struct lguest_driver *drv);
+extern void unregister_lguest_driver(struct lguest_driver *drv);
+#endif /* _ASM_LGUEST_DEVICE_H */
diff -puN /dev/null include/asm-i386/lguest_user.h
--- /dev/null
+++ a/include/asm-i386/lguest_user.h
@@ -0,0 +1,86 @@
+#ifndef _ASM_LGUEST_USER
+#define _ASM_LGUEST_USER
+/* Everything the "lguest" userspace program needs to know. */
+/* They can register up to 32 arrays of lguest_dma. */
+#define LGUEST_MAX_DMA		32
+/* At most we can dma 16 lguest_dma in one op. */
+#define LGUEST_MAX_DMA_SECTIONS	16
+
+/* How many devices?  Assume each one wants up to two dma arrays per device. */
+#define LGUEST_MAX_DEVICES (LGUEST_MAX_DMA/2)
+
+struct lguest_dma
+{
+	/* 0 if free to be used, filled by hypervisor. */
+ 	u32 used_len;
+	u32 addr[LGUEST_MAX_DMA_SECTIONS];
+	u16 len[LGUEST_MAX_DMA_SECTIONS];
+};
+
+/* This is found at address 0. */
+struct lguest_boot_info
+{
+	u32 max_pfn;
+	u32 initrd_size;
+	char cmdline[256];
+};
+
+struct lguest_block_page
+{
+	/* 0 is a read, 1 is a write. */
+	int type;
+	u32 sector; 	/* Offset in device = sector * 512. */
+	u32 bytes;	/* Length expected to be read/written in bytes */
+	/* 0 = pending, 1 = done, 2 = done, error */
+	int result;
+	u32 num_sectors; /* Disk length = num_sectors * 512 */
+};
+
+/* There is a shared page of these. */
+struct lguest_net
+{
+	union {
+		unsigned char mac[6];
+		struct {
+			u8 promisc;
+			u8 pad;
+			u16 guestid;
+		};
+	};
+};
+
+/* lguest_device_desc->type */
+#define LGUEST_DEVICE_T_CONSOLE	1
+#define LGUEST_DEVICE_T_NET	2
+#define LGUEST_DEVICE_T_BLOCK	3
+
+/* lguest_device_desc->status.  256 and above are device specific. */
+#define LGUEST_DEVICE_S_ACKNOWLEDGE	1 /* We have seen device. */
+#define LGUEST_DEVICE_S_DRIVER		2 /* We have found a driver */
+#define LGUEST_DEVICE_S_DRIVER_OK	4 /* Driver says OK! */
+#define LGUEST_DEVICE_S_REMOVED		8 /* Device has gone away. */
+#define LGUEST_DEVICE_S_REMOVED_ACK	16 /* Driver has been told. */
+#define LGUEST_DEVICE_S_FAILED		128 /* Something actually failed */
+
+#define LGUEST_NET_F_NOCSUM		0x4000 /* Don't bother checksumming */
+#define LGUEST_DEVICE_F_RANDOMNESS	0x8000 /* IRQ is fairly random */
+
+/* We have a page of these descriptors in the lguest_device page. */
+struct lguest_device_desc {
+	u16 type;
+	u16 features;
+	u16 status;
+	u16 num_pages;
+	u32 pfn;
+};
+
+/* Write command first word is a request. */
+enum lguest_req
+{
+	LHREQ_INITIALIZE, /* + pfnlimit, pgdir, start, pageoffset */
+	LHREQ_GETDMA, /* + addr (returns &lguest_dma, irq in ->used_len) */
+	LHREQ_IRQ, /* + irq */
+};
+
+
+#endif /* _ASM_LGUEST_USER */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-guest-code-warning-fixes.patch
lguest-clean-up-some-references-inittext-warnings.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
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
