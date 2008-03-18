From: akpm@linux-foundation.org
Subject: + revert-clocksource-make-clocksource-watchdog-cycle-through-online-cpus.patch added to -mm tree
Date: Tue, 18 Mar 2008 13:30:58 -0700
Message-ID: <200803182030.m2IKUwd2014887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758058AbYCSTnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, hancockr@shaw.ca, mingo@elte.hu, nix.or.die@googlemail.com, rjw@sisk.pl, tglx@linutronix.de, torvalds@linux-foundation.org


The patch titled
     revert "clocksource: make clocksource watchdog cycle through online CPUs"
has been added to the -mm tree.  Its filename is
     revert-clocksource-make-clocksource-watchdog-cycle-through-online-cpus.patch

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
Subject: revert "clocksource: make clocksource watchdog cycle through online CPUs"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 1ada5cba6a0318f90e45b38557e7b5206a9cba38
Author: Andi Kleen <ak@suse.de>
Date:   Wed Jan 30 13:30:02 2008 +0100

    clocksource: make clocksource watchdog cycle through online CPUs
    
    This way it checks if the clocks are synchronized between CPUs too.
    This might be able to detect slowly drifting TSCs which only
    go wrong over longer time.
    
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Due to the regression reported by Gabriel C at
http://lkml.org/lkml/2008/2/24/281

Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gabriel C <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN kernel/time/clocksource.c~revert-clocksource-make-clocksource-watchdog-cycle-through-online-cpus kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~revert-clocksource-make-clocksource-watchdog-cycle-through-online-cpus
+++ a/kernel/time/clocksource.c
@@ -141,13 +141,8 @@ static void clocksource_watchdog(unsigne
 	}
 
 	if (!list_empty(&watchdog_list)) {
-		/* Cycle through CPUs to check if the CPUs stay synchronized to
-		 * each other. */
-		int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
-		if (next_cpu >= NR_CPUS)
-			next_cpu = first_cpu(cpu_online_map);
-		watchdog_timer.expires += WATCHDOG_INTERVAL;
-		add_timer_on(&watchdog_timer, next_cpu);
+		__mod_timer(&watchdog_timer,
+			    watchdog_timer.expires + WATCHDOG_INTERVAL);
 	}
 	spin_unlock(&watchdog_lock);
 }
@@ -169,7 +164,7 @@ static void clocksource_check_watchdog(s
 		if (!started && watchdog) {
 			watchdog_last = watchdog->read();
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
-			add_timer_on(&watchdog_timer, first_cpu(cpu_online_map));
+			add_timer(&watchdog_timer);
 		}
 	} else {
 		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
@@ -190,8 +185,7 @@ static void clocksource_check_watchdog(s
 				watchdog_last = watchdog->read();
 				watchdog_timer.expires =
 					jiffies + WATCHDOG_INTERVAL;
-				add_timer_on(&watchdog_timer,
-						first_cpu(cpu_online_map));
+				add_timer(&watchdog_timer);
 			}
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zisofs-fix-readpage-outside-i_size-fix.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
cifs-suppress-warning.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
arch-ia64-kernel-use-time_-macros-checkpatch-fixes.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
git-input.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
git-mips-git-rejects.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch
drivers-net-arcnet-arcnetc-use-time_-macros-checkpatch-fixes.patch
drivers-net-tokenring-3c359c-use-time_-macros-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros-checkpatch-fixes.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-sched-make-sure-jiffies-is-up-to-date-before-calling-__update_rq_clock.patch
git-sh.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
x86-fix-aperture-vs-suspend-problem.patch
revert-pcie-utilize-pcie-transaction-pending-bit.patch
revert-clocksource-make-clocksource-watchdog-cycle-through-online-cpus.patch
netpoll-zap_completion_queue-adjust-skb-users-counter.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

