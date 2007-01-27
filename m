From: akpm@osdl.org
Subject: - powerpc-vdso-use-vm_alwaysdump.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:29 -0800
Message-ID: <200701270131.l0R1VTTf031837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35538 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbXA0BcO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc vDSO: use VM_ALWAYSDUMP
has been removed from the -mm tree.  Its filename was
     powerpc-vdso-use-vm_alwaysdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc vDSO: use VM_ALWAYSDUMP
From: Roland McGrath <roland@redhat.com>

This patch fixes core dumps to include the vDSO vma, which is left out now.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/kernel/vdso.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/powerpc/kernel/vdso.c~powerpc-vdso-use-vm_alwaysdump arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~powerpc-vdso-use-vm_alwaysdump
+++ a/arch/powerpc/kernel/vdso.c
@@ -284,6 +284,13 @@ int arch_setup_additional_pages(struct l
 	 * pages though
 	 */
 	vma->vm_flags = VM_READ|VM_EXEC|VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC;
+	/*
+	 * Make sure the vDSO gets into every core dump.
+	 * Dumping its contents makes post-mortem fully interpretable later
+	 * without matching up the same kernel and hardware config to see
+	 * what PC values meant.
+	 */
+	vma->vm_flags |= VM_ALWAYSDUMP;
 	vma->vm_flags |= mm->def_flags;
 	vma->vm_page_prot = protection_map[vma->vm_flags & 0x7];
 	vma->vm_ops = &vdso_vmops;
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
