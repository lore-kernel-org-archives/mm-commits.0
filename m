From: akpm@linux-foundation.org
Subject: - watchdog-ar7-watchdog.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:47 -0700
Message-ID: <200807162135.m6GLZlAk014122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756732AbYGPVge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: aR7 watchdog
has been removed from the -mm tree.  Its filename was
     watchdog-ar7-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: aR7 watchdog
From: Alan Cox <alan@redhat.com>

Fix locking
Use unlocked_ioctl
Remove semaphores

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ar7_wdt.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff -puN drivers/watchdog/ar7_wdt.c~watchdog-ar7-watchdog drivers/watchdog/ar7_wdt.c
--- a/drivers/watchdog/ar7_wdt.c~watchdog-ar7-watchdog
+++ a/drivers/watchdog/ar7_wdt.c
@@ -69,7 +69,8 @@ struct ar7_wdt {
 	u32 prescale;
 };
 
-static struct semaphore open_semaphore;
+static unsigned long wdt_is_open;
+static spinlock_t wdt_lock;
 static unsigned expect_close;
 
 /* XXX currently fixed, allows max margin ~68.72 secs */
@@ -154,8 +155,10 @@ static void ar7_wdt_update_margin(int ne
 	u32 change;
 
 	change = new_margin * (ar7_vbus_freq() / prescale_value);
-	if (change < 1) change = 1;
-	if (change > 0xffff) change = 0xffff;
+	if (change < 1)
+		change = 1;
+	if (change > 0xffff)
+		change = 0xffff;
 	ar7_wdt_change(change);
 	margin = change * prescale_value / ar7_vbus_freq();
 	printk(KERN_INFO DRVNAME
@@ -179,7 +182,7 @@ static void ar7_wdt_disable_wdt(void)
 static int ar7_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 	ar7_wdt_enable_wdt();
 	expect_close = 0;
@@ -195,9 +198,7 @@ static int ar7_wdt_release(struct inode 
 		"will not disable the watchdog timer\n");
 	else if (!nowayout)
 		ar7_wdt_disable_wdt();
-
-	up(&open_semaphore);
-
+	clear_bit(0, &wdt_is_open);
 	return 0;
 }
 
@@ -222,7 +223,9 @@ static ssize_t ar7_wdt_write(struct file
 	if (len) {
 		size_t i;
 
+		spin_lock(&wdt_lock);
 		ar7_wdt_kick(1);
+		spin_unlock(&wdt_lock);
 
 		expect_close = 0;
 		for (i = 0; i < len; ++i) {
@@ -237,8 +240,8 @@ static ssize_t ar7_wdt_write(struct file
 	return len;
 }
 
-static int ar7_wdt_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long ar7_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	static struct watchdog_info ident = {
 		.identity = LONGNAME,
@@ -269,8 +272,10 @@ static int ar7_wdt_ioctl(struct inode *i
 		if (new_margin < 1)
 			return -EINVAL;
 
+		spin_lock(&wdt_lock);
 		ar7_wdt_update_margin(new_margin);
 		ar7_wdt_kick(1);
+		spin_unlock(&wdt_lock);
 
 	case WDIOC_GETTIMEOUT:
 		if (put_user(margin, (int *)arg))
@@ -282,7 +287,7 @@ static int ar7_wdt_ioctl(struct inode *i
 static const struct file_operations ar7_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ar7_wdt_write,
-	.ioctl		= ar7_wdt_ioctl,
+	.unlocked_ioctl	= ar7_wdt_ioctl,
 	.open		= ar7_wdt_open,
 	.release	= ar7_wdt_release,
 };
@@ -297,6 +302,8 @@ static int __init ar7_wdt_init(void)
 {
 	int rc;
 
+	spin_lock_init(&wdt_lock);
+
 	ar7_wdt_get_regs();
 
 	if (!request_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt),
@@ -312,8 +319,6 @@ static int __init ar7_wdt_init(void)
 	ar7_wdt_prescale(prescale_value);
 	ar7_wdt_update_margin(margin);
 
-	sema_init(&open_semaphore, 1);
-
 	rc = register_reboot_notifier(&ar7_wdt_notifier);
 	if (rc) {
 		printk(KERN_ERR DRVNAME
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

