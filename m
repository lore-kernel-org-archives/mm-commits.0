From: akpm@linux-foundation.org
Subject: + xtensa-variant-irq-set-callbacks.patch added to -mm tree
Date: Mon, 30 Mar 2009 17:00:11 -0700
Message-ID: <200903310000.n2V00CKR031415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbZCaANV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 20:13:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, dg@emlix.com, os@emlix.com


The patch titled
     xtensa: variant irq set callbacks
has been added to the -mm tree.  Its filename is
     xtensa-variant-irq-set-callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: variant irq set callbacks
From: Johannes Weiner <jw@emlix.com>

Allow the core variant code to provide irq enable/disable callbacks.

The s6000 has a crossbar that multiplexes peripheral IRQ lines to a
smaller number of core lines.  These callbacks allow the s6000 variant
to program the crossbar when core lines are toggled.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig           |    3 +++
 arch/xtensa/include/asm/irq.h |    7 +++++++
 arch/xtensa/kernel/irq.c      |   14 ++++++++++++++
 3 files changed, 24 insertions(+)

diff -puN arch/xtensa/Kconfig~xtensa-variant-irq-set-callbacks arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~xtensa-variant-irq-set-callbacks
+++ a/arch/xtensa/Kconfig
@@ -57,6 +57,9 @@ config HZ
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
+config VARIANT_IRQ_SWITCH
+	def_bool n
+
 menu "Processor type and features"
 
 choice
diff -puN arch/xtensa/include/asm/irq.h~xtensa-variant-irq-set-callbacks arch/xtensa/include/asm/irq.h
--- a/arch/xtensa/include/asm/irq.h~xtensa-variant-irq-set-callbacks
+++ a/arch/xtensa/include/asm/irq.h
@@ -14,6 +14,13 @@
 #include <platform/hardware.h>
 #include <variant/core.h>
 
+#ifdef CONFIG_VARIANT_IRQ_SWITCH
+#include <variant/irq.h>
+#else
+static inline void variant_irq_enable(unsigned int irq) { }
+static inline void variant_irq_disable(unsigned int irq) { }
+#endif
+
 #ifndef PLATFORM_NR_IRQS
 # define PLATFORM_NR_IRQS 0
 #endif
diff -puN arch/xtensa/kernel/irq.c~xtensa-variant-irq-set-callbacks arch/xtensa/kernel/irq.c
--- a/arch/xtensa/kernel/irq.c~xtensa-variant-irq-set-callbacks
+++ a/arch/xtensa/kernel/irq.c
@@ -132,6 +132,18 @@ static void xtensa_irq_unmask(unsigned i
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
+static void xtensa_irq_enable(unsigned int irq)
+{
+	variant_irq_enable(irq);
+	xtensa_irq_unmask(irq);
+}
+
+static void xtensa_irq_disable(unsigned int irq)
+{
+	xtensa_irq_mask(irq);
+	variant_irq_disable(irq);
+}
+
 static void xtensa_irq_ack(unsigned int irq)
 {
 	set_sr(1 << irq, INTCLEAR);
@@ -146,6 +158,8 @@ static int xtensa_irq_retrigger(unsigned
 
 static struct irq_chip xtensa_irq_chip = {
 	.name		= "xtensa",
+	.enable		= xtensa_irq_enable,
+	.disable	= xtensa_irq_disable,
 	.mask		= xtensa_irq_mask,
 	.unmask		= xtensa_irq_unmask,
 	.ack		= xtensa_irq_ack,
_

Patches currently in -mm which might be from jw@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

