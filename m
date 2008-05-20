From: akpm@linux-foundation.org
Subject: + watchdog-ibmasr-coding-style-locking-verify.patch added to -mm tree
Date: Tue, 20 May 2008 01:28:00 -0700
Message-ID: <200805200828.m4K8S0BG013107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759781AbYETI2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:28:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com


The patch titled
     watchdog: ibmasr: coding style, locking verify
has been added to the -mm tree.  Its filename is
     watchdog-ibmasr-coding-style-locking-verify.patch

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
Subject: watchdog: ibmasr: coding style, locking verify
From: Alan Cox <alan@redhat.com>

There is a new #if 0 section here which is a suggested fix for the horrible
PCI hack in the existing code. Would be good if someone with a box that uses
this device could test it.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ibmasr.c |  149 +++++++++++++++++++++---------------
 1 file changed, 87 insertions(+), 62 deletions(-)

diff -puN drivers/watchdog/ibmasr.c~watchdog-ibmasr-coding-style-locking-verify drivers/watchdog/ibmasr.c
--- a/drivers/watchdog/ibmasr.c~watchdog-ibmasr-coding-style-locking-verify
+++ a/drivers/watchdog/ibmasr.c
@@ -19,9 +19,8 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/dmi.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 
 enum {
@@ -70,10 +69,13 @@ static char asr_expect_close;
 static unsigned int asr_type, asr_base, asr_length;
 static unsigned int asr_read_addr, asr_write_addr;
 static unsigned char asr_toggle_mask, asr_disable_mask;
+static spinlock_t asr_lock;
 
-static void asr_toggle(void)
+static void __asr_toggle(void)
 {
-	unsigned char reg = inb(asr_read_addr);
+	unsigned char reg;
+
+	reg = inb(asr_read_addr);
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
@@ -83,12 +85,21 @@ static void asr_toggle(void)
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
+}
+
+static void asr_toggle(void)
+{
+	spin_lock(&asr_lock);
+	__asr_toggle();
+	spin_unlock(&asr_lock);
 }
 
 static void asr_enable(void)
 {
 	unsigned char reg;
 
+	spin_lock(&asr_lock);
 	if (asr_type == ASMTYPE_TOPAZ) {
 		/* asr_write_addr == asr_read_addr */
 		reg = inb(asr_read_addr);
@@ -99,17 +110,21 @@ static void asr_enable(void)
 		 * First make sure the hardware timer is reset by toggling
 		 * ASR hardware timer line.
 		 */
-		asr_toggle();
+		__asr_toggle();
 
 		reg = inb(asr_read_addr);
 		outb(reg & ~asr_disable_mask, asr_write_addr);
 	}
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
 }
 
 static void asr_disable(void)
 {
-	unsigned char reg = inb(asr_read_addr);
+	unsigned char reg;
+
+	spin_lock(&asr_lock);
+	reg = inb(asr_read_addr);
 
 	if (asr_type == ASMTYPE_TOPAZ)
 		/* asr_write_addr == asr_read_addr */
@@ -122,6 +137,7 @@ static void asr_disable(void)
 		outb(reg | asr_disable_mask, asr_write_addr);
 	}
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
 }
 
 static int __init asr_get_base_address(void)
@@ -133,7 +149,8 @@ static int __init asr_get_base_address(v
 
 	switch (asr_type) {
 	case ASMTYPE_TOPAZ:
-		/* SELECT SuperIO CHIP FOR QUERYING (WRITE 0x07 TO BOTH 0x2E and 0x2F) */
+		/* SELECT SuperIO CHIP FOR QUERYING
+		   (WRITE 0x07 TO BOTH 0x2E and 0x2F) */
 		outb(0x07, 0x2e);
 		outb(0x07, 0x2f);
 
@@ -154,14 +171,26 @@ static int __init asr_get_base_address(v
 
 	case ASMTYPE_JASPER:
 		type = "Jaspers ";
-
-		/* FIXME: need to use pci_config_lock here, but it's not exported */
+#if 0
+		u32 r;
+		/* Suggested fix */
+		pdev = pci_get_bus_and_slot(0, DEVFN(0x1f, 0));
+		if (pdev == NULL)
+			return -ENODEV;
+		pci_read_config_dword(pdev, 0x58, &r);
+		asr_base = r & 0xFFFE;
+		pci_dev_put(pdev);
+#else
+		/* FIXME: need to use pci_config_lock here,
+		   but it's not exported */
 
 /*		spin_lock_irqsave(&pci_config_lock, flags);*/
 
 		/* Select the SuperIO chip in the PCI I/O port register */
 		outl(0x8000f858, 0xcf8);
 
+		/* BUS 0, Slot 1F, fnc 0, offset 58 */
+
 		/*
 		 * Read the base address for the SuperIO chip.
 		 * Only the lower 16 bits are valid, but the address is word
@@ -170,7 +199,7 @@ static int __init asr_get_base_address(v
 		asr_base = inl(0xcfc) & 0xfffe;
 
 /*		spin_unlock_irqrestore(&pci_config_lock, flags);*/
-
+#endif
 		asr_read_addr = asr_write_addr =
 			asr_base + JASPER_ASR_REG_OFFSET;
 		asr_toggle_mask = JASPER_ASR_TOGGLE_MASK;
@@ -241,11 +270,10 @@ static ssize_t asr_write(struct file *fi
 	return count;
 }
 
-static int asr_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long asr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	static const struct watchdog_info ident = {
-		.options =	WDIOF_KEEPALIVEPING | 
+		.options =	WDIOF_KEEPALIVEPING |
 				WDIOF_MAGICCLOSE,
 		.identity =	"IBM ASR"
 	};
@@ -254,53 +282,45 @@ static int asr_ioctl(struct inode *inode
 	int heartbeat;
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident)) ?
-				-EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		asr_toggle();
+		return 0;
+	/*
+	 * The hardware has a fixed timeout value, so no WDIOC_SETTIMEOUT
+	 * and WDIOC_GETTIMEOUT always returns 256.
+	 */
+	case WDIOC_GETTIMEOUT:
+		heartbeat = 256;
+		return put_user(heartbeat, p);
+	case WDIOC_SETOPTIONS:
+	{
+		int new_options, retval = -EINVAL;
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			asr_disable();
+			retval = 0;
+		}
+		if (new_options & WDIOS_ENABLECARD) {
+			asr_enable();
 			asr_toggle();
-			return 0;
-
-		/*
-		 * The hardware has a fixed timeout value, so no WDIOC_SETTIMEOUT
-		 * and WDIOC_GETTIMEOUT always returns 256.
-		 */
-		case WDIOC_GETTIMEOUT:
-			heartbeat = 256;
-			return put_user(heartbeat, p);
-
-		case WDIOC_SETOPTIONS: {
-			int new_options, retval = -EINVAL;
-
-			if (get_user(new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				asr_disable();
-				retval = 0;
-			}
-
-			if (new_options & WDIOS_ENABLECARD) {
-				asr_enable();
-				asr_toggle();
-				retval = 0;
-			}
-
-			return retval;
+			retval = 0;
 		}
+		return retval;
+	}
+	default:
+		return -ENOTTY;
 	}
-
-	return -ENOTTY;
 }
 
 static int asr_open(struct inode *inode, struct file *file)
 {
-	if(test_and_set_bit(0, &asr_is_open))
+	if (test_and_set_bit(0, &asr_is_open))
 		return -EBUSY;
 
 	asr_toggle();
@@ -314,7 +334,8 @@ static int asr_release(struct inode *ino
 	if (asr_expect_close == 42)
 		asr_disable();
 	else {
-		printk(KERN_CRIT PFX "unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+				"unexpected close, not stopping watchdog!\n");
 		asr_toggle();
 	}
 	clear_bit(0, &asr_is_open);
@@ -323,12 +344,12 @@ static int asr_release(struct inode *ino
 }
 
 static const struct file_operations asr_fops = {
-	.owner =	THIS_MODULE,
-	.llseek	=	no_llseek,
-	.write =	asr_write,
-	.ioctl =	asr_ioctl,
-	.open =		asr_open,
-	.release =	asr_release,
+	.owner =		THIS_MODULE,
+	.llseek	=		no_llseek,
+	.write =		asr_write,
+	.unlocked_ioctl =	asr_ioctl,
+	.open =			asr_open,
+	.release =		asr_release,
 };
 
 static struct miscdevice asr_miscdev = {
@@ -367,6 +388,8 @@ static int __init ibmasr_init(void)
 	if (!asr_type)
 		return -ENODEV;
 
+	spin_lock_init(&asr_lock);
+
 	rc = asr_get_base_address();
 	if (rc)
 		return rc;
@@ -395,7 +418,9 @@ module_init(ibmasr_init);
 module_exit(ibmasr_exit);
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 MODULE_DESCRIPTION("IBM Automatic Server Restart driver");
 MODULE_AUTHOR("Andrey Panin");
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

