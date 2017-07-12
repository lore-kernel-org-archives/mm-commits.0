From: akpm@linux-foundation.org
Subject: [patch 05/96] kexec: move vmcoreinfo out of the kernel's
 .bss section
Date: Wed, 12 Jul 2017 14:33:14 -0700
Message-ID: <20170712213314.x-mpN0bkP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754172AbdGLVdQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, dyoung@redhat.com, ebiederm@xmission.com, hbathini@linux.vnet.ibm.com, holzheu@linux.vnet.ibm.com, jgross@suse.com, mahesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, xlpang@redhat.com

From: Xunlei Pang <xlpang@redhat.com>
Subject: kexec: move vmcoreinfo out of the kernel's .bss section

As Eric said,
"what we need to do is move the variable vmcoreinfo_note out
of the kernel's .bss section.  And modify the code to regenerate
and keep this information in something like the control page.

Definitely something like this needs a page all to itself, and ideally far
away from any other kernel data structures.  I clearly was not watching
closely the data someone decided to keep this silly thing in the kernel's
.bss section."

This patch allocates extra pages for these vmcoreinfo_XXX variables, one
advantage is that it enhances some safety of vmcoreinfo, because
vmcoreinfo now is kept far away from other kernel data structures.

Link: http://lkml.kernel.org/r/1493281021-20737-1-git-send-email-xlpang@redhat.com
Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Tested-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Suggested-by: Eric Biederman <ebiederm@xmission.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.vnet.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/machine_kexec.c |    5 -----
 arch/s390/kernel/machine_kexec.c |    1 +
 arch/s390/kernel/setup.c         |    6 ------
 arch/x86/kernel/crash.c          |    2 +-
 arch/x86/xen/mmu_pv.c            |    4 ++--
 include/linux/crash_core.h       |    4 ++--
 kernel/crash_core.c              |   26 ++++++++++++++++++++++----
 kernel/ksysfs.c                  |    2 +-
 8 files changed, 29 insertions(+), 21 deletions(-)

diff -puN arch/ia64/kernel/machine_kexec.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -163,8 +163,3 @@ void arch_crash_save_vmcoreinfo(void)
 #endif
 }
 
-phys_addr_t paddr_vmcoreinfo_note(void)
-{
-	return ia64_tpa((unsigned long)(char *)&vmcoreinfo_note);
-}
-
diff -puN arch/s390/kernel/machine_kexec.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section arch/s390/kernel/machine_kexec.c
--- a/arch/s390/kernel/machine_kexec.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section
+++ a/arch/s390/kernel/machine_kexec.c
@@ -246,6 +246,7 @@ void arch_crash_save_vmcoreinfo(void)
 	VMCOREINFO_SYMBOL(lowcore_ptr);
 	VMCOREINFO_SYMBOL(high_memory);
 	VMCOREINFO_LENGTH(lowcore_ptr, NR_CPUS);
+	mem_assign_absolute(S390_lowcore.vmcore_info, paddr_vmcoreinfo_note());
 }
 
 void machine_shutdown(void)
diff -puN arch/s390/kernel/setup.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section arch/s390/kernel/setup.c
--- a/arch/s390/kernel/setup.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section
+++ a/arch/s390/kernel/setup.c
@@ -496,11 +496,6 @@ static void __init setup_memory_end(void
 	pr_notice("The maximum memory size is %luMB\n", memory_end >> 20);
 }
 
-static void __init setup_vmcoreinfo(void)
-{
-	mem_assign_absolute(S390_lowcore.vmcore_info, paddr_vmcoreinfo_note());
-}
-
 #ifdef CONFIG_CRASH_DUMP
 
 /*
@@ -939,7 +934,6 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	setup_resources();
-	setup_vmcoreinfo();
 	setup_lowcore();
 	smp_fill_possible_mask();
 	cpu_detect_mhz_feature();
diff -puN arch/x86/kernel/crash.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section arch/x86/kernel/crash.c
--- a/arch/x86/kernel/crash.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section
+++ a/arch/x86/kernel/crash.c
@@ -457,7 +457,7 @@ static int prepare_elf64_headers(struct
 	bufp += sizeof(Elf64_Phdr);
 	phdr->p_type = PT_NOTE;
 	phdr->p_offset = phdr->p_paddr = paddr_vmcoreinfo_note();
-	phdr->p_filesz = phdr->p_memsz = sizeof(vmcoreinfo_note);
+	phdr->p_filesz = phdr->p_memsz = VMCOREINFO_NOTE_SIZE;
 	(ehdr->e_phnum)++;
 
 #ifdef CONFIG_X86_64
diff -puN arch/x86/xen/mmu_pv.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section arch/x86/xen/mmu_pv.c
--- a/arch/x86/xen/mmu_pv.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section
+++ a/arch/x86/xen/mmu_pv.c
@@ -2693,8 +2693,8 @@ EXPORT_SYMBOL_GPL(xen_destroy_contiguous
 phys_addr_t paddr_vmcoreinfo_note(void)
 {
 	if (xen_pv_domain())
-		return virt_to_machine(&vmcoreinfo_note).maddr;
+		return virt_to_machine(vmcoreinfo_note).maddr;
 	else
-		return __pa_symbol(&vmcoreinfo_note);
+		return __pa(vmcoreinfo_note);
 }
 #endif /* CONFIG_KEXEC_CORE */
diff -puN include/linux/crash_core.h~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section include/linux/crash_core.h
--- a/include/linux/crash_core.h~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section
+++ a/include/linux/crash_core.h
@@ -19,7 +19,7 @@
 				     CRASH_CORE_NOTE_NAME_BYTES +	\
 				     CRASH_CORE_NOTE_DESC_BYTES)
 
-#define VMCOREINFO_BYTES	   (4096)
+#define VMCOREINFO_BYTES	   PAGE_SIZE
 #define VMCOREINFO_NOTE_NAME	   "VMCOREINFO"
 #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
 #define VMCOREINFO_NOTE_SIZE	   ((CRASH_CORE_NOTE_HEAD_BYTES * 2) +	\
@@ -56,7 +56,7 @@ phys_addr_t paddr_vmcoreinfo_note(void);
 #define VMCOREINFO_CONFIG(name) \
 	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
 
-extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+extern u32 *vmcoreinfo_note;
 extern size_t vmcoreinfo_size;
 extern size_t vmcoreinfo_max_size;
 
diff -puN kernel/crash_core.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section kernel/crash_core.c
--- a/kernel/crash_core.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section
+++ a/kernel/crash_core.c
@@ -14,10 +14,10 @@
 #include <asm/sections.h>
 
 /* vmcoreinfo stuff */
-static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
-u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+static unsigned char *vmcoreinfo_data;
 size_t vmcoreinfo_size;
-size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
+size_t vmcoreinfo_max_size = VMCOREINFO_BYTES;
+u32 *vmcoreinfo_note;
 
 /*
  * parsing the "crashkernel" commandline
@@ -326,6 +326,9 @@ static void update_vmcoreinfo_note(void)
 
 void crash_save_vmcoreinfo(void)
 {
+	if (!vmcoreinfo_note)
+		return;
+
 	vmcoreinfo_append_str("CRASHTIME=%ld\n", get_seconds());
 	update_vmcoreinfo_note();
 }
@@ -356,11 +359,26 @@ void __weak arch_crash_save_vmcoreinfo(v
 
 phys_addr_t __weak paddr_vmcoreinfo_note(void)
 {
-	return __pa_symbol((unsigned long)(char *)&vmcoreinfo_note);
+	return __pa(vmcoreinfo_note);
 }
 
 static int __init crash_save_vmcoreinfo_init(void)
 {
+	vmcoreinfo_data = (unsigned char *)get_zeroed_page(GFP_KERNEL);
+	if (!vmcoreinfo_data) {
+		pr_warn("Memory allocation for vmcoreinfo_data failed\n");
+		return -ENOMEM;
+	}
+
+	vmcoreinfo_note = alloc_pages_exact(VMCOREINFO_NOTE_SIZE,
+						GFP_KERNEL | __GFP_ZERO);
+	if (!vmcoreinfo_note) {
+		free_page((unsigned long)vmcoreinfo_data);
+		vmcoreinfo_data = NULL;
+		pr_warn("Memory allocation for vmcoreinfo_note failed\n");
+		return -ENOMEM;
+	}
+
 	VMCOREINFO_OSRELEASE(init_uts_ns.name.release);
 	VMCOREINFO_PAGESIZE(PAGE_SIZE);
 
diff -puN kernel/ksysfs.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section kernel/ksysfs.c
--- a/kernel/ksysfs.c~kexec-move-vmcoreinfo-out-of-the-kernels-bss-section
+++ a/kernel/ksysfs.c
@@ -134,7 +134,7 @@ static ssize_t vmcoreinfo_show(struct ko
 {
 	phys_addr_t vmcore_base = paddr_vmcoreinfo_note();
 	return sprintf(buf, "%pa %x\n", &vmcore_base,
-		       (unsigned int)sizeof(vmcoreinfo_note));
+			(unsigned int)VMCOREINFO_NOTE_SIZE);
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
_
