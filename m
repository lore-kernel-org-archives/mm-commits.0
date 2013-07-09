From: akpm@linux-foundation.org
Subject: [merged]
 reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:13 -0700
Message-ID: <51dc9b25.Y8ehiRVsOZH3OxU4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GIXWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, mingo@kernel.org, mboton.lkml@gmail.com, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: [merged] reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch removed from -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,mboton.lkml@gmail.com,mingo@kernel.org,rja@sgi.com,rmk+kernel@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:13 -0700


The patch titled
     Subject: reboot: x86: prepare reboot_mode for moving to generic kernel code
has been removed from the -mm tree.  Its filename was
     reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

