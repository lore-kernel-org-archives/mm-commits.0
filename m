From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 131/131] arm64: mm: use ARCH_HAS_DEBUG_WX instead
 of arch defined
Date: Wed, 03 Jun 2020 16:04:02 -0700
Message-ID: <20200603230402.XCluSVOgm%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgFCXIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, catalin.marinas@arm.com, hpa@zytor.com, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, palmer@dabbelt.com, paul.walmsley@sifive.com, tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org, zong.li@sifive.com

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
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
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
