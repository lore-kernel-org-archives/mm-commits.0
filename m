From: akpm@linux-foundation.org
Subject: + blackfin-arch-always-include-linux-kallsysms-header-file.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:24:36 -0700
Message-ID: <200704062124.l36LOaFZ019314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbXDFVYi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     Blackfin arch: always include linux kallsysms header file in trap c
has been added to the -mm tree.  Its filename is
     blackfin-arch-always-include-linux-kallsysms-header-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin arch: always include linux kallsysms header file in trap c
From: "Wu, Bryan" <bryan.wu@analog.com>

Just include linux/kallsyms.h all the time as the header will handle
prototypes/defines when CONFIG_KALLSYMS is disabled ...  fixes build error
when disabled due to print_ip_sym not being macroed away

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/traps.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/blackfin/kernel/traps.c~blackfin-arch-always-include-linux-kallsysms-header-file arch/blackfin/kernel/traps.c
--- a/arch/blackfin/kernel/traps.c~blackfin-arch-always-include-linux-kallsysms-header-file
+++ a/arch/blackfin/kernel/traps.c
@@ -35,6 +35,8 @@
 #include <asm/irq_handler.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/kallsyms.h>
+
 #ifdef CONFIG_KGDB
 # include <linux/debugger.h>
 # include <linux/kgdb.h>
@@ -52,9 +54,6 @@ asmlinkage void trap_c(struct pt_regs *f
 
 int kstack_depth_to_print = 48;
 
-#ifdef CONFIG_KALLSYMS
-#include <linux/kallsyms.h>
-#endif
 static int printk_address(unsigned long address)
 {
 	struct vm_list_struct *vml;
_

Patches currently in -mm which might be from bryan.wu@analog.com are

usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
move-die-notifier-handling-to-common-code-fix.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
