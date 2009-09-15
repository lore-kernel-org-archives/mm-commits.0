From: akpm@linux-foundation.org
Subject: [folded] cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-fix.patch removed from -mm tree
Date: Mon, 14 Sep 2009 18:38:38 -0700
Message-ID: <200909150138.n8F1cckE014679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757450AbZIOBj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Sep 2009 21:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, arjan@linux.intel.com, lenb@kernel.org, mingo@elte.hu, venkatesh.pallipadi@intel.com, yanmin_zhang@linux.intel.com, mm-commits@vger.


The patch titled
     cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-fix
has been removed from the -mm tree.  Its filename was
     cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-fix.patch

This patch was dropped because it was folded into cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix spellos

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu-tng.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/cpuidle/governors/menu-tng.c~cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-fix drivers/cpuidle/governors/menu-tng.c
--- a/drivers/cpuidle/governors/menu-tng.c~cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-fix
+++ a/drivers/cpuidle/governors/menu-tng.c
@@ -32,7 +32,7 @@
  *
  * For the menu-tng governor, there are 3 decision factors for picking a C
  * state:
- * 1) Energie break even point
+ * 1) Energy break even point
  * 2) Performance impact
  * 3) Latency tolerance (from pmqos infrastructure)
  * These these three factors are treated independently.
@@ -55,12 +55,12 @@
  * menu-tng uses a running average for this correction factor, however it uses a
  * set of factors, not just a single factor. This stems from the realization
  * that the ratio is dependent on the order of magnitude of the expected
- * duration; if we expect 500 milliseconds of idle time the likelyhood of
+ * duration; if we expect 500 milliseconds of idle time the likelihood of
  * getting an interrupt very early is much higher than if we expect 50 micro
  * seconds of idle time. A second independent factor that has big impact on
  * the actual factor is if there is (disk) IO outstanding or not.
  * (as a special twist, we consider every sleep longer than 50 milliseconds
- * as perfect; there is no power gains for sleeping longer than this)
+ * as perfect; there are no power gains for sleeping longer than this)
  *
  * For these two reasons we keep an array of 12 independent factors, that gets
  * indexed based on the magnitude of the expected duration as well as the
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
hwmon-driver-for-acpi-40-power-meters-fix.patch
hwmon-driver-for-acpi-40-power-meters-fix-2.patch
cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance.patch
cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-fix.patch
cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-percpu-workaround.patch
video-initial-support-for-adv7180-update-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
drivers-net-r8169c-remove-unused-label.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
st-fix-test-of-value-range-in-st_set_options-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency-fix.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

