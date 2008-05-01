From: akpm@linux-foundation.org
Subject: - drivers-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:48 -0700
Message-ID: <200805010932.m419Wm5B031013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758108AbYEAJda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     drivers: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     drivers-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c         |    4 ++--
 drivers/hwmon/ads7828.c        |    2 +-
 drivers/mfd/asic3.c            |    6 +++---
 drivers/mfd/sm501.c            |    4 ++--
 drivers/parport/parport_gsc.c  |    4 ++--
 drivers/parport/parport_pc.c   |    8 ++++----
 drivers/sbus/char/cpwatchdog.c |    2 +-
 drivers/sbus/char/uctrl.c      |    4 ++--
 drivers/w1/w1_log.h            |    2 +-
 9 files changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/gpio/gpiolib.c~drivers-replace-remaining-__function__-occurrences drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/gpio/gpiolib.c
@@ -382,7 +382,7 @@ fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	if (status)
 		pr_debug("%s: gpio-%d status %d\n",
-			__FUNCTION__, gpio, status);
+			__func__, gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_input);
@@ -420,7 +420,7 @@ fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	if (status)
 		pr_debug("%s: gpio-%d status %d\n",
-			__FUNCTION__, gpio, status);
+			__func__, gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output);
diff -puN drivers/hwmon/ads7828.c~drivers-replace-remaining-__function__-occurrences drivers/hwmon/ads7828.c
--- a/drivers/hwmon/ads7828.c~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/hwmon/ads7828.c
@@ -224,7 +224,7 @@ static int ads7828_detect(struct i2c_ada
 			if (in_data & 0xF000) {
 				printk(KERN_DEBUG
 				"%s : Doesn't look like an ads7828 device\n",
-				__FUNCTION__);
+				__func__);
 				goto exit_free;
 			}
 		}
diff -puN drivers/mfd/asic3.c~drivers-replace-remaining-__function__-occurrences drivers/mfd/asic3.c
--- a/drivers/mfd/asic3.c~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/mfd/asic3.c
@@ -132,7 +132,7 @@ static void asic3_irq_demux(unsigned int
 
 	if (iter >= MAX_ASIC_ISR_LOOPS)
 		printk(KERN_ERR "%s: interrupt processing overrun\n",
-		       __FUNCTION__);
+		       __func__);
 }
 
 static inline int asic3_irq_to_bank(struct asic3 *asic, int irq)
@@ -409,7 +409,7 @@ int asic3_gpio_get_value(struct asic3 *a
 		return asic3_get_gpio_d(asic, Status) & mask;
 	default:
 		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
-		       __FUNCTION__, gpio);
+		       __func__, gpio);
 		return -EINVAL;
 	}
 }
@@ -437,7 +437,7 @@ void asic3_gpio_set_value(struct asic3 *
 		return;
 	default:
 		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
-		       __FUNCTION__, gpio);
+		       __func__, gpio);
 		return;
 	}
 }
diff -puN drivers/mfd/sm501.c~drivers-replace-remaining-__function__-occurrences drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/mfd/sm501.c
@@ -349,11 +349,11 @@ int sm501_unit_power(struct device *dev,
 	mode &= 3;		/* get current power mode */
 
 	if (unit >= ARRAY_SIZE(sm->unit_power)) {
-		dev_err(dev, "%s: bad unit %d\n", __FUNCTION__, unit);
+		dev_err(dev, "%s: bad unit %d\n", __func__, unit);
 		goto already;
 	}
 
-	dev_dbg(sm->dev, "%s: unit %d, cur %d, to %d\n", __FUNCTION__, unit,
+	dev_dbg(sm->dev, "%s: unit %d, cur %d, to %d\n", __func__, unit,
 		sm->unit_power[unit], to);
 
 	if (to == 0 && sm->unit_power[unit] == 0) {
diff -puN drivers/parport/parport_gsc.c~drivers-replace-remaining-__function__-occurrences drivers/parport/parport_gsc.c
--- a/drivers/parport/parport_gsc.c~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/parport/parport_gsc.c
@@ -365,11 +365,11 @@ static int __devinit parport_init_chip(s
 	if (boot_cpu_data.cpu_type > pcxt && !pdc_add_valid(port+4)) {
 
 		/* Initialize bidirectional-mode (0x10) & data-tranfer-mode #1 (0x20) */
-		printk("%s: initialize bidirectional-mode.\n", __FUNCTION__);
+		printk("%s: initialize bidirectional-mode.\n", __func__);
 		parport_writeb ( (0x10 + 0x20), port + 4);
 
 	} else {
-		printk("%s: enhanced parport-modes not supported.\n", __FUNCTION__);
+		printk("%s: enhanced parport-modes not supported.\n", __func__);
 	}
 	
 	p = parport_gsc_probe_port(port, 0, dev->irq,
diff -puN drivers/parport/parport_pc.c~drivers-replace-remaining-__function__-occurrences drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/parport/parport_pc.c
@@ -1415,7 +1415,7 @@ static void __devinit winbond_check(int 
 {
 	int devid,devrev,oldid,x_devid,x_devrev,x_oldid;
 
-	if (!request_region(io, 3, __FUNCTION__))
+	if (!request_region(io, 3, __func__))
 		return;
 
 	/* First probe without key */
@@ -1449,7 +1449,7 @@ static void __devinit winbond_check2(int
 {
         int devid,devrev,oldid,x_devid,x_devrev,x_oldid;
 
-	if (!request_region(io, 3, __FUNCTION__))
+	if (!request_region(io, 3, __func__))
 		return;
 
 	/* First probe without the key */
@@ -1482,7 +1482,7 @@ static void __devinit smsc_check(int io,
 {
         int id,rev,oldid,oldrev,x_id,x_rev,x_oldid,x_oldrev;
 
-	if (!request_region(io, 3, __FUNCTION__))
+	if (!request_region(io, 3, __func__))
 		return;
 
 	/* First probe without the key */
@@ -1547,7 +1547,7 @@ static void __devinit detect_and_report_
 	u8 r;
 	if (verbose_probing)
 		printk(KERN_DEBUG "IT8705 Super-IO detection, now testing port 2E ...\n");
-	if (!request_region(0x2e, 1, __FUNCTION__))
+	if (!request_region(0x2e, 1, __func__))
 		return;
 	outb(0x87, 0x2e);
 	outb(0x01, 0x2e);
diff -puN drivers/sbus/char/cpwatchdog.c~drivers-replace-remaining-__function__-occurrences drivers/sbus/char/cpwatchdog.c
--- a/drivers/sbus/char/cpwatchdog.c~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/sbus/char/cpwatchdog.c
@@ -637,7 +637,7 @@ static int wd_inittimer(int whichdog)
 			break;
 		default:
 			printk("%s: %s: invalid watchdog id: %i\n",
-				WD_OBPNAME, __FUNCTION__, whichdog);
+				WD_OBPNAME, __func__, whichdog);
 			return(1);
 	}
 	if(0 != misc_register(whichmisc))
diff -puN drivers/sbus/char/uctrl.c~drivers-replace-remaining-__function__-occurrences drivers/sbus/char/uctrl.c
--- a/drivers/sbus/char/uctrl.c~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/sbus/char/uctrl.c
@@ -393,13 +393,13 @@ static int __init ts102_uctrl_init(void)
 	err = request_irq(driver->irq, uctrl_interrupt, 0, "uctrl", driver);
 	if (err) {
 		printk("%s: unable to register irq %d\n",
-		       __FUNCTION__, driver->irq);
+		       __func__, driver->irq);
 		return err;
 	}
 
 	if (misc_register(&uctrl_dev)) {
 		printk("%s: unable to get misc minor %d\n",
-		       __FUNCTION__, uctrl_dev.minor);
+		       __func__, uctrl_dev.minor);
 		free_irq(driver->irq, driver);
 		return -ENODEV;
 	}
diff -puN drivers/w1/w1_log.h~drivers-replace-remaining-__function__-occurrences drivers/w1/w1_log.h
--- a/drivers/w1/w1_log.h~drivers-replace-remaining-__function__-occurrences
+++ a/drivers/w1/w1_log.h
@@ -30,7 +30,7 @@
 #  define assert(expr) \
         if(unlikely(!(expr))) {				        \
         printk(KERN_ERR "Assertion failed! %s,%s,%s,line=%d\n",	\
-        #expr,__FILE__,__FUNCTION__,__LINE__);		        \
+	#expr, __FILE__, __func__, __LINE__);		        \
         }
 #endif
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

