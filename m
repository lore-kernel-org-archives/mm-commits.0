From: akpm@osdl.org
Subject: + char-mxser_new-upgrade-to-1915.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:07:57 -0800
Message-ID: <200701052007.l05K7v6f030947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbXAEUID (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:08:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, upgrade to 1.9.15
has been added to the -mm tree.  Its filename is
     char-mxser_new-upgrade-to-1915.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, upgrade to 1.9.15
From: Jiri Slaby <jirislaby@gmail.com>

- allow special rates
- break when bad status

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |  109 ++++++++++++++++++++++++++++++-------
 drivers/char/mxser_new.h |   14 ++++
 2 files changed, 103 insertions(+), 20 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-upgrade-to-1915 drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-upgrade-to-1915
+++ a/drivers/char/mxser_new.c
@@ -49,7 +49,7 @@
 
 #include "mxser_new.h"
 
-#define	MXSER_VERSION	"2.0"
+#define	MXSER_VERSION	"2.0.1"		/* 1.9.15 */
 #define	MXSERMAJOR	 174
 #define	MXSERCUMAJOR	 175
 
@@ -179,6 +179,16 @@ static struct pci_device_id mxser_pcibrd
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
 
+static int mxvar_baud_table[] = {
+	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400,
+	4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
+};
+static unsigned int mxvar_baud_table1[] = {
+	0, B50, B75, B110, B134, B150, B200, B300, B600, B1200, B1800, B2400,
+	B4800, B9600, B19200, B38400, B57600, B115200, B230400, B460800, B921600
+};
+#define BAUD_TABLE_NO ARRAY_SIZE(mxvar_baud_table)
+
 static int ioaddr[MXSER_BOARDS] = { 0, 0, 0, 0 };
 static int ttymajor = MXSERMAJOR;
 static int calloutmajor = MXSERCUMAJOR;
@@ -240,6 +250,7 @@ struct mxser_port {
 	long realbaud;
 	int type;		/* UART type */
 	int flags;		/* defined in tty.h */
+	int speed;
 
 	int x_char;		/* xon/xoff character */
 	int IER;		/* Interrupt Enable Register */
@@ -444,10 +455,10 @@ static int mxser_block_til_ready(struct 
 
 static int mxser_set_baud(struct mxser_port *info, long newspd)
 {
+	unsigned int i;
 	int quot = 0;
 	unsigned char cval;
 	int ret = 0;
-	unsigned long flags;
 
 	if (!info->tty || !info->tty->termios)
 		return ret;
@@ -459,29 +470,34 @@ static int mxser_set_baud(struct mxser_p
 		return 0;
 
 	info->realbaud = newspd;
-	if (newspd == 134) {
-		quot = (2 * info->baud_base / 269);
-	} else if (newspd) {
-		quot = info->baud_base / newspd;
-		if (quot == 0)
-			quot = 1;
+	for (i = 0; i < BAUD_TABLE_NO; i++)
+	       if (newspd == mxvar_baud_table[i])
+		       break;
+	if (i == BAUD_TABLE_NO) {
+		quot = info->baud_base / info->speed;
+		if (info->speed <= 0 || info->speed > info->max_baud)
+			quot = 0;
 	} else {
-		quot = 0;
+		if (newspd == 134) {
+			quot = (2 * info->baud_base / 269);
+		} else if (newspd) {
+			quot = info->baud_base / newspd;
+			if (quot == 0)
+				quot = 1;
+		} else {
+			quot = 0;
+		}
 	}
 
 	info->timeout = ((info->xmit_fifo_size * HZ * 10 * quot) / info->baud_base);
 	info->timeout += HZ / 50;	/* Add .02 seconds of slop */
 
 	if (quot) {
-		spin_lock_irqsave(&info->slock, flags);
 		info->MCR |= UART_MCR_DTR;
 		outb(info->MCR, info->ioaddr + UART_MCR);
-		spin_unlock_irqrestore(&info->slock, flags);
 	} else {
-		spin_lock_irqsave(&info->slock, flags);
 		info->MCR &= ~UART_MCR_DTR;
 		outb(info->MCR, info->ioaddr + UART_MCR);
-		spin_unlock_irqrestore(&info->slock, flags);
 		return ret;
 	}
 
@@ -493,6 +509,18 @@ static int mxser_set_baud(struct mxser_p
 	outb(quot >> 8, info->ioaddr + UART_DLM);	/* MS of divisor */
 	outb(cval, info->ioaddr + UART_LCR);	/* reset DLAB */
 
+	if (i == BAUD_TABLE_NO) {
+		quot = info->baud_base % info->speed;
+		quot *= 8;
+		if ((quot % info->speed) > (info->speed / 2)) {
+			quot /= info->speed;
+			quot++;
+		} else {
+			quot /= info->speed;
+		}
+		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, quot);
+	} else
+		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, 0);
 
 	return ret;
 }
@@ -508,7 +536,6 @@ static int mxser_change_speed(struct mxs
 	int ret = 0;
 	unsigned char status;
 	long baud;
-	unsigned long flags;
 
 	if (!info->tty || !info->tty->termios)
 		return ret;
@@ -517,7 +544,10 @@ static int mxser_change_speed(struct mxs
 		return ret;
 
 	if (mxser_set_baud_method[info->tty->index] == 0) {
-		baud = tty_get_baud_rate(info->tty);
+		if ((cflag & (CBAUD | CBAUDEX)) == B4000000)
+			baud = info->speed;
+		else
+			baud = tty_get_baud_rate(info->tty);
 		mxser_set_baud(info, baud);
 	}
 
@@ -656,7 +686,6 @@ static int mxser_change_speed(struct mxs
 		}
 	}
 	if (info->board->chip_flag) {
-		spin_lock_irqsave(&info->slock, flags);
 		SET_MOXA_MUST_XON1_VALUE(info->ioaddr, START_CHAR(info->tty));
 		SET_MOXA_MUST_XOFF1_VALUE(info->ioaddr, STOP_CHAR(info->tty));
 		if (I_IXON(info->tty)) {
@@ -669,7 +698,6 @@ static int mxser_change_speed(struct mxs
 		} else {
 			DISABLE_MOXA_MUST_TX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
 		}
-		spin_unlock_irqrestore(&info->slock, flags);
 	}
 
 
@@ -822,8 +850,8 @@ static int mxser_startup(struct mxser_po
 	/*
 	 * and set the speed of the serial port
 	 */
-	spin_unlock_irqrestore(&info->slock, flags);
 	mxser_change_speed(info, NULL);
+	spin_unlock_irqrestore(&info->slock, flags);
 
 	info->flags |= ASYNC_INITIALIZED;
 	return 0;
@@ -1195,6 +1223,7 @@ static int mxser_set_serial_info(struct 
 		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
+	unsigned long sl_flags;
 	unsigned int flags;
 	int retval = 0;
 
@@ -1237,8 +1266,11 @@ static int mxser_set_serial_info(struct 
 	process_txrx_fifo(info);
 
 	if (info->flags & ASYNC_INITIALIZED) {
-		if (flags != (info->flags & ASYNC_SPD_MASK))
+		if (flags != (info->flags & ASYNC_SPD_MASK)) {
+			spin_lock_irqsave(&info->slock, sl_flags);
 			mxser_change_speed(info, NULL);
+			spin_unlock_irqrestore(&info->slock, sl_flags);
+		}
 	} else
 		retval = mxser_startup(info);
 
@@ -1615,6 +1647,7 @@ static int mxser_ioctl(struct tty_struct
 	struct serial_icounter_struct __user *p_cuser;
 	unsigned long templ;
 	unsigned long flags;
+	unsigned int i;
 	void __user *argp = (void __user *)arg;
 	int retval;
 
@@ -1653,6 +1686,36 @@ static int mxser_ioctl(struct tty_struct
 		return 0;
 	}
 
+	if (cmd == MOXA_SET_SPECIAL_BAUD_RATE) {
+		int speed;
+
+		if (get_user(speed, (int __user *)argp))
+			return -EFAULT;
+		if (speed <= 0 || speed > info->max_baud)
+			return -EFAULT;
+		if (!info->tty || !info->tty->termios || !info->ioaddr)
+			return 0;
+		info->tty->termios->c_cflag &= ~(CBAUD | CBAUDEX);
+		for (i = 0; i < BAUD_TABLE_NO; i++)
+			if (speed == mxvar_baud_table[i])
+				break;
+		if (i == BAUD_TABLE_NO) {
+			info->tty->termios->c_cflag |= B4000000;
+		} else if (speed != 0)
+			info->tty->termios->c_cflag |= mxvar_baud_table1[i];
+
+		info->speed = speed;
+		spin_lock_irqsave(&info->slock, flags);
+		mxser_change_speed(info, 0);
+		spin_unlock_irqrestore(&info->slock, flags);
+
+		return 0;
+	} else if (cmd == MOXA_GET_SPECIAL_BAUD_RATE) {
+		if (copy_to_user(argp, &info->speed, sizeof(int)))
+		     return -EFAULT;
+		return 0;
+	}
+
 	if (cmd != TIOCGSERIAL && cmd != TIOCMIWAIT && cmd != TIOCGICOUNT &&
 			test_bit(TTY_IO_ERROR, &tty->flags))
 		return -EIO;
@@ -1770,7 +1833,9 @@ static int mxser_ioctl(struct tty_struct
 		long baud;
 		if (get_user(baud, (long __user *)argp))
 			return -EFAULT;
+		spin_lock_irqsave(&info->slock, flags);
 		mxser_set_baud(info, baud);
+		spin_unlock_irqrestore(&info->slock, flags);
 		return 0;
 	}
 	case MOXA_ASPP_GETBAUD:
@@ -1947,7 +2012,9 @@ static void mxser_set_termios(struct tty
 	if ((tty->termios->c_cflag != old_termios->c_cflag) ||
 			(RELEVANT_IFLAG(tty->termios->c_iflag) != RELEVANT_IFLAG(old_termios->c_iflag))) {
 
+		spin_lock_irqsave(&info->slock, flags);
 		mxser_change_speed(info, old_termios);
+		spin_unlock_irqrestore(&info->slock, flags);
 
 		if ((old_termios->c_cflag & CRTSCTS) &&
 				!(tty->termios->c_cflag & CRTSCTS)) {
@@ -2137,7 +2204,8 @@ intr_old:
 				} else if (*status & UART_LSR_OE) {
 					flag = TTY_OVERRUN;
 					port->icount.overrun++;
-				}
+				} else
+					flag = TTY_BREAK;
 			}
 			tty_insert_flip_char(tty, ch, flag);
 			cnt++;
@@ -2385,6 +2453,7 @@ static int __devinit mxser_initbrd(struc
 		info->normal_termios = mxvar_sdriver->init_termios;
 		init_waitqueue_head(&info->open_wait);
 		init_waitqueue_head(&info->delta_msr_wait);
+		info->speed = 9600;
 		memset(&info->mon_data, 0, sizeof(struct mxser_mon));
 		info->err_shadow = 0;
 		spin_lock_init(&info->slock);
diff -puN drivers/char/mxser_new.h~char-mxser_new-upgrade-to-1915 drivers/char/mxser_new.h
--- a/drivers/char/mxser_new.h~char-mxser_new-upgrade-to-1915
+++ a/drivers/char/mxser_new.h
@@ -35,6 +35,8 @@
 #define MOXA_ASPP_LSTATUS 	(MOXA + 74)
 #define MOXA_ASPP_MON_EXT 	(MOXA + 75)
 #define MOXA_SET_BAUD_METHOD	(MOXA + 76)
+#define MOXA_SET_SPECIAL_BAUD_RATE	(MOXA + 77)
+#define MOXA_GET_SPECIAL_BAUD_RATE	(MOXA + 78)
 
 /* --------------------------------------------------- */
 
@@ -212,6 +214,18 @@
 	outb(__oldlcr, (info)->ioaddr+UART_LCR);		\
 } while (0)
 
+#define SET_MOXA_MUST_ENUM_VALUE(baseio, Value) do {		\
+	u8	__oldlcr, __efr;				\
+	__oldlcr = inb((baseio)+UART_LCR);			\
+	outb(MOXA_MUST_ENTER_ENCHANCE, (baseio)+UART_LCR);	\
+	__efr = inb((baseio)+MOXA_MUST_EFR_REGISTER);		\
+	__efr &= ~MOXA_MUST_EFR_BANK_MASK;			\
+	__efr |= MOXA_MUST_EFR_BANK2;				\
+	outb(__efr, (baseio)+MOXA_MUST_EFR_REGISTER);		\
+	outb((u8)(Value), (baseio)+MOXA_MUST_ENUM_REGISTER);	\
+	outb(__oldlcr, (baseio)+UART_LCR);			\
+} while (0)
+
 #define GET_MOXA_MUST_HARDWARE_ID(baseio, pId) do {		\
 	u8	__oldlcr, __efr;				\
 	__oldlcr = inb((baseio)+UART_LCR);			\
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
shrink_slab-handle-bad-shrinkers.patch
