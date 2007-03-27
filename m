From: akpm@linux-foundation.org
Subject: - bonding-replace-system-timer-with-work-queue-tidy.patch removed from -mm tree
Date: Mon, 26 Mar 2007 21:48:33 -0800
Message-ID: <200703270548.l2R5mXLh008331@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40185 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934029AbXC0FtO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 01:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ctindel@users.sourceforge.net, fubar@us.ibm.com, oleg@tv-sign.ru, perex@suse.cz, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     bonding-replace-system-timer-with-work-queue-tidy
has been removed from the -mm tree.  Its filename was
     bonding-replace-system-timer-with-work-queue-tidy.patch

This patch was dropped because it was folded into bonding-replace-system-timer-with-work-queue.patch

------------------------------------------------------
Subject: bonding-replace-system-timer-with-work-queue-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Chad Tindel <ctindel@users.sourceforge.net>
Cc: Jay Vosburgh <fubar@us.ibm.com>
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
@@ -2271,9 +2271,8 @@ void bond_mii_monitor(struct work_struct
 		bond_set_carrier(bond);
 
 re_arm:
-	if (bond->params.miimon) {
+	if (bond->params.miimon)
 		queue_delayed_work(bond_wq, &bond->mii_work, delta_in_ticks);
-	}
 out:
 	read_unlock(&bond->lock);
 }
@@ -2683,9 +2682,8 @@ void bond_loadbalance_arp_mon(struct wor
 	}
 
 re_arm:
-	if (bond->params.arp_interval) {
+	if (bond->params.arp_interval)
 		queue_delayed_work(bond_wq, &bond->arp_work, delta_in_ticks);
-	}
 out:
 	read_unlock(&bond->lock);
 }
@@ -2932,9 +2930,8 @@ void bond_activebackup_arp_mon(struct wo
 	}
 
 re_arm:
-	if (bond->params.arp_interval) {
+	if (bond->params.arp_interval)
 		queue_delayed_work(bond_wq, &bond->arp_work, delta_in_ticks);
-	}
 out:
 	read_unlock(&bond->lock);
 }
@@ -3529,7 +3526,7 @@ static int bond_open(struct net_device *
 			return -1;
 		}
 
-		INIT_DELAYED_WORK(alb_work, (void *)&bond_alb_monitor);
+		INIT_DELAYED_WORK(alb_work, bond_alb_monitor);
 		queue_delayed_work(bond_wq, alb_work, 1);
 	}
 
@@ -3545,7 +3542,7 @@ static int bond_open(struct net_device *
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		struct delayed_work *ad_work = &(BOND_AD_INFO(bond).ad_work);
-		INIT_DELAYED_WORK(ad_work, (void *)&bond_3ad_state_machine_handler);
+		INIT_DELAYED_WORK(ad_work, bond_3ad_state_machine_handler);
 		queue_delayed_work(bond_wq, ad_work, 1);
 
 		/* register to receive LACPDUs */
@@ -4250,12 +4247,11 @@ static int bond_init(struct net_device *
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

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-vs-gregkh-driver-driver-core-use-attribute-groups-in-struct-device_type.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
fix-gregkh-pci-pci-piggy-bus.patch
fix-gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
make-aout-executables-work-again-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
time-smp-friendly-alignment-of-struct-clocksource-fix.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
mm-only-hrtimers-debug-patch-fix.patch
