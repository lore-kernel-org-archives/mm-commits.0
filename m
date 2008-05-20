From: akpm@linux-foundation.org
Subject: + watchdog-i6300esb-style-unlocked_ioctl-cleanup.patch added to -mm tree
Date: Tue, 20 May 2008 01:27:58 -0700
Message-ID: <200805200827.m4K8RwAH013104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758719AbYETI2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: i6300esb: Style, unlocked_ioctl, cleanup
has been added to the -mm tree.  Its filename is
     watchdog-i6300esb-style-unlocked_ioctl-cleanup.patch

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
Subject: watchdog: i6300esb: Style, unlocked_ioctl, cleanup
From: Alan Cox <alan@redhat.com>


Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/i6300esb.c |  354 ++++++++++++++++------------------
 1 file changed, 173 insertions(+), 181 deletions(-)

diff -puN drivers/watchdog/i6300esb.c~watchdog-i6300esb-style-unlocked_ioctl-cleanup drivers/watchdog/i6300esb.c
--- a/drivers/watchdog/i6300esb.c~watchdog-i6300esb-style-unlocked_ioctl-cleanup
+++ a/drivers/watchdog/i6300esb.c
@@ -38,9 +38,8 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 /* Module and version information */
 #define ESB_VERSION "0.03"
@@ -59,17 +58,17 @@
 #define ESB_RELOAD_REG  BASEADDR + 0x0c /* Reload register                   */
 
 /* Lock register bits */
-#define ESB_WDT_FUNC    ( 0x01 << 2 )   /* Watchdog functionality            */
-#define ESB_WDT_ENABLE  ( 0x01 << 1 )   /* Enable WDT                        */
-#define ESB_WDT_LOCK    ( 0x01 << 0 )   /* Lock (nowayout)                   */
+#define ESB_WDT_FUNC    (0x01 << 2)   /* Watchdog functionality            */
+#define ESB_WDT_ENABLE  (0x01 << 1)   /* Enable WDT                        */
+#define ESB_WDT_LOCK    (0x01 << 0)   /* Lock (nowayout)                   */
 
 /* Config register bits */
-#define ESB_WDT_REBOOT  ( 0x01 << 5 )   /* Enable reboot on timeout          */
-#define ESB_WDT_FREQ    ( 0x01 << 2 )   /* Decrement frequency               */
-#define ESB_WDT_INTTYPE ( 0x11 << 0 )   /* Interrupt type on timer1 timeout  */
+#define ESB_WDT_REBOOT  (0x01 << 5)   /* Enable reboot on timeout          */
+#define ESB_WDT_FREQ    (0x01 << 2)   /* Decrement frequency               */
+#define ESB_WDT_INTTYPE (0x11 << 0)   /* Interrupt type on timer1 timeout  */
 
 /* Reload register bits */
-#define ESB_WDT_RELOAD ( 0x01 << 8 )    /* prevent timeout                   */
+#define ESB_WDT_RELOAD  (0x01 << 8)    /* prevent timeout                   */
 
 /* Magic constants */
 #define ESB_UNLOCK1     0x80            /* Step 1 to unlock reset registers  */
@@ -84,14 +83,20 @@ static unsigned short triggered; /* The 
 static char esb_expect_close;
 
 /* module parameters */
-#define WATCHDOG_HEARTBEAT 30   /* 30 sec default heartbeat (1<heartbeat<2*1023) */
+/* 30 sec default heartbeat (1 < heartbeat < 2*1023) */
+#define WATCHDOG_HEARTBEAT 30
 static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
+
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (1<heartbeat<2046, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat,
+		"Watchdog heartbeat in seconds. (1<heartbeat<2046, default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some i6300ESB specific functions
@@ -104,8 +109,8 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
  * to once before they need to be unlocked again.
  */
 static inline void esb_unlock_registers(void) {
-        writeb(ESB_UNLOCK1, ESB_RELOAD_REG);
-        writeb(ESB_UNLOCK2, ESB_RELOAD_REG);
+	writeb(ESB_UNLOCK1, ESB_RELOAD_REG);
+	writeb(ESB_UNLOCK2, ESB_RELOAD_REG);
 }
 
 static void esb_timer_start(void)
@@ -114,8 +119,7 @@ static void esb_timer_start(void)
 
 	/* Enable or Enable + Lock? */
 	val = 0x02 | (nowayout ? 0x01 : 0x00);
-
-        pci_write_config_byte(esb_pci, ESB_LOCK_REG, val);
+	pci_write_config_byte(esb_pci, ESB_LOCK_REG, val);
 }
 
 static int esb_timer_stop(void)
@@ -140,7 +144,7 @@ static void esb_timer_keepalive(void)
 	spin_lock(&esb_lock);
 	esb_unlock_registers();
 	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
-        /* FIXME: Do we need to flush anything here? */
+	/* FIXME: Do we need to flush anything here? */
 	spin_unlock(&esb_lock);
 }
 
@@ -167,7 +171,7 @@ static int esb_timer_set_heartbeat(int t
 	esb_unlock_registers();
         writel(val, ESB_TIMER2_REG);
 
-        /* Reload */
+	/* Reload */
 	esb_unlock_registers();
 	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
 
@@ -179,54 +183,55 @@ static int esb_timer_set_heartbeat(int t
 	return 0;
 }
 
-static int esb_timer_read (void)
+static int esb_timer_read(void)
 {
-       	u32 count;
+	u32 count;
 
 	/* This isn't documented, and doesn't take into
-         * acount which stage is running, but it looks
-         * like a 20 bit count down, so we might as well report it.
-         */
-        pci_read_config_dword(esb_pci, 0x64, &count);
-        return (int)count;
+	 * acount which stage is running, but it looks
+	 * like a 20 bit count down, so we might as well report it.
+	 */
+	pci_read_config_dword(esb_pci, 0x64, &count);
+	return (int)count;
 }
 
 /*
  * 	/dev/watchdog handling
  */
 
-static int esb_open (struct inode *inode, struct file *file)
+static int esb_open(struct inode *inode, struct file *file)
 {
-        /* /dev/watchdog can only be opened once */
-        if (test_and_set_bit(0, &timer_alive))
-                return -EBUSY;
-
-        /* Reload and activate timer */
-        esb_timer_keepalive ();
-        esb_timer_start ();
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &timer_alive))
+		return -EBUSY;
+
+	/* Reload and activate timer */
+	esb_timer_keepalive();
+	esb_timer_start();
 
 	return nonseekable_open(inode, file);
 }
 
-static int esb_release (struct inode *inode, struct file *file)
+static int esb_release(struct inode *inode, struct file *file)
 {
-        /* Shut off the timer. */
-        if (esb_expect_close == 42) {
-                esb_timer_stop ();
-        } else {
-                printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
-                esb_timer_keepalive ();
-        }
-        clear_bit(0, &timer_alive);
-        esb_expect_close = 0;
-        return 0;
+	/* Shut off the timer. */
+	if (esb_expect_close == 42)
+		esb_timer_stop();
+	else {
+		printk(KERN_CRIT PFX
+				"Unexpected close, not stopping watchdog!\n");
+		esb_timer_keepalive();
+	}
+	clear_bit(0, &timer_alive);
+	esb_expect_close = 0;
+	return 0;
 }
 
-static ssize_t esb_write (struct file *file, const char __user *data,
-			  size_t len, loff_t * ppos)
+static ssize_t esb_write(struct file *file, const char __user *data,
+			  size_t len, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-        if (len) {
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -237,7 +242,7 @@ static ssize_t esb_write (struct file *f
 			/* scan to see whether or not we got the magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data+i))
+				if (get_user(c, data+i))
 					return -EFAULT;
 				if (c == 'V')
 					esb_expect_close = 42;
@@ -245,13 +250,12 @@ static ssize_t esb_write (struct file *f
 		}
 
 		/* someone wrote to us, we should reload the timer */
-		esb_timer_keepalive ();
+		esb_timer_keepalive();
 	}
 	return len;
 }
 
-static int esb_ioctl (struct inode *inode, struct file *file,
-		      unsigned int cmd, unsigned long arg)
+static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_options, retval = -EINVAL;
 	int new_heartbeat;
@@ -266,71 +270,65 @@ static int esb_ioctl (struct inode *inod
 	};
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-					    sizeof (ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-			return put_user (esb_timer_read(), p);
-
-		case WDIOC_GETBOOTSTATUS:
-			return put_user (triggered, p);
-
-                case WDIOC_KEEPALIVE:
-                        esb_timer_keepalive ();
-                        return 0;
-
-                case WDIOC_SETOPTIONS:
-                {
-                        if (get_user (new_options, p))
-                                return -EFAULT;
-
-                        if (new_options & WDIOS_DISABLECARD) {
-                                esb_timer_stop ();
-                                retval = 0;
-                        }
-
-                        if (new_options & WDIOS_ENABLECARD) {
-                                esb_timer_keepalive ();
-                                esb_timer_start ();
-                                retval = 0;
-                        }
-
-                        return retval;
-                }
-
-                case WDIOC_SETTIMEOUT:
-                {
-                        if (get_user(new_heartbeat, p))
-                                return -EFAULT;
-
-                        if (esb_timer_set_heartbeat(new_heartbeat))
-                            return -EINVAL;
-
-                        esb_timer_keepalive ();
-                        /* Fall */
-                }
-
-                case WDIOC_GETTIMEOUT:
-                        return put_user(heartbeat, p);
-
-                default:
-                        return -ENOTTY;
-        }
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident,
+					sizeof(ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+		return put_user(esb_timer_read(), p);
+
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(triggered, p);
+
+	case WDIOC_KEEPALIVE:
+		esb_timer_keepalive();
+		return 0;
+
+	case WDIOC_SETOPTIONS:
+	{
+		if (get_user(new_options, p))
+			return -EFAULT;
+
+		if (new_options & WDIOS_DISABLECARD) {
+			esb_timer_stop();
+			retval = 0;
+		}
+
+		if (new_options & WDIOS_ENABLECARD) {
+			esb_timer_keepalive();
+			esb_timer_start();
+			retval = 0;
+		}
+		return retval;
+	}
+	case WDIOC_SETTIMEOUT:
+	{
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (esb_timer_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		esb_timer_keepalive();
+		/* Fall */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
+	}
 }
 
 /*
  *      Notify system
  */
 
-static int esb_notify_sys (struct notifier_block *this, unsigned long code, void *unused)
+static int esb_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
-        if (code==SYS_DOWN || code==SYS_HALT) {
-                /* Turn the WDT off */
-                esb_timer_stop ();
-        }
-
-        return NOTIFY_DONE;
+	if (code == SYS_DOWN || code == SYS_HALT) {
+		/* Turn the WDT off */
+		esb_timer_stop();
+	}
+	return NOTIFY_DONE;
 }
 
 /*
@@ -338,22 +336,22 @@ static int esb_notify_sys (struct notifi
  */
 
 static const struct file_operations esb_fops = {
-        .owner =        THIS_MODULE,
-        .llseek =       no_llseek,
-        .write =        esb_write,
-        .ioctl =        esb_ioctl,
-        .open =         esb_open,
-        .release =      esb_release,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = esb_write,
+	.unlocked_ioctl = esb_ioctl,
+	.open = esb_open,
+	.release = esb_release,
 };
 
 static struct miscdevice esb_miscdev = {
-        .minor =        WATCHDOG_MINOR,
-        .name =         "watchdog",
-        .fops =         &esb_fops,
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &esb_fops,
 };
 
 static struct notifier_block esb_notifier = {
-        .notifier_call =        esb_notify_sys,
+	.notifier_call = esb_notify_sys,
 };
 
 /*
@@ -365,50 +363,44 @@ static struct notifier_block esb_notifie
  * want to register another driver on the same PCI id.
  */
 static struct pci_device_id esb_pci_tbl[] = {
-        { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
-        { 0, },                 /* End of list */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
+	{ 0, },                 /* End of list */
 };
-MODULE_DEVICE_TABLE (pci, esb_pci_tbl);
+MODULE_DEVICE_TABLE(pci, esb_pci_tbl);
 
 /*
  *      Init & exit routines
  */
 
-static unsigned char __init esb_getdevice (void)
+static unsigned char __init esb_getdevice(void)
 {
 	u8 val1;
 	unsigned short val2;
+	/*
+	 *      Find the PCI device
+	 */
 
-        struct pci_dev *dev = NULL;
-        /*
-         *      Find the PCI device
-         */
-
-        for_each_pci_dev(dev) {
-                if (pci_match_id(esb_pci_tbl, dev)) {
-                        esb_pci = dev;
-                        break;
-                }
-	}
+	esb_pci = pci_get_device(PCI_VENDOR_ID_INTEL,
+					PCI_DEVICE_ID_INTEL_ESB_9, NULL);
 
-        if (esb_pci) {
-        	if (pci_enable_device(esb_pci)) {
-			printk (KERN_ERR PFX "failed to enable device\n");
+	if (esb_pci) {
+		if (pci_enable_device(esb_pci)) {
+			printk(KERN_ERR PFX "failed to enable device\n");
 			goto err_devput;
 		}
 
 		if (pci_request_region(esb_pci, 0, ESB_MODULE_NAME)) {
-			printk (KERN_ERR PFX "failed to request region\n");
+			printk(KERN_ERR PFX "failed to request region\n");
 			goto err_disable;
 		}
 
 		BASEADDR = ioremap(pci_resource_start(esb_pci, 0),
 				   pci_resource_len(esb_pci, 0));
 		if (BASEADDR == NULL) {
-                	/* Something's wrong here, BASEADDR has to be set */
-			printk (KERN_ERR PFX "failed to get BASEADDR\n");
-                        goto err_release;
-                }
+			/* Something's wrong here, BASEADDR has to be set */
+			printk(KERN_ERR PFX "failed to get BASEADDR\n");
+			goto err_release;
+		}
 
 		/*
 		 * The watchdog has two timers, it can be setup so that the
@@ -425,7 +417,7 @@ static unsigned char __init esb_getdevic
 		/* Check that the WDT isn't already locked */
 		pci_read_config_byte(esb_pci, ESB_LOCK_REG, &val1);
 		if (val1 & ESB_WDT_LOCK)
-			printk (KERN_WARNING PFX "nowayout already set\n");
+			printk(KERN_WARNING PFX "nowayout already set\n");
 
 		/* Set the timer to watchdog mode and disable it for now */
 		pci_write_config_byte(esb_pci, ESB_LOCK_REG, 0x00);
@@ -452,44 +444,44 @@ err_devput:
 	return 0;
 }
 
-static int __init watchdog_init (void)
+static int __init watchdog_init(void)
 {
-        int ret;
-
-        /* Check whether or not the hardware watchdog is there */
-        if (!esb_getdevice () || esb_pci == NULL)
-                return -ENODEV;
-
-        /* Check that the heartbeat value is within it's range ; if not reset to the default */
-        if (esb_timer_set_heartbeat (heartbeat)) {
-                esb_timer_set_heartbeat (WATCHDOG_HEARTBEAT);
-                printk(KERN_INFO PFX "heartbeat value must be 1<heartbeat<2046, using %d\n",
-		       heartbeat);
-        }
-
-        ret = register_reboot_notifier(&esb_notifier);
-        if (ret != 0) {
-                printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-                        ret);
-                goto err_unmap;
-        }
-
-        ret = misc_register(&esb_miscdev);
-        if (ret != 0) {
-                printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-                        WATCHDOG_MINOR, ret);
-                goto err_notifier;
-        }
+	int ret;
 
-        esb_timer_stop ();
-
-        printk (KERN_INFO PFX "initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
-                BASEADDR, heartbeat, nowayout);
+	/* Check whether or not the hardware watchdog is there */
+	if (!esb_getdevice() || esb_pci == NULL)
+		return -ENODEV;
+
+	/* Check that the heartbeat value is within it's range;
+	   if not reset to the default */
+	if (esb_timer_set_heartbeat(heartbeat)) {
+        	esb_timer_set_heartbeat(WATCHDOG_HEARTBEAT);
+		printk(KERN_INFO PFX
+			"heartbeat value must be 1<heartbeat<2046, using %d\n",
+								heartbeat);
+	}
+	ret = register_reboot_notifier(&esb_notifier);
+	if (ret != 0) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
+		goto err_unmap;
+	}
 
-        return 0;
+	ret = misc_register(&esb_miscdev);
+	if (ret != 0) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
+		goto err_notifier;
+	}
+	esb_timer_stop();
+	printk(KERN_INFO PFX
+		"initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
+						BASEADDR, heartbeat, nowayout);
+	return 0;
 
 err_notifier:
-        unregister_reboot_notifier(&esb_notifier);
+	unregister_reboot_notifier(&esb_notifier);
 err_unmap:
 	iounmap(BASEADDR);
 /* err_release: */
@@ -498,18 +490,18 @@ err_unmap:
 	pci_disable_device(esb_pci);
 /* err_devput: */
 	pci_dev_put(esb_pci);
-        return ret;
+	return ret;
 }
 
-static void __exit watchdog_cleanup (void)
+static void __exit watchdog_cleanup(void)
 {
 	/* Stop the timer before we leave */
 	if (!nowayout)
-		esb_timer_stop ();
+		esb_timer_stop();
 
 	/* Deregister */
 	misc_deregister(&esb_miscdev);
-        unregister_reboot_notifier(&esb_notifier);
+	unregister_reboot_notifier(&esb_notifier);
 	iounmap(BASEADDR);
 	pci_release_region(esb_pci, 0);
 	pci_disable_device(esb_pci);
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

