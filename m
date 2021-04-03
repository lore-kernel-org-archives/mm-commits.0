Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3376AC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12950611B0
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhDCAvn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 20:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235924AbhDCAvm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 20:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 384E5611AF;
        Sat,  3 Apr 2021 00:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617411101;
        bh=NeVe+PJxNJINA9TUy65rMXdSdCyKBIiQ6p+HVoVPols=;
        h=Date:From:To:Subject:From;
        b=nyyI95QuIiw7FhEIbV/s/GNx+7f88VuRzEU49B7KNHeEpOJYvJY5pjHT7JnMw6UHw
         hdPth7r/1MyyAUxBPeWvoR+CK56fxAD+vQk//CB+7slwAIiOOrniw4Kh12jTP+9MwJ
         VnuNrcBKRuUZ3mJT4pUARmrmwxenzS0s0aYkXddg=
Date:   Fri, 02 Apr 2021 17:51:39 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, aou@eecs.berkeley.edu, arnd@arndb.de,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, dalias@libc.org, deller@gmx.de,
        gor@linux.ibm.com, hca@linux.ibm.com, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        paulus@samba.org, tglx@linutronix.de, tsbogend@alpha.franken.de,
        vgupta@synopsys.com, viro@zeniv.linux.org.uk, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  + mm-drop-redundant-arch_enable_split_pmd_ptlock.patch
 added to -mm tree
Message-ID: <20210403005139.qyD5TCxjc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK
has been added to the -mm tree.  Its filename is
     mm-drop-redundant-arch_enable_split_pmd_ptlock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-drop-redundant-arch_enable_split_pmd_ptlock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-redundant-arch_enable_split_pmd_ptlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: drop redundant ARCH_ENABLE_SPLIT_PMD_PTLOCK

ARCH_ENABLE_SPLIT_PMD_PTLOCKS has duplicate definitions on platforms that
subscribe it.  Drop these redundant definitions and instead just select it
on applicable platforms.

Link: https://lkml.kernel.org/r/1617259448-22529-6-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com> (arm64)
Acked-by: Heiko Carstens <hca@linux.ibm.com> (s390)
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig                     |    4 +---
 arch/powerpc/platforms/Kconfig.cputype |    5 +----
 arch/s390/Kconfig                      |    4 +---
 arch/x86/Kconfig                       |    5 +----
 4 files changed, 4 insertions(+), 14 deletions(-)

--- a/arch/arm64/Kconfig~mm-drop-redundant-arch_enable_split_pmd_ptlock
+++ a/arch/arm64/Kconfig
@@ -14,6 +14,7 @@ config ARM64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
@@ -1063,9 +1064,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config ARCH_ENABLE_SPLIT_PMD_PTLOCK
-	def_bool y if PGTABLE_LEVELS > 2
-
 # Supported by clang >= 7.0
 config CC_HAVE_SHADOW_CALL_STACK
 	def_bool $(cc-option, -fsanitize=shadow-call-stack -ffixed-x18)
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-drop-redundant-arch_enable_split_pmd_ptlock
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -97,6 +97,7 @@ config PPC_BOOK3S_64
 	select PPC_HAVE_PMU_SUPPORT
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
+	select ARCH_ENABLE_PMD_SPLIT_PTLOCK
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
@@ -356,10 +357,6 @@ config SPE
 
 	  If in doubt, say Y here.
 
-config ARCH_ENABLE_SPLIT_PMD_PTLOCK
-	def_bool y
-	depends on PPC_BOOK3S_64
-
 config PPC_RADIX_MMU
 	bool "Radix MMU Support"
 	depends on PPC_BOOK3S_64
--- a/arch/s390/Kconfig~mm-drop-redundant-arch_enable_split_pmd_ptlock
+++ a/arch/s390/Kconfig
@@ -62,6 +62,7 @@ config S390
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
@@ -628,9 +629,6 @@ config ARCH_SPARSEMEM_ENABLE
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 
-config ARCH_ENABLE_SPLIT_PMD_PTLOCK
-	def_bool y
-
 config MAX_PHYSMEM_BITS
 	int "Maximum size of supported physical memory in bits (42-53)"
 	range 42 53
--- a/arch/x86/Kconfig~mm-drop-redundant-arch_enable_split_pmd_ptlock
+++ a/arch/x86/Kconfig
@@ -63,6 +63,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if x86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if X86_64 || X86_PAE
 	select ARCH_ENABLE_THP_MIGRATION if x86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
@@ -2432,10 +2433,6 @@ config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
 
-config ARCH_ENABLE_SPLIT_PMD_PTLOCK
-	def_bool y
-	depends on X86_64 || X86_PAE
-
 menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-hugetlb_page_size_variable.patch
mm-generalize-arch_has_cache_line_size.patch
mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs.patch
mm-generalize-arch_enable_memory_.patch
mm-drop-redundant-arch_enable__migration.patch
mm-drop-redundant-arch_enable_split_pmd_ptlock.patch
mm-drop-redundant-have_arch_transparent_hugepage.patch

