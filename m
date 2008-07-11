From: akpm@linux-foundation.org
Subject: + sdio-fix-break-control-to-now-return-success-or-an-error.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:43:26 -0700
Message-ID: <200807111849.m6BIn7Pn031181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946AbYGKStg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, alan@lxorguk.ukuu.org.uk, drzeus@drzeus.cx


The patch titled
     sdio: fix break control to now return success or an error
has been added to the -mm tree.  Its filename is
     sdio-fix-break-control-to-now-return-success-or-an-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
acpi-fix-build-with-config_pm_sleep=n.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-mixart-soundcard-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
fix-a-const-assignment-in-moxa_load_fw.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

