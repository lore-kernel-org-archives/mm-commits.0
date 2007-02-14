From: akpm@linux-foundation.org
Subject: - cleanup-make-disable_acpi-valid-w-o-config_acpi.patch removed from -mm tree
Date: Tue, 13 Feb 2007 21:54:53 -0800
Message-ID: <200702140554.l1E5sraE022811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42620 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbXBNF4O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 00:56:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cleanup: make disable_acpi() valid w/o CONFIG_ACPI
has been removed from the -mm tree.  Its filename was
     cleanup-make-disable_acpi-valid-w-o-config_acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup: make disable_acpi() valid w/o CONFIG_ACPI
From: Rusty Russell <rusty@rustcorp.com.au>

Len Brown <lenb@kernel.org> said:
> Okay, but better to use disable_acpi()
> indeed, since this would be the first code not already inside CONFIG_ACPI
> to invoke disable_acpi(), we could define the inline as empty and you could
> then scratch the #ifdef too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/acpi.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-i386/acpi.h~cleanup-make-disable_acpi-valid-w-o-config_acpi include/asm-i386/acpi.h
--- a/include/asm-i386/acpi.h~cleanup-make-disable_acpi-valid-w-o-config_acpi
+++ a/include/asm-i386/acpi.h
@@ -127,6 +127,7 @@ extern int acpi_irq_balance_set(char *st
 #define acpi_ioapic 0
 static inline void acpi_noirq_set(void) { }
 static inline void acpi_disable_pci(void) { }
+static inline void disable_acpi(void) { }
 
 #endif	/* !CONFIG_ACPI */
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-acpi.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
