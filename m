From: akpm@linux-foundation.org
Subject: [merged]
 mm-compactionc-fix-suitable_migration_target-unused-warning.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:53:16 -0700
Message-ID: <552fe8fc.VM7QwmYExx2bJVkV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbDPQrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: fix "suitable_migration_target() unused" warning
has been removed from the -mm tree.  Its filename was
     mm-compactionc-fix-suitable_migration_target-unused-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/compaction.c: fix "suitable_migration_target() unused" warning

mm/compaction.c:250:13: warning: 'suitable_migration_target' defined but not used [-Wunused-function]

Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN mm/compaction.c~mm-compactionc-fix-suitable_migration_target-unused-warning mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-fix-suitable_migration_target-unused-warning
+++ a/mm/compaction.c
@@ -391,28 +391,6 @@ static inline bool compact_should_abort(
 	return false;
 }
 
-/* Returns true if the page is within a block suitable for migration to */
-static bool suitable_migration_target(struct page *page)
-{
-	/* If the page is a large free page, then disallow migration */
-	if (PageBuddy(page)) {
-		/*
-		 * We are checking page_order without zone->lock taken. But
-		 * the only small danger is that we skip a potentially suitable
-		 * pageblock, so it's not worth to check order for valid range.
-		 */
-		if (page_order_unsafe(page) >= pageblock_order)
-			return false;
-	}
-
-	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
-	if (migrate_async_suitable(get_pageblock_migratetype(page)))
-		return true;
-
-	/* Otherwise skip the block */
-	return false;
-}
-
 /*
  * Isolate free pages onto a private freelist. If @strict is true, will abort
  * returning 0 on any invalid PFNs or non-free pages inside of the pageblock
@@ -896,6 +874,29 @@ isolate_migratepages_range(struct compac
 
 #endif /* CONFIG_COMPACTION || CONFIG_CMA */
 #ifdef CONFIG_COMPACTION
+
+/* Returns true if the page is within a block suitable for migration to */
+static bool suitable_migration_target(struct page *page)
+{
+	/* If the page is a large free page, then disallow migration */
+	if (PageBuddy(page)) {
+		/*
+		 * We are checking page_order without zone->lock taken. But
+		 * the only small danger is that we skip a potentially suitable
+		 * pageblock, so it's not worth to check order for valid range.
+		 */
+		if (page_order_unsafe(page) >= pageblock_order)
+			return false;
+	}
+
+	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
+	if (migrate_async_suitable(get_pageblock_migratetype(page)))
+		return true;
+
+	/* Otherwise skip the block */
+	return false;
+}
+
 /*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

