From: akpm@linux-foundation.org
Subject: - watchdog-i6300esb-style-unlocked_ioctl-cleanup.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:36:05 -0700
Message-ID: <200807162136.m6GLa5LQ014161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754705AbYGPVnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: i6300esb: Style, unlocked_ioctl, cleanup
has been removed from the -mm tree.  Its filename was
     watchdog-i6300esb-style-unlocked_ioctl-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

