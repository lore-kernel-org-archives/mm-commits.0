From: akpm@linux-foundation.org
Subject: + fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:10:43 -0700
Message-ID: <200704110610.l3B6AhIs029972@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbXDKGKw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, nate.diller@gmail.com


The patch titled
     fs-convert-core-functions-to-zero_user_page-pass-kmap-type
has been added to the -mm tree.  Its filename is
     fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs-convert-core-functions-to-zero_user_page-pass-kmap-type
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c    |    2 +-
 fs/buffer.c             |   21 ++++++++++++---------
 fs/direct-io.c          |    2 +-
 fs/mpage.c              |    6 ++++--
 include/linux/highmem.h |   29 +++++++++++++++++------------
 mm/filemap_xip.c        |    2 +-
 6 files changed, 36 insertions(+), 26 deletions(-)

diff -puN drivers/block/loop.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type drivers/block/loop.c
--- a/drivers/block/loop.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/drivers/block/loop.c
@@ -250,7 +250,7 @@ static int do_lo_send_aops(struct loop_d
 			 */
 			printk(KERN_ERR "loop: transfer error block %llu\n",
 			       (unsigned long long)index);
-			zero_user_page(page, offset, size);
+			zero_user_page(page, offset, size, KM_USER0);
 		}
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset,
diff -puN fs/buffer.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/buffer.c
--- a/fs/buffer.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/buffer.c
@@ -1855,7 +1855,7 @@ static int __block_prepare_write(struct 
 			break;
 		if (buffer_new(bh)) {
 			clear_buffer_new(bh);
-			zero_user_page(page, block_start, bh->b_size);
+			zero_user_page(page, block_start, bh->b_size, KM_USER0);
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
@@ -1943,7 +1943,8 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				zero_user_page(page, i * blocksize, blocksize);
+				zero_user_page(page, i * blocksize, blocksize,
+						KM_USER0);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2107,7 +2108,8 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE-zerofrom);
+		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
+				KM_USER0);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
 		page_cache_release(new_page);
@@ -2134,7 +2136,7 @@ int cont_prepare_write(struct page *page
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
-		zero_user_page(page, zerofrom, offset-zerofrom);
+		zero_user_page(page, zerofrom, offset - zerofrom, KM_USER0);
 		__block_commit_write(inode, page, zerofrom, offset);
 	}
 	return 0;
@@ -2333,7 +2335,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	zero_user_page(page, 0, PAGE_CACHE_SIZE);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2402,7 +2404,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2436,7 +2438,8 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
+				KM_USER0);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2515,7 +2518,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length);
+	zero_user_page(page, offset, length, KM_USER0);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2561,7 +2564,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
diff -puN fs/direct-io.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/direct-io.c
--- a/fs/direct-io.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/direct-io.c
@@ -888,7 +888,7 @@ do_holes:
 					goto out;
 				}
 				zero_user_page(page, block_in_page << blkbits,
-						1 << blkbits);
+						1 << blkbits, KM_USER0);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
diff -puN fs/mpage.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type fs/mpage.c
--- a/fs/mpage.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/fs/mpage.c
@@ -285,7 +285,8 @@ do_mpage_readpage(struct bio *bio, struc
 
 	if (first_hole != blocks_per_page) {
 		zero_user_page(page, first_hole << blkbits,
-				PAGE_CACHE_SIZE - (first_hole << blkbits));
+				PAGE_CACHE_SIZE - (first_hole << blkbits),
+				KM_USER0);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -584,7 +585,8 @@ page_is_mapped:
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
+				KM_USER0);
 	}
 
 	/*
diff -puN include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page-pass-kmap-type include/linux/highmem.h
--- a/include/linux/highmem.h~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/include/linux/highmem.h
@@ -136,22 +136,27 @@ static inline void clear_highpage(struct
 
 /*
  * Same but also flushes aliased cache contents to RAM.
+ *
+ * This must be a macro because KM_USER0 and friends aren't defined if
+ * !CONFIG_HIGHMEM
  */
-static inline void zero_user_page(struct page *page, unsigned int offset, unsigned int size)
-{
-	void *kaddr;
-
-	BUG_ON(offset + size > PAGE_SIZE);
+#define zero_user_page(page, offset, size, km_type)		\
+	do {							\
+		void *kaddr;					\
+								\
+		BUG_ON((offset) + (size) > PAGE_SIZE);		\
+								\
+		kaddr = kmap_atomic(page, km_type);		\
+		memset((char *)kaddr + (offset), 0, (size));	\
+		flush_dcache_page(page);			\
+		kunmap_atomic(kaddr, (km_type));		\
+	} while (0)
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset((char *)kaddr + offset, 0, size);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-}
 
-static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+static inline void __deprecated memclear_highpage_flush(struct page *page,
+			unsigned int offset, unsigned int size)
 {
-	return zero_user_page(page, offset, size);
+	zero_user_page(page, offset, size, KM_USER0);
 }
 
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
diff -puN mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type mm/filemap_xip.c
--- a/mm/filemap_xip.c~fs-convert-core-functions-to-zero_user_page-pass-kmap-type
+++ a/mm/filemap_xip.c
@@ -463,7 +463,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	zero_user_page(page, offset, length);
+	zero_user_page(page, offset, length, KM_USER0);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86_64-early-quirks-fix-early_qrk-section-tag.patch
i386-irqbalance_disable-section-fix.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-avr32.patch
git-avr32-fixup.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-sysfs-crash-debugging.patch
device_schedule_callback-needs-a-module-reference-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
git-ocfs2.patch
git-parisc.patch
git-r8169-fixup.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-s390-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-fix-amd64-agp-aperture-validation.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
xfs-clean-up-shrinker-games.patch
pktgen-add-try_to_freeze.patch
acpi-thermal-fix-mod_timer-interval.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
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
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
undo-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
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
