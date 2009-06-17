From: akpm@linux-foundation.org
Subject: [merged] m32r-remove-obsolete-hw_interrupt_type.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:52 -0700
Message-ID: <200906171836.n5HIaqQb002959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760431AbZFQSh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: remove obsolete hw_interrupt_type
has been removed from the -mm tree.  Its filename was
     m32r-remove-obsolete-hw_interrupt_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: remove obsolete hw_interrupt_type
From: Thomas Gleixner <tglx@linutronix.de>

The defines and typedefs (hw_interrupt_type, no_irq_type, irq_desc_t) have
been kept around for migration reasons.  After more than two years it's
time to remove them finally.

This patch cleans up one of the remaining users.  When all such patches
hit mainline we can remove the defines and typedefs finally.

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/platforms/m32104ut/setup.c |    2 +-
 arch/m32r/platforms/m32700ut/setup.c |    8 ++++----
 arch/m32r/platforms/mappi/setup.c    |    2 +-
 arch/m32r/platforms/mappi2/setup.c   |    2 +-
 arch/m32r/platforms/mappi3/setup.c   |    2 +-
 arch/m32r/platforms/oaks32r/setup.c  |    2 +-
 arch/m32r/platforms/opsput/setup.c   |    8 ++++----
 arch/m32r/platforms/usrv/setup.c     |    4 ++--
 8 files changed, 15 insertions(+), 15 deletions(-)

diff -puN arch/m32r/platforms/m32104ut/setup.c~m32r-remove-obsolete-hw_interrupt_type arch/m32r/platforms/m32104ut/setup.c
--- a/arch/m32r/platforms/m32104ut/setup.c~m32r-remove-obsolete-hw_interrupt_type
+++ a/arch/m32r/platforms/m32104ut/setup.c
@@ -63,7 +63,7 @@ static void shutdown_m32104ut_irq(unsign
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32104ut_irq_type =
+static struct irq_chip m32104ut_irq_type =
 {
 	.typename = "M32104UT-IRQ",
 	.startup = startup_m32104ut_irq,
diff -puN arch/m32r/platforms/m32700ut/setup.c~m32r-remove-obsolete-hw_interrupt_type arch/m32r/platforms/m32700ut/setup.c
--- a/arch/m32r/platforms/m32700ut/setup.c~m32r-remove-obsolete-hw_interrupt_type
+++ a/arch/m32r/platforms/m32700ut/setup.c
@@ -69,7 +69,7 @@ static void shutdown_m32700ut_irq(unsign
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_irq_type =
+static struct irq_chip m32700ut_irq_type =
 {
 	.typename = "M32700UT-IRQ",
 	.startup = startup_m32700ut_irq,
@@ -146,7 +146,7 @@ static void shutdown_m32700ut_pld_irq(un
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_pld_irq_type =
+static struct irq_chip m32700ut_pld_irq_type =
 {
 	.typename = "M32700UT-PLD-IRQ",
 	.startup = startup_m32700ut_pld_irq,
@@ -215,7 +215,7 @@ static void shutdown_m32700ut_lanpld_irq
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_lanpld_irq_type =
+static struct irq_chip m32700ut_lanpld_irq_type =
 {
 	.typename = "M32700UT-PLD-LAN-IRQ",
 	.startup = startup_m32700ut_lanpld_irq,
@@ -284,7 +284,7 @@ static void shutdown_m32700ut_lcdpld_irq
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_lcdpld_irq_type =
+static struct irq_chip m32700ut_lcdpld_irq_type =
 {
 	.typename = "M32700UT-PLD-LCD-IRQ",
 	.startup = startup_m32700ut_lcdpld_irq,
diff -puN arch/m32r/platforms/mappi/setup.c~m32r-remove-obsolete-hw_interrupt_type arch/m32r/platforms/mappi/setup.c
--- a/arch/m32r/platforms/mappi/setup.c~m32r-remove-obsolete-hw_interrupt_type
+++ a/arch/m32r/platforms/mappi/setup.c
@@ -63,7 +63,7 @@ static void shutdown_mappi_irq(unsigned 
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type mappi_irq_type =
+static struct irq_chip mappi_irq_type =
 {
 	.typename = "MAPPI-IRQ",
 	.startup = startup_mappi_irq,
diff -puN arch/m32r/platforms/mappi2/setup.c~m32r-remove-obsolete-hw_interrupt_type arch/m32r/platforms/mappi2/setup.c
--- a/arch/m32r/platforms/mappi2/setup.c~m32r-remove-obsolete-hw_interrupt_type
+++ a/arch/m32r/platforms/mappi2/setup.c
@@ -70,7 +70,7 @@ static void shutdown_mappi2_irq(unsigned
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type mappi2_irq_type =
+static struct irq_chip mappi2_irq_type =
 {
 	.typename = "MAPPI2-IRQ",
 	.startup = startup_mappi2_irq,
diff -puN arch/m32r/platforms/mappi3/setup.c~m32r-remove-obsolete-hw_interrupt_type arch/m32r/platforms/mappi3/setup.c
--- a/arch/m32r/platforms/mappi3/setup.c~m32r-remove-obsolete-hw_interrupt_type
+++ a/arch/m32r/platforms/mappi3/setup.c
@@ -70,7 +70,7 @@ static void shutdown_mappi3_irq(unsigned
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type mappi3_irq_type =
+static struct irq_chip mappi3_irq_type =
 {
 	.typename = "MAPPI3-IRQ",
 	.startup = startup_mappi3_irq,
diff -puN arch/m32r/platforms/oaks32r/setup.c~m32r-remove-obsolete-hw_interrupt_type arch/m32r/platforms/oaks32r/setup.c
--- a/arch/m32r/platforms/oaks32r/setup.c~m32r-remove-obsolete-hw_interrupt_type
+++ a/arch/m32r/platforms/oaks32r/setup.c
@@ -61,7 +61,7 @@ static void shutdown_oaks32r_irq(unsigne
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type oaks32r_irq_type =
+static struct irq_chip oaks32r_irq_type =
 {
 	.typename = "OAKS32R-IRQ",
 	.startup = startup_oaks32r_irq,
diff -puN arch/m32r/platforms/opsput/setup.c~m32r-remove-obsolete-hw_interrupt_type arch/m32r/platforms/opsput/setup.c
--- a/arch/m32r/platforms/opsput/setup.c~m32r-remove-obsolete-hw_interrupt_type
+++ a/arch/m32r/platforms/opsput/setup.c
@@ -70,7 +70,7 @@ static void shutdown_opsput_irq(unsigned
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type opsput_irq_type =
+static struct irq_chip opsput_irq_type =
 {
 	.typename = "OPSPUT-IRQ",
 	.startup = startup_opsput_irq,
@@ -147,7 +147,7 @@ static void shutdown_opsput_pld_irq(unsi
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type opsput_pld_irq_type =
+static struct irq_chip opsput_pld_irq_type =
 {
 	.typename = "OPSPUT-PLD-IRQ",
 	.startup = startup_opsput_pld_irq,
@@ -216,7 +216,7 @@ static void shutdown_opsput_lanpld_irq(u
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type opsput_lanpld_irq_type =
+static struct irq_chip opsput_lanpld_irq_type =
 {
 	.typename = "OPSPUT-PLD-LAN-IRQ",
 	.startup = startup_opsput_lanpld_irq,
@@ -285,7 +285,7 @@ static void shutdown_opsput_lcdpld_irq(u
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type opsput_lcdpld_irq_type =
+static struct irq_chip opsput_lcdpld_irq_type =
 {
 	"OPSPUT-PLD-LCD-IRQ",
 	startup_opsput_lcdpld_irq,
diff -puN arch/m32r/platforms/usrv/setup.c~m32r-remove-obsolete-hw_interrupt_type arch/m32r/platforms/usrv/setup.c
--- a/arch/m32r/platforms/usrv/setup.c~m32r-remove-obsolete-hw_interrupt_type
+++ a/arch/m32r/platforms/usrv/setup.c
@@ -61,7 +61,7 @@ static void shutdown_mappi_irq(unsigned 
 	outl(M32R_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type mappi_irq_type =
+static struct irq_chip mappi_irq_type =
 {
 	.typename = "M32700-IRQ",
 	.startup = startup_mappi_irq,
@@ -134,7 +134,7 @@ static void shutdown_m32700ut_pld_irq(un
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
 
-static struct hw_interrupt_type m32700ut_pld_irq_type =
+static struct irq_chip m32700ut_pld_irq_type =
 {
 	.typename = "USRV-PLD-IRQ",
 	.startup = startup_m32700ut_pld_irq,
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
ia64-remove-obsolete-hw_interrupt_type.patch
parisc-remove-obsolete-hw_interrupt_type.patch
x86-fix-cpufreq-tsc-scaling.patch

