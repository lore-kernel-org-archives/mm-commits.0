From: akpm@linux-foundation.org
Subject: - watchdog-smsc37b787_wdt-coding-style-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:07 -0700
Message-ID: <200807162137.m6GLb7Ok014350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758176AbYGPVqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: smsc37b787_wdt: coding style, switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-smsc37b787_wdt-coding-style-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: smsc37b787_wdt: coding style, switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/smsc37b787_wdt.c |  442 ++++++++++++++--------------
 1 file changed, 222 insertions(+), 220 deletions(-)

diff -puN drivers/watchdog/smsc37b787_wdt.c~watchdog-smsc37b787_wdt-coding-style-switch-to-unlocked_ioctl drivers/watchdog/smsc37b787_wdt.c
--- a/drivers/watchdog/smsc37b787_wdt.c~watchdog-smsc37b787_wdt-coding-style-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/smsc37b787_wdt.c
@@ -18,7 +18,7 @@
  *  History:
  *	2003 - Created version 1.0 for Linux 2.4.x.
  *	2006 - Ported to Linux 2.6, added nowayout and MAGICCLOSE
- *             features. Released version 1.1
+ *	       features. Released version 1.1
  *
  *  Theory of operation:
  *
@@ -55,9 +55,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 /* enable support for minutes as units? */
@@ -71,15 +71,15 @@
 #define UNIT_MINUTE     1
 
 #define MODNAME		"smsc37b787_wdt: "
-#define VERSION         "1.1"
+#define VERSION		"1.1"
 
-#define IOPORT          0x3F0
+#define IOPORT		0x3F0
 #define IOPORT_SIZE     2
-#define IODEV_NO        8
+#define IODEV_NO	8
 
-static int unit = UNIT_SECOND;  /* timer's unit */
-static int timeout = 60;        /* timeout value: default is 60 "units" */
-static unsigned long timer_enabled = 0;   /* is the timer enabled? */
+static int unit = UNIT_SECOND;	/* timer's unit */
+static int timeout = 60;	/* timeout value: default is 60 "units" */
+static unsigned long timer_enabled;   /* is the timer enabled? */
 
 static char expect_close;       /* is the close expected? */
 
@@ -93,114 +93,121 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 
 static inline void open_io_config(void)
 {
-        outb(0x55, IOPORT);
+	outb(0x55, IOPORT);
 	mdelay(1);
-        outb(0x55, IOPORT);
+	outb(0x55, IOPORT);
 }
 
 /* lock the IO chip */
 static inline void close_io_config(void)
 {
-        outb(0xAA, IOPORT);
+	outb(0xAA, IOPORT);
 }
 
 /* select the IO device */
 static inline void select_io_device(unsigned char devno)
 {
-        outb(0x07, IOPORT);
-        outb(devno, IOPORT+1);
+	outb(0x07, IOPORT);
+	outb(devno, IOPORT+1);
 }
 
 /* write to the control register */
 static inline void write_io_cr(unsigned char reg, unsigned char data)
 {
-        outb(reg, IOPORT);
-        outb(data, IOPORT+1);
+	outb(reg, IOPORT);
+	outb(data, IOPORT+1);
 }
 
 /* read from the control register */
 static inline char read_io_cr(unsigned char reg)
 {
-        outb(reg, IOPORT);
-        return inb(IOPORT+1);
+	outb(reg, IOPORT);
+	return inb(IOPORT+1);
 }
 
 /* -- Medium level functions ------------------------------------*/
 
 static inline void gpio_bit12(unsigned char reg)
 {
-	// -- General Purpose I/O Bit 1.2 --
-	// Bit 0,   In/Out: 0 = Output, 1 = Input
-	// Bit 1,   Polarity: 0 = No Invert, 1 = Invert
-	// Bit 2,   Group Enable Intr.: 0 = Disable, 1 = Enable
-	// Bit 3/4, Function select: 00 = GPI/O, 01 = WDT, 10 = P17,
-	//                           11 = Either Edge Triggered Intr. 2
-        // Bit 5/6  (Reserved)
-	// Bit 7,   Output Type: 0 = Push Pull Bit, 1 = Open Drain
-        write_io_cr(0xE2, reg);
+	/* -- General Purpose I/O Bit 1.2 --
+	 * Bit 0,   In/Out: 0 = Output, 1 = Input
+	 * Bit 1,   Polarity: 0 = No Invert, 1 = Invert
+	 * Bit 2,   Group Enable Intr.: 0 = Disable, 1 = Enable
+	 * Bit 3/4, Function select: 00 = GPI/O, 01 = WDT, 10 = P17,
+	 *                           11 = Either Edge Triggered Intr. 2
+	 * Bit 5/6  (Reserved)
+	 * Bit 7,   Output Type: 0 = Push Pull Bit, 1 = Open Drain
+	 */
+	write_io_cr(0xE2, reg);
 }
 
 static inline void gpio_bit13(unsigned char reg)
 {
-	// -- General Purpose I/O Bit 1.3 --
-	// Bit 0,  In/Out: 0 = Output, 1 = Input
-	// Bit 1,  Polarity: 0 = No Invert, 1 = Invert
-	// Bit 2,  Group Enable Intr.: 0 = Disable, 1 = Enable
-	// Bit 3,  Function select: 0 = GPI/O, 1 = LED
-        // Bit 4-6 (Reserved)
-	// Bit 7,  Output Type: 0 = Push Pull Bit, 1 = Open Drain
-        write_io_cr(0xE3, reg);
+	/* -- General Purpose I/O Bit 1.3 --
+	 * Bit 0,  In/Out: 0 = Output, 1 = Input
+	 * Bit 1,  Polarity: 0 = No Invert, 1 = Invert
+	 * Bit 2,  Group Enable Intr.: 0 = Disable, 1 = Enable
+	 * Bit 3,  Function select: 0 = GPI/O, 1 = LED
+	 * Bit 4-6 (Reserved)
+	 * Bit 7,  Output Type: 0 = Push Pull Bit, 1 = Open Drain
+	 */
+	write_io_cr(0xE3, reg);
 }
 
 static inline void wdt_timer_units(unsigned char new_units)
 {
-	// -- Watchdog timer units --
-	// Bit 0-6 (Reserved)
-	// Bit 7,  WDT Time-out Value Units Select
-	//         (0 = Minutes, 1 = Seconds)
-        write_io_cr(0xF1, new_units);
+	/* -- Watchdog timer units --
+	 * Bit 0-6 (Reserved)
+	 * Bit 7,  WDT Time-out Value Units Select
+	 *         (0 = Minutes, 1 = Seconds)
+	 */
+	write_io_cr(0xF1, new_units);
 }
 
 static inline void wdt_timeout_value(unsigned char new_timeout)
 {
-	// -- Watchdog Timer Time-out Value --
-	// Bit 0-7 Binary coded units (0=Disabled, 1..255)
-        write_io_cr(0xF2, new_timeout);
+	/* -- Watchdog Timer Time-out Value --
+	 * Bit 0-7 Binary coded units (0=Disabled, 1..255)
+	 */
+	write_io_cr(0xF2, new_timeout);
 }
 
 static inline void wdt_timer_conf(unsigned char conf)
 {
-	// -- Watchdog timer configuration --
-	// Bit 0   Joystick enable: 0* = No Reset, 1 = Reset WDT upon Gameport I/O
-	// Bit 1   Keyboard enable: 0* = No Reset, 1 = Reset WDT upon KBD Intr.
-	// Bit 2   Mouse enable: 0* = No Reset, 1 = Reset WDT upon Mouse Intr.
-        // Bit 3   Reset the timer
-        //         (Wrong in SMsC documentation? Given as: PowerLED Timout Enabled)
-	// Bit 4-7 WDT Interrupt Mapping: (0000* = Disabled,
-	//            0001=IRQ1, 0010=(Invalid), 0011=IRQ3 to 1111=IRQ15)
-        write_io_cr(0xF3, conf);
+	/* -- Watchdog timer configuration --
+	 * Bit 0   Joystick enable: 0* = No Reset, 1 = Reset WDT upon
+	 *							Gameport I/O
+	 * Bit 1   Keyboard enable: 0* = No Reset, 1 = Reset WDT upon KBD Intr.
+	 * Bit 2   Mouse enable: 0* = No Reset, 1 = Reset WDT upon Mouse Intr
+	 * Bit 3   Reset the timer
+	 *         (Wrong in SMsC documentation? Given as: PowerLED Timout
+	 *							Enabled)
+	 * Bit 4-7 WDT Interrupt Mapping: (0000* = Disabled,
+	 *            0001=IRQ1, 0010=(Invalid), 0011=IRQ3 to 1111=IRQ15)
+	 */
+	write_io_cr(0xF3, conf);
 }
 
 static inline void wdt_timer_ctrl(unsigned char reg)
 {
-	// -- Watchdog timer control --
-	// Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
-	// Bit 1   Power LED Toggle: 0 = Disable Toggle, 1 = Toggle at 1 Hz
-	// Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
-	// Bit 3   P20 Force Timeout enabled:
-	//          0 = P20 activity does not generate the WD timeout event
-	//          1 = P20 Allows rising edge of P20, from the keyboard
-	//              controller, to force the WD timeout event.
-	// Bit 4   (Reserved)
-	// -- Soft power management --
-	// Bit 5   Stop Counter: 1 = Stop software power down counter
-	//            set via register 0xB8, (self-cleaning)
-	//            (Upon read: 0 = Counter running, 1 = Counter stopped)
-	// Bit 6   Restart Counter: 1 = Restart software power down counter
-	//            set via register 0xB8, (self-cleaning)
-	// Bit 7   SPOFF: 1 = Force software power down (self-cleaning)
-
-        write_io_cr(0xF4, reg);
+	/* -- Watchdog timer control --
+	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
+	 * Bit 1   Power LED Toggle: 0 = Disable Toggle, 1 = Toggle at 1 Hz
+	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
+	 * Bit 3   P20 Force Timeout enabled:
+	 *          0 = P20 activity does not generate the WD timeout event
+	 *          1 = P20 Allows rising edge of P20, from the keyboard
+	 *              controller, to force the WD timeout event.
+	 * Bit 4   (Reserved)
+	 * -- Soft power management --
+	 * Bit 5   Stop Counter: 1 = Stop software power down counter
+	 *            set via register 0xB8, (self-cleaning)
+	 *            (Upon read: 0 = Counter running, 1 = Counter stopped)
+	 * Bit 6   Restart Counter: 1 = Restart software power down counter
+	 *            set via register 0xB8, (self-cleaning)
+	 * Bit 7   SPOFF: 1 = Force software power down (self-cleaning)
+	 */
+	write_io_cr(0xF4, reg);
 }
 
 /* -- Higher level functions ------------------------------------*/
@@ -209,33 +216,34 @@ static inline void wdt_timer_ctrl(unsign
 
 static void wb_smsc_wdt_initialize(void)
 {
-        unsigned char old;
+	unsigned char old;
 
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
-
-	// enable the watchdog
-	gpio_bit13(0x08);  // Select pin 80 = LED not GPIO
-	gpio_bit12(0x0A);  // Set pin 79 = WDT not GPIO/Output/Polarity=Invert
+	open_io_config();
+	select_io_device(IODEV_NO);
 
-	// disable the timeout
-        wdt_timeout_value(0);
+	/* enable the watchdog */
+	gpio_bit13(0x08);  /* Select pin 80 = LED not GPIO */
+	gpio_bit12(0x0A);  /* Set pin 79 = WDT not
+			      GPIO/Output/Polarity=Invert */
+	/* disable the timeout */
+	wdt_timeout_value(0);
 
-	// reset control register
-        wdt_timer_ctrl(0x00);
+	/* reset control register */
+	wdt_timer_ctrl(0x00);
 
-	// reset configuration register
+	/* reset configuration register */
 	wdt_timer_conf(0x00);
 
-	// read old (timer units) register
-        old = read_io_cr(0xF1) & 0x7F;
-        if (unit == UNIT_SECOND) old |= 0x80; // set to seconds
+	/* read old (timer units) register */
+	old = read_io_cr(0xF1) & 0x7F;
+	if (unit == UNIT_SECOND)
+		old |= 0x80;	/* set to seconds */
 
-	// set the watchdog timer units
-        wdt_timer_units(old);
+	/* set the watchdog timer units */
+	wdt_timer_units(old);
 
-        close_io_config();
+	close_io_config();
 	spin_unlock(&io_lock);
 }
 
@@ -244,23 +252,23 @@ static void wb_smsc_wdt_initialize(void)
 static void wb_smsc_wdt_shutdown(void)
 {
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
+	open_io_config();
+	select_io_device(IODEV_NO);
 
-	// disable the watchdog
-        gpio_bit13(0x09);
-        gpio_bit12(0x09);
+	/* disable the watchdog */
+	gpio_bit13(0x09);
+	gpio_bit12(0x09);
 
-	// reset watchdog config register
+	/* reset watchdog config register */
 	wdt_timer_conf(0x00);
 
-	// reset watchdog control register
-        wdt_timer_ctrl(0x00);
+	/* reset watchdog control register */
+	wdt_timer_ctrl(0x00);
 
-	// disable timeout
-        wdt_timeout_value(0x00);
+	/* disable timeout */
+	wdt_timeout_value(0x00);
 
-        close_io_config();
+	close_io_config();
 	spin_unlock(&io_lock);
 }
 
@@ -269,16 +277,16 @@ static void wb_smsc_wdt_shutdown(void)
 static void wb_smsc_wdt_set_timeout(unsigned char new_timeout)
 {
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
+	open_io_config();
+	select_io_device(IODEV_NO);
 
-	// set Power LED to blink, if we enable the timeout
-        wdt_timer_ctrl((new_timeout == 0) ? 0x00 : 0x02);
+	/* set Power LED to blink, if we enable the timeout */
+	wdt_timer_ctrl((new_timeout == 0) ? 0x00 : 0x02);
 
-	// set timeout value
-        wdt_timeout_value(new_timeout);
+	/* set timeout value */
+	wdt_timeout_value(new_timeout);
 
-        close_io_config();
+	close_io_config();
 	spin_unlock(&io_lock);
 }
 
@@ -286,32 +294,32 @@ static void wb_smsc_wdt_set_timeout(unsi
 
 static unsigned char wb_smsc_wdt_get_timeout(void)
 {
-        unsigned char set_timeout;
+	unsigned char set_timeout;
 
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
-        set_timeout = read_io_cr(0xF2);
-        close_io_config();
+	open_io_config();
+	select_io_device(IODEV_NO);
+	set_timeout = read_io_cr(0xF2);
+	close_io_config();
 	spin_unlock(&io_lock);
 
-        return set_timeout;
+	return set_timeout;
 }
 
 /* disable watchdog */
 
 static void wb_smsc_wdt_disable(void)
 {
-        // set the timeout to 0 to disable the watchdog
-        wb_smsc_wdt_set_timeout(0);
+	/* set the timeout to 0 to disable the watchdog */
+	wb_smsc_wdt_set_timeout(0);
 }
 
 /* enable watchdog by setting the current timeout */
 
 static void wb_smsc_wdt_enable(void)
 {
-        // set the current timeout...
-        wb_smsc_wdt_set_timeout(timeout);
+	/* set the current timeout... */
+	wb_smsc_wdt_set_timeout(timeout);
 }
 
 /* reset the timer */
@@ -319,14 +327,14 @@ static void wb_smsc_wdt_enable(void)
 static void wb_smsc_wdt_reset_timer(void)
 {
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
+	open_io_config();
+	select_io_device(IODEV_NO);
 
-	// reset the timer
+	/* reset the timer */
 	wdt_timeout_value(timeout);
 	wdt_timer_conf(0x08);
 
-        close_io_config();
+	close_io_config();
 	spin_unlock(&io_lock);
 }
 
@@ -355,7 +363,9 @@ static int wb_smsc_wdt_open(struct inode
 	/* Reload and activate timer */
 	wb_smsc_wdt_enable();
 
-	printk(KERN_INFO MODNAME "Watchdog enabled. Timeout set to %d %s.\n", timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
+	printk(KERN_INFO MODNAME
+		"Watchdog enabled. Timeout set to %d %s.\n",
+		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
 
 	return nonseekable_open(inode, file);
 }
@@ -367,10 +377,12 @@ static int wb_smsc_wdt_release(struct in
 	/* Shut off the timer. */
 
 	if (expect_close == 42) {
-	        wb_smsc_wdt_disable();
-		printk(KERN_INFO MODNAME "Watchdog disabled, sleeping again...\n");
+		wb_smsc_wdt_disable();
+		printk(KERN_INFO MODNAME
+				"Watchdog disabled, sleeping again...\n");
 	} else {
-		printk(KERN_CRIT MODNAME "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT MODNAME
+				"Unexpected close, not stopping watchdog!\n");
 		wb_smsc_wdt_reset_timer();
 	}
 
@@ -392,7 +404,8 @@ static ssize_t wb_smsc_wdt_write(struct 
 			/* reset expect flag */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != len; i++) {
 				char c;
 				if (get_user(c, data+i))
@@ -410,8 +423,8 @@ static ssize_t wb_smsc_wdt_write(struct 
 
 /* ioctl => control interface */
 
-static int wb_smsc_wdt_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long wb_smsc_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int new_timeout;
 
@@ -420,9 +433,9 @@ static int wb_smsc_wdt_ioctl(struct inod
 		int __user *i;
 	} uarg;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = 		WDIOF_KEEPALIVEPING |
-		                        WDIOF_SETTIMEOUT |
+					WDIOF_SETTIMEOUT |
 					WDIOF_MAGICCLOSE,
 		.firmware_version =	0,
 		.identity = 		"SMsC 37B787 Watchdog"
@@ -431,78 +444,62 @@ static int wb_smsc_wdt_ioctl(struct inod
 	uarg.i = (int __user *)arg;
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(uarg.ident, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-			return put_user(wb_smsc_wdt_status(), uarg.i);
-
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, uarg.i);
-
-		case WDIOC_KEEPALIVE:
-			wb_smsc_wdt_reset_timer();
-			return 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_timeout, uarg.i))
-				return -EFAULT;
-
-			// the API states this is given in secs
-			if (unit == UNIT_MINUTE)
-			  new_timeout /= 60;
-
-			if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
-				return -EINVAL;
-
-			timeout = new_timeout;
-			wb_smsc_wdt_set_timeout(timeout);
-
-			// fall through and return the new timeout...
-
-		case WDIOC_GETTIMEOUT:
-
-		        new_timeout = timeout;
-
-			if (unit == UNIT_MINUTE)
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident, &ident, sizeof(ident))
+								? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		return put_user(wb_smsc_wdt_status(), uarg.i);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, uarg.i);
+	case WDIOC_KEEPALIVE:
+		wb_smsc_wdt_reset_timer();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, uarg.i))
+			return -EFAULT;
+		/* the API states this is given in secs */
+		if (unit == UNIT_MINUTE)
+			new_timeout /= 60;
+		if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
+			return -EINVAL;
+		timeout = new_timeout;
+		wb_smsc_wdt_set_timeout(timeout);
+		/* fall through and return the new timeout... */
+	case WDIOC_GETTIMEOUT:
+		new_timeout = timeout;
+		if (unit == UNIT_MINUTE)
 			  new_timeout *= 60;
+		return put_user(new_timeout, uarg.i);
+	case WDIOC_SETOPTIONS:
+	{
+		int options, retval = -EINVAL;
 
-			return put_user(new_timeout, uarg.i);
-
-		case WDIOC_SETOPTIONS:
-		{
-			int options, retval = -EINVAL;
-
-			if (get_user(options, uarg.i))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-				wb_smsc_wdt_disable();
-				retval = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				wb_smsc_wdt_enable();
-				retval = 0;
-			}
+		if (get_user(options, uarg.i))
+			return -EFAULT;
 
-			return retval;
+		if (options & WDIOS_DISABLECARD) {
+			wb_smsc_wdt_disable();
+			retval = 0;
 		}
+		if (options & WDIOS_ENABLECARD) {
+			wb_smsc_wdt_enable();
+			retval = 0;
+		}
+		return retval;
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
 /* -- Notifier funtions -----------------------------------------*/
 
-static int wb_smsc_wdt_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int wb_smsc_wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT)
-	{
-                // set timeout to 0, to avoid possible race-condition
-	        timeout = 0;
+	if (code == SYS_DOWN || code == SYS_HALT) {
+		/* set timeout to 0, to avoid possible race-condition */
+		timeout = 0;
 		wb_smsc_wdt_disable();
 	}
 	return NOTIFY_DONE;
@@ -510,23 +507,20 @@ static int wb_smsc_wdt_notify_sys(struct
 
 /* -- Module's structures ---------------------------------------*/
 
-static const struct file_operations wb_smsc_wdt_fops =
-{
-	.owner          = THIS_MODULE,
+static const struct file_operations wb_smsc_wdt_fops = {
+	.owner	  = THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wb_smsc_wdt_write,
-	.ioctl		= wb_smsc_wdt_ioctl,
+	.unlocked_ioctl	= wb_smsc_wdt_ioctl,
 	.open		= wb_smsc_wdt_open,
 	.release	= wb_smsc_wdt_release,
 };
 
-static struct notifier_block wb_smsc_wdt_notifier =
-{
+static struct notifier_block wb_smsc_wdt_notifier = {
 	.notifier_call  = wb_smsc_wdt_notify_sys,
 };
 
-static struct miscdevice wb_smsc_wdt_miscdev =
-{
+static struct miscdevice wb_smsc_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &wb_smsc_wdt_fops,
@@ -540,39 +534,44 @@ static int __init wb_smsc_wdt_init(void)
 {
 	int ret;
 
-	printk("SMsC 37B787 watchdog component driver " VERSION " initialising...\n");
+	printk(KERN_INFO "SMsC 37B787 watchdog component driver "
+					VERSION " initialising...\n");
 
 	if (!request_region(IOPORT, IOPORT_SIZE, "SMsC 37B787 watchdog")) {
-		printk(KERN_ERR MODNAME "Unable to register IO port %#x\n", IOPORT);
+		printk(KERN_ERR MODNAME "Unable to register IO port %#x\n",
+								IOPORT);
 		ret = -EBUSY;
 		goto out_pnp;
 	}
 
-        // set new maximum, if it's too big
-        if (timeout > MAX_TIMEOUT)
-               timeout = MAX_TIMEOUT;
+	/* set new maximum, if it's too big */
+	if (timeout > MAX_TIMEOUT)
+		timeout = MAX_TIMEOUT;
 
-        // init the watchdog timer
-        wb_smsc_wdt_initialize();
+	/* init the watchdog timer */
+	wb_smsc_wdt_initialize();
 
 	ret = register_reboot_notifier(&wb_smsc_wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR MODNAME "Unable to register reboot notifier err = %d\n", ret);
+		printk(KERN_ERR MODNAME
+			"Unable to register reboot notifier err = %d\n", ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&wb_smsc_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR MODNAME "Unable to register miscdev on minor %d\n", WATCHDOG_MINOR);
+		printk(KERN_ERR MODNAME
+			"Unable to register miscdev on minor %d\n",
+							WATCHDOG_MINOR);
 		goto out_rbt;
 	}
 
-	// output info
-	printk(KERN_INFO MODNAME "Timeout set to %d %s.\n", timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
-	printk(KERN_INFO MODNAME "Watchdog initialized and sleeping (nowayout=%d)...\n", nowayout);
-
-	// ret = 0
-
+	/* output info */
+	printk(KERN_INFO MODNAME "Timeout set to %d %s.\n",
+		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
+	printk(KERN_INFO MODNAME
+		"Watchdog initialized and sleeping (nowayout=%d)...\n",
+								nowayout);
 out_clean:
 	return ret;
 
@@ -591,8 +590,7 @@ out_pnp:
 static void __exit wb_smsc_wdt_exit(void)
 {
 	/* Stop the timer before we leave */
-	if (!nowayout)
-	{
+	if (!nowayout) {
 		wb_smsc_wdt_shutdown();
 		printk(KERN_INFO MODNAME "Watchdog disabled.\n");
 	}
@@ -601,25 +599,29 @@ static void __exit wb_smsc_wdt_exit(void
 	unregister_reboot_notifier(&wb_smsc_wdt_notifier);
 	release_region(IOPORT, IOPORT_SIZE);
 
-	printk("SMsC 37B787 watchdog component driver removed.\n");
+	printk(KERN_INFO "SMsC 37B787 watchdog component driver removed.\n");
 }
 
 module_init(wb_smsc_wdt_init);
 module_exit(wb_smsc_wdt_exit);
 
 MODULE_AUTHOR("Sven Anders <anders@anduras.de>");
-MODULE_DESCRIPTION("Driver for SMsC 37B787 watchdog component (Version " VERSION ")");
+MODULE_DESCRIPTION("Driver for SMsC 37B787 watchdog component (Version "
+								VERSION ")");
 MODULE_LICENSE("GPL");
 
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 #ifdef SMSC_SUPPORT_MINUTES
 module_param(unit, int, 0);
-MODULE_PARM_DESC(unit, "set unit to use, 0=seconds or 1=minutes, default is 0");
+MODULE_PARM_DESC(unit,
+		"set unit to use, 0=seconds or 1=minutes, default is 0");
 #endif
 
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "range is 1-255 units, default is 60");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
linux-next.patch
ia64-hp-sim-simserialc-adapt-to-new-tty-framework.patch
remove-is_tty.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
hamradio-add-missing-sanity-check-to-tty-operation.patch
git-watchdog.patch
serial-8250_gscc-add-module_license.patch
serial-add-support-for-a-no-name-4-ports-multiserial-card.patch
istallion-remove-unused-variable.patch
stallion-removed-unused-variable.patch
spidev-bkl-removal.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
unexport-proc_clear_tty.patch

