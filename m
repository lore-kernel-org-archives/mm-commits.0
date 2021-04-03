Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E60DC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28189611AF
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhDCAvk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 20:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235924AbhDCAvi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 20:51:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 365F861185;
        Sat,  3 Apr 2021 00:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617411097;
        bh=MUcJm4bswPQL+Z3W8tXKU/bfkJaUVWDQlzI+a22ypd8=;
        h=Date:From:To:Subject:From;
        b=hQ3to+RTYFhVRK40sDSi9dnWXIkHw1Og8HqQvIAZnErBDXSpdFxFXfZPFxkjP25xr
         OGuShbR0qck/6svkbUX5o1DJBjVYK6kxZ4o4DZTRYP8GMOvQkK6PoWBu8FChnFC83+
         nS68nlQOfwSKu0REuE3NrUSAz9KsYvbpm/ClZdRA=
Date:   Fri, 02 Apr 2021 17:51:35 -0700
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
Subject:  + mm-drop-redundant-arch_enable__migration.patch added to
 -mm tree
Message-ID: <20210403005135.eVdt5flhL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop redundant ARCH_ENABLE_[HUGEPAGE|THP]_MIGRATION
has been added to the -mm tree.  Its filename is
     mm-drop-redundant-arch_enable__migration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-drop-redundant-arch_enable__migration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-redundant-arch_enable__migration.patch

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
Subject: mm: drop redundant ARCH_ENABLE_[HUGEPAGE|THP]_MIGRATION

ARCH_ENABLE_[HUGEPAGE|THP]_MIGRATION configs have duplicate definitions on
platforms that subscribe them.  Drop these reduntant definitions and
instead just select them appropriately.

Link: https://lkml.kernel.org/r/1617259448-22529-5-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com> (arm64)
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig                     |   10 ++--------
 arch/powerpc/platforms/Kconfig.cputype |    5 +----
 arch/x86/Kconfig                       |   10 ++--------
 3 files changed, 5 insertions(+), 20 deletions(-)

--- a/arch/arm64/Kconfig~mm-drop-redundant-arch_enable__migration
+++ a/arch/arm64/Kconfig
@@ -11,8 +11,10 @@ config ARM64
 	select ACPI_PPTT if ACPI
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_BINFMT_ELF_STATE
+	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG
 	select ARCH_ENABLE_MEMORY_HOTREMOVE
+	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
@@ -1906,14 +1908,6 @@ config SYSVIPC_COMPAT
 	def_bool y
 	depends on COMPAT && SYSVIPC
 
-config ARCH_ENABLE_HUGEPAGE_MIGRATION
-	def_bool y
-	depends on HUGETLB_PAGE && MIGRATION
-
-config ARCH_ENABLE_THP_MIGRATION
-	def_bool y
-	depends on TRANSPARENT_HUGEPAGE
-
 menu "Power management options"
 
 source "kernel/power/Kconfig"
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-drop-redundant-arch_enable__migration
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -96,6 +96,7 @@ config PPC_BOOK3S_64
 	select PPC_FPU
 	select PPC_HAVE_PMU_SUPPORT
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
@@ -420,10 +421,6 @@ config PPC_PKEY
 	depends on PPC_BOOK3S_64
 	depends on PPC_MEM_KEYS || PPC_KUAP || PPC_KUEP
 
-config ARCH_ENABLE_HUGEPAGE_MIGRATION
-	def_bool y
-	depends on PPC_BOOK3S_64 && HUGETLB_PAGE && MIGRATION
-
 
 config PPC_MMU_NOHASH
 	def_bool y
--- a/arch/x86/Kconfig~mm-drop-redundant-arch_enable__migration
+++ a/arch/x86/Kconfig
@@ -60,8 +60,10 @@ config X86
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_INIT
+	select ARCH_ENABLE_HUGEPAGE_MIGRATION if x86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
+	select ARCH_ENABLE_THP_MIGRATION if x86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
@@ -2434,14 +2436,6 @@ config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	def_bool y
 	depends on X86_64 || X86_PAE
 
-config ARCH_ENABLE_HUGEPAGE_MIGRATION
-	def_bool y
-	depends on X86_64 && HUGETLB_PAGE && MIGRATION
-
-config ARCH_ENABLE_THP_MIGRATION
-	def_bool y
-	depends on X86_64 && TRANSPARENT_HUGEPAGE
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

