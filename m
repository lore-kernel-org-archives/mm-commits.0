From: akpm@osdl.org
Subject: + fix-config_compat_vdso.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:48:43 -0800
Message-ID: <200701231948.l0NJmhfp029436@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51726 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965454AbXAWTtn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:49:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org


The patch titled
     Fix CONFIG_COMPAT_VDSO
has been added to the -mm tree.  Its filename is
     fix-config_compat_vdso.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix CONFIG_COMPAT_VDSO
From: Roland McGrath <roland@redhat.com>

I wouldn't mind if CONFIG_COMPAT_VDSO went away entirely.  But if it's there,
it should work properly.  Currently it's quite haphazard: both real vma and
fixmap are mapped, both are put in the two different AT_* slots, sysenter
returns to the vma address rather than the fixmap address, and core dumps yet
are another story.

This patch makes CONFIG_COMPAT_VDSO disable the real vma and use the fixmap
area consistently.  This makes it actually compatible with what the old vdso
implementation did.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/entry.S    |    4 ++++
 arch/i386/kernel/sysenter.c |    2 ++
 include/asm-i386/elf.h      |    7 +++----
 include/asm-i386/fixmap.h   |    2 ++
 include/asm-i386/page.h     |    2 ++
 5 files changed, 13 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/entry.S~fix-config_compat_vdso arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~fix-config_compat_vdso
+++ a/arch/i386/kernel/entry.S
@@ -302,12 +302,16 @@ sysenter_past_esp:
 	pushl $(__USER_CS)
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET cs, 0*/
+#ifndef CONFIG_COMPAT_VDSO
 	/*
 	 * Push current_thread_info()->sysenter_return to the stack.
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
 	pushl (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
+#else
+	pushl $SYSENTER_RETURN
+#endif
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET eip, 0
 
diff -puN arch/i386/kernel/sysenter.c~fix-config_compat_vdso arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~fix-config_compat_vdso
+++ a/arch/i386/kernel/sysenter.c
@@ -100,6 +100,7 @@ int __init sysenter_setup(void)
 	return 0;
 }
 
+#ifndef CONFIG_COMPAT_VDSO
 static struct page *syscall_nopage(struct vm_area_struct *vma,
 				unsigned long adr, int *type)
 {
@@ -187,3 +188,4 @@ int in_gate_area_no_task(unsigned long a
 {
 	return 0;
 }
+#endif
diff -puN include/asm-i386/elf.h~fix-config_compat_vdso include/asm-i386/elf.h
--- a/include/asm-i386/elf.h~fix-config_compat_vdso
+++ a/include/asm-i386/elf.h
@@ -143,11 +143,8 @@ extern int dump_task_extended_fpu (struc
 # define VDSO_PRELINK		0
 #endif
 
-#define VDSO_COMPAT_SYM(x) \
-		(VDSO_COMPAT_BASE + (unsigned long)(x) - VDSO_PRELINK)
-
 #define VDSO_SYM(x) \
-		(VDSO_BASE + (unsigned long)(x) - VDSO_PRELINK)
+		(VDSO_COMPAT_BASE + (unsigned long)(x) - VDSO_PRELINK)
 
 #define VDSO_HIGH_EHDR		((const struct elfhdr *) VDSO_HIGH_BASE)
 #define VDSO_EHDR		((const struct elfhdr *) VDSO_COMPAT_BASE)
@@ -156,10 +153,12 @@ extern void __kernel_vsyscall;
 
 #define VDSO_ENTRY		VDSO_SYM(&__kernel_vsyscall)
 
+#ifndef CONFIG_COMPAT_VDSO
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
                                        int executable_stack);
+#endif
 
 extern unsigned int vdso_enabled;
 
diff -puN include/asm-i386/fixmap.h~fix-config_compat_vdso include/asm-i386/fixmap.h
--- a/include/asm-i386/fixmap.h~fix-config_compat_vdso
+++ a/include/asm-i386/fixmap.h
@@ -23,6 +23,8 @@
 extern unsigned long __FIXADDR_TOP;
 #else
 #define __FIXADDR_TOP  0xfffff000
+#define FIXADDR_USER_START	__fix_to_virt(FIX_VDSO)
+#define FIXADDR_USER_END	__fix_to_virt(FIX_VDSO - 1)
 #endif
 
 #ifndef __ASSEMBLY__
diff -puN include/asm-i386/page.h~fix-config_compat_vdso include/asm-i386/page.h
--- a/include/asm-i386/page.h~fix-config_compat_vdso
+++ a/include/asm-i386/page.h
@@ -143,7 +143,9 @@ extern int page_is_ram(unsigned long pag
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
+#ifndef CONFIG_COMPAT_VDSO
 #define __HAVE_ARCH_GATE_AREA 1
+#endif
 #endif /* __KERNEL__ */
 
 #endif /* _I386_PAGE_H */
_

Patches currently in -mm which might be from roland@redhat.com are

fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
