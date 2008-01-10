From: akpm@linux-foundation.org
Subject: + serial-speed-setup-failure-reporting.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:23:56 -0800
Message-ID: <200801100623.m0A6Naqm008669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44159 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbYAJGYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:24:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, rmk@arm.linux.org.uk


The patch titled
     serial: speed setup failure reporting
has been added to the -mm tree.  Its filename is
     serial-speed-setup-failure-reporting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: speed setup failure reporting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Invalid speeds are forced to 9600. Update the code for this to encode new
style baud rates properly.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/serial/serial_core.c~serial-speed-setup-failure-reporting drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-speed-setup-failure-reporting
+++ a/drivers/serial/serial_core.c
@@ -371,7 +371,8 @@ uart_get_baud_rate(struct uart_port *por
 		 */
 		termios->c_cflag &= ~CBAUD;
 		if (old) {
-			termios->c_cflag |= old->c_cflag & CBAUD;
+			baud = tty_termios_baud_rate(old);
+			tty_termios_encode_baud_rate(termios, baud, baud);
 			old = NULL;
 			continue;
 		}
@@ -380,7 +381,7 @@ uart_get_baud_rate(struct uart_port *por
 		 * As a last resort, if the quotient is zero,
 		 * default to 9600 bps
 		 */
-		termios->c_cflag |= B9600;
+		tty_termios_encode_baud_rate(termios, 9600, 9600);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

pl2303-fix-mode-switching-regression.patch
pl2303-fix-mode-switching-regression-fix.patch
git-arm.patch
git-libata-all.patch
git-libata-all-fix-pata_winbond-borkage.patch
git-libata-all-wtf.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_pdc202xx_old-further-fixups.patch
git-netdev-all.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
serial-speed-setup-failure-reporting.patch
ti_usb-termios-cleanups.patch
mos7720-clean-up-termios.patch
io_ti-clean-up-termios-handling.patch
wdt-fix-locking.patch
wdt-fix-locking-checkpatch-fixes.patch
libata-sff-pci-irq-handling-fix.patch
libata-correct-handling-of-tss-dvd.patch
keyspan-fix-oops.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
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
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
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
