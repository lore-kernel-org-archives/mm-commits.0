From: akpm@linux-foundation.org
Subject: + drivers-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 19:50:22 -0800
Message-ID: <200803060350.m263oMjf007353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723AbYCFDvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 22:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, ben-linux@fluff.org


The patch titled
     drivers: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     drivers-replace-remaining-__function__-occurrences.patch

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
@@ -300,7 +300,7 @@ fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	if (status)
 		pr_debug("%s: gpio-%d status %d\n",
-			__FUNCTION__, gpio, status);
+			__func__, gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_input);
@@ -338,7 +338,7 @@ fail:
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

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
cifs-replace-remaining-__function__-occurrences.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
drivers-base-replace-remaining-__function__-occurrences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
infiniband-replace-remaining-__function__-occurrences.patch
input-replace-remaining-__function__-occurrences.patch
jfs-replace-__inline-with-inline.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
mips-replace-__inline-with-inline.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
net-replace-__inline-with-inline.patch
irda-replace-__inline-with-inline.patch
blackfin-replace-remaining-__function__-occurences.patch
nfs-replace-remaining-__function__-occurrences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
sh-replace-remaining-__function__-occurences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
isdn-replace-__inline-with-inline.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
ext2-replace-remaining-__function__-occurrences.patch
jbd-sparse-warnings-in-revokec-journalc.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch
acpi-replace-remaining-__function__-occurrences.patch
ata-replace-remaining-__function__-occurrences.patch
block-replace-remaining-__function__-occurrences.patch
iop-admac-replace-remaining-__function__-occurrences.patch
ieee1394-replace-remaining-__function__-occurrences.patch
firmware-replace-remaining-__function__-occurrences.patch
mtd-replace-remaining-__function__-occurrences.patch
md-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
ioc3c-replace-remaining-__function__-occurrences.patch
watchdog-replace-remaining-__function__-occurrences.patch
spi-replace-remaining-__function__-occurrences.patch
power-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

