Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031B8C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 19:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243972AbiESTaX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 15:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbiESTaV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 15:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5FA9B197
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 12:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D172861B6D
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 19:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385C6C385AA;
        Thu, 19 May 2022 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652988619;
        bh=/Gkvn2ElvBrE/0ESb95g74SWuKMU+xPk5v+Ntzp7BZk=;
        h=Date:To:From:Subject:From;
        b=WYczDb+YLDGq4kx+gXjrMfUZ63DA+137H2PY2PfqEr3hOOPicMWfdWhLsy+eGgvZc
         DLt+NEs6weYvtgkmL6GHmb9RMfIhTCr1vnHLCG75oaRYTDtYEuqAbCS0xq6FNG38oE
         MostZ4krYc/PkAUzBReLVhqMIoqK0NBrxVgdMijo=
Date:   Thu, 19 May 2022 12:30:18 -0700
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        naveen.n.rao@linux.vnet.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations.patch added to mm-nonmm-unstable branch
Message-Id: <20220519193019.385C6C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file: Drop weak attribute from arch_kexec_apply_relocations[_add]
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: kexec_file: Drop weak attribute from arch_kexec_apply_relocations[_add]
Date: Thu, 19 May 2022 14:42:37 +0530

Since commit d1bcae833b32f1 ("ELF: Don't generate unused section
symbols") [1], binutils (v2.36+) started dropping section symbols that
it thought were unused.  This isn't an issue in general, but with
kexec_file.c, gcc is placing kexec_arch_apply_relocations[_add] into a
separate .text.unlikely section and the section symbol ".text.unlikely"
is being dropped. Due to this, recordmcount is unable to find a non-weak
symbol in .text.unlikely to generate a relocation record against.

Address this by dropping the weak attribute from these functions.
Instead, follow the existing pattern of having architectures #define the
name of the function they want to override in their headers.

[1] https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=d1bcae833b32f1

Link: https://lkml.kernel.org/r/20220519091237.676736-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/kexec.h |    8 +++++
 arch/x86/include/asm/kexec.h  |    8 +++++
 include/linux/kexec.h         |   46 ++++++++++++++++++++++++++------
 kernel/kexec_file.c           |   34 -----------------------
 4 files changed, 54 insertions(+), 42 deletions(-)

--- a/arch/s390/include/asm/kexec.h~kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations
+++ a/arch/s390/include/asm/kexec.h
@@ -83,4 +83,12 @@ struct kimage_arch {
 extern const struct kexec_file_ops s390_kexec_image_ops;
 extern const struct kexec_file_ops s390_kexec_elf_ops;
 
+#ifdef CONFIG_KEXEC_FILE
+struct purgatory_info;
+int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
+				     Elf_Shdr *section,
+				     const Elf_Shdr *relsec,
+				     const Elf_Shdr *symtab);
+#define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+#endif
 #endif /*_S390_KEXEC_H */
--- a/arch/x86/include/asm/kexec.h~kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations
+++ a/arch/x86/include/asm/kexec.h
@@ -186,6 +186,14 @@ extern int arch_kexec_post_alloc_pages(v
 extern void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages);
 #define arch_kexec_pre_free_pages arch_kexec_pre_free_pages
 
+#ifdef CONFIG_KEXEC_FILE
+struct purgatory_info;
+int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
+				     Elf_Shdr *section,
+				     const Elf_Shdr *relsec,
+				     const Elf_Shdr *symtab);
+#define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+#endif
 #endif
 
 typedef void crash_vmclear_fn(void);
--- a/include/linux/kexec.h~kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations
+++ a/include/linux/kexec.h
@@ -193,14 +193,6 @@ void *kexec_purgatory_get_symbol_addr(st
 int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
 				  unsigned long buf_len);
 void *arch_kexec_kernel_image_load(struct kimage *image);
-int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
-				     Elf_Shdr *section,
-				     const Elf_Shdr *relsec,
-				     const Elf_Shdr *symtab);
-int arch_kexec_apply_relocations(struct purgatory_info *pi,
-				 Elf_Shdr *section,
-				 const Elf_Shdr *relsec,
-				 const Elf_Shdr *symtab);
 int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #ifdef CONFIG_KEXEC_SIG
 int arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
@@ -229,6 +221,44 @@ extern int crash_exclude_mem_range(struc
 				   unsigned long long mend);
 extern int crash_prepare_elf64_headers(struct crash_mem *mem, int kernel_map,
 				       void **addr, unsigned long *sz);
+
+#ifndef arch_kexec_apply_relocations_add
+/*
+ * arch_kexec_apply_relocations_add - apply relocations of type RELA
+ * @pi:		Purgatory to be relocated.
+ * @section:	Section relocations applying to.
+ * @relsec:	Section containing RELAs.
+ * @symtab:	Corresponding symtab.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static inline int
+arch_kexec_apply_relocations_add(struct purgatory_info *pi, Elf_Shdr *section,
+				 const Elf_Shdr *relsec, const Elf_Shdr *symtab)
+{
+	pr_err("RELA relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
+
+#ifndef arch_kexec_apply_relocations
+/*
+ * arch_kexec_apply_relocations - apply relocations of type REL
+ * @pi:		Purgatory to be relocated.
+ * @section:	Section relocations applying to.
+ * @relsec:	Section containing RELs.
+ * @symtab:	Corresponding symtab.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static inline int
+arch_kexec_apply_relocations(struct purgatory_info *pi, Elf_Shdr *section,
+			     const Elf_Shdr *relsec, const Elf_Shdr *symtab)
+{
+	pr_err("REL relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
 #endif /* CONFIG_KEXEC_FILE */
 
 #ifdef CONFIG_KEXEC_ELF
--- a/kernel/kexec_file.c~kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations
+++ a/kernel/kexec_file.c
@@ -109,40 +109,6 @@ int __weak arch_kexec_kernel_verify_sig(
 #endif
 
 /*
- * arch_kexec_apply_relocations_add - apply relocations of type RELA
- * @pi:		Purgatory to be relocated.
- * @section:	Section relocations applying to.
- * @relsec:	Section containing RELAs.
- * @symtab:	Corresponding symtab.
- *
- * Return: 0 on success, negative errno on error.
- */
-int __weak
-arch_kexec_apply_relocations_add(struct purgatory_info *pi, Elf_Shdr *section,
-				 const Elf_Shdr *relsec, const Elf_Shdr *symtab)
-{
-	pr_err("RELA relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
-/*
- * arch_kexec_apply_relocations - apply relocations of type REL
- * @pi:		Purgatory to be relocated.
- * @section:	Section relocations applying to.
- * @relsec:	Section containing RELs.
- * @symtab:	Corresponding symtab.
- *
- * Return: 0 on success, negative errno on error.
- */
-int __weak
-arch_kexec_apply_relocations(struct purgatory_info *pi, Elf_Shdr *section,
-			     const Elf_Shdr *relsec, const Elf_Shdr *symtab)
-{
-	pr_err("REL relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
-/*
  * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have
  * been loaded into separate segments and have been copied elsewhere.
_

Patches currently in -mm which might be from naveen.n.rao@linux.vnet.ibm.com are

kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations.patch

