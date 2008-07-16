From: akpm@linux-foundation.org
Subject: - watchdog-txx9-fix-locking-switch-to-unlocked_ioctl.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:37:11 -0700
Message-ID: <200807162137.m6GLbBMo014356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757298AbYGPVhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: txx9: Fix locking, switch to unlocked_ioctl
has been removed from the -mm tree.  Its filename was
     watchdog-txx9-fix-locking-switch-to-unlocked_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: txx9: Fix locking, switch to unlocked_ioctl
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/txx9wdt.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff -puN drivers/watchdog/txx9wdt.c~watchdog-txx9-fix-locking-switch-to-unlocked_ioctl drivers/watchdog/txx9wdt.c
--- a/drivers/watchdog/txx9wdt.c~watchdog-txx9-fix-locking-switch-to-unlocked_ioctl
+++ a/drivers/watchdog/txx9wdt.c
@@ -45,27 +45,34 @@ static unsigned long txx9wdt_alive;
 static int expect_close;
 static struct txx9_tmr_reg __iomem *txx9wdt_reg;
 static struct clk *txx9_imclk;
+static DECLARE_LOCK(txx9_lock);
 
 static void txx9wdt_ping(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+	spin_unlock(&txx9_lock);
 }
 
 static void txx9wdt_start(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(WD_TIMER_CLK * timeout, &txx9wdt_reg->cpra);
 	__raw_writel(WD_TIMER_CCD, &txx9wdt_reg->ccdr);
 	__raw_writel(0, &txx9wdt_reg->tisr);	/* clear pending interrupt */
 	__raw_writel(TXx9_TMTCR_TCE | TXx9_TMTCR_CCDE | TXx9_TMTCR_TMODE_WDOG,
 		     &txx9wdt_reg->tcr);
 	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+	spin_unlock(&txx9_lock);
 }
 
 static void txx9wdt_stop(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(TXx9_TMWTMR_WDIS, &txx9wdt_reg->wtmr);
 	__raw_writel(__raw_readl(&txx9wdt_reg->tcr) & ~TXx9_TMTCR_TCE,
 		     &txx9wdt_reg->tcr);
+	spin_unlock(&txx9_lock);
 }
 
 static int txx9wdt_open(struct inode *inode, struct file *file)
@@ -120,13 +127,13 @@ static ssize_t txx9wdt_write(struct file
 	return len;
 }
 
-static int txx9wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long txx9wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
@@ -168,18 +175,18 @@ static int txx9wdt_notify_sys(struct not
 }
 
 static const struct file_operations txx9wdt_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	txx9wdt_write,
-	.ioctl =	txx9wdt_ioctl,
-	.open =		txx9wdt_open,
-	.release =	txx9wdt_release,
+	.owner		=	THIS_MODULE,
+	.llseek		=	no_llseek,
+	.write		=	txx9wdt_write,
+	.unlocked_ioctl =	txx9wdt_ioctl,
+	.open		=	txx9wdt_open,
+	.release	=	txx9wdt_release,
 };
 
 static struct miscdevice txx9wdt_miscdev = {
-	.minor =	WATCHDOG_MINOR,
-	.name =		"watchdog",
-	.fops =		&txx9wdt_fops,
+	.minor	=	WATCHDOG_MINOR,
+	.name	=	"watchdog",
+	.fops	=	&txx9wdt_fops,
 };
 
 static struct notifier_block txx9wdt_notifier = {
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

