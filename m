From: akpm@linux-foundation.org
Subject: - watchdog-it8712f-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:13 -0700
Message-ID: <200807162136.m6GLaD1s014173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979AbYGPVkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:40:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: it8712f: unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-it8712f-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: it8712f: unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/it8712f_wdt.c |   77 ++++++++++---------------------
 1 file changed, 27 insertions(+), 50 deletions(-)

diff -puN drivers/watchdog/it8712f_wdt.c~watchdog-it8712f-unlocked_ioctl drivers/watchdog/it8712f_wdt.c
--- a/drivers/watchdog/it8712f_wdt.c~watchdog-it8712f-unlocked_ioctl
+++ a/drivers/watchdog/it8712f_wdt.c
@@ -30,9 +30,8 @@
 #include <linux/fs.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define NAME "it8712f_wdt"
 
@@ -50,7 +49,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
-static struct semaphore it8712f_wdt_sem;
+static unsigned long wdt_open;
 static unsigned expect_close;
 static spinlock_t io_lock;
 static unsigned char revision;
@@ -86,22 +85,19 @@ static unsigned short address;
 #define WDT_OUT_PWROK	0x10
 #define WDT_OUT_KRST	0x40
 
-static int
-superio_inb(int reg)
+static int superio_inb(int reg)
 {
 	outb(reg, REG);
 	return inb(VAL);
 }
 
-static void
-superio_outb(int val, int reg)
+static void superio_outb(int val, int reg)
 {
 	outb(reg, REG);
 	outb(val, VAL);
 }
 
-static int
-superio_inw(int reg)
+static int superio_inw(int reg)
 {
 	int val;
 	outb(reg++, REG);
@@ -111,15 +107,13 @@ superio_inw(int reg)
 	return val;
 }
 
-static inline void
-superio_select(int ldn)
+static inline void superio_select(int ldn)
 {
 	outb(LDN, REG);
 	outb(ldn, VAL);
 }
 
-static inline void
-superio_enter(void)
+static inline void superio_enter(void)
 {
 	spin_lock(&io_lock);
 	outb(0x87, REG);
@@ -128,22 +122,19 @@ superio_enter(void)
 	outb(0x55, REG);
 }
 
-static inline void
-superio_exit(void)
+static inline void superio_exit(void)
 {
 	outb(0x02, REG);
 	outb(0x02, VAL);
 	spin_unlock(&io_lock);
 }
 
-static inline void
-it8712f_wdt_ping(void)
+static inline void it8712f_wdt_ping(void)
 {
 	inb(address);
 }
 
-static void
-it8712f_wdt_update_margin(void)
+static void it8712f_wdt_update_margin(void)
 {
 	int config = WDT_OUT_KRST | WDT_OUT_PWROK;
 	int units = margin;
@@ -165,8 +156,7 @@ it8712f_wdt_update_margin(void)
 	superio_outb(units, WDT_TIMEOUT);
 }
 
-static int
-it8712f_wdt_get_status(void)
+static int it8712f_wdt_get_status(void)
 {
 	if (superio_inb(WDT_CONTROL) & 0x01)
 		return WDIOF_CARDRESET;
@@ -174,8 +164,7 @@ it8712f_wdt_get_status(void)
 		return 0;
 }
 
-static void
-it8712f_wdt_enable(void)
+static void it8712f_wdt_enable(void)
 {
 	printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
 	superio_enter();
@@ -190,8 +179,7 @@ it8712f_wdt_enable(void)
 	it8712f_wdt_ping();
 }
 
-static void
-it8712f_wdt_disable(void)
+static void it8712f_wdt_disable(void)
 {
 	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
 
@@ -207,8 +195,7 @@ it8712f_wdt_disable(void)
 	superio_exit();
 }
 
-static int
-it8712f_wdt_notify(struct notifier_block *this,
+static int it8712f_wdt_notify(struct notifier_block *this,
 		    unsigned long code, void *unused)
 {
 	if (code == SYS_HALT || code == SYS_POWER_OFF)
@@ -222,9 +209,8 @@ static struct notifier_block it8712f_wdt
 	.notifier_call = it8712f_wdt_notify,
 };
 
-static ssize_t
-it8712f_wdt_write(struct file *file, const char __user *data,
-	size_t len, loff_t *ppos)
+static ssize_t it8712f_wdt_write(struct file *file, const char __user *data,
+					size_t len, loff_t *ppos)
 {
 	/* check for a magic close character */
 	if (len) {
@@ -245,9 +231,8 @@ it8712f_wdt_write(struct file *file, con
 	return len;
 }
 
-static int
-it8712f_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -302,19 +287,16 @@ it8712f_wdt_ioctl(struct inode *inode, s
 	}
 }
 
-static int
-it8712f_wdt_open(struct inode *inode, struct file *file)
+static int it8712f_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&it8712f_wdt_sem))
+	if (test_and_set_bit(0, &wdt_open))
 		return -EBUSY;
 	it8712f_wdt_enable();
-
 	return nonseekable_open(inode, file);
 }
 
-static int
-it8712f_wdt_release(struct inode *inode, struct file *file)
+static int it8712f_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42) {
 		printk(KERN_WARNING NAME
@@ -324,7 +306,7 @@ it8712f_wdt_release(struct inode *inode,
 		it8712f_wdt_disable();
 	}
 	expect_close = 0;
-	up(&it8712f_wdt_sem);
+	clear_bit(0, &wdt_open);
 
 	return 0;
 }
@@ -333,7 +315,7 @@ static const struct file_operations it87
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = it8712f_wdt_write,
-	.ioctl = it8712f_wdt_ioctl,
+	.unlocked_ioctl = it8712f_wdt_ioctl,
 	.open = it8712f_wdt_open,
 	.release = it8712f_wdt_release,
 };
@@ -344,8 +326,7 @@ static struct miscdevice it8712f_wdt_mis
 	.fops = &it8712f_wdt_fops,
 };
 
-static int __init
-it8712f_wdt_find(unsigned short *address)
+static int __init it8712f_wdt_find(unsigned short *address)
 {
 	int err = -ENODEV;
 	int chip_type;
@@ -387,8 +368,7 @@ exit:
 	return err;
 }
 
-static int __init
-it8712f_wdt_init(void)
+static int __init it8712f_wdt_init(void)
 {
 	int err = 0;
 
@@ -404,8 +384,6 @@ it8712f_wdt_init(void)
 
 	it8712f_wdt_disable();
 
-	sema_init(&it8712f_wdt_sem, 1);
-
 	err = register_reboot_notifier(&it8712f_wdt_notifier);
 	if (err) {
 		printk(KERN_ERR NAME ": unable to register reboot notifier\n");
@@ -430,8 +408,7 @@ out:
 	return err;
 }
 
-static void __exit
-it8712f_wdt_exit(void)
+static void __exit it8712f_wdt_exit(void)
 {
 	misc_deregister(&it8712f_wdt_miscdev);
 	unregister_reboot_notifier(&it8712f_wdt_notifier);
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

