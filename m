Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A565BC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D1661424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhEHWvM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWvL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAB146100C;
        Sat,  8 May 2021 22:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514209;
        bh=bYWHH6jF8uafwI0zzWX6yF9ZOy+Z9/FjynvwXRNO1f0=;
        h=Date:From:To:Subject:From;
        b=nBHoOF+IBbCc7m3Cyr8yV5nIsvcF6FGeWj9gmR2vcZIEKVRuo2uCQ3CT8rWtlxXXJ
         4UbfUXr200VkljaQOP0yct739bjdygpVuURIu4qlqReKwsOyE+jo+x2Xsm800AmFLm
         F3vIGe8rGypy2n7ISTB7bOt0+cMCGB3Z5GvNQDfc=
Date:   Sat, 08 May 2021 15:50:08 -0700
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
Subject:  [merged] mm-drop-redundant-arch_enable__migration.patch
 removed from -mm tree
Message-ID: <20210508225008.FKPQo06T8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop redundant ARCH_ENABLE_[HUGEPAGE|THP]_MIGRATION
has been removed from the -mm tree.  Its filename was
     mm-drop-redundant-arch_enable__migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: drop redundant ARCH_ENABLE_[HUGEPAGE|THP]_MIGRATION

ARCH_ENABLE_[HUGEPAGE|THP]_MIGRATION configs have duplicate definitions on
platforms that subscribe them.  Drop these reduntant definitions and
instead just select them appropriately.

[akpm@linux-foundation.org: s/x86_64/X86_64/, per Oscar]
Link: https://lkml.kernel.org/r/1617259448-22529-5-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
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
@@ -1916,14 +1918,6 @@ config SYSVIPC_COMPAT
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
+	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
+	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
@@ -2437,14 +2439,6 @@ config ARCH_ENABLE_SPLIT_PMD_PTLOCK
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


