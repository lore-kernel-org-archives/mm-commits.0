From: akpm@osdl.org
Subject: + powerpc-vdso-use-vm_alwaysdump.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:49:01 -0800
Message-ID: <200701231949.l0NJn10a029457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51752 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461AbXAWTuC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:50:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org


The patch titled
     powerpc vDSO: use VM_ALWAYSDUMP
has been added to the -mm tree.  Its filename is
     powerpc-vdso-use-vm_alwaysdump.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc vDSO: use VM_ALWAYSDUMP
From: Roland McGrath <roland@redhat.com>

This patch fixes core dumps to include the vDSO vma, which is left out now.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/kernel/vdso.c |    7 +++++++
 1 files changed, 7 insertions(+)

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

fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
