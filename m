From: akpm@osdl.org
Subject: - x86_64-ia32-vdso-define-arch_vma_name.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:31 -0800
Message-ID: <200701270131.l0R1VVEG031840@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbXA0BcO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 ia32 vDSO: define arch_vma_name
has been removed from the -mm tree.  Its filename was
     x86_64-ia32-vdso-define-arch_vma_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 ia32 vDSO: define arch_vma_name
From: Roland McGrath <roland@redhat.com>

This patch makes x86_64 define arch_vma_name for CONFIG_IA32_EMULATION.  This
makes the ia32 vDSO mapping appear in /proc/PID/maps with "[vdso]" for ia32
processes, as it does on native i386.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/ia32/syscall32.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86_64/ia32/syscall32.c~x86_64-ia32-vdso-define-arch_vma_name arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~x86_64-ia32-vdso-define-arch_vma_name
+++ a/arch/x86_64/ia32/syscall32.c
@@ -82,6 +82,14 @@ int syscall32_setup_pages(struct linux_b
 	return 0;
 }
 
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	if (vma->vm_start == VSYSCALL32_BASE &&
+	    vma->vm_mm && vma->vm_mm->task_size == IA32_PAGE_OFFSET)
+		return "[vdso]";
+	return NULL;
+}
+
 static int __init init_syscall32(void)
 { 
 	syscall32_page = (void *)get_zeroed_page(GFP_KERNEL); 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
sh-vdso-use-install_special_mappingpatch.patch
arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
