From: akpm@linux-foundation.org
Subject: - x86_64-fix-arch_vma_name.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:10 -0700
Message-ID: <200707290612.l6T6CAJg011106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759529AbXG2GXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix arch_vma_name
has been removed from the -mm tree.  Its filename was
     x86_64-fix-arch_vma_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix arch_vma_name
From: Roland McGrath <roland@redhat.com>

The function arch_vma_name() is declared weak and thus it was
not noticed that x86_64 had two almost identical implementations.

It was introduced in syscall32.c by: c633090e3105e779c97d4978e5e3d7d66b291cfb
It was introduced in mm/init.c by: 2aae950b21e4bc789d1fc6668faf67e8748300b7

Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32_binfmt.c |    5 +++--
 arch/x86_64/ia32/syscall32.c   |    8 --------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN arch/x86_64/ia32/ia32_binfmt.c~x86_64-fix-arch_vma_name arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~x86_64-fix-arch_vma_name
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -41,8 +41,9 @@ int sysctl_vsyscall32 = 1;
 #undef ARCH_DLINFO
 #define ARCH_DLINFO do {  \
 	if (sysctl_vsyscall32) { \
-	NEW_AUX_ENT(AT_SYSINFO, (u32)(u64)VSYSCALL32_VSYSCALL); \
-	NEW_AUX_ENT(AT_SYSINFO_EHDR, VSYSCALL32_BASE);    \
+		current->mm->context.vdso = (void *)VSYSCALL32_BASE;	\
+		NEW_AUX_ENT(AT_SYSINFO, (u32)(u64)VSYSCALL32_VSYSCALL); \
+		NEW_AUX_ENT(AT_SYSINFO_EHDR, VSYSCALL32_BASE);    \
 	}	\
 } while(0)
 
diff -puN arch/x86_64/ia32/syscall32.c~x86_64-fix-arch_vma_name arch/x86_64/ia32/syscall32.c
--- a/arch/x86_64/ia32/syscall32.c~x86_64-fix-arch_vma_name
+++ a/arch/x86_64/ia32/syscall32.c
@@ -49,14 +49,6 @@ int syscall32_setup_pages(struct linux_b
 	return ret;
 }
 
-const char *arch_vma_name(struct vm_area_struct *vma)
-{
-	if (vma->vm_start == VSYSCALL32_BASE &&
-	    vma->vm_mm && vma->vm_mm->task_size == IA32_PAGE_OFFSET)
-		return "[vdso]";
-	return NULL;
-}
-
 static int __init init_syscall32(void)
 { 
 	char *syscall32_page = (void *)get_zeroed_page(GFP_KERNEL);
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
