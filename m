Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481F0C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 20:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2360660E90
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 20:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhJJUoP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 16:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231712AbhJJUoP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 16:44:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338A16023F;
        Sun, 10 Oct 2021 20:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633898536;
        bh=xaPSN7yBkDGoliJ/dEBEB2T8dKL59arX9IEgxOk/rLg=;
        h=Date:From:To:Subject:From;
        b=rxpdFTXAJbCk5Vc2RTnEHJwi7S+KFL59D+4dm7VnmWujvjG96OJqrdToBjXJpGKdH
         nBKPq/vDRvHsPeo3X90Bi8uuYh/zYuv+UIyNMLIrIJwdVNy4a5wyxYxB5LIGmzHTDb
         LmBT/Q+nRtzAUbpCGj9Y/JvpJpDNbODIGMBbWNBM=
Date:   Sun, 10 Oct 2021 13:42:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20211010204215.d-Mn-R7NZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig                |    3 -
 arch/riscv/include/asm/vdso.h     |    4 -
 arch/riscv/kernel/vdso.c          |   70 ----------------------------
 arch/riscv/kernel/vdso/vdso.lds.S |    3 -
 arch/x86/kernel/fpu/signal.c      |   11 ----
 tools/objtool/check.c             |    4 -
 6 files changed, 95 deletions(-)

--- a/arch/riscv/include/asm/vdso.h~linux-next-git-rejects
+++ a/arch/riscv/include/asm/vdso.h
@@ -22,11 +22,7 @@
  */
 #ifdef CONFIG_MMU
 
-<<<<<<< HEAD
-#define __VVAR_PAGES    1
-=======
 #define __VVAR_PAGES    2
->>>>>>> linux-next/akpm-base
 
 #ifndef __ASSEMBLY__
 #include <generated/vdso-offsets.h>
--- a/arch/riscv/Kconfig~linux-next-git-rejects
+++ a/arch/riscv/Kconfig
@@ -562,8 +562,5 @@ menu "Power management options"
 source "kernel/power/Kconfig"
 
 endmenu
-<<<<<<< HEAD
-=======
 
 source "arch/riscv/kvm/Kconfig"
->>>>>>> linux-next/akpm-base
--- a/arch/riscv/kernel/vdso.c~linux-next-git-rejects
+++ a/arch/riscv/kernel/vdso.c
@@ -13,10 +13,7 @@
 #include <linux/err.h>
 #include <asm/page.h>
 #include <asm/vdso.h>
-<<<<<<< HEAD
-=======
 #include <linux/time_namespace.h>
->>>>>>> linux-next/akpm-base
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 #include <vdso/datapage.h>
@@ -29,20 +26,11 @@ extern char vdso_start[], vdso_end[];
 
 enum vvar_pages {
 	VVAR_DATA_PAGE_OFFSET,
-<<<<<<< HEAD
-=======
 	VVAR_TIMENS_PAGE_OFFSET,
->>>>>>> linux-next/akpm-base
 	VVAR_NR_PAGES,
 };
 
 #define VVAR_SIZE  (VVAR_NR_PAGES << PAGE_SHIFT)
-<<<<<<< HEAD
-
-static unsigned int vdso_pages __ro_after_init;
-static struct page **vdso_pagelist __ro_after_init;
-=======
->>>>>>> linux-next/akpm-base
 
 /*
  * The vDSO data page.
@@ -84,18 +72,9 @@ static int __init __vdso_init(void)
 	struct page **vdso_pagelist;
 	unsigned long pfn;
 
-<<<<<<< HEAD
-	vdso_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
-	vdso_pagelist =
-		kcalloc(vdso_pages + VVAR_NR_PAGES, sizeof(struct page *), GFP_KERNEL);
-	if (unlikely(vdso_pagelist == NULL)) {
-		pr_err("vdso: pagelist allocation failed\n");
-		return -ENOMEM;
-=======
 	if (memcmp(vdso_info.vdso_code_start, "\177ELF", 4)) {
 		pr_err("vDSO is not a valid ELF object!\n");
 		return -EINVAL;
->>>>>>> linux-next/akpm-base
 	}
 
 	vdso_info.vdso_pages = (
@@ -242,67 +221,28 @@ static int __setup_additional_pages(stru
 
 	BUILD_BUG_ON(VVAR_NR_PAGES != __VVAR_PAGES);
 
-<<<<<<< HEAD
-	BUILD_BUG_ON(VVAR_NR_PAGES != __VVAR_PAGES);
-
-	vdso_len = (vdso_pages + VVAR_NR_PAGES) << PAGE_SHIFT;
-
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
-	vdso_base = get_unmapped_area(NULL, 0, vdso_len, 0, 0);
-=======
 	vdso_text_len = vdso_info.vdso_pages << PAGE_SHIFT;
 	/* Be sure to map the data page */
 	vdso_mapping_len = vdso_text_len + VVAR_SIZE;
 
 	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
->>>>>>> linux-next/akpm-base
 	if (IS_ERR_VALUE(vdso_base)) {
 		ret = ERR_PTR(vdso_base);
 		goto up_fail;
 	}
 
-<<<<<<< HEAD
-	mm->context.vdso = NULL;
-	ret = install_special_mapping(mm, vdso_base, VVAR_SIZE,
-		(VM_READ | VM_MAYREAD), &vdso_pagelist[vdso_pages]);
-	if (unlikely(ret))
-		goto end;
-=======
 	ret = _install_special_mapping(mm, vdso_base, VVAR_SIZE,
 		(VM_READ | VM_MAYREAD | VM_PFNMAP), vdso_info.dm);
 	if (IS_ERR(ret))
 		goto up_fail;
->>>>>>> linux-next/akpm-base
 
 	vdso_base += VVAR_SIZE;
 	mm->context.vdso = (void *)vdso_base;
 	ret =
-<<<<<<< HEAD
-	   install_special_mapping(mm, vdso_base + VVAR_SIZE,
-		vdso_pages << PAGE_SHIFT,
-=======
 	   _install_special_mapping(mm, vdso_base, vdso_text_len,
->>>>>>> linux-next/akpm-base
 		(VM_READ | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC),
 		vdso_info.cm);
 
-<<<<<<< HEAD
-	if (unlikely(ret))
-		goto end;
-
-	/*
-	 * Put vDSO base into mm struct. We need to do this before calling
-	 * install_special_mapping or the perf counter mmap tracking code
-	 * will fail to recognise it as a vDSO (since arch_vma_name fails).
-	 */
-	mm->context.vdso = (void *)vdso_base + VVAR_SIZE;
-
-end:
-	mmap_write_unlock(mm);
-	return ret;
-=======
 	if (IS_ERR(ret))
 		goto up_fail;
 
@@ -311,19 +251,10 @@ end:
 up_fail:
 	mm->context.vdso = NULL;
 	return PTR_ERR(ret);
->>>>>>> linux-next/akpm-base
 }
 
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
-<<<<<<< HEAD
-	if (vma->vm_mm && (vma->vm_start == (long)vma->vm_mm->context.vdso))
-		return "[vdso]";
-	if (vma->vm_mm && (vma->vm_start ==
-			   (long)vma->vm_mm->context.vdso - VVAR_SIZE))
-		return "[vdso_data]";
-	return NULL;
-=======
 	struct mm_struct *mm = current->mm;
 	int ret;
 
@@ -334,5 +265,4 @@ int arch_setup_additional_pages(struct l
 	mmap_write_unlock(mm);
 
 	return ret;
->>>>>>> linux-next/akpm-base
 }
--- a/arch/riscv/kernel/vdso/vdso.lds.S~linux-next-git-rejects
+++ a/arch/riscv/kernel/vdso/vdso.lds.S
@@ -10,12 +10,9 @@ OUTPUT_ARCH(riscv)
 SECTIONS
 {
 	PROVIDE(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE);
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_TIME_NS
 	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE);
 #endif
->>>>>>> linux-next/akpm-base
 	. = SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
--- a/arch/x86/kernel/fpu/signal.c~linux-next-git-rejects
+++ a/arch/x86/kernel/fpu/signal.c
@@ -384,19 +384,8 @@ static bool __fpu_restore_sig(void __use
 				     sizeof(fpu->state.fxsave)))
 			return false;
 
-<<<<<<< HEAD
-		if (IS_ENABLED(CONFIG_X86_64)) {
-			/* Reject invalid MXCSR values. */
-			if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
-				return -EINVAL;
-		} else {
-			/* Mask invalid bits out for historical reasons (broken hardware). */
-			fpu->state.fxsave.mxcsr &= ~mxcsr_feature_mask;
-		}
-=======
 		/* Mask out reserved MXCSR bits. */
 		fpu->state.fxsave.mxcsr &= mxcsr_feature_mask;
->>>>>>> linux-next/akpm-base
 
 		/* Enforce XFEATURE_MASK_FPSSE when XSAVE is enabled */
 		if (use_xsave())
--- a/tools/objtool/check.c~linux-next-git-rejects
+++ a/tools/objtool/check.c
@@ -382,11 +382,7 @@ static int decode_instructions(struct ob
 			insn->sec = sec;
 			insn->offset = offset;
 
-<<<<<<< HEAD
-			ret = arch_decode_instruction(file->elf, sec, offset,
-=======
 			ret = arch_decode_instruction(file, sec, offset,
->>>>>>> linux-next/akpm-base
 						      sec->sh.sh_size - offset,
 						      &insn->len, &insn->type,
 						      &insn->immediate,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

elfcore-correct-reference-to-config_uml-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

