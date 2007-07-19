From: akpm@linux-foundation.org
Subject: + geode-setup-correct-chipset-access-functions.patch added to -mm tree
Date: Wed, 18 Jul 2007 18:02:27 -0700
Message-ID: <200707190102.l6J12RYW006197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761953AbXGSBDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 21:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juergen@kreuzholzen.de, ak@suse.de, alan@lxorguk.ukuu.org.uk, dilinger@debian.org, jordan.crouse@amd.com, takada@mbf.nifty.com


The patch titled
     geode: setup correct chipset access functions
has been added to the -mm tree.  Its filename is
     geode-setup-correct-chipset-access-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: geode: setup correct chipset access functions
From: Juergen Beisert <juergen@kreuzholzen.de>

Replace NSC/Cyrix specific chipset access macros by inlined functions. 
With the macros a line like this fails (and does nothing):

	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);

With inlined functions this line will work as expected.

Note about a side effect: Seems on Geode GX1 based systems the "suspend on
halt power saving feature" was never enabled due to this wrong macro
expansion.  With inlined functions it will be enabled, but this will stop
the TSC when the CPU runs into a HLT instruction.  Kernel output something
like this:

	Clocksource tsc unstable (delta = -472746897 ns)

Signed-off-by: Juergen Beisert <juergen@kreuzholzen.de>
Cc: TAKADA Yoshihito <takada@mbf.nifty.com>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/gx-suspmod.c |    2 +-
 arch/i386/kernel/cpu/cyrix.c              |    2 +-
 arch/i386/kernel/cpu/mtrr/cyrix.c         |    1 +
 include/asm-i386/processor-cyrix.h        |   20 ++++++++++++++++++++
 include/asm-i386/processor.h              |   11 -----------
 include/asm-x86_64/processor.h            |   11 -----------
 6 files changed, 23 insertions(+), 24 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/gx-suspmod.c~geode-setup-correct-chipset-access-functions arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
--- a/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c~geode-setup-correct-chipset-access-functions
+++ a/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
@@ -79,7 +79,7 @@
 #include <linux/smp.h>
 #include <linux/cpufreq.h>
 #include <linux/pci.h>
-#include <asm/processor.h>
+#include <asm/processor-cyrix.h>
 #include <asm/errno.h>
 
 /* PCI config registers, all at F0 */
diff -puN arch/i386/kernel/cpu/cyrix.c~geode-setup-correct-chipset-access-functions arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c~geode-setup-correct-chipset-access-functions
+++ a/arch/i386/kernel/cpu/cyrix.c
@@ -4,7 +4,7 @@
 #include <linux/pci.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/processor.h>
+#include <asm/processor-cyrix.h>
 #include <asm/timer.h>
 #include <asm/pci-direct.h>
 #include <asm/tsc.h>
diff -puN arch/i386/kernel/cpu/mtrr/cyrix.c~geode-setup-correct-chipset-access-functions arch/i386/kernel/cpu/mtrr/cyrix.c
--- a/arch/i386/kernel/cpu/mtrr/cyrix.c~geode-setup-correct-chipset-access-functions
+++ a/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -3,6 +3,7 @@
 #include <asm/mtrr.h>
 #include <asm/msr.h>
 #include <asm/io.h>
+#include <asm/processor-cyrix.h>
 #include "mtrr.h"
 
 int arr3_protected;
diff -puN /dev/null include/asm-i386/processor-cyrix.h
--- /dev/null
+++ a/include/asm-i386/processor-cyrix.h
@@ -0,0 +1,20 @@
+#ifndef __ASM_I386_PROCESSOR_CYRIX_H
+#define __ASM_I386_PROCESSOR_CYRIX
+
+#include <asm/processor-flags.h>
+/*
+ * NSC/Cyrix CPU indexed register access
+ */
+static inline u8 getCx86(u8 reg)
+{
+	outb(reg, 0x22);
+	return inb(0x23);
+}
+
+static inline void setCx86(u8 reg, u8 data)
+{
+	outb(reg, 0x22);
+	outb(data, 0x23);
+}
+
+#endif
diff -puN include/asm-i386/processor.h~geode-setup-correct-chipset-access-functions include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~geode-setup-correct-chipset-access-functions
+++ a/include/asm-i386/processor.h
@@ -168,17 +168,6 @@ static inline void clear_in_cr4 (unsigne
 	write_cr4(cr4);
 }
 
-/*
- *      NSC/Cyrix CPU indexed register access macros
- */
-
-#define getCx86(reg) ({ outb((reg), 0x22); inb(0x23); })
-
-#define setCx86(reg, data) do { \
-	outb((reg), 0x22); \
-	outb((data), 0x23); \
-} while (0)
-
 /* Stop speculative execution */
 static inline void sync_core(void)
 {
diff -puN include/asm-x86_64/processor.h~geode-setup-correct-chipset-access-functions include/asm-x86_64/processor.h
--- a/include/asm-x86_64/processor.h~geode-setup-correct-chipset-access-functions
+++ a/include/asm-x86_64/processor.h
@@ -389,17 +389,6 @@ static inline void prefetchw(void *x) 
 
 #define cpu_relax()   rep_nop()
 
-/*
- *      NSC/Cyrix CPU indexed register access macros
- */
-
-#define getCx86(reg) ({ outb((reg), 0x22); inb(0x23); })
-
-#define setCx86(reg, data) do { \
-	outb((reg), 0x22); \
-	outb((data), 0x23); \
-} while (0)
-
 static inline void serialize_cpu(void)
 {
 	__asm__ __volatile__ ("cpuid" : : : "ax", "bx", "cx", "dx");
_

Patches currently in -mm which might be from juergen@kreuzholzen.de are

geode-setup-correct-chipset-access-functions.patch
