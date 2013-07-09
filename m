From: akpm@linux-foundation.org
Subject: [merged]
 reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:15 -0700
Message-ID: <51dc9b27.26vsO4hI86wR/NQ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GIXWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: [merged] reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch removed from -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,rja@sgi.com,rmk+kernel@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:15 -0700


The patch titled
     Subject: reboot: arm: remove unused restart_mode fields from some arm subarchs
has been removed from the -mm tree.  Its filename was
     reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: arm: remove unused restart_mode fields from some arm subarchs

These restart_mode fields are not used at all.  Remove them to make moving
the reboot= cmdline options to the general kernel easier.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ebsa110/core.c |    1 -
 arch/arm/mach-pxa/mioa701.c  |    1 -
 arch/arm/mach-pxa/spitz.c    |    3 ---
 arch/arm/mach-pxa/tosa.c     |    1 -
 4 files changed, 6 deletions(-)

diff -puN arch/arm/mach-ebsa110/core.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs arch/arm/mach-ebsa110/core.c
--- a/arch/arm/mach-ebsa110/core.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs
+++ a/arch/arm/mach-ebsa110/core.c
@@ -321,7 +321,6 @@ MACHINE_START(EBSA110, "EBSA110")
 	.atag_offset	= 0x400,
 	.reserve_lp0	= 1,
 	.reserve_lp2	= 1,
-	.restart_mode	= 's',
 	.map_io		= ebsa110_map_io,
 	.init_early	= ebsa110_init_early,
 	.init_irq	= ebsa110_init_irq,
diff -puN arch/arm/mach-pxa/mioa701.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs arch/arm/mach-pxa/mioa701.c
--- a/arch/arm/mach-pxa/mioa701.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs
+++ a/arch/arm/mach-pxa/mioa701.c
@@ -761,7 +761,6 @@ static void mioa701_machine_exit(void)
 
 MACHINE_START(MIOA701, "MIO A701")
 	.atag_offset	= 0x100,
-	.restart_mode	= 's',
 	.map_io		= &pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
 	.init_irq	= &pxa27x_init_irq,
diff -puN arch/arm/mach-pxa/spitz.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs arch/arm/mach-pxa/spitz.c
--- a/arch/arm/mach-pxa/spitz.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs
+++ a/arch/arm/mach-pxa/spitz.c
@@ -979,7 +979,6 @@ static void __init spitz_fixup(struct ta
 
 #ifdef CONFIG_MACH_SPITZ
 MACHINE_START(SPITZ, "SHARP Spitz")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
@@ -993,7 +992,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_BORZOI
 MACHINE_START(BORZOI, "SHARP Borzoi")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
@@ -1007,7 +1005,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_AKITA
 MACHINE_START(AKITA, "SHARP Akita")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
diff -puN arch/arm/mach-pxa/tosa.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs arch/arm/mach-pxa/tosa.c
--- a/arch/arm/mach-pxa/tosa.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs
+++ a/arch/arm/mach-pxa/tosa.c
@@ -969,7 +969,6 @@ static void __init fixup_tosa(struct tag
 }
 
 MACHINE_START(TOSA, "SHARP Tosa")
-	.restart_mode	= 'g',
 	.fixup          = fixup_tosa,
 	.map_io         = pxa25x_map_io,
 	.nr_irqs	= TOSA_NR_IRQS,
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

