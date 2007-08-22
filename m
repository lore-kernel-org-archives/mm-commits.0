From: akpm@linux-foundation.org
Subject: + add-vmcoreinfo.patch added to -mm tree
Date: Wed, 22 Aug 2007 15:30:18 -0700
Message-ID: <200708222230.l7MMUIho008115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756902AbXHVWaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 18:30:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp, bwalle@suse.de, da-x@monatomic.org, nishimura@mxp.nes.nec.co.jp


The patch titled
     Add vmcoreinfo
has been added to the -mm tree.  Its filename is
     add-vmcoreinfo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add vmcoreinfo
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

This patch set frees the restriction that makedumpfile users should install a
vmlinux file (including the debugging information) into each system.

makedumpfile command is the dump filtering feature for kdump.  It creates a
small dumpfile by filtering unnecessary pages for the analysis.  To
distinguish unnecessary pages, it needs a vmlinux file including the debugging
information.  These days, the debugging package becomes a huge file, and it is
hard to install it into each system.

To solve the problem, kdump developers discussed it at lkml and kexec-ml.  As
the result, we reached the conclusion that necessary information for dump
filtering (called "vmcoreinfo") should be embedded into the first kernel file
and it should be accessed through /proc/vmcore during the second kernel. 
(http://www.uwsg.iu.edu/hypermail/linux/kernel/0707.0/1806.html) 

Dan Aloni created the patch set for the above implementation. 
(http://www.uwsg.iu.edu/hypermail/linux/kernel/0707.1/1053.html)

And I updated it for multi architectures and memory models. 
(http://lists.infradead.org/pipermail/kexec/2007-August/000479.html)

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/machine_kexec.c   |   13 +++
 arch/ia64/kernel/machine_kexec.c   |   30 +++++++
 arch/ia64/mm/discontig.c           |    2 
 arch/x86_64/kernel/machine_kexec.c |    9 ++
 include/asm-ia64/numa.h            |    1 
 include/linux/kexec.h              |   26 ++++++
 kernel/kexec.c                     |  110 +++++++++++++++++++++++++++
 kernel/ksysfs.c                    |   10 ++
 8 files changed, 200 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/machine_kexec.c~add-vmcoreinfo arch/i386/kernel/machine_kexec.c
--- a/arch/i386/kernel/machine_kexec.c~add-vmcoreinfo
+++ a/arch/i386/kernel/machine_kexec.c
@@ -10,6 +10,7 @@
 #include <linux/kexec.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/numa.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
@@ -169,3 +170,15 @@ static int __init parse_crashkernel(char
 	return 0;
 }
 early_param("crashkernel", parse_crashkernel);
+
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+	SYMBOL(node_data);
+	LENGTH(node_data, MAX_NUMNODES);
+#endif
+#ifdef CONFIG_X86_PAE
+	CONFIG(X86_PAE);
+#endif
+}
+
diff -puN arch/ia64/kernel/machine_kexec.c~add-vmcoreinfo arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~add-vmcoreinfo
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -15,6 +15,8 @@
 #include <linux/cpu.h>
 #include <linux/irq.h>
 #include <linux/efi.h>
+#include <linux/numa.h>
+#include <linux/mmzone.h>
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/delay.h>
@@ -125,3 +127,31 @@ void machine_kexec(struct kimage *image)
 	unw_init_running(ia64_machine_kexec, image);
 	for(;;);
 }
+
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+	SYMBOL(pgdat_list);
+	LENGTH(pgdat_list, MAX_NUMNODES);
+
+	SYMBOL(node_memblk);
+	LENGTH(node_memblk, NR_NODE_MEMBLKS);
+	SIZE(node_memblk_s);
+	OFFSET(node_memblk_s, start_paddr);
+	OFFSET(node_memblk_s, size);
+#endif
+#ifdef CONFIG_PGTABLE_3
+	CONFIG(PGTABLE_3);
+#elif  CONFIG_PGTABLE_4
+	CONFIG(PGTABLE_4);
+#endif
+}
+
+unsigned long paddr_vmcoreinfo_note(void)
+{
+	unsigned long vaddr, paddr;
+	vaddr = (unsigned long)(char *)&vmcoreinfo_note;
+	asm volatile ("tpa %0 = %1" : "=r"(paddr) : "r"(vaddr) : "memory");
+	return paddr;
+}
+
diff -puN arch/ia64/mm/discontig.c~add-vmcoreinfo arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~add-vmcoreinfo
+++ a/arch/ia64/mm/discontig.c
@@ -47,7 +47,7 @@ struct early_node_data {
 static struct early_node_data mem_data[MAX_NUMNODES] __initdata;
 static nodemask_t memory_less_mask __initdata;
 
-static pg_data_t *pgdat_list[MAX_NUMNODES];
+pg_data_t *pgdat_list[MAX_NUMNODES];
 
 /*
  * To prevent cache aliasing effects, align per-node structures so that they
diff -puN arch/x86_64/kernel/machine_kexec.c~add-vmcoreinfo arch/x86_64/kernel/machine_kexec.c
--- a/arch/x86_64/kernel/machine_kexec.c~add-vmcoreinfo
+++ a/arch/x86_64/kernel/machine_kexec.c
@@ -10,6 +10,7 @@
 #include <linux/kexec.h>
 #include <linux/string.h>
 #include <linux/reboot.h>
+#include <linux/numa.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -257,3 +258,11 @@ static int __init setup_crashkernel(char
 }
 early_param("crashkernel", setup_crashkernel);
 
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
+	SYMBOL(node_data);
+	LENGTH(node_data, MAX_NUMNODES);
+#endif
+}
+
diff -puN include/asm-ia64/numa.h~add-vmcoreinfo include/asm-ia64/numa.h
--- a/include/asm-ia64/numa.h~add-vmcoreinfo
+++ a/include/asm-ia64/numa.h
@@ -24,6 +24,7 @@
 
 extern u16 cpu_to_node_map[NR_CPUS] __cacheline_aligned;
 extern cpumask_t node_to_cpu_mask[MAX_NUMNODES] __cacheline_aligned;
+extern pg_data_t *pgdat_list[MAX_NUMNODES];
 
 /* Stuff below this line could be architecture independent */
 
diff -puN include/linux/kexec.h~add-vmcoreinfo include/linux/kexec.h
--- a/include/linux/kexec.h~add-vmcoreinfo
+++ a/include/linux/kexec.h
@@ -121,6 +121,23 @@ extern struct page *kimage_alloc_control
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
+void crash_save_vmcoreinfo(void);
+void arch_crash_save_vmcoreinfo(void);
+void vmcoreinfo_append_str(const char *fmt, ...);
+unsigned long paddr_vmcoreinfo_note(void);
+
+#define SYMBOL(name) \
+	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
+#define SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%d\n", #name, sizeof(struct name))
+#define OFFSET(name, field) \
+	vmcoreinfo_append_str("OFFSET(%s.%s)=%d\n", #name, #field, \
+			      &(((struct name *)0)->field))
+#define LENGTH(name, value) \
+	vmcoreinfo_append_str("LENGTH(%s)=%d\n", #name, value)
+#define CONFIG(name) \
+	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
+
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
 
@@ -148,11 +165,20 @@ extern struct kimage *kexec_crash_image;
 
 #define KEXEC_FLAGS    (KEXEC_ON_CRASH)  /* List of defined/legal kexec flags */
 
+#define VMCOREINFO_BYTES           (4096)
+#define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
+#define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
+#define VMCOREINFO_NOTE_SIZE       (KEXEC_NOTE_HEAD_BYTES*2 + VMCOREINFO_BYTES \
+				    + VMCOREINFO_NOTE_NAME_BYTES)
+
 /* Location of a reserved region to hold the crash kernel.
  */
 extern struct resource crashk_res;
 typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
 extern note_buf_t *crash_notes;
+extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+extern unsigned int vmcoreinfo_size;
+extern unsigned int vmcoreinfo_max_size;
 
 
 #else /* !CONFIG_KEXEC */
diff -puN kernel/kexec.c~add-vmcoreinfo kernel/kexec.c
--- a/kernel/kexec.c~add-vmcoreinfo
+++ a/kernel/kexec.c
@@ -21,16 +21,26 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/utsrelease.h>
+#include <linux/utsname.h>
+#include <linux/numa.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/semaphore.h>
+#include <asm/sections.h>
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t* crash_notes;
 
+/* vmcoreinfo stuff */
+unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
+u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+unsigned int vmcoreinfo_size = 0;
+unsigned int vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -1060,6 +1070,7 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 			crash_setup_regs(&fixed_regs, regs);
+			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
@@ -1134,3 +1145,102 @@ static int __init crash_notes_memory_ini
 	return 0;
 }
 module_init(crash_notes_memory_init)
+
+void crash_save_vmcoreinfo(void)
+{
+	u32 *buf;
+
+	if (!vmcoreinfo_size)
+		return;
+
+	vmcoreinfo_append_str("CRASHTIME=%d", xtime.tv_sec);
+
+	buf = (u32 *)vmcoreinfo_note;
+
+	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
+			      vmcoreinfo_size);
+
+	final_note(buf);
+}
+
+void vmcoreinfo_append_str(const char *fmt, ...)
+{
+	va_list args;
+	char buf[0x50];
+	int r;
+
+	va_start(args, fmt);
+	r = vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+
+	if (r + vmcoreinfo_size > vmcoreinfo_max_size)
+		r = vmcoreinfo_max_size - vmcoreinfo_size;
+
+	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
+
+	vmcoreinfo_size += r;
+}
+
+/*
+ * provide an empty default implementation here -- architecture
+ * code may override this
+ */
+void __attribute__ ((weak)) arch_crash_save_vmcoreinfo(void)
+{}
+
+unsigned long __attribute__ ((weak)) paddr_vmcoreinfo_note(void)
+{
+	return __pa((unsigned long)(char *)&vmcoreinfo_note);
+}
+
+static int __init crash_save_vmcoreinfo_init(void)
+{
+	vmcoreinfo_append_str("OSRELEASE=%s\n", UTS_RELEASE);
+	vmcoreinfo_append_str("PAGESIZE=%d\n", PAGE_SIZE);
+
+	SYMBOL(init_uts_ns);
+	SYMBOL(node_online_map);
+	SYMBOL(swapper_pg_dir);
+	SYMBOL(_stext);
+
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+	SYMBOL(mem_map);
+	SYMBOL(contig_page_data);
+#endif
+#ifdef CONFIG_SPARSEMEM
+	SYMBOL(mem_section);
+	LENGTH(mem_section, NR_SECTION_ROOTS);
+	SIZE(mem_section);
+	OFFSET(mem_section, section_mem_map);
+#endif
+	SIZE(page);
+	SIZE(pglist_data);
+	SIZE(zone);
+	SIZE(free_area);
+	SIZE(list_head);
+	OFFSET(page, flags);
+	OFFSET(page, _count);
+	OFFSET(page, mapping);
+	OFFSET(page, lru);
+	OFFSET(pglist_data, node_zones);
+	OFFSET(pglist_data, nr_zones);
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
+	OFFSET(pglist_data, node_mem_map);
+#endif
+	OFFSET(pglist_data, node_start_pfn);
+	OFFSET(pglist_data, node_spanned_pages);
+	OFFSET(pglist_data, node_id);
+	OFFSET(zone, free_area);
+	OFFSET(zone, vm_stat);
+	OFFSET(zone, spanned_pages);
+	OFFSET(free_area, free_list);
+	OFFSET(list_head, next);
+	OFFSET(list_head, prev);
+	LENGTH(zone.free_area, MAX_ORDER);
+
+	arch_crash_save_vmcoreinfo();
+
+	return 0;
+}
+
+module_init(crash_save_vmcoreinfo_init)
diff -puN kernel/ksysfs.c~add-vmcoreinfo kernel/ksysfs.c
--- a/kernel/ksysfs.c~add-vmcoreinfo
+++ a/kernel/ksysfs.c
@@ -60,6 +60,15 @@ static ssize_t kexec_crash_loaded_show(s
 	return sprintf(page, "%d\n", !!kexec_crash_image);
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
+
+static ssize_t vmcoreinfo_show(struct kset *kset, char *page)
+{
+	return sprintf(page, "%lx %x\n",
+		       paddr_vmcoreinfo_note(),
+		       vmcoreinfo_max_size);
+}
+KERNEL_ATTR_RO(vmcoreinfo);
+
 #endif /* CONFIG_KEXEC */
 
 /*
@@ -95,6 +104,7 @@ static struct attribute * kernel_attrs[]
 #ifdef CONFIG_KEXEC
 	&kexec_loaded_attr.attr,
 	&kexec_crash_loaded_attr.attr,
+	&vmcoreinfo_attr.attr,
 #endif
 	NULL
 };
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

add-vmcoreinfo.patch
