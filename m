From: akpm@osdl.org
Subject: - slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch removed from -mm tree
Date: Tue, 12 Dec 2006 23:13:20 -0800
Message-ID: <200612130713.kBD7DLfQ031089@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59098 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbWLMHNd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 02:13:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, clameter@sgi.com, dada1@cosmosbay.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks
has been removed from the -mm tree.  Its filename was
     slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch

This patch was dropped because it was folded into slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch

------------------------------------------------------
Subject: slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks
From: Andrew Morton <akpm@osdl.org>

Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/reciprocal_div.h |    2 ++
 lib/reciprocal_div.c           |    1 -
 mm/slab.c                      |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/reciprocal_div.h~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks include/linux/reciprocal_div.h
--- a/include/linux/reciprocal_div.h~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks
+++ a/include/linux/reciprocal_div.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_RECIPROCAL_DIV_H
 #define _LINUX_RECIPROCAL_DIV_H
 
+#include <linux/types.h>
+
 /*
  * This file describes reciprocical division.
  *
diff -puN lib/reciprocal_div.c~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks lib/reciprocal_div.c
--- a/lib/reciprocal_div.c~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks
+++ a/lib/reciprocal_div.c
@@ -1,4 +1,3 @@
-#include <linux/types.h>
 #include <asm/div64.h>
 #include <linux/reciprocal_div.h>
 
diff -puN mm/slab.c~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks mm/slab.c
--- a/mm/slab.c~slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks
+++ a/mm/slab.c
@@ -638,7 +638,7 @@ static inline void *index_to_obj(struct 
 static inline unsigned int obj_to_index(const struct kmem_cache *cache,
 					const struct slab *slab, void *obj)
 {
-	unsigned int offset = (obj - slab->s_mem);
+	u32 offset = (obj - slab->s_mem);
 	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
 }
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
ecryptfs-public-key-packet-management-slab-fix.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
lockdep-fix-possible-races-while-disabling-lock-debugging-fix.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

