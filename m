From: akpm@linux-foundation.org
Subject: [merged] eeepc-should-depend-on-input.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:44 -0800
Message-ID: <200902191916.n1JJGiKB016279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbZBSTRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, lenb@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     eeepc: should depend on INPUT
has been removed from the -mm tree.  Its filename was
     eeepc-should-depend-on-input.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eeepc: should depend on INPUT
From: Alexey Dobriyan <adobriyan@gmail.com>

Otherwise with INPUT=m, EEEPC_LAPTOP=y one gets

drivers/built-in.o: In function `input_sync':
eeepc-laptop.c:(.text+0x18ce51): undefined reference to `input_event'
drivers/built-in.o: In function `input_report_key':
eeepc-laptop.c:(.text+0x18ce73): undefined reference to `input_event'
drivers/built-in.o: In function `eeepc_hotk_check':
eeepc-laptop.c:(.text+0x18d05f): undefined reference to `input_allocate_device'
eeepc-laptop.c:(.text+0x18d10f): undefined reference to `input_register_device'
eeepc-laptop.c:(.text+0x18d131): undefined reference to `input_free_device'
drivers/built-in.o: In function `eeepc_backlight_exit':
eeepc-laptop.c:(.text+0x18d546): undefined reference to `input_unregister_device'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/Kconfig~eeepc-should-depend-on-input drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~eeepc-should-depend-on-input
+++ a/drivers/platform/x86/Kconfig
@@ -301,6 +301,7 @@ config INTEL_MENLOW
 config EEEPC_LAPTOP
 	tristate "Eee PC Hotkey Driver (EXPERIMENTAL)"
 	depends on ACPI
+	depends on INPUT
 	depends on EXPERIMENTAL
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
fs-proc-task_mmuc-fix-sparse-warnings.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
xtensa-fix-compilation-somewhat.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

