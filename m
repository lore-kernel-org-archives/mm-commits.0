From: akpm@linux-foundation.org
Subject: - sdio-fix-break-control-to-now-return-success-or-an-error.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:14 -0700
Message-ID: <200807162135.m6GLZERI014065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756942AbYGPVlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, alan@lxorguk.ukuu.org.uk, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     sdio: fix break control to now return success or an error
has been removed from the -mm tree.  Its filename was
     sdio-fix-break-control-to-now-return-success-or-an-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: fix break control to now return success or an error
From: David Howells <dhowells@redhat.com>

Fix SDIO break control to now return success or an error.

This is a consequence of patch 9ea761bfef52c116fed4715d4043392c2503fe6a.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/sdio_uart.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/card/sdio_uart.c~sdio-fix-break-control-to-now-return-success-or-an-error drivers/mmc/card/sdio_uart.c
--- a/drivers/mmc/card/sdio_uart.c~sdio-fix-break-control-to-now-return-success-or-an-error
+++ a/drivers/mmc/card/sdio_uart.c
@@ -885,12 +885,14 @@ static void sdio_uart_set_termios(struct
 	sdio_uart_release_func(port);
 }
 
-static void sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
+static int sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
 {
 	struct sdio_uart_port *port = tty->driver_data;
+	int result;
 
-	if (sdio_uart_claim_func(port) != 0)
-		return;
+	result = sdio_uart_claim_func(port);
+	if (result != 0)
+		return result;
 
 	if (break_state == -1)
 		port->lcr |= UART_LCR_SBC;
@@ -899,6 +901,7 @@ static void sdio_uart_break_ctl(struct t
 	sdio_out(port, UART_LCR, port->lcr);
 
 	sdio_uart_release_func(port);
+	return 0;
 }
 
 static int sdio_uart_tiocmget(struct tty_struct *tty, struct file *file)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
netfilter-fix-xt_times-time_mts-use-of-do_div.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

