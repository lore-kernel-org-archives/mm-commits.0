From: akpm@linux-foundation.org
Subject: + watchdog-mpc-watchdog-clean-up-and-locking.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:16 -0700
Message-ID: <200805200828.m4K8SG0P013143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760453AbYETI2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: mpc watchdog: clean up and locking
has been added to the -mm tree.  Its filename is
     watchdog-mpc-watchdog-clean-up-and-locking.patch

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

