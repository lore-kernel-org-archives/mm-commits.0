From: akpm@osdl.org
Subject: + fix-gate_vmavm_flags.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:48:50 -0800
Message-ID: <200701231948.l0NJmo1o029442@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51729 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965455AbXAWTtp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:49:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org


The patch titled
     Fix gate_vma.vm_flags
has been added to the -mm tree.  Its filename is
     fix-gate_vmavm_flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix gate_vma.vm_flags
From: Roland McGrath <roland@redhat.com>

This patch fixes the initialization of gate_vma.vm_flags and
gate_vma.vm_page_prot to reflect reality.  This makes the "[vdso]" line in
/proc/PID/maps correctly show r-xp instead of ---p, when gate_vma is used
(CONFIG_COMPAT_VDSO on i386).

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~fix-gate_vmavm_flags mm/memory.c
--- a/mm/memory.c~fix-gate_vmavm_flags
+++ a/mm/memory.c
@@ -2606,8 +2606,8 @@ static int __init gate_vma_init(void)
 	gate_vma.vm_mm = NULL;
 	gate_vma.vm_start = FIXADDR_USER_START;
 	gate_vma.vm_end = FIXADDR_USER_END;
-	gate_vma.vm_page_prot = PAGE_READONLY;
-	gate_vma.vm_flags = 0;
+	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
+	gate_vma.vm_page_prot = __P101;
 	return 0;
 }
 __initcall(gate_vma_init);
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
