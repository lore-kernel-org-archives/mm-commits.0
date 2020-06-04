From: akpm@linux-foundation.org
Subject: [merged] mm-add-debug_wx-support.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:21:35 -0700
Message-ID: <20200604172135.cLQSycpea%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgFDRVh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:21:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@alien8.de, catalin.marinas@arm.com, hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org, palmer@dabbelt.com, paul.walmsley@sifive.com, tglx@linutronix.de, will@kernel.org, zong.li@sifive.com


The patch titled
     Subject: mm: add DEBUG_WX support
has been removed from the -mm tree.  Its filename was
     mm-add-debug_wx-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zong Li <zong.li@sifive.com>
Subject: mm: add DEBUG_WX support

Patch series "Extract DEBUG_WX to shared use".

Some architectures support DEBUG_WX function, it's verbatim from each
others, so extract to mm/Kconfig.debug for shared use.

PPC and ARM ports don't support generic page dumper yet, so we only
refine x86 and arm64 port in this patch series.

For RISC-V port, the DEBUG_WX support depends on other patches which
be merged already:
  - RISC-V page table dumper
  - Support strict kernel memory permissions for security


This patch (of 4):

Some architectures support DEBUG_WX function, it's verbatim from each
others.  Extract to mm/Kconfig.debug for shared use.

[akpm@linux-foundation.org: reword text, per Will Deacon & Zong Li]
  Link: http://lkml.kernel.org/r/20200427194245.oxRJKj3fn%25akpm@linux-foundation.org
[zong.li@sifive.com: remove the specific name of arm64]
  Link: http://lkml.kernel.org/r/3a6a92ecedc54e1d0fc941398e63d504c2cd5611.1589178399.git.zong.li@sifive.com
[zong.li@sifive.com: add MMU dependency for DEBUG_WX]
  Link: http://lkml.kernel.org/r/4a674ac7863ff39ca91847b10e51209771f99416.1589178399.git.zong.li@sifive.com
Link: http://lkml.kernel.org/r/cover.1587455584.git.zong.li@sifive.com
Link: http://lkml.kernel.org/r/23980cd0f0e5d79e24a92169116407c75bcc650d.1587455584.git.zong.li@sifive.com
Signed-off-by: Zong Li <zong.li@sifive.com>
Suggested-by: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/mm/Kconfig.debug~mm-add-debug_wx-support
+++ a/mm/Kconfig.debug
@@ -118,6 +118,38 @@ config DEBUG_RODATA_TEST
     ---help---
       This option enables a testcase for the setting rodata read-only.
 
+config ARCH_HAS_DEBUG_WX
+	bool
+
+config DEBUG_WX
+	bool "Warn on W+X mappings at boot"
+	depends on ARCH_HAS_DEBUG_WX
+	depends on MMU
+	select PTDUMP_CORE
+	help
+	  Generate a warning if any W+X mappings are found at boot.
+
+	  This is useful for discovering cases where the kernel is leaving W+X
+	  mappings after applying NX, as such mappings are a security risk.
+
+	  Look for a message in dmesg output like this:
+
+	    <arch>/mm: Checked W+X mappings: passed, no W+X pages found.
+
+	  or like this, if the check failed:
+
+	    <arch>/mm: Checked W+X mappings: failed, <N> W+X pages found.
+
+	  Note that even if the check fails, your kernel is possibly
+	  still fine, as W+X mappings are not a security hole in
+	  themselves, what they do is that they make the exploitation
+	  of other unfixed kernel bugs easier.
+
+	  There is no runtime or memory usage effect of this option
+	  once the kernel has booted up - it's a one time check.
+
+	  If in doubt, say "Y".
+
 config GENERIC_PTDUMP
 	bool
 
_

Patches currently in -mm which might be from zong.li@sifive.com are
