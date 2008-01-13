From: akpm@linux-foundation.org
Subject: - pl2303-fix-mode-switching-regression.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:29 -0800
Message-ID: <200801131133.m0DBX9JG009825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbYAMLeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:34:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mirko.parthey@informatik.tu-chemnitz.de, mm-commits@vger.kernel.org


The patch titled
     pl2303: fix mode switching regression
has been removed from the -mm tree.  Its filename was
     pl2303-fix-mode-switching-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pl2303: fix mode switching regression
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Cleaning out all the incorrect 'no change made' checks for termios settings
showed up a problem with the PL2303.  The hardware here seems to lose sync
and bits if you tell it to make no changes.  This shows up with a real
world application.

To fix this the driver check for meaningful hardware changes is restored
but doing the tests correctly and as a tty layer function so it doesn't get
duplicated wrongly everywhere if other drivers turn out to need it.

Signed-off-by: Alan Cox <alan@redhat.com>
Tested-by: Mirko Parthey <mirko.parthey@informatik.tu-chemnitz.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c    |   19 +++++++++++++++++++
 drivers/usb/serial/pl2303.c |    7 +++++++
 include/linux/tty.h         |    1 +
 3 files changed, 27 insertions(+)

diff -puN drivers/char/tty_ioctl.c~pl2303-fix-mode-switching-regression drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~pl2303-fix-mode-switching-regression
+++ a/drivers/char/tty_ioctl.c
@@ -365,6 +365,25 @@ void tty_termios_copy_hw(struct ktermios
 EXPORT_SYMBOL(tty_termios_copy_hw);
 
 /**
+ *	tty_termios_hw_change	-	check for setting change
+ *	@a: termios
+ *	@b: termios to compare
+ *
+ *	Check if any of the bits that affect a dumb device have changed
+ *	between the two termios structures, or a speed change is needed.
+ */
+
+int tty_termios_hw_change(struct ktermios *a, struct ktermios *b)
+{
+	if (a->c_ispeed != b->c_ispeed || a->c_ospeed != b->c_ospeed)
+		return 1;
+	if ((a->c_cflag ^ b->c_cflag) & ~(HUPCL | CREAD | CLOCAL))
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(tty_termios_hw_change);
+
+/**
  *	change_termios		-	update termios values
  *	@tty: tty to update
  *	@new_termios: desired new value
diff -puN drivers/usb/serial/pl2303.c~pl2303-fix-mode-switching-regression drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c~pl2303-fix-mode-switching-regression
+++ a/drivers/usb/serial/pl2303.c
@@ -483,6 +483,13 @@ static void pl2303_set_termios(struct us
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* The PL2303 is reported to lose bytes if you change
+	   serial settings even to the same values as before. Thus
+	   we actually need to filter in this specific case */
+
+	if (!tty_termios_hw_change(port->tty->termios, old_termios))
+		return;
+
 	cflag = port->tty->termios->c_cflag;
 
 	buf = kzalloc(7, GFP_KERNEL);
diff -puN include/linux/tty.h~pl2303-fix-mode-switching-regression include/linux/tty.h
--- a/include/linux/tty.h~pl2303-fix-mode-switching-regression
+++ a/include/linux/tty.h
@@ -319,6 +319,7 @@ extern speed_t tty_termios_input_baud_ra
 extern void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud);
 extern void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud);
 extern void tty_termios_copy_hw(struct ktermios *new, struct ktermios *old);
+extern int tty_termios_hw_change(struct ktermios *a, struct ktermios *b);
 
 extern struct tty_ldisc *tty_ldisc_ref(struct tty_struct *);
 extern void tty_ldisc_deref(struct tty_ldisc *);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
pl2303-fix-mode-switching-regression-fix.patch
git-acpi.patch
git-arm.patch
bw-qcam-adds-module-parameter-aggressive-to-skip-polite-auto-detection-prior-to-direct-initialization.patch
git-libata-all.patch
git-libata-all-fix-pata_winbond-borkage.patch
git-libata-all-wtf.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
pata_legacy-resychronize-with-upstream-changes-and-resubmit.patch
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
serverworks-irq-routing-needs-no-_p.patch
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
