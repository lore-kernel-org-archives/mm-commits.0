From: akpm@linux-foundation.org
Subject: + serial-coding-style.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:24:27 -0800
Message-ID: <200801100624.m0A6O7fU008686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbYAJGY4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:24:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     serial: Coding style
has been added to the -mm tree.  Its filename is
     serial-coding-style.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: Coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Coding style tweaks and printk levels.

Signed-off-by: Alan Cox <alan@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c     |    2 +-
 drivers/serial/8250_pnp.c |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/serial/8250.c~serial-coding-style drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-coding-style
+++ a/drivers/serial/8250.c
@@ -2047,7 +2047,7 @@ serial8250_set_termios(struct uart_port 
 	 * Oxford Semi 952 rev B workaround
 	 */
 	if (up->bugs & UART_BUG_QUOT && (quot & 0xff) == 0)
-		quot ++;
+		quot++;
 
 	if (up->capabilities & UART_CAP_FIFO && up->port.fifosize > 1) {
 		if (baud < 2400)
diff -puN drivers/serial/8250_pnp.c~serial-coding-style drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-coding-style
+++ a/drivers/serial/8250_pnp.c
@@ -414,8 +414,9 @@ static int __devinit check_resources(str
  */
 static int __devinit serial_pnp_guess_board(struct pnp_dev *dev, int *flags)
 {
-	if (!(check_name(pnp_dev_name(dev)) || (dev->card && check_name(dev->card->name))))
-		return -ENODEV;
+	if (!(check_name(pnp_dev_name(dev)) ||
+		(dev->card && check_name(dev->card->name))))
+			return -ENODEV;
 
 	if (check_resources(dev->independent))
 		return 0;
@@ -452,8 +453,9 @@ serial_pnp_probe(struct pnp_dev *dev, co
 		return -ENODEV;
 
 #ifdef SERIAL_DEBUG_PNP
-	printk("Setup PNP port: port %x, mem 0x%lx, irq %d, type %d\n",
-	       port.iobase, port.mapbase, port.irq, port.iotype);
+	printk(KERN_DEBUG
+		"Setup PNP port: port %x, mem 0x%lx, irq %d, type %d\n",
+		       port.iobase, port.mapbase, port.irq, port.iotype);
 #endif
 
 	port.flags |= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
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
serial-coding-style.patch
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
