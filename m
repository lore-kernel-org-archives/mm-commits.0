From: akpm@osdl.org
Subject: - try_to_free_buffers-dont-clear-pte-dirty-bits.patch removed from -mm tree
Date: Thu, 21 Dec 2006 11:57:20 -0800
Message-ID: <200612211957.kBLJvKc6003177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423065AbWLUT60 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 14:58:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, a.p.zijlstra@chello.nl, dgc@sgi.com, hugh@veritas.com, miklos@szeredi.hu, reiserfs-dev@namesys.com, shaggy@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     try_to_free_buffers(): don't clear pte dirty bits
has been removed from the -mm tree.  Its filename was
     try_to_free_buffers-dont-clear-pte-dirty-bits.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: try_to_free_buffers(): don't clear pte dirty bits
From: Andrew Morton <akpm@osdl.org>

try_to_free_buffers() clears the page's dirty state if it successfully removed
the page's buffers.

  Background for this:

  - a process does a one-byte-write to a file on a 64k pagesize, 4k
    blocksize ext3 filesystem.  The page is now PageDirty, !PgeUptodate and
    has one dirty buffer and 15 not uptodate buffers.

  - kjournald writes the dirty buffer.  The page is now PageDirty,
    !PageUptodate and has a mix of clean and not uptodate buffers.

  - try_to_free_buffers() removes the page's buffers.  It MUST now clear
    PageDirty.  If we were to leave the page dirty then we'd have a dirty, not
    uptodate page with no buffer_heads.

    We're screwed: we cannot write the page because we don't know which
    sections of it contain garbage.  We cannot read the page because we don't
    know which sections of it contain modified data.  We cannot free the page
    because it is dirty.


Peter's "mm: tracking shared dirty pages"
(d08b3851da41d0ee60851f2c75b118e1f7a5fc89) modified clear_page_dirty() so that
it also clears the page's pte mapping's dirty flags, arranging for a
subsequent userspace modification of the page to cause a fault.

That change to clear_page_dirty() was correct for when it is called on the
writeback path.  Here, we effectively do:

	ClearPageDirty()
	pte_mkclean()
	submit-the-writeout

if a page-dirtying via write() or via pte's happens after the ClearPageDirty()
or the pte_mkclean() then the page is redirtied while writeout is in flight
and the page will again need writing; no probs.

But that change to clear_page_dirty() was incorrect for when it is called on
the try_to_free_buffers() path.  Here, we want to preserve any pte-dirtiness
because we're not going to write the page to backing store.  We need to keep
a record of any userspace modification to the page.

One way of addressing this would be to bale from try_to_free_buffers() if the
page is mapped into pagetables.  However that is racy, because the pagefault
path doesn't lock the page when establishing a pte against it (I which it did
- it would solve a lot of nasties).

So this patch instead arranges for clear_page_dirty() to not clean the pte's
when it is called on the try_to_free_buffers() path.

clear_page_dirty() had several callers and it's not immediately obvious to me
what the appropriate behaviour is in each case.  Could maintainers please take
a look?

From my quick reading, all callers of try_to_free_buffers() have already
unmapped the page from pagetables, and given that the reported ext3 corruption
happens on uniprocessor, non-preempt kernels, I doubt if this patch will fix
things.

But even if it is true that try_to_free_buffers() callers unmap the page
first, this fix is still needed, because a minor fault could reestablish pte's
in the meanwhile.

Note that with this change, we can now restore try_to_free_buffers()'s
->private_lock to cover the test_clear_page_dirty().  If we indeed need to do
that, it'll be in a separate patch.

(Need to think about this some more.  How can a page be pte-dirty, but not
have dirty buffers?  We're supposed to clean the pte's when we write the
page, and we dirty the page and buffers when userspace dirties the pte...)


Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: <reiserfs-dev@namesys.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/buffer.c                 |    2 +-
 fs/cifs/file.c              |    2 +-
 fs/fuse/file.c              |    2 +-
 fs/hugetlbfs/inode.c        |    2 +-
 fs/jfs/jfs_metapage.c       |    2 +-
 fs/reiserfs/stree.c         |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c |    2 +-
 include/linux/page-flags.h  |    6 +++---
 mm/page-writeback.c         |    5 +++--
 mm/truncate.c               |    4 ++--
 10 files changed, 15 insertions(+), 14 deletions(-)

diff -puN fs/buffer.c~try_to_free_buffers-dont-clear-pte-dirty-bits fs/buffer.c
--- a/fs/buffer.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/fs/buffer.c
@@ -2858,7 +2858,7 @@ int try_to_free_buffers(struct page *pag
 		 * the page's buffers clean.  We discover that here and clean
 		 * the page also.
 		 */
-		if (test_clear_page_dirty(page))
+		if (test_clear_page_dirty(page, 0))
 			task_io_account_cancelled_write(PAGE_CACHE_SIZE);
 	}
 out:
diff -puN fs/fuse/file.c~try_to_free_buffers-dont-clear-pte-dirty-bits fs/fuse/file.c
--- a/fs/fuse/file.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/fs/fuse/file.c
@@ -484,7 +484,7 @@ static int fuse_commit_write(struct file
 		spin_unlock(&fc->lock);
 
 		if (offset == 0 && to == PAGE_CACHE_SIZE) {
-			clear_page_dirty(page);
+			clear_page_dirty(page, 1);
 			SetPageUptodate(page);
 		}
 	}
diff -puN fs/hugetlbfs/inode.c~try_to_free_buffers-dont-clear-pte-dirty-bits fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/fs/hugetlbfs/inode.c
@@ -176,7 +176,7 @@ static int hugetlbfs_commit_write(struct
 
 static void truncate_huge_page(struct page *page)
 {
-	clear_page_dirty(page);
+	clear_page_dirty(page, 1);
 	ClearPageUptodate(page);
 	remove_from_page_cache(page);
 	put_page(page);
diff -puN fs/jfs/jfs_metapage.c~try_to_free_buffers-dont-clear-pte-dirty-bits fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/fs/jfs/jfs_metapage.c
@@ -773,7 +773,7 @@ void release_metapage(struct metapage * 
 
 	/* Retest mp->count since we may have released page lock */
 	if (test_bit(META_discard, &mp->flag) && !mp->count) {
-		clear_page_dirty(page);
+		clear_page_dirty(page, 1);
 		ClearPageUptodate(page);
 	}
 #else
diff -puN fs/reiserfs/stree.c~try_to_free_buffers-dont-clear-pte-dirty-bits fs/reiserfs/stree.c
--- a/fs/reiserfs/stree.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/fs/reiserfs/stree.c
@@ -1459,7 +1459,7 @@ static void unmap_buffers(struct page *p
 				bh = next;
 			} while (bh != head);
 			if (PAGE_SIZE == bh->b_size) {
-				clear_page_dirty(page);
+				clear_page_dirty(page, 1);
 			}
 		}
 	}
diff -puN fs/xfs/linux-2.6/xfs_aops.c~try_to_free_buffers-dont-clear-pte-dirty-bits fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -343,7 +343,7 @@ xfs_start_page_writeback(
 	ASSERT(!PageWriteback(page));
 	set_page_writeback(page);
 	if (clear_dirty)
-		clear_page_dirty(page);
+		clear_page_dirty(page, 1);
 	unlock_page(page);
 	if (!buffers) {
 		end_page_writeback(page);
diff -puN include/linux/page-flags.h~try_to_free_buffers-dont-clear-pte-dirty-bits include/linux/page-flags.h
--- a/include/linux/page-flags.h~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/include/linux/page-flags.h
@@ -253,13 +253,13 @@ static inline void SetPageUptodate(struc
 
 struct page;	/* forward declaration */
 
-int test_clear_page_dirty(struct page *page);
+int test_clear_page_dirty(struct page *page, int must_clean_ptes);
 int test_clear_page_writeback(struct page *page);
 int test_set_page_writeback(struct page *page);
 
-static inline void clear_page_dirty(struct page *page)
+static inline void clear_page_dirty(struct page *page, int must_clean_ptes)
 {
-	test_clear_page_dirty(page);
+	test_clear_page_dirty(page, must_clean_ptes);
 }
 
 static inline void set_page_writeback(struct page *page)
diff -puN mm/page-writeback.c~try_to_free_buffers-dont-clear-pte-dirty-bits mm/page-writeback.c
--- a/mm/page-writeback.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/mm/page-writeback.c
@@ -848,7 +848,7 @@ EXPORT_SYMBOL(set_page_dirty_lock);
  * Clear a page's dirty flag, while caring for dirty memory accounting. 
  * Returns true if the page was previously dirty.
  */
-int test_clear_page_dirty(struct page *page)
+int test_clear_page_dirty(struct page *page, int must_clean_ptes)
 {
 	struct address_space *mapping = page_mapping(page);
 	unsigned long flags;
@@ -866,7 +866,8 @@ int test_clear_page_dirty(struct page *p
 		 * page is locked, which pins the address_space
 		 */
 		if (mapping_cap_account_dirty(mapping)) {
-			page_mkclean(page);
+			if (must_clean_ptes)
+				page_mkclean(page);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 		}
 		return 1;
diff -puN mm/truncate.c~try_to_free_buffers-dont-clear-pte-dirty-bits mm/truncate.c
--- a/mm/truncate.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/mm/truncate.c
@@ -70,7 +70,7 @@ truncate_complete_page(struct address_sp
 	if (PagePrivate(page))
 		do_invalidatepage(page, 0);
 
-	if (test_clear_page_dirty(page))
+	if (test_clear_page_dirty(page, 1))
 		task_io_account_cancelled_write(PAGE_CACHE_SIZE);
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
@@ -386,7 +386,7 @@ int invalidate_inode_pages2_range(struct
 					  PAGE_CACHE_SIZE, 0);
 				}
 			}
-			was_dirty = test_clear_page_dirty(page);
+			was_dirty = test_clear_page_dirty(page, 0);
 			if (!invalidate_complete_page2(mapping, page)) {
 				if (was_dirty)
 					set_page_dirty(page);
diff -puN fs/cifs/file.c~try_to_free_buffers-dont-clear-pte-dirty-bits fs/cifs/file.c
--- a/fs/cifs/file.c~try_to_free_buffers-dont-clear-pte-dirty-bits
+++ a/fs/cifs/file.c
@@ -1245,7 +1245,7 @@ retry:
 				wait_on_page_writeback(page);
 
 			if (PageWriteback(page) ||
-					!test_clear_page_dirty(page)) {
+					!test_clear_page_dirty(page, 1)) {
 				unlock_page(page);
 				break;
 			}
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
truncate-clear-page-dirtiness-before-running-try_to_free_buffers.patch
try_to_free_buffers-dont-clear-pte-dirty-bits.patch
kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch
rtc-warning-fix.patch
fix-vm_events_fold_cpu-build-breakage-fix.patch
smc911-workqueue-fixes.patch
schedule_timeout-improve-warning-message.patch
relay-remove-inlining.patch
increase-cardbus_mem_size.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
build-compileh-earlier.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
arm-systemh-build-fix.patch
cifs-sprintf-fix.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
driver-for-silan-sc92031-netdev.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-disable-multithreaded-probing.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
funsoft-is-bust-on-sparc.patch
nokia-e70-is-an-unusual-device.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
spi-controller-driver-for-omap-microwire-tidy.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
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
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

