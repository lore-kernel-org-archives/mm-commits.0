From: akpm@linux-foundation.org
Subject: - powerpc-vdso_do_func_patch3264-must-be-__init.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:17:19 -0500
Message-ID: <200802150720.m1F7KfMD025844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbYBOH3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: vdso_do_func_patch{32,64}() must be __init
has been removed from the -mm tree.  Its filename was
     powerpc-vdso_do_func_patch3264-must-be-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: vdso_do_func_patch{32,64}() must be __init
From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0xe49c): Section mismatch in reference from the function .vdso_do_func_patch64() to the function .init.text:.find_symbol64()
WARNING: vmlinux.o(.text+0xe4d0): Section mismatch in reference from the function .vdso_do_func_patch64() to the function .init.text:.find_symbol64()
WARNING: vmlinux.o(.text+0xe56c): Section mismatch in reference from the function .vdso_do_func_patch32() to the function .init.text:.find_symbol32()
WARNING: vmlinux.o(.text+0xe5a0): Section mismatch in reference from the function .vdso_do_func_patch32() to the function .init.text:.find_symbol32()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vdso.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/kernel/vdso.c~powerpc-vdso_do_func_patch3264-must-be-__init arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~powerpc-vdso_do_func_patch3264-must-be-__init
+++ a/arch/powerpc/kernel/vdso.c
@@ -336,9 +336,9 @@ static unsigned long __init find_functio
 	return sym->st_value - VDSO32_LBASE;
 }
 
-static int vdso_do_func_patch32(struct lib32_elfinfo *v32,
-				struct lib64_elfinfo *v64,
-				const char *orig, const char *fix)
+static int __init vdso_do_func_patch32(struct lib32_elfinfo *v32,
+				       struct lib64_elfinfo *v64,
+				       const char *orig, const char *fix)
 {
 	Elf32_Sym *sym32_gen, *sym32_fix;
 
@@ -433,9 +433,9 @@ static unsigned long __init find_functio
 #endif
 }
 
-static int vdso_do_func_patch64(struct lib32_elfinfo *v32,
-				struct lib64_elfinfo *v64,
-				const char *orig, const char *fix)
+static int __init vdso_do_func_patch64(struct lib32_elfinfo *v32,
+				       struct lib64_elfinfo *v64,
+				       const char *orig, const char *fix)
 {
 	Elf64_Sym *sym64_gen, *sym64_fix;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-net.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
sparc-fix-build.patch
reiser4.patch
