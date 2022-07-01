Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23D0C43334
	for <mm-commits@archiver.kernel.org>; Fri,  1 Jul 2022 22:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiGAWqY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 18:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGAWqW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 18:46:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285937124A
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 15:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B15E5B8323C
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 22:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAD5C341C8;
        Fri,  1 Jul 2022 22:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656715578;
        bh=sRKvjPaGC8TbA0+wJqYbtzh0aNaPv6h/RIQj6w3ascI=;
        h=Date:To:From:Subject:From;
        b=t29L4O5Qnmff+h3psZJsUEi03nvILZW2ILEpJUapLF+uvp3UJRpJo7Sf5GzktRoMQ
         aS0TaY16Lf2Co6x0jvD7/mYcrGokwZY3BCNCdOhwihYB5ze9tGl6qpqgaZoGJ6FYWI
         +iGjb0GtZYc3SqUc9YLozSKipIql+kSnqyJnWdm4=
Date:   Fri, 01 Jul 2022 15:46:17 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        naveen.n.rao@linux.vnet.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-drop-weak-attribute-from-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20220701224618.4DAD5C341C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: drop weak attribute from functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-drop-weak-attribute-from-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-drop-weak-attribute-from-functions.patch

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
Subject: kexec: drop weak attribute from functions
Date: Fri, 1 Jul 2022 13:04:05 +0530

Drop __weak attribute from functions in kexec_core.c:
- machine_kexec_post_load()
- arch_kexec_protect_crashkres()
- arch_kexec_unprotect_crashkres()
- crash_free_reserved_phys_range()

Link: https://lkml.kernel.org/r/c0f6219e03cb399d166d518ab505095218a902dd.1656659357.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Suggested-by: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kexec.h   |   16 ++++++++++++--
 arch/powerpc/include/asm/kexec.h |    5 ++++
 arch/s390/include/asm/kexec.h    |   11 +++++++++
 arch/x86/include/asm/kexec.h     |    6 +++++
 include/linux/kexec.h            |   32 +++++++++++++++++++++++++----
 kernel/kexec_core.c              |   27 ------------------------
 6 files changed, 64 insertions(+), 33 deletions(-)

--- a/arch/arm64/include/asm/kexec.h~kexec-drop-weak-attribute-from-functions
+++ a/arch/arm64/include/asm/kexec.h
@@ -84,16 +84,30 @@ static inline void crash_setup_regs(stru
 extern bool crash_is_nosave(unsigned long pfn);
 extern void crash_prepare_suspend(void);
 extern void crash_post_resume(void);
+
+void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
+#define crash_free_reserved_phys_range crash_free_reserved_phys_range
 #else
 static inline bool crash_is_nosave(unsigned long pfn) {return false; }
 static inline void crash_prepare_suspend(void) {}
 static inline void crash_post_resume(void) {}
 #endif
 
+struct kimage;
+
 #if defined(CONFIG_KEXEC_CORE)
 void cpu_soft_restart(unsigned long el2_switch, unsigned long entry,
 		      unsigned long arg0, unsigned long arg1,
 		      unsigned long arg2);
+
+int machine_kexec_post_load(struct kimage *image);
+#define machine_kexec_post_load machine_kexec_post_load
+
+void arch_kexec_protect_crashkres(void);
+#define arch_kexec_protect_crashkres arch_kexec_protect_crashkres
+
+void arch_kexec_unprotect_crashkres(void);
+#define arch_kexec_unprotect_crashkres arch_kexec_unprotect_crashkres
 #endif
 
 #define ARCH_HAS_KIMAGE_ARCH
@@ -113,8 +127,6 @@ struct kimage_arch {
 #ifdef CONFIG_KEXEC_FILE
 extern const struct kexec_file_ops kexec_image_ops;
 
-struct kimage;
-
 int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 
--- a/arch/powerpc/include/asm/kexec.h~kexec-drop-weak-attribute-from-functions
+++ a/arch/powerpc/include/asm/kexec.h
@@ -98,6 +98,11 @@ void relocate_new_kernel(unsigned long i
 
 void kexec_copy_flush(struct kimage *image);
 
+#if defined(CONFIG_CRASH_DUMP) && defined(CONFIG_PPC_RTAS)
+void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
+#define crash_free_reserved_phys_range crash_free_reserved_phys_range
+#endif
+
 #ifdef CONFIG_KEXEC_FILE
 extern const struct kexec_file_ops kexec_elf64_ops;
 
--- a/arch/s390/include/asm/kexec.h~kexec-drop-weak-attribute-from-functions
+++ a/arch/s390/include/asm/kexec.h
@@ -85,6 +85,17 @@ struct kimage_arch {
 extern const struct kexec_file_ops s390_kexec_image_ops;
 extern const struct kexec_file_ops s390_kexec_elf_ops;
 
+#ifdef CONFIG_CRASH_DUMP
+void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
+#define crash_free_reserved_phys_range crash_free_reserved_phys_range
+
+void arch_kexec_protect_crashkres(void);
+#define arch_kexec_protect_crashkres arch_kexec_protect_crashkres
+
+void arch_kexec_unprotect_crashkres(void);
+#define arch_kexec_unprotect_crashkres arch_kexec_unprotect_crashkres
+#endif
+
 #ifdef CONFIG_KEXEC_FILE
 struct purgatory_info;
 int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
--- a/arch/x86/include/asm/kexec.h~kexec-drop-weak-attribute-from-functions
+++ a/arch/x86/include/asm/kexec.h
@@ -186,6 +186,12 @@ extern int arch_kexec_post_alloc_pages(v
 extern void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages);
 #define arch_kexec_pre_free_pages arch_kexec_pre_free_pages
 
+void arch_kexec_protect_crashkres(void);
+#define arch_kexec_protect_crashkres arch_kexec_protect_crashkres
+
+void arch_kexec_unprotect_crashkres(void);
+#define arch_kexec_unprotect_crashkres arch_kexec_unprotect_crashkres
+
 #ifdef CONFIG_KEXEC_FILE
 struct purgatory_info;
 int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
--- a/include/linux/kexec.h~kexec-drop-weak-attribute-from-functions
+++ a/include/linux/kexec.h
@@ -390,7 +390,10 @@ extern void machine_kexec_cleanup(struct
 extern int kernel_kexec(void);
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
-int machine_kexec_post_load(struct kimage *image);
+
+#ifndef machine_kexec_post_load
+static inline int machine_kexec_post_load(struct kimage *image) { return 0; }
+#endif
 
 extern void __crash_kexec(struct pt_regs *);
 extern void crash_kexec(struct pt_regs *);
@@ -423,10 +426,21 @@ extern bool kexec_in_progress;
 
 int crash_shrink_memory(unsigned long new_size);
 size_t crash_get_memory_size(void);
-void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
 
-void arch_kexec_protect_crashkres(void);
-void arch_kexec_unprotect_crashkres(void);
+#ifndef arch_kexec_protect_crashkres
+/*
+ * Protection mechanism for crashkernel reserved memory after
+ * the kdump kernel is loaded.
+ *
+ * Provide an empty default implementation here -- architecture
+ * code may override this
+ */
+static inline void arch_kexec_protect_crashkres(void) { }
+#endif
+
+#ifndef arch_kexec_unprotect_crashkres
+static inline void arch_kexec_unprotect_crashkres(void) { }
+#endif
 
 #ifndef page_to_boot_pfn
 static inline unsigned long page_to_boot_pfn(struct page *page)
@@ -456,6 +470,16 @@ static inline phys_addr_t boot_phys_to_p
 }
 #endif
 
+#ifndef crash_free_reserved_phys_range
+static inline void crash_free_reserved_phys_range(unsigned long begin, unsigned long end)
+{
+	unsigned long addr;
+
+	for (addr = begin; addr < end; addr += PAGE_SIZE)
+		free_reserved_page(boot_pfn_to_page(addr >> PAGE_SHIFT));
+}
+#endif
+
 static inline unsigned long virt_to_boot_phys(void *addr)
 {
 	return phys_to_boot_phys(__pa((unsigned long)addr));
--- a/kernel/kexec_core.c~kexec-drop-weak-attribute-from-functions
+++ a/kernel/kexec_core.c
@@ -591,11 +591,6 @@ static void kimage_free_extra_pages(stru
 
 }
 
-int __weak machine_kexec_post_load(struct kimage *image)
-{
-	return 0;
-}
-
 void kimage_terminate(struct kimage *image)
 {
 	if (*image->entry != 0)
@@ -1020,15 +1015,6 @@ size_t crash_get_memory_size(void)
 	return size;
 }
 
-void __weak crash_free_reserved_phys_range(unsigned long begin,
-					   unsigned long end)
-{
-	unsigned long addr;
-
-	for (addr = begin; addr < end; addr += PAGE_SIZE)
-		free_reserved_page(boot_pfn_to_page(addr >> PAGE_SHIFT));
-}
-
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
@@ -1225,16 +1211,3 @@ int kernel_kexec(void)
 	mutex_unlock(&kexec_mutex);
 	return error;
 }
-
-/*
- * Protection mechanism for crashkernel reserved memory after
- * the kdump kernel is loaded.
- *
- * Provide an empty default implementation here -- architecture
- * code may override this
- */
-void __weak arch_kexec_protect_crashkres(void)
-{}
-
-void __weak arch_kexec_unprotect_crashkres(void)
-{}
_

Patches currently in -mm which might be from naveen.n.rao@linux.vnet.ibm.com are

kexec_file-drop-weak-attribute-from-functions.patch
kexec-drop-weak-attribute-from-functions.patch

