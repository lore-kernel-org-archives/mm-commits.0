From: akpm@linux-foundation.org
Subject: + cleanup-move-mce_disabled-to-asm-mceh.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:10 -0800
Message-ID: <200702130703.l1D73A9w024514@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56977 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbXBMHDR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     cleanup: Move mce_disabled to asm/mce.h
has been added to the -mm tree.  Its filename is
     cleanup-move-mce_disabled-to-asm-mceh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup: Move mce_disabled to asm/mce.h
From: Rusty Russell <rusty@rustcorp.com.au>

Allows external actors to disable mce.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/mce.h |    2 +-
 include/asm-i386/mce.h            |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/mcheck/mce.h~cleanup-move-mce_disabled-to-asm-mceh arch/i386/kernel/cpu/mcheck/mce.h
--- a/arch/i386/kernel/cpu/mcheck/mce.h~cleanup-move-mce_disabled-to-asm-mceh
+++ a/arch/i386/kernel/cpu/mcheck/mce.h
@@ -1,4 +1,5 @@
 #include <linux/init.h>
+#include <asm/mce.h>
 
 void amd_mcheck_init(struct cpuinfo_x86 *c);
 void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
@@ -9,6 +10,5 @@ void winchip_mcheck_init(struct cpuinfo_
 /* Call the installed machine check handler for this CPU setup. */
 extern fastcall void (*machine_check_vector)(struct pt_regs *, long error_code);
 
-extern int mce_disabled;
 extern int nr_mce_banks;
 
diff -puN include/asm-i386/mce.h~cleanup-move-mce_disabled-to-asm-mceh include/asm-i386/mce.h
--- a/include/asm-i386/mce.h~cleanup-move-mce_disabled-to-asm-mceh
+++ a/include/asm-i386/mce.h
@@ -3,3 +3,5 @@ extern void mcheck_init(struct cpuinfo_x
 #else
 #define mcheck_init(c) do {} while(0)
 #endif
+
+extern int mce_disabled;
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
