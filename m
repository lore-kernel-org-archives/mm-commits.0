From: akpm@linux-foundation.org
Subject: + bonding-replace-system-timer-with-work-queue-tidy.patch added to -mm tree
Date: Wed, 28 Feb 2007 23:35:28 -0800
Message-ID: <200703010735.l217ZSWC007657@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbXCAHfe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 02:35:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, oleg@tv-sign.ru, perex@suse.cz, shemminger@linux-foundation.org


The patch titled
     bonding-replace-system-timer-with-work-queue-tidy
has been added to the -mm tree.  Its filename is
     bonding-replace-system-timer-with-work-queue-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bonding-replace-system-timer-with-work-queue-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_3ad.c   |    7 +++++--
 drivers/net/bonding/bond_alb.c   |    7 +++++--
 drivers/net/bonding/bond_main.c  |   24 ++++++++++--------------
 drivers/net/bonding/bond_sysfs.c |   11 ++++++-----
 4 files changed, 26 insertions(+), 23 deletions(-)

diff -puN drivers/net/bonding/bond_3ad.c~bonding-replace-system-timer-with-work-queue-tidy drivers/net/bonding/bond_3ad.c
--- a/drivers/net/bonding/bond_3ad.c~bonding-replace-system-timer-with-work-queue-tidy
+++ a/drivers/net/bonding/bond_3ad.c
@@ -2099,11 +2099,14 @@ void bond_3ad_unbind_slave(struct slave 
  */
 void bond_3ad_state_machine_handler(struct work_struct *work)
 {
-	struct ad_bond_info *ad_info = container_of(work, struct ad_bond_info, ad_work.work);
-	struct bonding *bond = (struct bonding *)((char *)ad_info - offsetof(struct bonding, ad_info));
+	struct ad_bond_info *ad_info;
+	struct bonding *bond;
 	struct port *port;
 	struct aggregator *aggregator;
 
+	ad_info = container_of(work, struct ad_bond_info, ad_work.work);
+	bond = container_of(ad_info, struct bonding, ad_info);
+
 	read_lock(&bond->lock);
 
 	if (bond->kill_timers) {
diff -puN drivers/net/bonding/bond_alb.c~bonding-replace-system-timer-with-work-queue-tidy drivers/net/bonding/bond_alb.c
--- a/drivers/net/bonding/bond_alb.c~bonding-replace-system-timer-with-work-queue-tidy
+++ a/drivers/net/bonding/bond_alb.c
@@ -1367,11 +1367,14 @@ out:
 
 void bond_alb_monitor(struct work_struct *work)
 {
-	struct alb_bond_info *bond_info = container_of(work, struct alb_bond_info, alb_work.work);
-	struct bonding *bond = (struct bonding *)((char *)bond_info - offsetof(struct bonding, alb_info));
+	struct alb_bond_info *bond_info;
+	struct bonding *bond;
 	struct slave *slave;
 	int i;
 
+	bond_info = container_of(work, struct alb_bond_info, alb_work.work);
+	bond = container_of(bond_info, struct bonding, alb_info);
+
 	read_lock(&bond->lock);
 
 	if (bond->kill_timers) {
diff -puN drivers/net/bonding/bond_main.c~bonding-replace-system-timer-with-work-queue-tidy drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-replace-system-timer-with-work-queue-tidy
+++ a/drivers/net/bonding/bond_main.c
@@ -2246,9 +2246,8 @@ void bond_mii_monitor(struct work_struct
 		bond_set_carrier(bond);
 
 re_arm:
-	if (bond->params.miimon) {
+	if (bond->params.miimon)
 		queue_delayed_work(bond_wq, &bond->mii_work, delta_in_ticks);
-	}
 out:
 	read_unlock(&bond->lock);
 }
@@ -2658,9 +2657,8 @@ void bond_loadbalance_arp_mon(struct wor
 	}
 
 re_arm:
-	if (bond->params.arp_interval) {
+	if (bond->params.arp_interval)
 		queue_delayed_work(bond_wq, &bond->arp_work, delta_in_ticks);
-	}
 out:
 	read_unlock(&bond->lock);
 }
@@ -2907,9 +2905,8 @@ void bond_activebackup_arp_mon(struct wo
 	}
 
 re_arm:
-	if (bond->params.arp_interval) {
+	if (bond->params.arp_interval)
 		queue_delayed_work(bond_wq, &bond->arp_work, delta_in_ticks);
-	}
 out:
 	read_unlock(&bond->lock);
 }
@@ -3498,7 +3495,7 @@ static int bond_open(struct net_device *
 			return -1;
 		}
 
-		INIT_DELAYED_WORK(alb_work, (void *)&bond_alb_monitor);
+		INIT_DELAYED_WORK(alb_work, bond_alb_monitor);
 		queue_delayed_work(bond_wq, alb_work, 1);
 	}
 
@@ -3514,7 +3511,7 @@ static int bond_open(struct net_device *
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct delayed_work *ad_work = &(BOND_AD_INFO(bond).ad_work);
-		INIT_DELAYED_WORK(ad_work, (void *)&bond_3ad_state_machine_handler);
+		INIT_DELAYED_WORK(ad_work, bond_3ad_state_machine_handler);
 		queue_delayed_work(bond_wq, ad_work, 1);
 
 		/* register to receive LACPDUs */
@@ -4270,12 +4267,11 @@ static int bond_init(struct net_device *
 	rwlock_init(&bond->curr_slave_lock);
 
 	/* initialize work */
-	INIT_DELAYED_WORK(&bond->mii_work, (void *)&bond_mii_monitor);
-	if (params->mode == BOND_MODE_ACTIVEBACKUP) {
-	        INIT_DELAYED_WORK(&bond->arp_work, (void *)&bond_activebackup_arp_mon);
-	} else {
-		INIT_DELAYED_WORK(&bond->arp_work, (void *)&bond_loadbalance_arp_mon);
-	}
+	INIT_DELAYED_WORK(&bond->mii_work, bond_mii_monitor);
+	if (params->mode == BOND_MODE_ACTIVEBACKUP)
+	        INIT_DELAYED_WORK(&bond->arp_work, bond_activebackup_arp_mon);
+	else
+		INIT_DELAYED_WORK(&bond->arp_work, bond_loadbalance_arp_mon);
 
 	bond->params = *params; /* copy params struct */
 
diff -puN drivers/net/bonding/bond_sysfs.c~bonding-replace-system-timer-with-work-queue-tidy drivers/net/bonding/bond_sysfs.c
--- a/drivers/net/bonding/bond_sysfs.c~bonding-replace-system-timer-with-work-queue-tidy
+++ a/drivers/net/bonding/bond_sysfs.c
@@ -433,11 +433,12 @@ static ssize_t bonding_store_mode(struct
 		if (bond->params.mode == BOND_MODE_ALB)
 			bond_unset_master_alb_flags(bond);
 
-		if (new_value == BOND_MODE_ACTIVEBACKUP) {
-			INIT_DELAYED_WORK(&bond->arp_work, (void *)&bond_activebackup_arp_mon);
-		} else {
-			INIT_DELAYED_WORK(&bond->arp_work, (void *)&bond_loadbalance_arp_mon);
-		}
+		if (new_value == BOND_MODE_ACTIVEBACKUP)
+			INIT_DELAYED_WORK(&bond->arp_work,
+					bond_activebackup_arp_mon);
+		else
+			INIT_DELAYED_WORK(&bond->arp_work,
+					bond_loadbalance_arp_mon);
 
 		bond->params.mode = new_value;
 		bond_set_mode_ops(bond, bond->params.mode);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-hid-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
log-reason-why-tsc-was-marked-unstable-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
