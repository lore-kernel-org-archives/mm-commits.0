From: akpm@linux-foundation.org
Subject: - watchdog-mpc-watchdog-clean-up-and-locking.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:27 -0700
Message-ID: <200807162136.m6GLaRJW014206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757139AbYGPVhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: mpc watchdog: clean up and locking
has been removed from the -mm tree.  Its filename was
     watchdog-mpc-watchdog-clean-up-and-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: mpc watchdog: clean up and locking
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/mpc5200_wdt.c |   20 ++++++++++------
 drivers/watchdog/mpc83xx_wdt.c |   19 ++++++++-------
 drivers/watchdog/mpc8xx_wdt.c  |   37 +++++++++++++++----------------
 3 files changed, 41 insertions(+), 35 deletions(-)

diff -puN drivers/watchdog/mpc5200_wdt.c~watchdog-mpc-watchdog-clean-up-and-locking drivers/watchdog/mpc5200_wdt.c
--- a/drivers/watchdog/mpc5200_wdt.c~watchdog-mpc-watchdog-clean-up-and-locking
+++ a/drivers/watchdog/mpc5200_wdt.c
@@ -4,8 +4,8 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
-#include <asm/of_platform.h>
-#include <asm/uaccess.h>
+#include <linux/of_platform.h>
+#include <linux/uaccess.h>
 #include <asm/mpc52xx.h>
 
 
@@ -57,7 +57,8 @@ static int mpc5200_wdt_start(struct mpc5
 	/* set timeout, with maximum prescaler */
 	out_be32(&wdt->regs->count, 0x0 | wdt->count);
 	/* enable watchdog */
-	out_be32(&wdt->regs->mode, GPT_MODE_CE | GPT_MODE_WDT | GPT_MODE_MS_TIMER);
+	out_be32(&wdt->regs->mode, GPT_MODE_CE | GPT_MODE_WDT |
+						GPT_MODE_MS_TIMER);
 	spin_unlock(&wdt->io_lock);
 
 	return 0;
@@ -66,7 +67,8 @@ static int mpc5200_wdt_ping(struct mpc52
 {
 	spin_lock(&wdt->io_lock);
 	/* writing A5 to OCPW resets the watchdog */
-	out_be32(&wdt->regs->mode, 0xA5000000 | (0xffffff & in_be32(&wdt->regs->mode)));
+	out_be32(&wdt->regs->mode, 0xA5000000 |
+				(0xffffff & in_be32(&wdt->regs->mode)));
 	spin_unlock(&wdt->io_lock);
 	return 0;
 }
@@ -92,8 +94,8 @@ static struct watchdog_info mpc5200_wdt_
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= "mpc5200 watchdog on GPT0",
 };
-static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long mpc5200_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct mpc5200_wdt *wdt = file->private_data;
 	int __user *data = (int __user *)arg;
@@ -103,7 +105,7 @@ static int mpc5200_wdt_ioctl(struct inod
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = copy_to_user(data, &mpc5200_wdt_info,
-			sizeof(mpc5200_wdt_info));
+						sizeof(mpc5200_wdt_info));
 		if (ret)
 			ret = -EFAULT;
 		break;
@@ -135,6 +137,7 @@ static int mpc5200_wdt_ioctl(struct inod
 	}
 	return ret;
 }
+
 static int mpc5200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
@@ -167,7 +170,8 @@ static const struct file_operations mpc5
 };
 
 /* module operations */
-static int mpc5200_wdt_probe(struct of_device *op, const struct of_device_id *match)
+static int mpc5200_wdt_probe(struct of_device *op,
+					const struct of_device_id *match)
 {
 	struct mpc5200_wdt *wdt;
 	int err;
diff -puN drivers/watchdog/mpc83xx_wdt.c~watchdog-mpc-watchdog-clean-up-and-locking drivers/watchdog/mpc83xx_wdt.c
--- a/drivers/watchdog/mpc83xx_wdt.c~watchdog-mpc-watchdog-clean-up-and-locking
+++ a/drivers/watchdog/mpc83xx_wdt.c
@@ -22,8 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 struct mpc83xx_wdt {
 	__be32 res0;
@@ -42,11 +42,13 @@ static struct mpc83xx_wdt __iomem *wd_ba
 
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in ticks. (0<timeout<65536, default=65535");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in ticks. (0<timeout<65536, default=65535");
 
 static int reset = 1;
 module_param(reset, bool, 0);
-MODULE_PARM_DESC(reset, "Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
+MODULE_PARM_DESC(reset,
+	"Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
 
 /*
  * We always prescale, but if someone really doesn't want to they can set this
@@ -105,8 +107,8 @@ static int mpc83xx_wdt_release(struct in
 	return 0;
 }
 
-static int mpc83xx_wdt_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
+static long mpc83xx_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -136,7 +138,7 @@ static const struct file_operations mpc8
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= mpc83xx_wdt_write,
-	.ioctl		= mpc83xx_wdt_ioctl,
+	.unlocked_ioctl	= mpc83xx_wdt_ioctl,
 	.open		= mpc83xx_wdt_open,
 	.release	= mpc83xx_wdt_release,
 };
@@ -161,8 +163,7 @@ static int __devinit mpc83xx_wdt_probe(s
 		goto err_out;
 	}
 
-	wd_base = ioremap(r->start, sizeof (struct mpc83xx_wdt));
-
+	wd_base = ioremap(r->start, sizeof(struct mpc83xx_wdt));
 	if (wd_base == NULL) {
 		ret = -ENOMEM;
 		goto err_out;
diff -puN drivers/watchdog/mpc8xx_wdt.c~watchdog-mpc-watchdog-clean-up-and-locking drivers/watchdog/mpc8xx_wdt.c
--- a/drivers/watchdog/mpc8xx_wdt.c~watchdog-mpc-watchdog-clean-up-and-locking
+++ a/drivers/watchdog/mpc8xx_wdt.c
@@ -16,36 +16,35 @@
 #include <linux/module.h>
 #include <linux/watchdog.h>
 #include <asm/8xx_immap.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <syslib/m8xx_wdt.h>
 
 static unsigned long wdt_opened;
 static int wdt_status;
+static spinlock_t wdt_lock;
 
 static void mpc8xx_wdt_handler_disable(void)
 {
 	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t*)IMAP_ADDR)->im_sit.sit_piscr;
+	piscr = (uint *)&((immap_t *)IMAP_ADDR)->im_sit.sit_piscr;
 
 	if (!m8xx_has_internal_rtc)
 		m8xx_wdt_stop_timer();
 	else
 		out_be32(piscr, in_be32(piscr) & ~(PISCR_PIE | PISCR_PTE));
-
 	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler deactivated\n");
 }
 
 static void mpc8xx_wdt_handler_enable(void)
 {
 	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t*)IMAP_ADDR)->im_sit.sit_piscr;
+	piscr = (uint *)&((immap_t *)IMAP_ADDR)->im_sit.sit_piscr;
 
 	if (!m8xx_has_internal_rtc)
 		m8xx_wdt_install_timer();
 	else
 		out_be32(piscr, in_be32(piscr) | PISCR_PIE | PISCR_PTE);
-
 	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler activated\n");
 }
 
@@ -53,37 +52,34 @@ static int mpc8xx_wdt_open(struct inode 
 {
 	if (test_and_set_bit(0, &wdt_opened))
 		return -EBUSY;
-
 	m8xx_wdt_reset();
 	mpc8xx_wdt_handler_disable();
-
 	return nonseekable_open(inode, file);
 }
 
 static int mpc8xx_wdt_release(struct inode *inode, struct file *file)
 {
 	m8xx_wdt_reset();
-
 #if !defined(CONFIG_WATCHDOG_NOWAYOUT)
 	mpc8xx_wdt_handler_enable();
 #endif
-
 	clear_bit(0, &wdt_opened);
-
 	return 0;
 }
 
-static ssize_t mpc8xx_wdt_write(struct file *file, const char *data, size_t len,
-				loff_t * ppos)
+static ssize_t mpc8xx_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
-	if (len)
+	if (len) {
+		spin_lock(&wdt_lock);
 		m8xx_wdt_reset();
-
+		spin_unlock(&wdt_lock);
+	}
 	return len;
 }
 
-static int mpc8xx_wdt_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg)
+static long mpc8xx_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int timeout;
 	static struct watchdog_info info = {
@@ -112,15 +108,19 @@ static int mpc8xx_wdt_ioctl(struct inode
 		return -EOPNOTSUPP;
 
 	case WDIOC_KEEPALIVE:
+		spin_lock(&wdt_lock);
 		m8xx_wdt_reset();
 		wdt_status |= WDIOF_KEEPALIVEPING;
+		spin_unlock(&wdt_lock);
 		break;
 
 	case WDIOC_SETTIMEOUT:
 		return -EOPNOTSUPP;
 
 	case WDIOC_GETTIMEOUT:
+		spin_lock(&wdt_lock);
 		timeout = m8xx_wdt_get_timeout();
+		spin_unlock(&wdt_lock);
 		if (put_user(timeout, (int *)arg))
 			return -EFAULT;
 		break;
@@ -136,7 +136,7 @@ static const struct file_operations mpc8
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = mpc8xx_wdt_write,
-	.ioctl = mpc8xx_wdt_ioctl,
+	.unlocked_ioctl = mpc8xx_wdt_ioctl,
 	.open = mpc8xx_wdt_open,
 	.release = mpc8xx_wdt_release,
 };
@@ -149,6 +149,7 @@ static struct miscdevice mpc8xx_wdt_misc
 
 static int __init mpc8xx_wdt_init(void)
 {
+	spin_lock_init(&wdt_lock);
 	return misc_register(&mpc8xx_wdt_miscdev);
 }
 
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

