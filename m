From: akpm@osdl.org
Subject: - paride-remove-parport-ifdefs.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:43 -0800
Message-ID: <200612072316.kB7NGhPO030860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54162 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163986AbWLGXUD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:20:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     paride: remove parport #ifdef's
has been removed from the -mm tree.  Its filename was
     paride-remove-parport-ifdefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paride: remove parport #ifdef's
From: Adrian Bunk <bunk@stusta.de>

CONFIG_PARIDE depends on CONFIG_PARPORT_PC, so there's no reason for
these #ifdef's.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/paride/bpck6.c  |   13 ------------
 drivers/block/paride/paride.c |   33 --------------------------------
 2 files changed, 46 deletions(-)

diff -puN drivers/block/paride/bpck6.c~paride-remove-parport-ifdefs drivers/block/paride/bpck6.c
--- a/drivers/block/paride/bpck6.c~paride-remove-parport-ifdefs
+++ a/drivers/block/paride/bpck6.c
@@ -31,10 +31,7 @@ static int verbose; /* set this to 1 to 
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <asm/io.h>
-
-#if defined(CONFIG_PARPORT_MODULE)||defined(CONFIG_PARPORT)
 #include <linux/parport.h>
-#endif
 
 #include "ppc6lnx.c"
 #include "paride.h"
@@ -139,11 +136,6 @@ static int bpck6_test_port ( PIA *pi )  
 	PPCSTRUCT(pi)->ppc_id=pi->unit;
 	PPCSTRUCT(pi)->lpt_addr=pi->port;
 
-#ifdef CONFIG_PARPORT_PC_MODULE
-#define CONFIG_PARPORT_PC
-#endif
-
-#ifdef CONFIG_PARPORT_PC
 	/* look at the parport device to see if what modes we can use */
 	if(((struct pardevice *)(pi->pardev))->port->modes & 
 		(PARPORT_MODE_EPP)
@@ -161,11 +153,6 @@ static int bpck6_test_port ( PIA *pi )  
 	{
 		return 1;
 	}
-#else
-	/* there is no way of knowing what kind of port we have
-	   default to the highest mode possible */
-	return 5;
-#endif
 }
 
 static int bpck6_probe_unit ( PIA *pi )
diff -puN drivers/block/paride/paride.c~paride-remove-parport-ifdefs drivers/block/paride/paride.c
--- a/drivers/block/paride/paride.c~paride-remove-parport-ifdefs
+++ a/drivers/block/paride/paride.c
@@ -29,14 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <linux/sched.h>	/* TASK_* */
-
-#ifdef CONFIG_PARPORT_MODULE
-#define CONFIG_PARPORT
-#endif
-
-#ifdef CONFIG_PARPORT
 #include <linux/parport.h>
-#endif
 
 #include "paride.h"
 
@@ -76,8 +69,6 @@ void pi_read_block(PIA * pi, char *buf, 
 
 EXPORT_SYMBOL(pi_read_block);
 
-#ifdef CONFIG_PARPORT
-
 static void pi_wake_up(void *p)
 {
 	PIA *pi = (PIA *) p;
@@ -100,11 +91,8 @@ static void pi_wake_up(void *p)
 		cont();
 }
 
-#endif
-
 int pi_schedule_claimed(PIA * pi, void (*cont) (void))
 {
-#ifdef CONFIG_PARPORT
 	unsigned long flags;
 
 	spin_lock_irqsave(&pi_spinlock, flags);
@@ -115,7 +103,6 @@ int pi_schedule_claimed(PIA * pi, void (
 	}
 	pi->claimed = 1;
 	spin_unlock_irqrestore(&pi_spinlock, flags);
-#endif
 	return 1;
 }
 EXPORT_SYMBOL(pi_schedule_claimed);
@@ -133,20 +120,16 @@ static void pi_claim(PIA * pi)
 	if (pi->claimed)
 		return;
 	pi->claimed = 1;
-#ifdef CONFIG_PARPORT
 	if (pi->pardev)
 		wait_event(pi->parq,
 			   !parport_claim((struct pardevice *) pi->pardev));
-#endif
 }
 
 static void pi_unclaim(PIA * pi)
 {
 	pi->claimed = 0;
-#ifdef CONFIG_PARPORT
 	if (pi->pardev)
 		parport_release((struct pardevice *) (pi->pardev));
-#endif
 }
 
 void pi_connect(PIA * pi)
@@ -167,21 +150,15 @@ EXPORT_SYMBOL(pi_disconnect);
 
 static void pi_unregister_parport(PIA * pi)
 {
-#ifdef CONFIG_PARPORT
 	if (pi->pardev) {
 		parport_unregister_device((struct pardevice *) (pi->pardev));
 		pi->pardev = NULL;
 	}
-#endif
 }
 
 void pi_release(PIA * pi)
 {
 	pi_unregister_parport(pi);
-#ifndef CONFIG_PARPORT
-	if (pi->reserved)
-		release_region(pi->port, pi->reserved);
-#endif				/* !CONFIG_PARPORT */
 	if (pi->proto->release_proto)
 		pi->proto->release_proto(pi);
 	module_put(pi->proto->owner);
@@ -269,8 +246,6 @@ EXPORT_SYMBOL(paride_unregister);
 
 static int pi_register_parport(PIA * pi, int verbose)
 {
-#ifdef CONFIG_PARPORT
-
 	struct parport *port;
 
 	port = parport_find_base(pi->port);
@@ -290,7 +265,6 @@ static int pi_register_parport(PIA * pi,
 		printk("%s: 0x%x is %s\n", pi->device, pi->port, port->name);
 
 	pi->parname = (char *) port->name;
-#endif
 
 	return 1;
 }
@@ -447,13 +421,6 @@ int pi_init(PIA * pi, int autoprobe, int
 			printk("%s: Adapter not found\n", device);
 		return 0;
 	}
-#ifndef CONFIG_PARPORT
-	if (!request_region(pi->port, pi->reserved, pi->device)) {
-		printk(KERN_WARNING "paride: Unable to request region 0x%x\n",
-		       pi->port);
-		return 0;
-	}
-#endif				/* !CONFIG_PARPORT */
 
 	if (pi->parname)
 		printk("%s: Sharing %s at 0x%x\n", pi->device,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

