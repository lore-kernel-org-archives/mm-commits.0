From: akpm@linux-foundation.org
Subject: + doc-clocksources.patch added to -mm tree
Date: Mon, 21 May 2007 21:07:50 -0700
Message-ID: <200705220407.l4M47oO4027000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbXEVELR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 00:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, tglx@linutronix.de


The patch titled
     document clocksources
has been added to the -mm tree.  Its filename is
     doc-clocksources.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 20 insertions(+), 4 deletions(-)

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
documentation-fix-the-explanation-of-kconfig-files.patch
update-dontdiff-file.patch
doc-clocksources.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
profile-likely-unlikely-macros.patch
