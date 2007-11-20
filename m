From: akpm@linux-foundation.org
Subject: + serial8250-coding-style.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:23:26 -0800
Message-ID: <200711200723.lAK7NQHn021398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866AbXKTH3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:29:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     serial8250: coding style
has been added to the -mm tree.  Its filename is
     serial8250-coding-style.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial8250: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/serial/8250.c~serial8250-coding-style drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial8250-coding-style
+++ a/drivers/serial/8250.c
@@ -305,7 +305,7 @@ static inline int map_8250_out_reg(struc
 	return au_io_out_map[offset];
 }
 
-#elif defined (CONFIG_SERIAL_8250_RM9K)
+#elif defined(CONFIG_SERIAL_8250_RM9K)
 
 static const u8
 	regmap_in[8] = {
@@ -475,7 +475,7 @@ static inline void _serial_dl_write(stru
 	serial_outp(up, UART_DLM, value >> 8 & 0xff);
 }
 
-#if defined (CONFIG_SERIAL_8250_AU1X00)
+#if defined(CONFIG_SERIAL_8250_AU1X00)
 /* Au1x00 haven't got a standard divisor latch */
 static int serial_dl_read(struct uart_8250_port *up)
 {
@@ -492,7 +492,7 @@ static void serial_dl_write(struct uart_
 	else
 		_serial_dl_write(up, value);
 }
-#elif defined (CONFIG_SERIAL_8250_RM9K)
+#elif defined(CONFIG_SERIAL_8250_RM9K)
 static int serial_dl_read(struct uart_8250_port *up)
 {
 	return	(up->port.iotype == UPIO_RM9000) ?
@@ -1185,8 +1185,8 @@ static void autoconfig_irq(struct uart_8
 
 	irqs = probe_irq_on();
 	serial_outp(up, UART_MCR, 0);
-	udelay (10);
-	if (up->port.flags & UPF_FOURPORT)  {
+	udelay(10);
+	if (up->port.flags & UPF_FOURPORT) {
 		serial_outp(up, UART_MCR,
 			    UART_MCR_DTR | UART_MCR_RTS);
 	} else {
@@ -1199,7 +1199,7 @@ static void autoconfig_irq(struct uart_8
 	(void)serial_inp(up, UART_IIR);
 	(void)serial_inp(up, UART_MSR);
 	serial_outp(up, UART_TX, 0xFF);
-	udelay (20);
+	udelay(20);
 	irq = probe_irq_off(irqs);
 
 	serial_outp(up, UART_MCR, save_mcr);
@@ -1343,7 +1343,7 @@ receive_chars(struct uart_8250_port *up,
 
 		uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
 
-	ignore_char:
+ignore_char:
 		lsr = serial_inp(up, UART_LSR);
 	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
@@ -1633,7 +1633,8 @@ static void serial8250_backup_timeout(un
 		serial_out(up, UART_IER, ier);
 
 	/* Standard timer interval plus 0.2s to keep the port running */
-	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout) + HZ/5);
+	mod_timer(&up->timer,
+		jiffies + poll_timeout(up->port.timeout) + HZ / 5);
 }
 
 static unsigned int serial8250_tx_empty(struct uart_port *port)
@@ -1844,7 +1845,7 @@ static int serial8250_startup(struct uar
 			up->timer.function = serial8250_backup_timeout;
 			up->timer.data = (unsigned long)up;
 			mod_timer(&up->timer, jiffies +
-			          poll_timeout(up->port.timeout) + HZ/5);
+				poll_timeout(up->port.timeout) + HZ / 5);
 		}
 	}
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

termios-document-callback-more-clearly.patch
revert-keyspan-init-termios-properly.patch
git-arm.patch
git-libata-all.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-separate-out-ata_acpi_gtm_xfermask-from-pacpi_discover_modes.patch
libata-fix-ata_acpi_gtm_xfermask.patch
libata-implement-ata_timing_cycle2mode-and-use-it-in-libata-acpi-and-pata_acpi.patch
libata-reimplement-ata_acpi_cbl_80wire-using-ata_acpi_gtm_xfermask.patch
libata-add-ata_cbl_pata_ign.patch
pata_amd-update-mode-selection-for-nv-patas.patch
ahci-invalid-use-of-writel-readl-with-iomap.patch
libata-core-list-more-documentation-sources-for-reference.patch
libata-iordy-handling.patch
libata-sff-tf_load.patch
pata_ali-add-mitac-8317-and-derivatives.patch
pata_ali-lots-of-problems-still-showing-up-with-small-atapi-dma.patch
pata_hpt37x-fix-cable-detect-bug-spotted-by-sergei.patch
pata_isapnp-polled-devices.patch
pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch
pata_ninja32-cardbus-ata-initial-support.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
quirk_vialatency-omit-reading-pci-revision-id.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
git-scsi-rc-fixes.patch
initio-fix-conflict-when-loading-driver.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
