From: akpm@osdl.org
Subject: - acpi-asus-s3-resume-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:29 -0800
Message-ID: <200612081104.kB8B4T2k018554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48612 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938030AbWLHLEf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:04:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luming.yu@intel.com, akpm@osdl.org, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: asus s3-resume fix
has been removed from the -mm tree.  Its filename was
     acpi-asus-s3-resume-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: acpi: asus s3-resume fix
From: "Yu, Luming" <luming.yu@intel.com>

See http://bugzilla.kernel.org/show_bug.cgi?id=6655

- extern decls never ever ever go in .c files.

- The !CONFIG_ACPI stub should be inline

- The !CONFIG_ACPI stub should be in a header file

- The !CONFIG_ACPI stub has an extra (and buggy) semicolon.

- The extra blank line in machine_emergency_restart() is unwelcome.

Cc: "Brown, Len" <len.brown@intel.com>
DESC
acpi-asus-s3-resume-fix-fix
EDESC

arch/i386/kernel/reboot.c: In function 'acpi_disable':
arch/i386/kernel/reboot.c:37: warning: control reaches end of non-void function

Also,

- extern decls never ever ever go in .c files.

- The !CONFIG_ACPI stub should be inline

- The !CONFIG_ACPI stub should be in a header file

- The !CONFIG_ACPI stub has an extra (and buggy) semicolon.

- The extra blank line in machine_emergency_restart() is unwelcome.

Cc: "Brown, Len" <len.brown@intel.com>
Cc: "Yu, Luming" <luming.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/reboot.c |   11 +++++++++++
 1 files changed, 11 insertions(+)

diff -puN arch/i386/kernel/reboot.c~acpi-asus-s3-resume-fix arch/i386/kernel/reboot.c
--- a/arch/i386/kernel/reboot.c~acpi-asus-s3-resume-fix
+++ a/arch/i386/kernel/reboot.c
@@ -30,6 +30,15 @@ static int reboot_thru_bios;
 #ifdef CONFIG_SMP
 static int reboot_cpu = -1;
 #endif
+#ifdef CONFIG_ACPI
+extern u32 acpi_disable(void);
+#else
+static u32 acpi_disable(void)
+{
+	return 0;
+};
+#endif
+
 static int __init reboot_setup(char *str)
 {
 	while(1) {
@@ -317,6 +326,8 @@ void machine_shutdown(void)
 
 void machine_emergency_restart(void)
 {
+
+	acpi_disable();
 	if (!reboot_thru_bios) {
 		if (efi_enabled) {
 			efi.reset_system(EFI_RESET_COLD, EFI_SUCCESS, 0, NULL);
_

Patches currently in -mm which might be from luming.yu@intel.com are

acpi-clear-gpe-before-disabling-it.patch
acpi-asus-s3-resume-fix.patch

