From: akpm@linux-foundation.org
Subject: - x86_64-add-acpi-reboot-option.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:52 -0800
Message-ID: <200712172340.lBHNeqUM008324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935518AbXLQXxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adurbin@google.com, ak@suse.de, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: add ACPI reboot option
has been removed from the -mm tree.  Its filename was
     x86_64-add-acpi-reboot-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: add ACPI reboot option
From: Aaron Durbin <adurbin@google.com>

Add the ability to reboot an x86_64 based machine using the RESET_REG in the
FADT ACPI table.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    5 ++++-
 arch/x86/kernel/reboot_64.c           |   11 ++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86_64-add-acpi-reboot-option Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-add-acpi-reboot-option
+++ a/Documentation/x86_64/boot-options.txt
@@ -110,12 +110,15 @@ Idle loop
 
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
diff -puN arch/x86/kernel/reboot_64.c~x86_64-add-acpi-reboot-option arch/x86/kernel/reboot_64.c
--- a/arch/x86/kernel/reboot_64.c~x86_64-add-acpi-reboot-option
+++ a/arch/x86/kernel/reboot_64.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/desc.h>
@@ -29,7 +30,8 @@ EXPORT_SYMBOL(pm_power_off);
 static long no_idt[3];
 static enum { 
 	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k'
+	BOOT_KBD = 'k',
+	BOOT_ACPI = 'a'
 } reboot_type = BOOT_KBD;
 static int reboot_mode = 0;
 int reboot_force;
@@ -39,6 +41,7 @@ int reboot_force;
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   acpi   Use the RESET_REG in the FADT
    force  Avoid anything that could hang.
  */ 
 static int __init reboot_setup(char *str)
@@ -54,6 +57,7 @@ static int __init reboot_setup(char *str
 			break;
 
 		case 't':
+		case 'a':
 		case 'b':
 		case 'k':
 			reboot_type = *str;
@@ -146,6 +150,11 @@ void machine_emergency_restart(void)
 
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

git-x86.patch
