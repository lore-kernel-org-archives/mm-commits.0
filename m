From: akpm@linux-foundation.org
Subject: + fs-sysfs-filec-use-create_singlethread_workqueue.patch added to -mm tree
Date: Thu, 07 May 2009 12:36:53 -0700
Message-ID: <200905071936.n47JarES000883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbZEGTkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, achiang@hp.com, gregkh@suse.de, laijs@cn.fujitsu.com


The patch titled
     fs/sysfs/file.c: use create_singlethread_workqueue()
has been added to the -mm tree.  Its filename is
     fs-sysfs-filec-use-create_singlethread_workqueue.patch

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
Subject: fs/sysfs/file.c: use create_singlethread_workqueue()
From: Andrew Morton <akpm@linux-foundation.org>

We don't need a kernel thread per CPU for this application.

Cc: Alex Chiang <achiang@hp.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysfs/file.c~fs-sysfs-filec-use-create_singlethread_workqueue fs/sysfs/file.c
--- a/fs/sysfs/file.c~fs-sysfs-filec-use-create_singlethread_workqueue
+++ a/fs/sysfs/file.c
@@ -723,7 +723,7 @@ int sysfs_schedule_callback(struct kobje
 	mutex_unlock(&sysfs_workq_mutex);
 
 	if (sysfs_workqueue == NULL) {
-		sysfs_workqueue = create_workqueue("sysfsd");
+		sysfs_workqueue = create_singlethread_workqueue("sysfsd");
 		if (sysfs_workqueue == NULL) {
 			module_put(owner);
 			return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
fs-sysfs-filec-use-create_singlethread_workqueue.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
mtd-fix-timeout-in-m25p80-driver-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
mm-madvisec-dont-open-code-is_vm_hugetlb_page.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
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

