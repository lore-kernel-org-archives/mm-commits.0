From: akpm@linux-foundation.org
Subject: + display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:48:24 -0700
Message-ID: <200704020548.l325mOsa025353@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36599 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319AbXDBFty (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:49:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jengelh@gmx.de, linux@treblig.org


The patch titled
     display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix
has been added to the -mm tree.  Its filename is
     display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dave Gilbert <linux@treblig.org>
Cc: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN block/genhd.c~display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix block/genhd.c
--- a/block/genhd.c~display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix
+++ a/block/genhd.c
@@ -216,14 +216,15 @@ struct gendisk *get_gendisk(dev_t dev, i
 }
 
 /*
- * printk a full list of all partitions - intended for
- * places where the root filesystem can't be mounted and thus
- * to give the victim some idea of what went wrong
+ * print a full list of all partitions - intended for places where the root
+ * filesystem can't be mounted and thus to give the victim some idea of what
+ * went wrong.
  */
-void printk_all_partitions(void)
+void __init printk_all_partitions(void)
 {
 	int n;
-        struct gendisk* sgp;
+	struct gendisk* sgp;
+
 	mutex_lock(&block_subsys_lock);
 
         /* For each block device... */
@@ -233,7 +234,7 @@ void printk_all_partitions(void)
 	  	 * Don't show empty devices or things that have been surpressed
 	  	 */
 		if (get_capacity(sgp) &&
-		  !(sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)) {
+		    !(sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)) {
 			/*
 			 * Note, unlike /proc/partitions I am showing the
 			 * numbers in hex in the same format as the root=
@@ -244,7 +245,7 @@ void printk_all_partitions(void)
 			       (unsigned long long)get_capacity(sgp) >> 1,
 			       disk_name(sgp, 0, buf));
 			if ((sgp->driverfs_dev) &&
-			  (sgp->driverfs_dev->driver)) {
+			    (sgp->driverfs_dev->driver)) {
 				printk(" driver: %s\n",
 				       sgp->driverfs_dev->driver->name);
 			} else {
@@ -252,15 +253,16 @@ void printk_all_partitions(void)
 			}
 
 			/* now show the partitions */
-			for (n = 0; n < sgp->minors - 1; ++n) {
+			for (n = 0; n < sgp->minors - 1; n++) {
 				if (!sgp->part[n])
 					continue;
 				if (sgp->part[n]->nr_sects == 0)
 					continue;
 				printk("  %02x%02x %10llu %s\n",
-				       sgp->major, n + 1 + sgp->first_minor,
-				       (unsigned long long)sgp->part[n]->nr_sects >> 1 ,
-				       disk_name(sgp, n + 1, buf));
+					sgp->major, n + 1 + sgp->first_minor,
+					(unsigned long long)
+						sgp->part[n]->nr_sects >> 1 ,
+					disk_name(sgp, n + 1, buf));
 			} /* partition subloop */
 		} /* Non 0 size, not surpressed */
 	} /* Block device loop */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n.patch
revert-retries-in-ext3_prepare_write-violate-ordering-requirements.patch
revert-retries-in-ext4_prepare_write-violate-ordering-requirements.patch
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
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-piggy-bus.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
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
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
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
utrace-x86_64-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-anonymous-inode-source-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
