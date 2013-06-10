From: akpm@linux-foundation.org
Subject: +
 reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch added to -mm tree
Date: Mon, 10 Jun 2013 15:15:31 -0700
Message-ID: <51b65003.3MA4wSASgcafD7f0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3FJWPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 18:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: + reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch added to -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,rja@sgi.com,rmk+kernel@arm.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 15:15:31 -0700


The patch titled
     Subject: reboot: unicore32: prepare reboot_mode for moving to generic kernel code
has been added to the -mm tree.  Its filename is
     reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch

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

