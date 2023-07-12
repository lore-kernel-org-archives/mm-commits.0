Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA006C001B0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 19:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjGLTQK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 15:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjGLTQJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 15:16:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303A1199E
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 12:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB991618BF
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 19:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203F2C433C9;
        Wed, 12 Jul 2023 19:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689189363;
        bh=mRDRsX72n5dSXeUe7WzN++/wsb/Wqf6owbOM/HwsUw4=;
        h=Date:To:From:Subject:From;
        b=fTe3CRd1bmWHmMHFtLvLzUyxa04vw+nis67FDCrVgk8VRhsFA3xsB+3JmzAqAfXTo
         J30cMPjj62rz2ZAZs08baGEn5lUzj8ElfTKgpqlahxlJJfvLmpIOxFD3J71Bbgo/l+
         B9UMzZAcyJjiH276hkXdfb2KCP1NKpCTYYlK/8yw=
Date:   Wed, 12 Jul 2023 12:16:02 -0700
To:     mm-commits@vger.kernel.org, eric.devolder@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-rename-arch_has_kexec_purgatory.patch added to mm-nonmm-unstable branch
Message-Id: <20230712191603.203F2C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: rename ARCH_HAS_KEXEC_PURGATORY
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-rename-arch_has_kexec_purgatory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-rename-arch_has_kexec_purgatory.patch

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
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: kexec: rename ARCH_HAS_KEXEC_PURGATORY
Date: Wed, 12 Jul 2023 12:15:45 -0400

The Kconfig refactor to consolidate KEXEC and CRASH options utilized
option names of the form ARCH_SUPPORTS_<option>. Thus rename the
ARCH_HAS_KEXEC_PURGATORY to ARCH_SUPPORTS_KEXEC_PURGATORY to follow
the same.

Link: https://lkml.kernel.org/r/20230712161545.87870-15-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig          |    2 +-
 arch/riscv/Kbuild             |    2 +-
 arch/riscv/Kconfig            |    2 +-
 arch/riscv/kernel/elf_kexec.c |    4 ++--
 arch/s390/Kbuild              |    2 +-
 arch/s390/Kconfig             |    2 +-
 arch/x86/Kconfig              |    2 +-
 kernel/kexec_file.c           |    6 +++---
 8 files changed, 11 insertions(+), 11 deletions(-)

--- a/arch/powerpc/Kconfig~kexec-rename-arch_has_kexec_purgatory
+++ a/arch/powerpc/Kconfig
@@ -596,7 +596,7 @@ config ARCH_SUPPORTS_KEXEC
 config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool PPC64 && CRYPTO=y && CRYPTO_SHA256=y
 
-config ARCH_HAS_KEXEC_PURGATORY
+config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool KEXEC_FILE
 
 config ARCH_SELECTS_KEXEC_FILE
--- a/arch/riscv/Kbuild~kexec-rename-arch_has_kexec_purgatory
+++ a/arch/riscv/Kbuild
@@ -5,7 +5,7 @@ obj-$(CONFIG_BUILTIN_DTB) += boot/dts/
 obj-y += errata/
 obj-$(CONFIG_KVM) += kvm/
 
-obj-$(CONFIG_ARCH_HAS_KEXEC_PURGATORY) += purgatory/
+obj-$(CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY) += purgatory/
 
 # for cleaning
 subdir- += boot
--- a/arch/riscv/Kconfig~kexec-rename-arch_has_kexec_purgatory
+++ a/arch/riscv/Kconfig
@@ -667,7 +667,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	select HAVE_IMA_KEXEC if IMA
 	select KEXEC_ELF
 
-config ARCH_HAS_KEXEC_PURGATORY
+config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool KEXEC_FILE
 	depends on CRYPTO=y
 	depends on CRYPTO_SHA256=y
--- a/arch/riscv/kernel/elf_kexec.c~kexec-rename-arch_has_kexec_purgatory
+++ a/arch/riscv/kernel/elf_kexec.c
@@ -260,7 +260,7 @@ static void *elf_kexec_load(struct kimag
 		cmdline = modified_cmdline;
 	}
 
-#ifdef CONFIG_ARCH_HAS_KEXEC_PURGATORY
+#ifdef CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY
 	/* Add purgatory to the image */
 	kbuf.top_down = true;
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
@@ -274,7 +274,7 @@ static void *elf_kexec_load(struct kimag
 					     sizeof(kernel_start), 0);
 	if (ret)
 		pr_err("Error update purgatory ret=%d\n", ret);
-#endif /* CONFIG_ARCH_HAS_KEXEC_PURGATORY */
+#endif /* CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY */
 
 	/* Add the initrd to the image */
 	if (initrd != NULL) {
--- a/arch/s390/Kbuild~kexec-rename-arch_has_kexec_purgatory
+++ a/arch/s390/Kbuild
@@ -7,7 +7,7 @@ obj-$(CONFIG_S390_HYPFS_FS)	+= hypfs/
 obj-$(CONFIG_APPLDATA_BASE)	+= appldata/
 obj-y				+= net/
 obj-$(CONFIG_PCI)		+= pci/
-obj-$(CONFIG_ARCH_HAS_KEXEC_PURGATORY) += purgatory/
+obj-$(CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY) += purgatory/
 
 # for cleaning
 subdir- += boot tools
--- a/arch/s390/Kconfig~kexec-rename-arch_has_kexec_purgatory
+++ a/arch/s390/Kconfig
@@ -258,7 +258,7 @@ config ARCH_SUPPORTS_KEXEC_FILE
 config ARCH_SUPPORTS_KEXEC_SIG
 	def_bool MODULE_SIG_FORMAT
 
-config ARCH_HAS_KEXEC_PURGATORY
+config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool KEXEC_FILE
 
 config ARCH_SUPPORTS_CRASH_DUMP
--- a/arch/x86/Kconfig~kexec-rename-arch_has_kexec_purgatory
+++ a/arch/x86/Kconfig
@@ -2051,7 +2051,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	depends on KEXEC_FILE
 	select HAVE_IMA_KEXEC if IMA
 
-config ARCH_HAS_KEXEC_PURGATORY
+config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool KEXEC_FILE
 
 config ARCH_SUPPORTS_KEXEC_SIG
--- a/kernel/kexec_file.c~kexec-rename-arch_has_kexec_purgatory
+++ a/kernel/kexec_file.c
@@ -685,7 +685,7 @@ static int kexec_calculate_store_digests
 	struct kexec_sha_region *sha_regions;
 	struct purgatory_info *pi = &image->purgatory_info;
 
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_KEXEC_PURGATORY))
+	if (!IS_ENABLED(CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY))
 		return 0;
 
 	zero_buf = __va(page_to_pfn(ZERO_PAGE(0)) << PAGE_SHIFT);
@@ -790,7 +790,7 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_ARCH_HAS_KEXEC_PURGATORY
+#ifdef CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY
 /*
  * kexec_purgatory_setup_kbuf - prepare buffer to load purgatory.
  * @pi:		Purgatory to be loaded.
@@ -1150,7 +1150,7 @@ int kexec_purgatory_get_set_symbol(struc
 
 	return 0;
 }
-#endif /* CONFIG_ARCH_HAS_KEXEC_PURGATORY */
+#endif /* CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY */
 
 int crash_exclude_mem_range(struct crash_mem *mem,
 			    unsigned long long mstart, unsigned long long mend)
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
x86-kexec-refactor-for-kernel-kconfigkexec.patch
arm-kexec-refactor-for-kernel-kconfigkexec.patch
ia64-kexec-refactor-for-kernel-kconfigkexec.patch
arm64-kexec-refactor-for-kernel-kconfigkexec.patch
loongarch-kexec-refactor-for-kernel-kconfigkexec.patch
m68k-kexec-refactor-for-kernel-kconfigkexec.patch
mips-kexec-refactor-for-kernel-kconfigkexec.patch
parisc-kexec-refactor-for-kernel-kconfigkexec.patch
powerpc-kexec-refactor-for-kernel-kconfigkexec.patch
riscv-kexec-refactor-for-kernel-kconfigkexec.patch
s390-kexec-refactor-for-kernel-kconfigkexec.patch
sh-kexec-refactor-for-kernel-kconfigkexec.patch
kexec-rename-arch_has_kexec_purgatory.patch

