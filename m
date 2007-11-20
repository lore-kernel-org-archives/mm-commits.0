From: akpm@linux-foundation.org
Subject: + serial_core-bring-mostly-into-line-with-coding-style.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:23:28 -0800
Message-ID: <200711200723.lAK7NSo5021407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbXKTH3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     serial_core: bring mostly into line with coding style
has been added to the -mm tree.  Its filename is
     serial_core-bring-mostly-into-line-with-coding-style.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial_core: bring mostly into line with coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   52 ++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN drivers/serial/serial_core.c~serial_core-bring-mostly-into-line-with-coding-style drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial_core-bring-mostly-into-line-with-coding-style
+++ a/drivers/serial/serial_core.c
@@ -58,7 +58,8 @@ static struct lock_class_key port_lock_k
 #define uart_console(port)	(0)
 #endif
 
-static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);
+static void uart_change_speed(struct uart_state *state,
+					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
@@ -129,8 +130,8 @@ uart_update_mctrl(struct uart_port *port
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-#define uart_set_mctrl(port,set)	uart_update_mctrl(port,set,0)
-#define uart_clear_mctrl(port,clear)	uart_update_mctrl(port,0,clear)
+#define uart_set_mctrl(port, set)	uart_update_mctrl(port, set, 0)
+#define uart_clear_mctrl(port, clear)	uart_update_mctrl(port, 0, clear)
 
 /*
  * Startup the port.  This will be called once per open.  All calls
@@ -290,7 +291,7 @@ uart_update_timeout(struct uart_port *po
 		break;
 	default:
 		bits = 10;
-		break; // CS8
+		break; /* CS8 */
 	}
 
 	if (cflag & CSTOPB)
@@ -621,7 +622,7 @@ static int uart_get_info(struct uart_sta
 	tmp.close_delay	    = state->close_delay / 10;
 	tmp.closing_wait    = state->closing_wait == USF_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
-			        state->closing_wait / 10;
+				state->closing_wait / 10;
 	tmp.custom_divisor  = port->custom_divisor;
 	tmp.hub6	    = port->hub6;
 	tmp.io_type         = port->iotype;
@@ -787,7 +788,8 @@ static int uart_set_info(struct uart_sta
 			 * We failed anyway.
 			 */
 			retval = -EBUSY;
-			goto exit;  // Added to return the correct error -Ram Gupta
+			/* Added to return the correct error -Ram Gupta */
+			goto exit;
 		}
 	}
 
@@ -857,7 +859,7 @@ static int uart_get_lsr_info(struct uart
 	    ((uart_circ_chars_pending(&state->info->xmit) > 0) &&
 	     !state->info->tty->stopped && !state->info->tty->hw_stopped))
 		result &= ~TIOCSER_TEMT;
-	
+
 	return put_user(result, value);
 }
 
@@ -995,8 +997,8 @@ uart_wait_modem_status(struct uart_state
 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
 		    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
-		    	ret = 0;
-		    	break;
+			ret = 0;
+			break;
 		}
 
 		schedule();
@@ -1136,7 +1138,8 @@ uart_ioctl(struct tty_struct *tty, struc
 	return ret;
 }
 
-static void uart_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void uart_set_termios(struct tty_struct *tty,
+						struct ktermios *old_termios)
 {
 	struct uart_state *state = tty->driver_data;
 	unsigned long flags;
@@ -1212,7 +1215,7 @@ static void uart_close(struct tty_struct
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port;
-	
+
 	BUG_ON(!kernel_locked());
 
 	if (!state || !state->port)
@@ -1277,8 +1280,8 @@ static void uart_close(struct tty_struct
 	uart_shutdown(state);
 	uart_flush_buffer(tty);
 
-	tty_ldisc_flush(tty);	
-	
+	tty_ldisc_flush(tty);
+
 	tty->closing = 0;
 	state->info->tty = NULL;
 
@@ -1340,7 +1343,7 @@ static void uart_wait_until_sent(struct 
 	expire = jiffies + timeout;
 
 	pr_debug("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
-	        port->line, jiffies, expire);
+		port->line, jiffies, expire);
 
 	/*
 	 * Check whether the transmitter is empty every 'char_time'.
@@ -1459,10 +1462,9 @@ uart_block_til_ready(struct file *filp, 
 		 * have set TTY_IO_ERROR for a non-existant port.
 		 */
 		if ((filp->f_flags & O_NONBLOCK) ||
-	            (info->tty->termios->c_cflag & CLOCAL) ||
-		    (info->tty->flags & (1 << TTY_IO_ERROR))) {
+		    (info->tty->termios->c_cflag & CLOCAL) ||
+		    (info->tty->flags & (1 << TTY_IO_ERROR)))
 			break;
-		}
 
 		/*
 		 * Set DTR to allow modem to know we're waiting.  Do
@@ -1673,7 +1675,7 @@ static int uart_line_info(char *buf, str
 			port->line, uart_type(port),
 			mmio ? "mmio:0x" : "port:",
 			mmio ? (unsigned long long)port->mapbase
-		             : (unsigned long long) port->iobase,
+			     : (unsigned long long) port->iobase,
 			port->irq);
 
 	if (port->type == PORT_UNKNOWN) {
@@ -1681,8 +1683,7 @@ static int uart_line_info(char *buf, str
 		return ret + 1;
 	}
 
-	if(capable(CAP_SYS_ADMIN))
-	{
+	if (capable(CAP_SYS_ADMIN)) {
 		mutex_lock(&state->mutex);
 		pm_state = state->pm_state;
 		if (pm_state)
@@ -1708,12 +1709,12 @@ static int uart_line_info(char *buf, str
 		if (port->icount.overrun)
 			ret += sprintf(buf + ret, " oe:%d",
 				port->icount.overrun);
-	
-#define INFOBIT(bit,str) \
+
+#define INFOBIT(bit, str) \
 	if (port->mctrl & (bit)) \
 		strncat(stat_buf, (str), sizeof(stat_buf) - \
 			strlen(stat_buf) - 2)
-#define STATBIT(bit,str) \
+#define STATBIT(bit, str) \
 	if (status & (bit)) \
 		strncat(stat_buf, (str), sizeof(stat_buf) - \
 		       strlen(stat_buf) - 2)
@@ -1729,7 +1730,7 @@ static int uart_line_info(char *buf, str
 		if (stat_buf[0])
 			stat_buf[0] = ' ';
 		strcat(stat_buf, "\n");
-	
+
 		ret += sprintf(buf + ret, stat_buf);
 	} else {
 		strcat(buf, "\n");
@@ -1990,9 +1991,8 @@ int uart_suspend_port(struct uart_driver
 		/*
 		 * Wait for the transmitter to empty.
 		 */
-		while (!ops->tx_empty(port)) {
+		while (!ops->tx_empty(port))
 			msleep(10);
-		}
 
 		ops->shutdown(port);
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
