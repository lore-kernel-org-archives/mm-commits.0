From: akpm@linux-foundation.org
Subject: [merged]
 reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:14 -0700
Message-ID: <51dc9b26.u7Gl7dzVmAg9XUAy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3GIXWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: [merged] reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch removed from -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,rja@sgi.com,rmk+kernel@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:14 -0700


The patch titled
     Subject: reboot: unicore32: prepare reboot_mode for moving to generic kernel code
has been removed from the -mm tree.  Its filename was
     reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: unicore32: prepare reboot_mode for moving to generic kernel code

Prepare for the moving the parsing of reboot= to the generic kernel code
by making reboot_mode into a more generic form.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/process.c |   10 +++++-----
 arch/unicore32/kernel/setup.h   |    2 +-
 arch/unicore32/mm/mmu.c         |    2 +-
 include/linux/reboot.h          |    2 ++
 4 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/unicore32/kernel/process.c~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/unicore32/kernel/process.c
--- a/arch/unicore32/kernel/process.c~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/unicore32/kernel/process.c
@@ -51,14 +51,14 @@ void arch_cpu_idle(void)
 	local_irq_enable();
 }
 
-static char reboot_mode = 'h';
+static enum reboot_mode reboot_mode = REBOOT_HARD;
 
 int __init reboot_setup(char *str)
 {
-	reboot_mode = str[0];
+	if ('s' == str[0])
+		reboot_mode = REBOOT_SOFT;
 	return 1;
 }
-
 __setup("reboot=", reboot_setup);
 
 void machine_halt(void)
@@ -88,7 +88,7 @@ void machine_restart(char *cmd)
 	 * we may need it to insert some 1:1 mappings so that
 	 * soft boot works.
 	 */
-	setup_mm_for_reboot(reboot_mode);
+	setup_mm_for_reboot();
 
 	/* Clean and invalidate caches */
 	flush_cache_all();
@@ -102,7 +102,7 @@ void machine_restart(char *cmd)
 	/*
 	 * Now handle reboot code.
 	 */
-	if (reboot_mode == 's') {
+	if (reboot_mode == REBOOT_SOFT) {
 		/* Jump into ROM at address 0xffff0000 */
 		cpu_reset(VECTORS_BASE);
 	} else {
diff -puN arch/unicore32/kernel/setup.h~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/unicore32/kernel/setup.h
--- a/arch/unicore32/kernel/setup.h~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/unicore32/kernel/setup.h
@@ -22,7 +22,7 @@ extern void puv3_ps2_init(void);
 extern void pci_puv3_preinit(void);
 extern void __init puv3_init_gpio(void);
 
-extern void setup_mm_for_reboot(char mode);
+extern void setup_mm_for_reboot(void);
 
 extern char __stubs_start[], __stubs_end[];
 extern char __vectors_start[], __vectors_end[];
diff -puN arch/unicore32/mm/mmu.c~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/unicore32/mm/mmu.c
--- a/arch/unicore32/mm/mmu.c~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/unicore32/mm/mmu.c
@@ -445,7 +445,7 @@ void __init paging_init(void)
  * the user-mode pages.  This will then ensure that we have predictable
  * results when turning the mmu off
  */
-void setup_mm_for_reboot(char mode)
+void setup_mm_for_reboot(void)
 {
 	unsigned long base_pmdval;
 	pgd_t *pgd;
diff -puN include/linux/reboot.h~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code include/linux/reboot.h
--- a/include/linux/reboot.h~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/include/linux/reboot.h
@@ -13,6 +13,8 @@
 enum reboot_mode {
 	REBOOT_COLD = 0,
 	REBOOT_WARM,
+	REBOOT_HARD,
+	REBOOT_SOFT,
 };
 
 extern int register_reboot_notifier(struct notifier_block *);
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

