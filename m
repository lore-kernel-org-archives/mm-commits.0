From: akpm@linux-foundation.org
Subject: - x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available.patch removed from -mm tree
Date: Tue, 25 Nov 2008 11:57:44 -0800
Message-ID: <200811251957.mAPJviji029291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260AbYKYT62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 14:58:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, arvidjaar@mail.ru, avi@redhat.com, ebiederm@xmission.com, ehabkost@redhat.com, lenb@kernel.org, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: attempt rebooting via port CF9 if it seems to be available
has been removed from the -mm tree.  Its filename was
     x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: attempt rebooting via port CF9 if it seems to be available
From: "H. Peter Anvin" <hpa@zytor.com>

Impact: Changes reboot behavior.

If port CF9 seems to be safe to touch, attempt it before trying the
keyboard controller.  Port CF9 is not available on all chipsets (a
significant but decreasing number of modern chipsets don't implement it),
but port CF9 itself should in general be safe to poke (no ill effects if
unimplemented) on any system which has PCI Configuration Method #1 or #2,
as it falls inside the PCI configuration port range in both cases.  No
chipset without PCI is known to have port CF9, either, although an
explicit "pci=bios" would mean we miss this and therefore don't use port
CF9.  An explicit "reboot=pci" can be used to force the use of port CF9.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/emergency-restart.h |    4 +-
 arch/x86/kernel/reboot.c                 |   34 ++++++++++++++++-----
 arch/x86/pci/direct.c                    |    4 +-
 arch/x86/pci/pci.h                       |    1 
 4 files changed, 34 insertions(+), 9 deletions(-)

diff -puN arch/x86/include/asm/emergency-restart.h~x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available arch/x86/include/asm/emergency-restart.h
--- a/arch/x86/include/asm/emergency-restart.h~x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available
+++ a/arch/x86/include/asm/emergency-restart.h
@@ -8,7 +8,9 @@ enum reboot_type {
 	BOOT_BIOS = 'b',
 #endif
 	BOOT_ACPI = 'a',
-	BOOT_EFI = 'e'
+	BOOT_EFI = 'e',
+	BOOT_CF9 = 'p',
+	BOOT_CF9_COND = 'q',
 };
 
 extern enum reboot_type reboot_type;
diff -puN arch/x86/kernel/reboot.c~x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available
+++ a/arch/x86/kernel/reboot.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_ACPI;
+enum reboot_type reboot_type = BOOT_CF9_COND;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
@@ -46,7 +46,10 @@ static int reboot_cpu = -1;
  */
 static int reboot_emergency;
 
-/* reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
+/* This is set by the PCI code if either type 1 or type 2 PCI is detected */
+bool port_cf9_safe = false;
+
+/* reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    bios   Reboot by jumping through the BIOS (only for X86_32)
@@ -55,6 +58,7 @@ static int reboot_emergency;
    kbd    Use the keyboard controller. cold reset (default)
    acpi   Use the RESET_REG in the FADT
    efi    Use efi reset_system runtime service
+   pci    Use the so-called "PCI reset register", CF9
    force  Avoid anything that could hang.
  */
 static int __init reboot_setup(char *str)
@@ -89,6 +93,7 @@ static int __init reboot_setup(char *str
 		case 'k':
 		case 't':
 		case 'e':
+		case 'p':
 			reboot_type = *str;
 			break;
 
@@ -451,28 +456,43 @@ static void native_machine_emergency_res
 			load_idt(&no_idt);
 			__asm__ __volatile__("int3");
 
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_CF9_COND;
 			break;
 
 #ifdef CONFIG_X86_32
 		case BOOT_BIOS:
 			machine_real_restart(jump_to_bios, sizeof(jump_to_bios));
 
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_CF9_COND;
 			break;
 #endif
 
 		case BOOT_ACPI:
 			acpi_reboot();
-			reboot_type = BOOT_KBD;
+			reboot_type = BOOT_CF9_COND;
 			break;
 
-
 		case BOOT_EFI:
 			if (efi_enabled)
-				efi.reset_system(reboot_mode ? EFI_RESET_WARM : EFI_RESET_COLD,
+				efi.reset_system(reboot_mode ?
+						 EFI_RESET_WARM :
+						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
+			reboot_type = BOOT_CF9_COND;
+			break;
+
+		case BOOT_CF9:
+			port_cf9_safe = true;
+			/* fall through */
 
+		case BOOT_CF9_COND:
+			if (port_cf9_safe) {
+				u8 cf9 = inb(0xcf9) & ~6;
+				outb(cf9|2, 0xcf9); /* Request hard reset */
+				udelay(50);
+				outb(cf9|6, 0xcf9); /* Actually do the reset */
+				udelay(50);
+			}
 			reboot_type = BOOT_KBD;
 			break;
 		}
diff -puN arch/x86/pci/direct.c~x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available arch/x86/pci/direct.c
--- a/arch/x86/pci/direct.c~x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available
+++ a/arch/x86/pci/direct.c
@@ -173,7 +173,7 @@ static int pci_conf2_write(unsigned int 
 
 #undef PCI_CONF2_ADDRESS
 
-static struct pci_raw_ops pci_direct_conf2 = {
+struct pci_raw_ops pci_direct_conf2 = {
 	.read =		pci_conf2_read,
 	.write =	pci_conf2_write,
 };
@@ -289,6 +289,7 @@ int __init pci_direct_probe(void)
 
 	if (pci_check_type1()) {
 		raw_pci_ops = &pci_direct_conf1;
+		port_cf9_safe = true;
 		return 1;
 	}
 	release_resource(region);
@@ -305,6 +306,7 @@ int __init pci_direct_probe(void)
 
 	if (pci_check_type2()) {
 		raw_pci_ops = &pci_direct_conf2;
+		port_cf9_safe = true;
 		return 2;
 	}
 
diff -puN arch/x86/pci/pci.h~x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available arch/x86/pci/pci.h
--- a/arch/x86/pci/pci.h~x86-attempt-rebooting-via-port-cf9-if-it-seems-to-be-available
+++ a/arch/x86/pci/pci.h
@@ -96,6 +96,7 @@ extern struct pci_raw_ops *raw_pci_ops;
 extern struct pci_raw_ops *raw_pci_ext_ops;
 
 extern struct pci_raw_ops pci_direct_conf1;
+extern bool port_cf9_safe;
 
 /* arch_initcall level */
 extern int pci_direct_probe(void);
_

Patches currently in -mm which might be from hpa@zytor.com are

linux-next.patch
apm-remove-config_apm_real_mode_power_off-in-favor-of-kernel-parameter.patch

