From: akpm@linux-foundation.org
Subject: + watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch added to -mm tree
Date: Thu, 01 May 2008 14:51:53 -0700
Message-ID: <200805012151.m41LproM027180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763486AbYEAVwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 17:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, g.chen@freescale.com, wim@iguana.be


The patch titled
     watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix
has been added to the -mm tree.  Its filename is
     watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch

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
Subject: watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Chen Gong <g.chen@freescale.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/booke_wdt.c |   77 +++++++++++----------------------
 1 file changed, 27 insertions(+), 50 deletions(-)

diff -puN drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix drivers/watchdog/booke_wdt.c
--- a/drivers/watchdog/booke_wdt.c~watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix
+++ a/drivers/watchdog/booke_wdt.c
@@ -1,6 +1,4 @@
 /*
- * drivers/watchdog/booke_wdt.c
- *
  * Watchdog timer for PowerPC Book-E systems
  *
  * Author: Matthew McClintock
@@ -39,7 +37,7 @@
 #define WDT_PERIOD_DEFAULT 3	/* Refer to the PPC40x and PPC4xx manuals */
 #endif				/* for timing information */
 
-u32 booke_wdt_enabled = 0;
+u32 booke_wdt_enabled;
 u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 
 #ifdef	CONFIG_FSL_BOOKE
@@ -55,19 +53,12 @@ static void __booke_wdt_ping(void *data)
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
 }
 
-/*
- * booke_wdt_ping:
- */
-static __inline__ void booke_wdt_ping(void)
+static void booke_wdt_ping(void)
 {
-	smp_call_function(__booke_wdt_ping, NULL, 0, 0);
-	__booke_wdt_ping(NULL);
+	on_each_cpu(__booke_wdt_ping, NULL, 0, 0);
 }
 
-/*
- * __booke_wdt_enable:
- */
-static inline void __booke_wdt_enable(void *data)
+static void __booke_wdt_enable(void *data)
 {
 	u32 val;
 
@@ -79,10 +70,7 @@ static inline void __booke_wdt_enable(vo
 	mtspr(SPRN_TCR, val);
 }
 
-/*
- * booke_wdt_write:
- */
-static ssize_t booke_wdt_write (struct file *file, const char __user *buf,
+static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	booke_wdt_ping();
@@ -90,15 +78,11 @@ static ssize_t booke_wdt_write (struct f
 }
 
 static struct watchdog_info ident = {
-  .options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-  .firmware_version = 0,
-  .identity = "PowerPC Book-E Watchdog",
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "PowerPC Book-E Watchdog",
 };
 
-/*
- * booke_wdt_ioctl:
- */
-static int booke_wdt_ioctl (struct inode *inode, struct file *file,
+static int booke_wdt_ioctl(struct inode *inode, struct file *file,
 			    unsigned int cmd, unsigned long arg)
 {
 	u32 tmp = 0;
@@ -106,7 +90,7 @@ static int booke_wdt_ioctl (struct inode
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user ((struct watchdog_info __user *) arg, &ident,
+		if (copy_to_user((struct watchdog_info __user *)arg, &ident,
 				sizeof(struct watchdog_info)))
 			return -EFAULT;
 	case WDIOC_GETSTATUS:
@@ -141,18 +125,15 @@ static int booke_wdt_ioctl (struct inode
 
 	return 0;
 }
-/*
- * booke_wdt_open:
- */
-static int booke_wdt_open (struct inode *inode, struct file *file)
+
+static int booke_wdt_open(struct inode *inode, struct file *file)
 {
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
-		__booke_wdt_enable(NULL);
-		smp_call_function(__booke_wdt_enable, NULL, 0, 0);
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
+		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
+		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+				"(wdt_period=%d)\n", booke_wdt_period);
 	}
 	spin_unlock(&booke_wdt_lock);
 
@@ -160,17 +141,17 @@ static int booke_wdt_open (struct inode 
 }
 
 static const struct file_operations booke_wdt_fops = {
-  .owner = THIS_MODULE,
-  .llseek = no_llseek,
-  .write = booke_wdt_write,
-  .ioctl = booke_wdt_ioctl,
-  .open = booke_wdt_open,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = booke_wdt_write,
+	.ioctl = booke_wdt_ioctl,
+	.open = booke_wdt_open,
 };
 
 static struct miscdevice booke_wdt_miscdev = {
-  .minor = WATCHDOG_MINOR,
-  .name = "watchdog",
-  .fops = &booke_wdt_fops,
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &booke_wdt_fops,
 };
 
 static void __exit booke_wdt_exit(void)
@@ -178,29 +159,25 @@ static void __exit booke_wdt_exit(void)
 	misc_deregister(&booke_wdt_miscdev);
 }
 
-/*
- * booke_wdt_init:
- */
 static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	printk (KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
+	printk(KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
-		printk (KERN_CRIT "Cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_CRIT "Cannot register miscdev on minor=%d: %d\n",
 				WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
-		__booke_wdt_enable(NULL);
-		smp_call_function(__booke_wdt_enable, NULL, 0, 0);
+		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+				"(wdt_period=%d)\n", booke_wdt_period);
+		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
 	}
 	spin_unlock(&booke_wdt_lock);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pnp-fix-printk-format-warnings.patch
drivers-char-synclinkc-inbreak-mgsl_put_char.patch
drivers-char-synclinkc-inbreak-mgsl_put_char-fix.patch
drivers-scsi-ncr53c8xxc-fix-warning.patch
drivers-scsi-mvsasc-fix-printk-warnings.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

