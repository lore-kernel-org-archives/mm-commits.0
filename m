From: akpm@linux-foundation.org
Subject: + x86_64-efi-runtime-service-support-efi-runtime-services.patch added to -mm tree
Date: Tue, 27 Nov 2007 02:03:13 -0800
Message-ID: <200711271003.lARA3DTj005998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755031AbXK0KEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 05:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de, mingo@elte.hu, mouli@linux.intel.com, tglx@linutronix.de


The patch titled
     x86_64 EFI runtime service support: EFI runtime services
has been added to the -mm tree.  Its filename is
     x86_64-efi-runtime-service-support-efi-runtime-services.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 EFI runtime service support: EFI runtime services
From: "Huang, Ying" <ying.huang@intel.com>

This patch adds support for several EFI runtime services for EFI x86_64
system.

The EFI support for emergency_restart is added.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot_64.c         |   20 +++++++++++++-------
 include/asm-x86/emergency-restart.h |    9 +++++++++
 2 files changed, 22 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/reboot_64.c~x86_64-efi-runtime-service-support-efi-runtime-services arch/x86/kernel/reboot_64.c
--- a/arch/x86/kernel/reboot_64.c~x86_64-efi-runtime-service-support-efi-runtime-services
+++ a/arch/x86/kernel/reboot_64.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <linux/efi.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/delay.h>
@@ -27,20 +28,17 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 static long no_idt[3];
-static enum { 
-	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k',
-	BOOT_ACPI = 'a'
-} reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_KBD;
 static int reboot_mode = 0;
 int reboot_force;
 
-/* reboot=t[riple] | k[bd] [, [w]arm | [c]old]
+/* reboot=t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
    acpi   Use the RESET_REG in the FADT
+   efi    Use efi reset_system runtime service
    force  Avoid anything that could hang.
  */ 
 static int __init reboot_setup(char *str)
@@ -59,6 +57,7 @@ static int __init reboot_setup(char *str
 		case 'a':
 		case 'b':
 		case 'k':
+		case 'e':
 			reboot_type = *str;
 			break;
 		case 'f':
@@ -151,7 +150,14 @@ void machine_emergency_restart(void)
 			acpi_reboot();
 			reboot_type = BOOT_KBD;
 			break;
-		}      
+
+		case BOOT_EFI:
+			if (efi_enabled)
+				efi.reset_system(reboot_mode ? EFI_RESET_WARM : EFI_RESET_COLD,
+						 EFI_SUCCESS, 0, NULL);
+			reboot_type = BOOT_KBD;
+			break;
+		}
 	}      
 }
 
diff -puN include/asm-x86/emergency-restart.h~x86_64-efi-runtime-service-support-efi-runtime-services include/asm-x86/emergency-restart.h
--- a/include/asm-x86/emergency-restart.h~x86_64-efi-runtime-service-support-efi-runtime-services
+++ a/include/asm-x86/emergency-restart.h
@@ -1,6 +1,15 @@
 #ifndef _ASM_EMERGENCY_RESTART_H
 #define _ASM_EMERGENCY_RESTART_H
 
+enum reboot_type {
+	BOOT_TRIPLE = 't',
+	BOOT_KBD = 'k',
+	BOOT_ACPI = 'a',
+	BOOT_EFI = 'e'
+};
+
+extern enum reboot_type reboot_type;
+
 extern void machine_emergency_restart(void);
 
 #endif /* _ASM_EMERGENCY_RESTART_H */
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
