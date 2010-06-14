From: akpm@linux-foundation.org
Subject: + serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:12:49 -0700
Message-ID: <201006141912.o5EJCnM5025759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830Ab0FNTNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gerg@uclinux.org, greg@kroah.com, ygeorgie@gmail.com


The patch titled
     serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix
has been added to the -mm tree.  Its filename is
     serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch

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
Subject: serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

make irq-handler return value more explicit

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Yury Georgievskiy <ygeorgie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mcf.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/serial/mcf.c~serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix drivers/serial/mcf.c
--- a/drivers/serial/mcf.c~serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix
+++ a/drivers/serial/mcf.c
@@ -352,17 +352,22 @@ static irqreturn_t mcf_interrupt(int irq
 	struct uart_port *port = data;
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned int isr;
+	irqreturn_t ret = IRQ_NONE;
 
 	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
 
 	spin_lock(&port->lock);
-	if (isr & MCFUART_UIR_RXREADY)
+	if (isr & MCFUART_UIR_RXREADY) {
 		mcf_rx_chars(pp);
-	if (isr & MCFUART_UIR_TXREADY)
+		ret = IRQ_HANDLED;
+	}
+	if (isr & MCFUART_UIR_TXREADY) {
 		mcf_tx_chars(pp);
+		ret = IRQ_HANDLED;
+	}
 	spin_unlock(&port->lock);
 
-	return IRQ_RETVAL(isr);
+	return ret;
 }
 
 /****************************************************************************/
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
x86-olpc-add-support-for-calling-into-openfirmware-fix-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
mmc-recognize-csd-structure-fix.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

