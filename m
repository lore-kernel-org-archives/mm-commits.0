Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC939C04FDF
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjHLWF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjHLWFp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D519A7
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7099261046
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A14C433C8;
        Sat, 12 Aug 2023 22:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877938;
        bh=VWaKZ5ssZ5e7zOIgHclD375JQ8zYH6Yvd0xGZhyi1f8=;
        h=Date:To:From:Subject:From;
        b=V9EeYMuHyo4Bu9fh+5UvWZ4iV6Okp9CUDPvGPdy5ew/CRGJn/G45LyfRJRxIXlyFD
         Ys4hThDSrTZVJeSfNKYgos3kjpV33TB1JJxsVHU3DLJnx5aD1KqUW2j/HfAaiJ4zMo
         WtGddlPYi5USHjQ8vlQnVmFe0KTbjT9g4Fvqzx7c=
Date:   Sat, 12 Aug 2023 15:05:38 -0700
To:     mm-commits@vger.kernel.org, eric.devolder@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-rename-arch_has_kexec_purgatory.patch removed from -mm tree
Message-Id: <20230812220538.C4A14C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: rename ARCH_HAS_KEXEC_PURGATORY
has been removed from the -mm tree.  Its filename was
     kexec-rename-arch_has_kexec_purgatory.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -595,7 +595,7 @@ config ARCH_SUPPORTS_KEXEC
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
@@ -257,7 +257,7 @@ config ARCH_SUPPORTS_KEXEC_FILE
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

crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
crash-add-generic-infrastructure-for-crash-hotplug-support.patch
kexec-exclude-elfcorehdr-from-the-segment-digest.patch
crash-memory-and-cpu-hotplug-sysfs-attributes.patch
x86-crash-add-x86-crash-hotplug-support.patch
crash-hotplug-support-for-kexec_load.patch
crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
x86-crash-optimize-cpu-changes.patch

