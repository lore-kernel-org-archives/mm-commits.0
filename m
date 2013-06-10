From: akpm@linux-foundation.org
Subject: +
 reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
 added to -mm tree
Date: Mon, 10 Jun 2013 15:15:33 -0700
Message-ID: <51b65005.A3BqkrYDtDdjRrer%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3FJWPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 18:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: + reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch added to -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,rja@sgi.com,rmk+kernel@arm.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 15:15:33 -0700


The patch titled
     Subject: reboot: arm: prepare reboot_mode for moving to generic kernel code
has been added to the -mm tree.  Its filename is
     reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -174,14 +174,14 @@ void arch_cpu_idle(void)
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
 
 void machine_shutdown(void)
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
@@ -790,8 +790,8 @@ void __init setup_arch(char **cmdline_p)
 
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

cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-v11.patch
migrate-shutdown-reboot-to-boot-cpu.patch
migrate-shutdown-reboot-to-boot-cpu-v11.patch
drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info.patch
dump_stack-serialize-the-output-from-dump_stack.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch
drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch
reboot-remove-stable-friendly-pf_thread_bound-define.patch
reboot-move-shutdown-reboot-related-functions-to-kernel-rebootc.patch
reboot-checkpatchpl-the-new-kernel-rebootc-file.patch
reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch
reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel.patch

