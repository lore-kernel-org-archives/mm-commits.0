From: akpm@linux-foundation.org
Subject: + fix-oprofile-configuration-breakage.patch added to -mm tree
Date: Thu, 06 Dec 2007 11:49:59 -0800
Message-ID: <200712061949.lB6JnxnU008800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbXLFTuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2007 14:50:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, mathieu.desnoyers@polymtl.ca


The patch titled
     Fix oprofile configuration breakage
has been added to the -mm tree.  Its filename is
     fix-oprofile-configuration-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix oprofile configuration breakage
From: Ralf Baechle <ralf@linux-mips.org>

The cleanup 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9 broke the oprofile
configuration for MIPS by allowing oprofile support to be built for
kernel models where oprofile doesn't have a chance in hell to work.

Just a dependecy list on a number of architectures is - surprise - broken
and should as per past discussions probably in most considered to be broken
in most cases.  So I introduce a dependency for the oprofile configuration
on ARCH_SUPPORTS_OPROFILE.

Since we're already in -rc4 I try to keep things minimally intrusive and
use ARCH_SUPPORTS_OPROFILE only for MIPS for now instead of touching a
dozen architectures.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig              |    4 ++++
 kernel/Kconfig.instrumentation |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/mips/Kconfig~fix-oprofile-configuration-breakage arch/mips/Kconfig
--- a/arch/mips/Kconfig~fix-oprofile-configuration-breakage
+++ a/arch/mips/Kconfig
@@ -714,6 +714,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ARCH_SUPPORTS_OPROFILE
+	bool
+	default y if !MIPS_MT_SMTC
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff -puN kernel/Kconfig.instrumentation~fix-oprofile-configuration-breakage kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~fix-oprofile-configuration-breakage
+++ a/kernel/Kconfig.instrumentation
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
-	depends on (ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64) && !UML
+	depends on (ARCH_SUPPORTS_OPROFILE || ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || PARISC || PPC || S390 || SUPERH || SPARC || X86_64) && !UML
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
_

Patches currently in -mm which might be from ralf@linux-mips.org are

fix-oprofile-configuration-breakage.patch
git-mips.patch
mips-remove-dead-config-symbols-from-mips-code.patch
drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
txx9-watchdog-driver.patch
add-support-for-sb1-hardware-watchdog.patch
add-support-for-sb1-hardware-watchdog-fix.patch
git-x86.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-inclusions-of-linux-autoconfh.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
dzc-use-a-helper-to-cast-from-struct-uart_port.patch
dzc-resource-management.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
