From: akpm@linux-foundation.org
Subject: +
 reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
 added to -mm tree
Date: Mon, 10 Jun 2013 15:15:30 -0700
Message-ID: <51b65002.oqFoY+FvvaDmYUMy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3FJWPg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 18:15:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, mingo@kernel.org, mboton.lkml@gmail.com, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: + reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch added to -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,mboton.lkml@gmail.com,mingo@kernel.org,rja@sgi.com,rmk+kernel@arm.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 15:15:30 -0700


The patch titled
     Subject: reboot: x86: prepare reboot_mode for moving to generic kernel code
has been added to the -mm tree.  Its filename is
     reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch

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
Subject: reboot: x86: prepare reboot_mode for moving to generic kernel code

Prepare for the moving the parsing of reboot= to the generic kernel code
by making reboot_mode into a more generic form.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Miguel Boton <mboton.lkml@gmail.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |   12 +++++++-----
 include/linux/reboot.h   |    5 +++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/reboot.c~reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/x86/kernel/reboot.c
@@ -36,7 +36,7 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
-static int reboot_mode;
+static enum reboot_mode reboot_mode;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
@@ -88,11 +88,11 @@ static int __init reboot_setup(char *str
 
 		switch (*str) {
 		case 'w':
-			reboot_mode = 0x1234;
+			reboot_mode = REBOOT_WARM;
 			break;
 
 		case 'c':
-			reboot_mode = 0;
+			reboot_mode = REBOOT_COLD;
 			break;
 
 #ifdef CONFIG_SMP
@@ -536,6 +536,7 @@ static void native_machine_emergency_res
 	int i;
 	int attempt = 0;
 	int orig_reboot_type = reboot_type;
+	unsigned short mode;
 
 	if (reboot_emergency)
 		emergency_vmx_disable_all();
@@ -543,7 +544,8 @@ static void native_machine_emergency_res
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
 	/* Tell the BIOS if we want cold or warm reboot */
-	*((unsigned short *)__va(0x472)) = reboot_mode;
+	mode = reboot_mode == REBOOT_WARM ? 0x1234 : 0;
+	*((unsigned short *)__va(0x472)) = mode;
 
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
@@ -585,7 +587,7 @@ static void native_machine_emergency_res
 
 		case BOOT_EFI:
 			if (efi_enabled(EFI_RUNTIME_SERVICES))
-				efi.reset_system(reboot_mode ?
+				efi.reset_system(reboot_mode == REBOOT_WARM ?
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
diff -puN include/linux/reboot.h~reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code include/linux/reboot.h
--- a/include/linux/reboot.h~reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/include/linux/reboot.h
@@ -10,6 +10,11 @@
 #define SYS_HALT	0x0002	/* Notify of system halt */
 #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
 
+enum reboot_mode {
+	REBOOT_COLD = 0,
+	REBOOT_WARM,
+};
+
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
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

