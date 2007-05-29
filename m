From: akpm@linux-foundation.org
Subject: - doc-clocksources.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:00 -0700
Message-ID: <200705291852.l4TIqxVp008441@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765450AbXE2S5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     document clocksources
has been removed from the -mm tree.  Its filename was
     doc-clocksources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: document clocksources
From: Randy Dunlap <randy.dunlap@oracle.com>

Document the available clocksources per platform and move clocksource= into
the correct (alpha) location in the file.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~doc-clocksources Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-clocksources
+++ a/Documentation/kernel-parameters.txt
@@ -396,6 +396,26 @@ and is between 256 and 4096 characters. 
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
+	clocksource=	[GENERIC_TIME] Override the default clocksource
+			Format: <string>
+			Override the default clocksource and use the clocksource
+			with the name specified.
+			Some clocksource names to choose from, depending on
+			the platform:
+			[all] jiffies (this is the base, fallback clocksource)
+			[ACPI] acpi_pm
+			[ARM] imx_timer1,OSTS,netx_timer,mpu_timer2,
+				pxa_timer,timer3,32k_counter,timer0_1
+			[AVR32] avr32
+			[IA-32] pit,hpet,tsc,vmi-timer;
+				scx200_hrt on Geode; cyclone on IBM x440
+			[MIPS] MIPS
+			[PARISC] cr16
+			[S390] tod
+			[SH] SuperH
+			[SPARC64] tick
+			[X86-64] hpet,tsc
+
 	code_bytes	[IA32] How many bytes of object code to print in an
 			oops report.
 			Range: 0 - 8192
@@ -1807,10 +1827,6 @@ and is between 256 and 4096 characters. 
 
 	time		Show timing data prefixed to each printk message line
 
-	clocksource=	[GENERIC_TIME] Override the default clocksource
-			Override the default clocksource and use the clocksource
-			with the name specified.
-
 	tipar.timeout=	[HW,PPT]
 			Set communications timeout in tenths of a second
 			(default 15).
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
add-notime-boot-option.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
