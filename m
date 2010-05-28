From: akpm@linux-foundation.org
Subject: + altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch added to -mm tree
Date: Fri, 28 May 2010 13:40:50 -0700
Message-ID: <201005282040.o4SKeojm012339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151Ab0E1Ukz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 16:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, tklauser@distanz.ch


The patch titled
     altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#32: FILE: drivers/serial/altera_uart.c:397:
+^I         ALTERA_UART_STATUS_TRDY_MSK))$

total: 1 errors, 0 warnings, 39 lines checked

./patches/altera_uart-simplify-altera_uart_console_putc.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Greg KH <greg@kroah.com>
Cc: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/altera_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/altera_uart.c~altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes drivers/serial/altera_uart.c
--- a/drivers/serial/altera_uart.c~altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes
+++ a/drivers/serial/altera_uart.c
@@ -394,7 +394,7 @@ int __init early_altera_uart_setup(struc
 static void altera_uart_console_putc(struct uart_port *port, const char c)
 {
 	while (!(readl(port->membase + ALTERA_UART_STATUS_REG) &
-	         ALTERA_UART_STATUS_TRDY_MSK))
+		 ALTERA_UART_STATUS_TRDY_MSK))
 		cpu_relax();
 
 	writel(c, port->membase + ALTERA_UART_TXDATA_REG);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
lib-kobject_ueventc-fix-conig_net=n-warning.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

