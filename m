From: akpm@linux-foundation.org
Subject: +
 fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch added to -mm tree
Date: Tue, 13 May 2014 15:41:12 -0700
Message-ID: <53729f88.hYdLDGAHzeIPllmr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaEMWlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 18:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, mgorman@suse.de, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, akpm@linux-foundation.org

Subject: + fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mgorman@suse.de,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 15:41:12 -0700


The patch titled
     Subject: fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix
has been added to the -mm tree.  Its filename is
     fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix

move BUFFER_FLAGS_DISCARD into the .c file

Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    9 ++++++++-
 include/linux/buffer_head.h |    5 -----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/buffer.c~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix fs/buffer.c
--- a/fs/buffer.c~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix
+++ a/fs/buffer.c
@@ -1483,6 +1483,12 @@ EXPORT_SYMBOL(set_bh_page);
 /*
  * Called when truncating a buffer on a page completely.
  */
+
+/* Bits that are cleared during an invalidate */
+#define BUFFER_FLAGS_DISCARD \
+	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
+	 1 << BH_Delay | 1 << BH_Unwritten)
+
 static void discard_buffer(struct buffer_head * bh)
 {
 	unsigned long b_state, b_state_old;
@@ -1492,7 +1498,8 @@ static void discard_buffer(struct buffer
 	bh->b_bdev = NULL;
 	b_state = bh->b_state;
 	for (;;) {
-		b_state_old = cmpxchg(&bh->b_state, b_state, (b_state & ~BUFFER_FLAGS_DISCARD));
+		b_state_old = cmpxchg(&bh->b_state, b_state,
+				      (b_state & ~BUFFER_FLAGS_DISCARD));
 		if (b_state_old == b_state)
 			break;
 		b_state = b_state_old;
diff -puN include/linux/buffer_head.h~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix
+++ a/include/linux/buffer_head.h
@@ -77,11 +77,6 @@ struct buffer_head {
 	atomic_t b_count;		/* users using this buffer_head */
 };
 
-/* Bits that are cleared during an invalidate */
-#define BUFFER_FLAGS_DISCARD \
-	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
-	 1 << BH_Delay | 1 << BH_Unwritten)
-
 /*
  * macro tricks to expand the set_buffer_foo(), clear_buffer_foo()
  * and buffer_foo() functions.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage.patch
mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

