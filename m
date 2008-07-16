From: akpm@linux-foundation.org
Subject: - watchdog-ali-watchdog-locking-and-style.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:45 -0700
Message-ID: <200807162135.m6GLZj5m014119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034AbYGPVgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:36:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: ali: watchdog locking and style
has been removed from the -mm tree.  Its filename was
     watchdog-ali-watchdog-locking-and-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: ali: watchdog locking and style
From: Alan Cox <alan@redhat.com>

Clean up and check locking

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/alim1535_wdt.c |  186 ++++++++++++------------
 drivers/watchdog/alim7101_wdt.c |  224 +++++++++++++++---------------
 2 files changed, 209 insertions(+), 201 deletions(-)

diff -puN drivers/watchdog/alim1535_wdt.c~watchdog-ali-watchdog-locking-and-style drivers/watchdog/alim1535_wdt.c
--- a/drivers/watchdog/alim1535_wdt.c~watchdog-ali-watchdog-locking-and-style
+++ a/drivers/watchdog/alim1535_wdt.c
@@ -19,8 +19,8 @@
 #include <linux/fs.h>
 #include <linux/pci.h>
 
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define WATCHDOG_NAME "ALi_M1535"
 #define PFX WATCHDOG_NAME ": "
@@ -30,17 +30,21 @@
 static unsigned long ali_is_open;
 static char ali_expect_release;
 static struct pci_dev *ali_pci;
-static u32 ali_timeout_bits;	/* stores the computed timeout */
+static u32 ali_timeout_bits;		/* stores the computed timeout */
 static DEFINE_SPINLOCK(ali_lock);	/* Guards the hardware */
 
 /* module parameters */
 static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (0<timeout<18000, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. (0 < timeout < 18000, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	ali_start	-	start watchdog countdown
@@ -103,15 +107,16 @@ static void ali_keepalive(void)
 
 static int ali_settimer(int t)
 {
-	if(t < 0)
+	if (t < 0)
 		return -EINVAL;
-	else if(t < 60)
+	else if (t < 60)
 		ali_timeout_bits = t|(1<<6);
-	else if(t < 3600)
+	else if (t < 3600)
 		ali_timeout_bits = (t/60)|(1<<7);
-	else if(t < 18000)
+	else if (t < 18000)
 		ali_timeout_bits = (t/300)|(1<<6)|(1<<7);
-	else return -EINVAL;
+	else
+		return -EINVAL;
 
 	timeout = t;
 	return 0;
@@ -134,21 +139,22 @@ static int ali_settimer(int t)
  */
 
 static ssize_t ali_write(struct file *file, const char __user *data,
-			      size_t len, loff_t * ppos)
+			      size_t len, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (len) {
 		if (!nowayout) {
 			size_t i;
 
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			/* note: just in case someone wrote the
+			   magic character five months ago... */
 			ali_expect_release = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got
+			   the magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data+i))
+				if (get_user(c, data+i))
 					return -EFAULT;
 				if (c == 'V')
 					ali_expect_release = 42;
@@ -163,7 +169,6 @@ static ssize_t ali_write(struct file *fi
 
 /*
  *	ali_ioctl	-	handle watchdog ioctls
- *	@inode: VFS inode
  *	@file: VFS file pointer
  *	@cmd: ioctl number
  *	@arg: arguments to the ioctl
@@ -172,8 +177,7 @@ static ssize_t ali_write(struct file *fi
  *	we want an extension to enable irq ack monitoring and the like
  */
 
-static int ali_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long ali_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -186,57 +190,45 @@ static int ali_ioctl(struct inode *inode
 	};
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof (ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
-			ali_keepalive();
-			return 0;
-
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if (get_user (new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				ali_stop();
-				retval = 0;
-			}
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 
-			if (new_options & WDIOS_ENABLECARD) {
-				ali_start();
-				retval = 0;
-			}
-
-			return retval;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		ali_keepalive();
+		return 0;
+	case WDIOC_SETOPTIONS:
+	{
+		int new_options, retval = -EINVAL;
+
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			ali_stop();
+			retval = 0;
 		}
-
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
-
-			if (get_user(new_timeout, p))
-				return -EFAULT;
-
-			if (ali_settimer(new_timeout))
-			    return -EINVAL;
-
-			ali_keepalive();
-			/* Fall */
+		if (new_options & WDIOS_ENABLECARD) {
+			ali_start();
+			retval = 0;
 		}
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
-
-		default:
-			return -ENOTTY;
+		return retval;
+	}
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (ali_settimer(new_timeout))
+			return -EINVAL;
+		ali_keepalive();
+		/* Fall */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -274,10 +266,11 @@ static int ali_release(struct inode *ino
 	/*
 	 *      Shut off the timer.
 	 */
-	if (ali_expect_release == 42) {
+	if (ali_expect_release == 42)
 		ali_stop();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+				"Unexpected close, not stopping watchdog!\n");
 		ali_keepalive();
 	}
 	clear_bit(0, &ali_is_open);
@@ -292,13 +285,11 @@ static int ali_release(struct inode *ino
  */
 
 
-static int ali_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int ali_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the WDT off */
-		ali_stop();
-	}
-
+	if (code == SYS_DOWN || code == SYS_HALT)
+		ali_stop();		/* Turn the WDT off */
 	return NOTIFY_DONE;
 }
 
@@ -340,10 +331,10 @@ static int __init ali_find_watchdog(void
 
 	/* Check for the a 7101 PMU */
 	pdev = pci_get_device(PCI_VENDOR_ID_AL, 0x7101, NULL);
-	if(pdev == NULL)
+	if (pdev == NULL)
 		return -ENODEV;
 
-	if(pci_enable_device(pdev)) {
+	if (pci_enable_device(pdev)) {
 		pci_dev_put(pdev);
 		return -EIO;
 	}
@@ -355,9 +346,12 @@ static int __init ali_find_watchdog(void
 	 */
 	pci_read_config_dword(pdev, 0xCC, &wdog);
 
-	wdog &= ~0x3F;		/* Timer bits */
-	wdog &= ~((1<<27)|(1<<26)|(1<<25)|(1<<24));	/* Issued events */
-	wdog &= ~((1<<16)|(1<<13)|(1<<12)|(1<<11)|(1<<10)|(1<<9));	/* No monitor bits */
+	/* Timer bits */
+	wdog &= ~0x3F;
+	/* Issued events */
+	wdog &= ~((1<<27)|(1<<26)|(1<<25)|(1<<24));
+	/* No monitor bits */
+	wdog &= ~((1<<16)|(1<<13)|(1<<12)|(1<<11)|(1<<10)|(1<<9));
 
 	pci_write_config_dword(pdev, 0xCC, wdog);
 
@@ -369,12 +363,12 @@ static int __init ali_find_watchdog(void
  */
 
 static const struct file_operations ali_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	ali_write,
-	.ioctl =	ali_ioctl,
-	.open =		ali_open,
-	.release =	ali_release,
+	.owner 		=	THIS_MODULE,
+	.llseek 	=	no_llseek,
+	.write		=	ali_write,
+	.unlocked_ioctl =	ali_ioctl,
+	.open 		=	ali_open,
+	.release 	=	ali_release,
 };
 
 static struct miscdevice ali_miscdev = {
@@ -399,15 +393,16 @@ static int __init watchdog_init(void)
 	int ret;
 
 	/* Check whether or not the hardware watchdog is there */
-	if (ali_find_watchdog() != 0) {
+	if (ali_find_watchdog() != 0)
 		return -ENODEV;
-	}
 
-	/* Check that the timeout value is within it's range ; if not reset to the default */
+	/* Check that the timeout value is within it's range;
+	   if not reset to the default */
 	if (timeout < 1 || timeout >= 18000) {
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 0<timeout<18000, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+		     "timeout value must be 0 < timeout < 18000, using %d\n",
+							timeout);
 	}
 
 	/* Calculate the watchdog's timeout */
@@ -415,15 +410,16 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&ali_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto out;
 	}
 
 	ret = misc_register(&ali_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
diff -puN drivers/watchdog/alim7101_wdt.c~watchdog-ali-watchdog-locking-and-style drivers/watchdog/alim7101_wdt.c
--- a/drivers/watchdog/alim7101_wdt.c~watchdog-ali-watchdog-locking-and-style
+++ a/drivers/watchdog/alim7101_wdt.c
@@ -32,8 +32,8 @@
 #include <linux/fs.h>
 #include <linux/pci.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "alim7101_wdt"
@@ -60,13 +60,17 @@
  */
 
 #define WATCHDOG_TIMEOUT 30            /* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT; /* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
-static int use_gpio = 0; /* Use the pic (for a1d revision alim7101) */
+static int use_gpio; /* Use the pic (for a1d revision alim7101) */
 module_param(use_gpio, int, 0);
-MODULE_PARM_DESC(use_gpio, "Use the gpio watchdog.  (required by old cobalt boards)");
+MODULE_PARM_DESC(use_gpio,
+		"Use the gpio watchdog (required by old cobalt boards).");
 
 static void wdt_timer_ping(unsigned long);
 static DEFINE_TIMER(timer, wdt_timer_ping, 0, 1);
@@ -77,8 +81,9 @@ static struct pci_dev *alim7101_pmu;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
-		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Whack the dog
@@ -89,23 +94,26 @@ static void wdt_timer_ping(unsigned long
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	char	tmp;
+	char tmp;
 
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT (this is actually a disarm/arm sequence) */
 		pci_read_config_byte(alim7101_pmu, 0x92, &tmp);
-		pci_write_config_byte(alim7101_pmu, ALI_7101_WDT, (tmp & ~ALI_WDT_ARM));
-		pci_write_config_byte(alim7101_pmu, ALI_7101_WDT, (tmp | ALI_WDT_ARM));
+		pci_write_config_byte(alim7101_pmu,
+					ALI_7101_WDT, (tmp & ~ALI_WDT_ARM));
+		pci_write_config_byte(alim7101_pmu,
+					ALI_7101_WDT, (tmp | ALI_WDT_ARM));
 		if (use_gpio) {
-			pci_read_config_byte(alim7101_pmu, ALI_7101_GPIO_O, &tmp);
-			pci_write_config_byte(alim7101_pmu, ALI_7101_GPIO_O, tmp
-					| 0x20);
-			pci_write_config_byte(alim7101_pmu, ALI_7101_GPIO_O, tmp
-					& ~0x20);
+			pci_read_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, &tmp);
+			pci_write_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, tmp | 0x20);
+			pci_write_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, tmp & ~0x20);
 		}
 	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 	}
 	/* Re-set the timer interval */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
@@ -121,17 +129,23 @@ static void wdt_change(int writeval)
 
 	pci_read_config_byte(alim7101_pmu, ALI_7101_WDT, &tmp);
 	if (writeval == WDT_ENABLE) {
-		pci_write_config_byte(alim7101_pmu, ALI_7101_WDT, (tmp | ALI_WDT_ARM));
+		pci_write_config_byte(alim7101_pmu,
+					ALI_7101_WDT, (tmp | ALI_WDT_ARM));
 		if (use_gpio) {
-			pci_read_config_byte(alim7101_pmu, ALI_7101_GPIO_O, &tmp);
-			pci_write_config_byte(alim7101_pmu, ALI_7101_GPIO_O, tmp & ~0x20);
+			pci_read_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, &tmp);
+			pci_write_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, tmp & ~0x20);
 		}
 
 	} else {
-		pci_write_config_byte(alim7101_pmu, ALI_7101_WDT, (tmp & ~ALI_WDT_ARM));
+		pci_write_config_byte(alim7101_pmu,
+					ALI_7101_WDT, (tmp & ~ALI_WDT_ARM));
 		if (use_gpio) {
-			pci_read_config_byte(alim7101_pmu, ALI_7101_GPIO_O, &tmp);
-			pci_write_config_byte(alim7101_pmu, ALI_7101_GPIO_O, tmp | 0x20);
+			pci_read_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, &tmp);
+			pci_write_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, tmp | 0x20);
 		}
 	}
 }
@@ -169,10 +183,11 @@ static void wdt_keepalive(void)
  * /dev/watchdog handling
  */
 
-static ssize_t fop_write(struct file * file, const char __user * buf, size_t count, loff_t * ppos)
+static ssize_t fop_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count) {
+	if (count) {
 		if (!nowayout) {
 			size_t ofs;
 
@@ -195,119 +210,116 @@ static ssize_t fop_write(struct file * f
 	return count;
 }
 
-static int fop_open(struct inode * inode, struct file * file)
+static int fop_open(struct inode *inode, struct file *file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 	/* Good, fire up the show */
 	wdt_startup();
 	return nonseekable_open(inode, file);
 }
 
-static int fop_close(struct inode * inode, struct file * file)
+static int fop_close(struct inode *inode, struct file *file)
 {
-	if(wdt_expect_close == 42)
+	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
 		/* wim: shouldn't there be a: del_timer(&timer); */
-		printk(KERN_CRIT PFX "device file closed unexpectedly. Will not stop the WDT!\n");
+		printk(KERN_CRIT PFX
+		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
 	return 0;
 }
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident =
-	{
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "ALiM7101",
 	};
 
-	switch(cmd)
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETOPTIONS:
 	{
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdt_keepalive();
-			return 0;
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if(get_user(new_options, p))
-				return -EFAULT;
-
-			if(new_options & WDIOS_DISABLECARD) {
-				wdt_turnoff();
-				retval = 0;
-			}
-
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
+		int new_options, retval = -EINVAL;
 
-			return retval;
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			wdt_turnoff();
+			retval = 0;
 		}
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
-
-			if(get_user(new_timeout, p))
-				return -EFAULT;
-
-			if(new_timeout < 1 || new_timeout > 3600) /* arbitrary upper limit */
-				return -EINVAL;
-
-			timeout = new_timeout;
-			wdt_keepalive();
-			/* Fall through */
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
 		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
-		default:
-			return -ENOTTY;
+		return retval;
+	}
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
+
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		/* arbitrary upper limit */
+		if (new_timeout < 1 || new_timeout > 3600)
+			return -EINVAL;
+		timeout = new_timeout;
+		wdt_keepalive();
+		/* Fall through */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
 static const struct file_operations wdt_fops = {
-	.owner=		THIS_MODULE,
-	.llseek=	no_llseek,
-	.write=		fop_write,
-	.open=		fop_open,
-	.release=	fop_close,
-	.ioctl=		fop_ioctl,
+	.owner		=	THIS_MODULE,
+	.llseek		=	no_llseek,
+	.write		=	fop_write,
+	.open		=	fop_open,
+	.release	=	fop_close,
+	.unlocked_ioctl	=	fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
-	.minor=WATCHDOG_MINOR,
-	.name="watchdog",
-	.fops=&wdt_fops,
+	.minor	=	WATCHDOG_MINOR,
+	.name	=	"watchdog",
+	.fops	=	&wdt_fops,
 };
 
 /*
  *	Notifier for system down
  */
 
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 
-	if (code==SYS_RESTART) {
+	if (code == SYS_RESTART) {
 		/*
-		 * Cobalt devices have no way of rebooting themselves other than
-		 * getting the watchdog to pull reset, so we restart the watchdog on
-		 * reboot with no heartbeat
+		 * Cobalt devices have no way of rebooting themselves other
+		 * than getting the watchdog to pull reset, so we restart the
+		 * watchdog on reboot with no heartbeat
 		 */
 		wdt_change(WDT_ENABLE);
 		printk(KERN_INFO PFX "Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second.\n");
@@ -320,8 +332,7 @@ static int wdt_notify_sys(struct notifie
  *	turn the timebomb registers off.
  */
 
-static struct notifier_block wdt_notifier=
-{
+static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
@@ -354,7 +365,8 @@ static int __init alim7101_wdt_init(void
 	ali1543_south = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533,
 		NULL);
 	if (!ali1543_south) {
-		printk(KERN_INFO PFX "ALi 1543 South-Bridge not present - WDT not set\n");
+		printk(KERN_INFO PFX
+			"ALi 1543 South-Bridge not present - WDT not set\n");
 		goto err_out;
 	}
 	pci_read_config_byte(ali1543_south, 0x5e, &tmp);
@@ -363,24 +375,25 @@ static int __init alim7101_wdt_init(void
 		if (!use_gpio) {
 			printk(KERN_INFO PFX "Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.\n");
 			goto err_out;
-		} 
+		}
 		nowayout = 1;
 	} else if ((tmp & 0x1e) != 0x12 && (tmp & 0x1e) != 0x00) {
 		printk(KERN_INFO PFX "ALi 1543 South-Bridge does not have the correct revision number (???1001?) - WDT not set\n");
 		goto err_out;
 	}
 
-	if(timeout < 1 || timeout > 3600) /* arbitrary upper limit */
-	{
+	if (timeout < 1 || timeout > 3600) {
+		/* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 3600, using %d\n",
+								timeout);
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out;
 	}
 
@@ -391,9 +404,8 @@ static int __init alim7101_wdt_init(void
 		goto err_out_reboot;
 	}
 
-	if (nowayout) {
+	if (nowayout)
 		__module_get(THIS_MODULE);
-	}
 
 	printk(KERN_INFO PFX "WDT driver for ALi M7101 initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
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

