From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
 removed from -mm tree
Date: Fri, 24 May 2013 15:40:28 -0700
Message-ID: <519fec5c.vt6M5vKDYYgqDXjA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3EXWka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 18:40:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, holt@sgi.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,holt@sgi.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 15:40:28 -0700


The patch titled
     Subject: mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch

This patch was dropped because it was folded into mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix

tweak comments

Cc: Robin Holt <holt@sgi.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix
+++ a/mm/mmu_notifier.c
@@ -46,11 +46,10 @@ void __mmu_notifier_release(struct mm_st
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist)
 		/*
-		 * if ->release runs before mmu_notifier_unregister it
-		 * must be handled as it's the only way for the driver
-		 * to flush all existing sptes and stop the driver
-		 * from establishing any more sptes before all the
-		 * pages in the mm are freed.
+		 * If ->release runs before mmu_notifier_unregister it must be
+		 * handled, as it's the only way for the driver to flush all
+		 * existing sptes and stop the driver from establishing any more
+		 * sptes before all the pages in the mm are freed.
 		 */
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
@@ -63,22 +62,22 @@ void __mmu_notifier_release(struct mm_st
 				 hlist);
 		/*
 		 * We arrived before mmu_notifier_unregister so
-		 * mmu_notifier_unregister will do nothing other than
-		 * to wait ->release to finish and
-		 * mmu_notifier_unregister to return.
+		 * mmu_notifier_unregister will do nothing other than to wait
+		 * for ->release to finish and for mmu_notifier_unregister to
+		 * return.
 		 */
 		hlist_del_init_rcu(&mn->hlist);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
 	/*
-	 * synchronize_srcu here prevents mmu_notifier_release to
-	 * return to exit_mmap (which would proceed freeing all pages
-	 * in the mm) until the ->release method returns, if it was
-	 * invoked by mmu_notifier_unregister.
+	 * synchronize_srcu here prevents mmu_notifier_release from returning to
+	 * exit_mmap (which would proceed with freeing all pages in the mm)
+	 * until the ->release method returns, if it was invoked by
+	 * mmu_notifier_unregister.
 	 *
-	 * The mmu_notifier_mm can't go away from under us because one
-	 * mm_count is hold by exit_mmap.
+	 * The mmu_notifier_mm can't go away from under us because one mm_count
+	 * is held by exit_mmap.
 	 */
 	synchronize_srcu(&srcu);
 }
@@ -291,16 +290,15 @@ void mmu_notifier_unregister(struct mmu_
 
 	if (!hlist_unhashed(&mn->hlist)) {
 		/*
-		 * SRCU here will force exit_mmap to wait ->release to finish
-		 * before freeing the pages.
+		 * SRCU here will force exit_mmap to wait for ->release to
+		 * finish before freeing the pages.
 		 */
 		int id;
 
 		id = srcu_read_lock(&srcu);
 		/*
-		 * exit_mmap will block in mmu_notifier_release to
-		 * guarantee ->release is called before freeing the
-		 * pages.
+		 * exit_mmap will block in mmu_notifier_release to guarantee
+		 * that ->release is called before freeing the pages.
 		 */
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
@@ -316,7 +314,7 @@ void mmu_notifier_unregister(struct mmu_
 	}
 
 	/*
-	 * Wait any running method to finish, of course including
+	 * Wait for any running method to finish, of course including
 	 * ->release if it was run by mmu_notifier_relase instead of us.
 	 */
 	synchronize_srcu(&srcu);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
revert-selftest-add-simple-test-for-soft-dirty-bit.patch
mm-pagewalkc-walk_page_range-should-avoid-vm_pfnmap-areas-fix.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time-fix.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

