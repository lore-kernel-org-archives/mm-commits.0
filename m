From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch added to -mm
 tree
Date: Sat, 25 Apr 2020 18:06:12 -0700
Message-ID: <20200426010612.41jaMSYBW%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgDZBGO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 21:06:14 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, catalin.marinas@arm.com, hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org, palmer@dabbelt.com, paul.walmsley@sifive.com, tglx@linutronix.de, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: arm64: mm: use ARCH_HAS_DEBUG_WX instead of arch defined
has been added to the -mm tree.  Its filename is
     arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zong Li <zong.li@sifive.com>
Subject: arm64: mm: use ARCH_HAS_DEBUG_WX instead of arch defined

Extract DEBUG_WX to mm/Kconfig.debug for shared use.  Change to use
ARCH_HAS_DEBUG_WX instead of DEBUG_WX defined by arch port.

Link: http://lkml.kernel.org/r/e19709e7576f65e303245fe520cad5f7bae72763.1587455584.git.zong.li@sifive.com
Signed-off-by: Zong Li <zong.li@sifive.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig       |    1 +
 arch/arm64/Kconfig.debug |   29 -----------------------------
 2 files changed, 1 insertion(+), 29 deletions(-)

--- a/arch/arm64/Kconfig~arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined
+++ a/arch/arm64/Kconfig
@@ -9,6 +9,7 @@ config ARM64
 	select ACPI_MCFG if (ACPI && PCI)
 	select ACPI_SPCR_TABLE if ACPI
 	select ACPI_PPTT if ACPI
+	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_DMA_PREP_COHERENT
--- a/arch/arm64/Kconfig.debug~arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined
+++ a/arch/arm64/Kconfig.debug
@@ -23,35 +23,6 @@ config ARM64_RANDOMIZE_TEXT_OFFSET
 	  of TEXT_OFFSET and platforms must not require a specific
 	  value.
 
-config DEBUG_WX
-	bool "Warn on W+X mappings at boot"
-	select PTDUMP_CORE
-	---help---
-	  Generate a warning if any W+X mappings are found at boot.
-
-	  This is useful for discovering cases where the kernel is leaving
-	  W+X mappings after applying NX, as such mappings are a security risk.
-	  This check also includes UXN, which should be set on all kernel
-	  mappings.
-
-	  Look for a message in dmesg output like this:
-
-	    arm64/mm: Checked W+X mappings: passed, no W+X pages found.
-
-	  or like this, if the check failed:
-
-	    arm64/mm: Checked W+X mappings: FAILED, <N> W+X pages found.
-
-	  Note that even if the check fails, your kernel is possibly
-	  still fine, as W+X mappings are not a security hole in
-	  themselves, what they do is that they make the exploitation
-	  of other unfixed kernel bugs easier.
-
-	  There is no runtime or memory usage effect of this option
-	  once the kernel has booted up - it's a one time check.
-
-	  If in doubt, say "Y".
