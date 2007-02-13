From: akpm@linux-foundation.org
Subject: + cleanup-make-disable_acpi-valid-w-o-config_acpi.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:16 -0800
Message-ID: <200702130703.l1D73Gwb024525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57049 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbXBMHEh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:04:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, lenb@kernel.org


The patch titled
     cleanup: make disable_acpi() valid w/o CONFIG_ACPI
has been added to the -mm tree.  Its filename is
     cleanup-make-disable_acpi-valid-w-o-config_acpi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
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
