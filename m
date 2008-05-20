From: akpm@linux-foundation.org
Subject: + watchdog-it8712f-unlocked_ioctl.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:05 -0700
Message-ID: <200805200828.m4K8S5Ks013122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759995AbYETI2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: it8712f: unlocked_ioctl
has been added to the -mm tree.  Its filename is
     watchdog-it8712f-unlocked_ioctl.patch

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
@@ -120,15 +116,13 @@ superio_outw(int val, int reg)
 	outb(val & 0xff, VAL);
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
@@ -137,22 +131,19 @@ superio_enter(void)
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
@@ -175,8 +166,7 @@ it8712f_wdt_update_margin(void)
 		superio_outb(units, WDT_TIMEOUT);
 }
 
-static int
-it8712f_wdt_get_status(void)
+static int it8712f_wdt_get_status(void)
 {
 	if (superio_inb(WDT_CONTROL) & 0x01)
 		return WDIOF_CARDRESET;
@@ -184,8 +174,7 @@ it8712f_wdt_get_status(void)
 		return 0;
 }
 
-static void
-it8712f_wdt_enable(void)
+static void it8712f_wdt_enable(void)
 {
 	printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
 	superio_enter();
@@ -200,8 +189,7 @@ it8712f_wdt_enable(void)
 	it8712f_wdt_ping();
 }
 
-static void
-it8712f_wdt_disable(void)
+static void it8712f_wdt_disable(void)
 {
 	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
 
@@ -217,8 +205,7 @@ it8712f_wdt_disable(void)
 	superio_exit();
 }
 
-static int
-it8712f_wdt_notify(struct notifier_block *this,
+static int it8712f_wdt_notify(struct notifier_block *this,
 		    unsigned long code, void *unused)
 {
 	if (code == SYS_HALT || code == SYS_POWER_OFF)
@@ -232,9 +219,8 @@ static struct notifier_block it8712f_wdt
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
@@ -255,9 +241,8 @@ it8712f_wdt_write(struct file *file, con
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
@@ -312,19 +297,16 @@ it8712f_wdt_ioctl(struct inode *inode, s
 	}
 }
 
-static int
-it8712f_wdt_open(struct inode *inode, struct file *file)
+static int it8712f_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (!down_nowait(&it8712f_wdt_sem))
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
@@ -334,7 +316,7 @@ it8712f_wdt_release(struct inode *inode,
 		it8712f_wdt_disable();
 	}
 	expect_close = 0;
-	up(&it8712f_wdt_sem);
+	clear_bit(0, &wdt_open);
 
 	return 0;
 }
@@ -343,7 +325,7 @@ static const struct file_operations it87
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = it8712f_wdt_write,
-	.ioctl = it8712f_wdt_ioctl,
+	.unlocked_ioctl = it8712f_wdt_ioctl,
 	.open = it8712f_wdt_open,
 	.release = it8712f_wdt_release,
 };
@@ -354,8 +336,7 @@ static struct miscdevice it8712f_wdt_mis
 	.fops = &it8712f_wdt_fops,
 };
 
-static int __init
-it8712f_wdt_find(unsigned short *address)
+static int __init it8712f_wdt_find(unsigned short *address)
 {
 	int err = -ENODEV;
 	int chip_type;
@@ -397,8 +378,7 @@ exit:
 	return err;
 }
 
-static int __init
-it8712f_wdt_init(void)
+static int __init it8712f_wdt_init(void)
 {
 	int err = 0;
 
@@ -414,8 +394,6 @@ it8712f_wdt_init(void)
 
 	it8712f_wdt_disable();
 
-	sema_init(&it8712f_wdt_sem, 1);
-
 	err = register_reboot_notifier(&it8712f_wdt_notifier);
 	if (err) {
 		printk(KERN_ERR NAME ": unable to register reboot notifier\n");
@@ -440,8 +418,7 @@ out:
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

linux-next.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
watchdog-clean-acquirewdt-and-check-for-bkl-dependancies.patch
watchdog-clean-up-and-check-advantech-watchdog.patch
watchdog-ali-watchdog-locking-and-style.patch
watchdog-ar7-watchdog.patch
watchdog-atp-watchdog.patch
watchdog-at91-watchdog-to-unlocked_ioctl.patch
watchdog-cpu5_wdt-switch-to-unlocked_ioctl.patch
watchdog-davinci_wdt-unlocked_ioctl-and-check-locking.patch
watchdog-ep93xx_wdt-unlocked_ioctl.patch
watchdog-eurotechwdt-unlocked_ioctl-code-lock-check-and-tidy.patch
watchdog-hpwdt-couple-of-include-cleanups.patch
watchdog-ib700wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-i6300esb-style-unlocked_ioctl-cleanup.patch
watchdog-ibmasr-coding-style-locking-verify.patch
watchdog-indydog-clean-up-and-tidy.patch
watchdog-iop-watchdog-switch-to-unlocked_ioctl.patch
watchdog-it8712f-unlocked_ioctl.patch
watchdog-bfin-watchdog-cleanup-and-unlocked_ioctl.patch
watchdog-ixp2000_wdt-clean-up-and-unlocked_ioctl.patch
watchdog-ixp4xx_wdt-unlocked_ioctl.patch
watchdog-ks8695_wdt-clean-up-coding-style-unlocked_ioctl.patch
watchdog-machzwd-clean-up-coding-style-unlocked_ioctl.patch
watchdog-mixcomwd-coding-style-locking-unlocked_ioctl.patch
watchdog-mpc-watchdog-clean-up-and-locking.patch
watchdog-mpcore-watchdog-unlocked_ioctl-and-bkl-work.patch
watchdog-mtx-1_wdt-clean-up-coding-style-unlocked-ioctl.patch
watchdog-mv64x60_wdt-clean-up-and-locking-checks.patch
watchdog-omap_wdt-locking-unlocked_ioctl-tidy.patch
watchdog-pc87413_wdt-clean-up-coding-style-unlocked_ioctl.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage.patch
watchdog-pnx4008_wdt-unlocked_ioctl-setup.patch
watchdog-rm9k_wdt-clean-up.patch
watchdog-s3c2410-watchdog-cleanup-and-switch-to-unlocked_ioctl.patch
watchdog-sa1100_wdt-switch-to-unlocked_ioctl.patch
watchdog-sbc60xxwdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-stg7240_wdt-unlocked_ioctl.patch
watchdog-sbc8360-clean-up.patch
watchdog-sbc_epx_c3_wdt-switch-to-unlocked_ioctl.patch
watchdog-sb_wdog-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-sc1200_wdt-clean-up-fix-locking-and-use-unlocked_ioctl.patch
watchdog-sc520_wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-scx200_wdt-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-shwdt-coding-style-cleanup-switch-to-unlocked_ioctl.patch
watchdog-smsc37b787_wdt-coding-style-switch-to-unlocked_ioctl.patch
watchdog-softdog-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-txx9-fix-locking-switch-to-unlocked_ioctl.patch
watchdog-w83627hf-coding-style-clean-up-and-switch-to-unlocked_ioctl.patch
watchdog-w83877f_wdt-clean-up-code-coding-style-switch-to-unlocked_ioctl.patch
watchdog-w83977f_wdt-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-wafer5823wdt-clean-up-coding-style-switch-to-unlocked_ioctl.patch
watchdog-wdrtas-clean-up-coding-style-switch-to-unlocked_ioctl.patch
watchdog-wdt285-switch-to-unlocked_ioctl-and-tidy-up-oddments-of-coding-style.patch
watchdog-wdt977-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
mm-fix-atomic_t-overflow-in-vm.patch
serial-8250_gscc-add-module_license.patch
remove-is_tty.patch
riscom8-remove-redundant-null-pointer-test.patch
unexport-proc_clear_tty.patch

