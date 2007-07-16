From: akpm@linux-foundation.org
Subject: + x86_64-add-acpi-reboot-option.patch added to -mm tree
Date: Mon, 16 Jul 2007 14:57:53 -0700
Message-ID: <200707162157.l6GLvrGt006237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbXGPV6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:58:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adurbin@google.com, ak@suse.de, lenb@kernel.org


The patch titled
     x86_64: add ACPI reboot option
has been added to the -mm tree.  Its filename is
     x86_64-add-acpi-reboot-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: add ACPI reboot option
From: Aaron Durbin <adurbin@google.com>

Add the ability to reboot an x86_64 based machine using the RESET_REG in the
FADT ACPI table.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    5 ++++-
 arch/x86_64/kernel/reboot.c           |   11 ++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86_64-add-acpi-reboot-option Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-add-acpi-reboot-option
+++ a/Documentation/x86_64/boot-options.txt
@@ -108,12 +108,15 @@ Idle loop
 
 Rebooting
 
-   reboot=b[ios] | t[riple] | k[bd] [, [w]arm | [c]old]
+   reboot=b[ios] | t[riple] | k[bd] | a[cpi] [, [w]arm | [c]old]
    bios	  Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
+          ACPI reset does not work, the reboot path attempts the reset using
+          the keyboard controller.
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
diff -puN arch/x86_64/kernel/reboot.c~x86_64-add-acpi-reboot-option arch/x86_64/kernel/reboot.c
--- a/arch/x86_64/kernel/reboot.c~x86_64-add-acpi-reboot-option
+++ a/arch/x86_64/kernel/reboot.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/hw_irq.h>
@@ -26,7 +27,8 @@ EXPORT_SYMBOL(pm_power_off);
 static long no_idt[3];
 static enum { 
 	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k'
+	BOOT_KBD = 'k',
+	BOOT_ACPI = 'a'
 } reboot_type = BOOT_KBD;
 static int reboot_mode = 0;
 int reboot_force;
@@ -36,6 +38,7 @@ int reboot_force;
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   acpi   Use the RESET_REG in the FADT
    force  Avoid anything that could hang.
  */ 
 static int __init reboot_setup(char *str)
@@ -51,6 +54,7 @@ static int __init reboot_setup(char *str
 			break;
 
 		case 't':
+		case 'a':
 		case 'b':
 		case 'k':
 			reboot_type = *str;
@@ -137,6 +141,11 @@ void machine_emergency_restart(void)
 
 			reboot_type = BOOT_KBD;
 			break;
+
+		case BOOT_ACPI:
+			acpi_reboot();
+			reboot_type = BOOT_KBD;
+			break;
 		}      
 	}      
 }
_

Patches currently in -mm which might be from adurbin@google.com are

acpi-add-reboot-mechanism.patch
x86_64-add-acpi-reboot-option.patch
x86_64-make-acpi-the-default-reset-option.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
