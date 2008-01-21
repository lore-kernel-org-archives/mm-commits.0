From: akpm@linux-foundation.org
Subject: - wdt-fix-locking.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:13:59 -0800
Message-ID: <200801212313.m0LNDxZG024942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761360AbYAUXTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     wdt: fix locking
has been removed from the -mm tree.  Its filename was
     wdt-fix-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wdt: fix locking
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

The audit of _p usage shows various drivers assume inb_p is somehow atomic.
 Of course it isn't and the delay can be split from the I/O cycle causing a
timing violation on chips that matter (eg this one)

With the proposed use of udelay() for some _p delays this will cease to be
a mostly theoretical bug (as the delay stall is unsplittable) and wants
fixing.

Lots of other drivers need fixing this way too.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/wdt.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff -puN drivers/watchdog/wdt.c~wdt-fix-locking drivers/watchdog/wdt.c
--- a/drivers/watchdog/wdt.c~wdt-fix-locking
+++ a/drivers/watchdog/wdt.c
@@ -70,6 +70,8 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 static int io=0x240;
 static int irq=11;
 
+static DEFINE_SPINLOCK(wdt_lock);
+
 module_param(io, int, 0);
 MODULE_PARM_DESC(io, "WDT io port (default=0x240)");
 module_param(irq, int, 0);
@@ -109,6 +111,8 @@ static void wdt_ctr_load(int ctr, int va
 
 static int wdt_start(void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_mode(0,3);		/* Program CTR0 for Mode 3: Square Wave Generator */
 	wdt_ctr_mode(1,2);		/* Program CTR1 for Mode 2: Rate Generator */
@@ -117,6 +121,7 @@ static int wdt_start(void)
 	wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
 	wdt_ctr_load(2,65535);		/* Length of reset pulse */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -128,9 +133,12 @@ static int wdt_start(void)
 
 static int wdt_stop (void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	/* Turn the card off */
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_load(2,0);		/* 0 length reset pulses now */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -143,11 +151,14 @@ static int wdt_stop (void)
 
 static int wdt_ping(void)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&wdt_lock, flags);
 	/* Write a watchdog value */
 	inb_p(WDT_DC);			/* Disable watchdog */
 	wdt_ctr_mode(1,2);		/* Re-Program CTR1 for Mode 2: Rate Generator */
 	wdt_ctr_load(1,wd_heartbeat);	/* Heartbeat */
 	outb_p(0, WDT_DC);		/* Enable watchdog */
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -182,7 +193,12 @@ static int wdt_set_heartbeat(int t)
 
 static int wdt_get_status(int *status)
 {
-	unsigned char new_status=inb_p(WDT_SR);
+	unsigned char new_status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
+	new_status = inb_p(WDT_SR);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 
 	*status=0;
 	if (new_status & WDC_SR_ISOI0)
@@ -214,8 +230,12 @@ static int wdt_get_status(int *status)
 
 static int wdt_get_temperature(int *temperature)
 {
-	unsigned short c=inb_p(WDT_RT);
+	unsigned short c;
+	unsigned long flags;
 
+	spin_lock_irqsave(&wdt_lock, flags);
+	c=inb_p(WDT_RT);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	*temperature = (c * 11 / 15) + 7;
 	return 0;
 }
@@ -237,7 +257,10 @@ static irqreturn_t wdt_interrupt(int irq
 	 *	Read the status register see what is up and
 	 *	then printk it.
 	 */
-	unsigned char status=inb_p(WDT_SR);
+	unsigned char status;
+
+	spin_lock(&wdt_lock);
+	status = inb_p(WDT_SR);
 
 	printk(KERN_CRIT "WDT status %d\n", status);
 
@@ -265,6 +288,7 @@ static irqreturn_t wdt_interrupt(int irq
 		printk(KERN_CRIT "Reset in 5ms.\n");
 #endif
 	}
+	spin_unlock(&wdt_lock);
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
keyspan-fix-oops.patch
git-acpi.patch
git-arm.patch
git-libata-all.patch
git-net.patch
bluetooth-rfcomm-tty_close-before-destruct.patch
hci_ldisc-fix-null-pointer-deref.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
serial-speed-setup-failure-reporting.patch
serial-coding-style.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-ti_usb-termios-cleanups.patch
git-watchdog.patch
git-x86.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch
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
