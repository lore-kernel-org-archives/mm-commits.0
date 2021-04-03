Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7195C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4AE611AE
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235598AbhDCAvZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 20:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234488AbhDCAvY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 20:51:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12D3F61185;
        Sat,  3 Apr 2021 00:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617411082;
        bh=5Mt6a9Pmzg3XCU9lEtbq7YSxjVbcoHzXkUBlpvpB5r0=;
        h=Date:From:To:Subject:From;
        b=loYRZYkOUDITrQit3lo1q+1r8EcM153hOEfJu+y00x0nc/chE0mB92QSwq70k1TWh
         Ui8U/LU65+pSwpJktBFyJEWP5R/cu38ZZQaTejoF1lWBUc80Z9NyoC736OigDJ+EtM
         f8picgEsfVySnKVWCw47kqSmnk45F4AdZCm2XwRE=
Date:   Fri, 02 Apr 2021 17:51:18 -0700
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
Subject:  + mm-generalize-arch_has_cache_line_size.patch added to
 -mm tree
Message-ID: <20210403005118.pi1qvwagz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalize ARCH_HAS_CACHE_LINE_SIZE
has been added to the -mm tree.  Its filename is
     mm-generalize-arch_has_cache_line_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-generalize-arch_has_cache_line_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-generalize-arch_has_cache_line_size.patch

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
Subject: mm: generalize ARCH_HAS_CACHE_LINE_SIZE

Patch series "mm: some config cleanups", v2.

This series contains config cleanup patches which reduces code duplication
across platforms and also improves maintainability. There is no functional
change intended with this series.


This patch (of 6):

ARCH_HAS_CACHE_LINE_SIZE config has duplicate definitions on platforms
that subscribe it.  Instead, just make it a generic option which can be
selected on applicable platforms.  This change reduces code duplication
and makes it cleaner.

Link: https://lkml.kernel.org/r/1617259448-22529-1-git-send-email-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/1617259448-22529-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com> (arm64)
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig   |    4 +---
 arch/arm64/Kconfig |    4 +---
 arch/x86/Kconfig   |    4 +---
 mm/Kconfig         |    3 +++
 4 files changed, 6 insertions(+), 9 deletions(-)

--- a/arch/arc/Kconfig~mm-generalize-arch_has_cache_line_size
+++ a/arch/arc/Kconfig
@@ -6,6 +6,7 @@
 config ARC
 	def_bool y
 	select ARC_TIMERS
+	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_PTE_SPECIAL
@@ -48,9 +49,6 @@ config ARC
 	select HAVE_ARCH_JUMP_LABEL if ISA_ARCV2 && !CPU_ENDIAN_BE32
 	select SET_FS
 
-config ARCH_HAS_CACHE_LINE_SIZE
-	def_bool y
-
 config TRACE_IRQFLAGS_SUPPORT
 	def_bool y
 
--- a/arch/arm64/Kconfig~mm-generalize-arch_has_cache_line_size
+++ a/arch/arm64/Kconfig
@@ -11,6 +11,7 @@ config ARM64
 	select ACPI_PPTT if ACPI
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_BINFMT_ELF_STATE
+	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DMA_PREP_COHERENT
@@ -1066,9 +1067,6 @@ config HW_PERF_EVENTS
 config SYS_SUPPORTS_HUGETLBFS
 	def_bool y
 
-config ARCH_HAS_CACHE_LINE_SIZE
-	def_bool y
-
 config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	def_bool y if PGTABLE_LEVELS > 2
 
--- a/arch/x86/Kconfig~mm-generalize-arch_has_cache_line_size
+++ a/arch/x86/Kconfig
@@ -61,6 +61,7 @@ config X86
 	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_INIT
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
+	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE	if !X86_PAE
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
@@ -314,9 +315,6 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
-config ARCH_HAS_CACHE_LINE_SIZE
-	def_bool y
-
 config ARCH_HAS_FILTER_PGPROT
 	def_bool y
 
--- a/mm/Kconfig~mm-generalize-arch_has_cache_line_size
+++ a/mm/Kconfig
@@ -773,6 +773,9 @@ config IDLE_PAGE_TRACKING
 	  See Documentation/admin-guide/mm/idle_page_tracking.rst for
 	  more details.
 
+config ARCH_HAS_CACHE_LINE_SIZE
+	bool
+
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-hugetlb_page_size_variable.patch
mm-generalize-arch_has_cache_line_size.patch
mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs.patch
mm-generalize-arch_enable_memory_.patch
mm-drop-redundant-arch_enable__migration.patch
mm-drop-redundant-arch_enable_split_pmd_ptlock.patch
mm-drop-redundant-have_arch_transparent_hugepage.patch

