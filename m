From: akpm@linux-foundation.org
Subject: + mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix.patch added to -mm tree
Date: Tue, 12 May 2009 10:55:01 -0700
Message-ID: <200905121755.n4CHt1eS013411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbZELR7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 13:59:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@gmail.com, mel@csn.ul.ie, pavel@ucw.cz, rientjes@google.com, rjw@sisk.pl


The patch titled
     mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix
has been added to the -mm tree.  Its filename is
     mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix
From: Andrew Morton <akpm@linux-foundation.org>

Be nicer to the namespace.

Cc: David Rientjes <rientjes@google.com>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    4 ++--
 kernel/power/process.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/gfp.h~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix
+++ a/include/linux/gfp.h
@@ -242,12 +242,12 @@ void drain_local_pages(void *dummy);
 
 extern bool oom_killer_disabled;
 
-static inline void disable_oom_killer(void)
+static inline void oom_killer_disable(void)
 {
 	oom_killer_disabled = true;
 }
 
-static inline void enable_oom_killer(void)
+static inline void oom_killer_enable(void)
 {
 	oom_killer_disabled = false;
 }
diff -puN kernel/power/process.c~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix kernel/power/process.c
--- a/kernel/power/process.c~mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix
+++ a/kernel/power/process.c
@@ -118,7 +118,7 @@ int freeze_processes(void)
 		goto Exit;
 	printk("done.");
 
-	disable_oom_killer();
+	oom_killer_disable();
  Exit:
 	BUG_ON(in_atomic());
 	printk("\n");
@@ -148,7 +148,7 @@ static void thaw_tasks(bool nosig_only)
 
 void thaw_processes(void)
 {
-	enable_oom_killer();
+	oom_killer_enable();
 
 	printk("Restarting tasks ... ");
 	thaw_tasks(true);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
alpha-unbreak-percpu-again.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-checkpatch-fixes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

