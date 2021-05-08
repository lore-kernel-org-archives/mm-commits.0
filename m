Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F79EC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E35B6142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWvI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWvI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D4F6101D;
        Sat,  8 May 2021 22:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514206;
        bh=FebJJOSKB4VE5i/fEsnQLAZx8gtmKe9ZUKT0nIt1jI0=;
        h=Date:From:To:Subject:From;
        b=HygmEqnjtqNP0tfwvQS0GeRagu18fdZEwHCX9XlA0rEJT7jk+tFJWAJrKWHhricgy
         rE2h+m3r1PFnHGKDkuLr8rreJmJSZOSHhHAsXT4ktmPdmb3sq4ZXesuYBQeDwPTL0L
         iw+Mej0OdxmuUQ6+9O3qVK6yJyF/xV7P7f9qEeUE=
Date:   Sat, 08 May 2021 15:50:05 -0700
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
Subject:  [merged] mm-generalize-arch_enable_memory_.patch removed
 from -mm tree
Message-ID: <20210508225005.keca_LVKs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalize ARCH_ENABLE_MEMORY_[HOTPLUG|HOTREMOVE]
has been removed from the -mm tree.  Its filename was
     mm-generalize-arch_enable_memory_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: generalize ARCH_ENABLE_MEMORY_[HOTPLUG|HOTREMOVE]

ARCH_ENABLE_MEMORY_[HOTPLUG|HOTREMOVE] configs have duplicate definitions
on platforms that subscribe them.  Instead, just make them generic options
which can be selected on applicable platforms.

Link: https://lkml.kernel.org/r/1617259448-22529-4-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Acked-by: Heiko Carstens <hca@linux.ibm.com>		[s390]
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

 arch/arm64/Kconfig   |    8 ++------
 arch/ia64/Kconfig    |    8 ++------
 arch/powerpc/Kconfig |    8 ++------
 arch/s390/Kconfig    |    8 ++------
 arch/sh/Kconfig      |    2 ++
 arch/sh/mm/Kconfig   |    8 --------
 arch/x86/Kconfig     |   10 ++--------
 mm/Kconfig           |    6 ++++++
 8 files changed, 18 insertions(+), 40 deletions(-)

--- a/arch/arm64/Kconfig~mm-generalize-arch_enable_memory_
+++ a/arch/arm64/Kconfig
@@ -11,6 +11,8 @@ config ARM64
 	select ACPI_PPTT if ACPI
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_BINFMT_ELF_STATE
+	select ARCH_ENABLE_MEMORY_HOTPLUG
+	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
@@ -311,12 +313,6 @@ config ZONE_DMA32
 	bool "Support DMA32 zone" if EXPERT
 	default y
 
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y
-
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	def_bool y
-
 config SMP
 	def_bool y
 
--- a/arch/ia64/Kconfig~mm-generalize-arch_enable_memory_
+++ a/arch/ia64/Kconfig
@@ -13,6 +13,8 @@ config IA64
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ACPI
 	select ACPI_NUMA if NUMA
+	select ARCH_ENABLE_MEMORY_HOTPLUG
+	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_SUPPORTS_ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT if ACPI
 	select ARCH_MIGHT_HAVE_ACPI_PDC if ACPI
@@ -246,12 +248,6 @@ config HOTPLUG_CPU
 	  can be controlled through /sys/devices/system/cpu/cpu#.
 	  Say N if you want to disable CPU hotplug.
 
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y
-
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	def_bool y
-
 config SCHED_SMT
 	bool "SMT scheduler support"
 	depends on SMP
--- a/arch/powerpc/Kconfig~mm-generalize-arch_enable_memory_
+++ a/arch/powerpc/Kconfig
@@ -118,6 +118,8 @@ config PPC
 	# Please keep this list sorted alphabetically.
 	#
 	select ARCH_32BIT_OFF_T if PPC32
+	select ARCH_ENABLE_MEMORY_HOTPLUG
+	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
@@ -512,12 +514,6 @@ config ARCH_CPU_PROBE_RELEASE
 	def_bool y
 	depends on HOTPLUG_CPU
 
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y
-
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	def_bool y
-
 config PPC64_SUPPORTS_MEMORY_FAILURE
 	bool "Add support for memory hwpoison"
 	depends on PPC_BOOK3S_64
--- a/arch/s390/Kconfig~mm-generalize-arch_enable_memory_
+++ a/arch/s390/Kconfig
@@ -60,6 +60,8 @@ config S390
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_BINFMT_ELF_STATE
+	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
+	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
@@ -626,12 +628,6 @@ config ARCH_SPARSEMEM_ENABLE
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y if SPARSEMEM
-
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	def_bool y
-
 config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	def_bool y
 
--- a/arch/sh/Kconfig~mm-generalize-arch_enable_memory_
+++ a/arch/sh/Kconfig
@@ -2,6 +2,8 @@
 config SUPERH
 	def_bool y
 	select ARCH_32BIT_OFF_T
+	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM && MMU
+	select ARCH_ENABLE_MEMORY_HOTREMOVE if SPARSEMEM && MMU
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select ARCH_HAS_BINFMT_FLAT if !MMU
--- a/arch/sh/mm/Kconfig~mm-generalize-arch_enable_memory_
+++ a/arch/sh/mm/Kconfig
@@ -136,14 +136,6 @@ config ARCH_SPARSEMEM_DEFAULT
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y
-	depends on SPARSEMEM && MMU
-
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	def_bool y
-	depends on SPARSEMEM && MMU
-
 config ARCH_MEMORY_PROBE
 	def_bool y
 	depends on MEMORY_HOTPLUG
--- a/arch/x86/Kconfig~mm-generalize-arch_enable_memory_
+++ a/arch/x86/Kconfig
@@ -60,6 +60,8 @@ config X86
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_INIT
+	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
+	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
@@ -2427,14 +2429,6 @@ config ARCH_HAS_ADD_PAGES
 	def_bool y
 	depends on X86_64 && ARCH_ENABLE_MEMORY_HOTPLUG
 
-config ARCH_ENABLE_MEMORY_HOTPLUG
-	def_bool y
-	depends on X86_64 || (X86_32 && HIGHMEM)
-
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	def_bool y
-	depends on MEMORY_HOTPLUG
-
 config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
--- a/mm/Kconfig~mm-generalize-arch_enable_memory_
+++ a/mm/Kconfig
@@ -148,6 +148,9 @@ config MEMORY_ISOLATION
 config HAVE_BOOTMEM_INFO_NODE
 	def_bool n
 
+config ARCH_ENABLE_MEMORY_HOTPLUG
+	bool
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
@@ -176,6 +179,9 @@ config MEMORY_HOTPLUG_DEFAULT_ONLINE
 	  Say N here if you want the default policy to keep all hot-plugged
 	  memory blocks in 'offline' state.
 
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	bool
+
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


