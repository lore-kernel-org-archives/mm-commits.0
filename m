From: akpm@linux-foundation.org
Subject: + char-mxser-remove-special-baudrate-processing.patch added to -mm tree
Date: Tue, 22 Jan 2008 00:52:23 -0800
Message-ID: <200801220852.m0M8q3wW013046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58779 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760311AbYAVIxK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 03:53:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: mxser, remove special baudrate processing
has been added to the -mm tree.  Its filename is
     char-mxser-remove-special-baudrate-processing.patch

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
Subject: Char: mxser, remove special baudrate processing
From: Jiri Slaby <jirislaby@gmail.com>

Let the special baudrate processing on the tty layer.  Also remove
set/get_special_rate ioctls introduced in commit
f64c84a1668930d1ca2b7dbaa92146c2139cb508, since it is no longer needed.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |  120 +++++++------------------------------
 drivers/char/mxser_new.h |    4 -
 2 files changed, 23 insertions(+), 101 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser-remove-special-baudrate-processing drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser-remove-special-baudrate-processing
+++ a/drivers/char/mxser_new.c
@@ -173,18 +173,6 @@ static struct pci_device_id mxser_pcibrd
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
 
-static int mxvar_baud_table[] = {
-	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400,
-	4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
-};
-static unsigned int mxvar_baud_table1[] = {
-	0, B50, B75, B110, B134, B150, B200, B300, B600, B1200, B1800, B2400,
-	B4800, B9600, B19200, B38400, B57600, B115200, B230400, B460800, B921600
-};
-#define BAUD_TABLE_NO ARRAY_SIZE(mxvar_baud_table)
-
-#define B_SPEC	B2000000
-
 static int ioaddr[MXSER_BOARDS] = { 0, 0, 0, 0 };
 static int ttymajor = MXSERMAJOR;
 static int calloutmajor = MXSERCUMAJOR;
@@ -243,10 +231,8 @@ struct mxser_port {
 	int rx_trigger;		/* Rx fifo trigger level */
 	int rx_low_water;
 	int baud_base;		/* max. speed */
-	long realbaud;
 	int type;		/* UART type */
 	int flags;		/* defined in tty.h */
-	int speed;
 
 	int x_char;		/* xon/xoff character */
 	int IER;		/* Interrupt Enable Register */
@@ -451,7 +437,6 @@ static int mxser_block_til_ready(struct 
 
 static int mxser_set_baud(struct mxser_port *info, long newspd)
 {
-	unsigned int i;
 	int quot = 0, baud;
 	unsigned char cval;
 
@@ -464,27 +449,17 @@ static int mxser_set_baud(struct mxser_p
 	if (newspd > info->max_baud)
 		return -1;
 
-	info->realbaud = newspd;
-	for (i = 0; i < BAUD_TABLE_NO; i++)
-	       if (newspd == mxvar_baud_table[i])
-		       break;
-	if (i == BAUD_TABLE_NO) {
-		quot = info->baud_base / info->speed;
-		if (info->speed <= 0 || info->speed > info->max_baud)
-			quot = 0;
+	if (newspd == 134) {
+		quot = 2 * info->baud_base / 269;
+		tty_encode_baud_rate(info->tty, 134, 134);
+	} else if (newspd) {
+		quot = info->baud_base / newspd;
+		if (quot == 0)
+			quot = 1;
+		baud = info->baud_base/quot;
+		tty_encode_baud_rate(info->tty, baud, baud);
 	} else {
-		if (newspd == 134) {
-			quot = (2 * info->baud_base / 269);
-			tty_encode_baud_rate(info->tty, 134, 134);
-		} else if (newspd) {
-			quot = info->baud_base / newspd;
-			if (quot == 0)
-				quot = 1;
-			baud = info->baud_base/quot;
-			tty_encode_baud_rate(info->tty, baud, baud);
-		} else {
-			quot = 0;
-		}
+		quot = 0;
 	}
 
 	info->timeout = ((info->xmit_fifo_size * HZ * 10 * quot) / info->baud_base);
@@ -507,17 +482,19 @@ static int mxser_set_baud(struct mxser_p
 	outb(quot >> 8, info->ioaddr + UART_DLM);	/* MS of divisor */
 	outb(cval, info->ioaddr + UART_LCR);	/* reset DLAB */
 
-	if (i == BAUD_TABLE_NO) {
-		quot = info->baud_base % info->speed;
+#ifdef BOTHER
+	if (C_BAUD(info->tty) == BOTHER) {
+		quot = info->baud_base % newspd;
 		quot *= 8;
-		if ((quot % info->speed) > (info->speed / 2)) {
-			quot /= info->speed;
+		if (quot % newspd > newspd / 2) {
+			quot /= newspd;
 			quot++;
-		} else {
-			quot /= info->speed;
-		}
+		} else
+			quot /= newspd;
+
 		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, quot);
 	} else
+#endif
 		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, 0);
 
 	return 0;
@@ -533,7 +510,6 @@ static int mxser_change_speed(struct mxs
 	unsigned cflag, cval, fcr;
 	int ret = 0;
 	unsigned char status;
-	long baud;
 
 	if (!info->tty || !info->tty->termios)
 		return ret;
@@ -541,13 +517,8 @@ static int mxser_change_speed(struct mxs
 	if (!(info->ioaddr))
 		return ret;
 
-	if (mxser_set_baud_method[info->tty->index] == 0) {
-		if ((cflag & CBAUD) == B_SPEC)
-			baud = info->speed;
-		else
-			baud = tty_get_baud_rate(info->tty);
-		mxser_set_baud(info, baud);
-	}
+	if (mxser_set_baud_method[info->tty->index] == 0)
+		mxser_set_baud(info, tty_get_baud_rate(info->tty));
 
 	/* byte size and parity */
 	switch (cflag & CSIZE) {
@@ -1587,7 +1558,8 @@ static int mxser_ioctl_special(unsigned 
 					port->mon_data.up_txcnt;
 				mon_data_ext.modem_status[i] =
 					port->mon_data.modem_status;
-				mon_data_ext.baudrate[i] = port->realbaud;
+				mon_data_ext.baudrate[i] =
+					tty_get_baud_rate(port->tty);
 
 				if (!port->tty || !port->tty->termios) {
 					cflag = port->normal_termios.c_cflag;
@@ -1645,7 +1617,6 @@ static int mxser_ioctl(struct tty_struct
 	struct serial_icounter_struct __user *p_cuser;
 	unsigned long templ;
 	unsigned long flags;
-	unsigned int i;
 	void __user *argp = (void __user *)arg;
 	int retval;
 
@@ -1684,36 +1655,6 @@ static int mxser_ioctl(struct tty_struct
 		return 0;
 	}
 
-	if (cmd == MOXA_SET_SPECIAL_BAUD_RATE) {
-		int speed;
-
-		if (get_user(speed, (int __user *)argp))
-			return -EFAULT;
-		if (speed <= 0 || speed > info->max_baud)
-			return -EFAULT;
-		if (!info->tty || !info->tty->termios || !info->ioaddr)
-			return 0;
-		info->tty->termios->c_cflag &= ~(CBAUD | CBAUDEX);
-		for (i = 0; i < BAUD_TABLE_NO; i++)
-			if (speed == mxvar_baud_table[i])
-				break;
-		if (i == BAUD_TABLE_NO) {
-			info->tty->termios->c_cflag |= B_SPEC;
-		} else if (speed != 0)
-			info->tty->termios->c_cflag |= mxvar_baud_table1[i];
-
-		info->speed = speed;
-		spin_lock_irqsave(&info->slock, flags);
-		mxser_change_speed(info, NULL);
-		spin_unlock_irqrestore(&info->slock, flags);
-
-		return 0;
-	} else if (cmd == MOXA_GET_SPECIAL_BAUD_RATE) {
-		if (copy_to_user(argp, &info->speed, sizeof(int)))
-		     return -EFAULT;
-		return 0;
-	}
-
 	if (cmd != TIOCGSERIAL && cmd != TIOCMIWAIT && cmd != TIOCGICOUNT &&
 			test_bit(TTY_IO_ERROR, &tty->flags))
 		return -EIO;
@@ -1807,20 +1748,6 @@ static int mxser_ioctl(struct tty_struct
 		info->mon_data.rxcnt = 0;
 		info->mon_data.txcnt = 0;
 		return 0;
-	case MOXA_ASPP_SETBAUD:{
-		long baud;
-		if (get_user(baud, (long __user *)argp))
-			return -EFAULT;
-		spin_lock_irqsave(&info->slock, flags);
-		mxser_set_baud(info, baud);
-		spin_unlock_irqrestore(&info->slock, flags);
-		return 0;
-	}
-	case MOXA_ASPP_GETBAUD:
-		if (copy_to_user(argp, &info->realbaud, sizeof(long)))
-			return -EFAULT;
-
-		return 0;
 
 	case MOXA_ASPP_OQUEUE:{
 		int len, lsr;
@@ -2434,7 +2361,6 @@ static int __devinit mxser_initbrd(struc
 		info->normal_termios = mxvar_sdriver->init_termios;
 		init_waitqueue_head(&info->open_wait);
 		init_waitqueue_head(&info->delta_msr_wait);
-		info->speed = 9600;
 		memset(&info->mon_data, 0, sizeof(struct mxser_mon));
 		info->err_shadow = 0;
 		spin_lock_init(&info->slock);
diff -puN drivers/char/mxser_new.h~char-mxser-remove-special-baudrate-processing drivers/char/mxser_new.h
--- a/drivers/char/mxser_new.h~char-mxser-remove-special-baudrate-processing
+++ a/drivers/char/mxser_new.h
@@ -29,14 +29,10 @@
 
 #define MOXA_SDS_RSTICOUNTER	(MOXA + 69)
 #define MOXA_ASPP_OQUEUE  	(MOXA + 70)
-#define MOXA_ASPP_SETBAUD 	(MOXA + 71)
-#define MOXA_ASPP_GETBAUD 	(MOXA + 72)
 #define MOXA_ASPP_MON     	(MOXA + 73)
 #define MOXA_ASPP_LSTATUS 	(MOXA + 74)
 #define MOXA_ASPP_MON_EXT 	(MOXA + 75)
 #define MOXA_SET_BAUD_METHOD	(MOXA + 76)
-#define MOXA_SET_SPECIAL_BAUD_RATE	(MOXA + 77)
-#define MOXA_GET_SPECIAL_BAUD_RATE	(MOXA + 78)
 
 /* --------------------------------------------------- */
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
capabilities-introduce-per-process-capability-bounding-set-capabilities-correct-logic-at-capset_check.patch
maintainers-order-auerswald-alphabetically.patch
phantom-dont-grab-other-devices.patch
driver-ip27-rtc-convert-ioctl-to-unlocked_ioctl-v2.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
char-mxser-remove-special-baudrate-processing.patch
char-mxser-0-to-null-in-pointer.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
char-mxser-ioctl-cleanup.patch
char-mxser-remove-it.patch
char-mxser-add-support-for-cp-114ul.patch
moxa-first-pass-at-termios-reporting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
