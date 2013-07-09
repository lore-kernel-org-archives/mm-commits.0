From: akpm@linux-foundation.org
Subject: [merged]
 reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:16 -0700
Message-ID: <51dc9b28.gZdp8ocX6+viyTBU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3GIXWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: [merged] reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch removed from -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,rja@sgi.com,rmk+kernel@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:16 -0700


The patch titled
     Subject: reboot: arm: prepare reboot_mode for moving to generic kernel code
has been removed from the -mm tree.  Its filename was
     reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: arm: prepare reboot_mode for moving to generic kernel code

Prepare for the moving the parsing of reboot= to the generic kernel code
by making reboot_mode into a more generic form.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/mach/arch.h   |    3 ++-
 arch/arm/kernel/process.c          |    8 ++++----
 arch/arm/kernel/setup.c            |    6 +++---
 arch/arm/mach-footbridge/cats-hw.c |    2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff -puN arch/arm/include/asm/mach/arch.h~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/arm/include/asm/mach/arch.h
--- a/arch/arm/include/asm/mach/arch.h~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/arm/include/asm/mach/arch.h
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 
 #ifndef __ASSEMBLY__
+#include <linux/reboot.h>
 
 struct tag;
 struct meminfo;
@@ -43,7 +44,7 @@ struct machine_desc {
 	unsigned char		reserve_lp0 :1;	/* never has lp0	*/
 	unsigned char		reserve_lp1 :1;	/* never has lp1	*/
 	unsigned char		reserve_lp2 :1;	/* never has lp2	*/
-	char			restart_mode;	/* default restart mode	*/
+	enum reboot_mode	reboot_mode;	/* default restart mode	*/
 	struct smp_operations	*smp;		/* SMP operations	*/
 	bool			(*smp_init)(void);
 	void			(*fixup)(struct tag *, char **,
diff -puN arch/arm/kernel/process.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/arm/kernel/process.c
@@ -175,14 +175,14 @@ void arch_cpu_idle(void)
 		default_idle();
 }
 
-static char reboot_mode = 'h';
+enum reboot_mode reboot_mode = REBOOT_HARD;
 
-int __init reboot_setup(char *str)
+static int __init reboot_setup(char *str)
 {
-	reboot_mode = str[0];
+	if ('s' == str[0])
+		reboot_mode = REBOOT_SOFT;
 	return 1;
 }
-
 __setup("reboot=", reboot_setup);
 
 /*
diff -puN arch/arm/kernel/setup.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/arm/kernel/setup.c
@@ -74,7 +74,7 @@ __setup("fpe=", fpe_setup);
 
 extern void paging_init(struct machine_desc *desc);
 extern void sanity_check_meminfo(void);
-extern void reboot_setup(char *str);
+extern enum reboot_mode reboot_mode;
 extern void setup_dma_zone(struct machine_desc *desc);
 
 unsigned int processor_id;
@@ -861,8 +861,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_dma_zone(mdesc);
 
-	if (mdesc->restart_mode)
-		reboot_setup(&mdesc->restart_mode);
+	if (mdesc->reboot_mode != REBOOT_HARD)
+		reboot_mode = mdesc->reboot_mode;
 
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
diff -puN arch/arm/mach-footbridge/cats-hw.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/arm/mach-footbridge/cats-hw.c
--- a/arch/arm/mach-footbridge/cats-hw.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/arm/mach-footbridge/cats-hw.c
@@ -86,7 +86,7 @@ fixup_cats(struct tag *tags, char **cmdl
 MACHINE_START(CATS, "Chalice-CATS")
 	/* Maintainer: Philip Blundell */
 	.atag_offset	= 0x100,
-	.restart_mode	= 's',
+	.reboot_mode	= REBOOT_SOFT,
 	.fixup		= fixup_cats,
 	.map_io		= footbridge_map_io,
 	.init_irq	= footbridge_init_irq,
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

