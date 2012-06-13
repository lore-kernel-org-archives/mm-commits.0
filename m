From: akpm@linux-foundation.org
Subject: [folded] mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch removed from -mm tree
Date: Wed, 13 Jun 2012 16:16:24 -0700
Message-ID: <20120613231625.10CBBA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:64083 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab2FMXQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jun 2012 19:16:28 -0400
Received: by lagr15 with SMTP id r15so57826lag.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 16:16:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, b.zolnierkie@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch

This patch was dropped because it was folded into mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix

make __count_immobile_pages() return bool, fix some comments

Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   14 +++++++-------
 mm/internal.h   |    2 +-
 mm/page_alloc.c |    3 +--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/compaction.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix
+++ a/mm/compaction.c
@@ -394,10 +394,10 @@ static void rescue_unmovable_pageblock(s
 }
 
 /*
- * MIGRATE_TARGET : good for migration target
- * RESCUE_UNMOVABLE_TARTET : good only if we can rescue the unmovable pageblock.
- * UNMOVABLE_TARGET : can't migrate because it's a page in unmovable pageblock.
- * SKIP_TARGET : can't migrate by another reasons.
+ * MIGRATE_TARGET: good for migration target
+ * RESCUE_UNMOVABLE_TARGET: good only if we can rescue the unmovable pageblock.
+ * UNMOVABLE_TARGET: can't migrate because it's a page in unmovable pageblock.
+ * SKIP_TARGET: can't migrate by another reasons.
  */
 enum smt_result {
 	MIGRATE_TARGET,
@@ -407,9 +407,9 @@ enum smt_result {
 };
 
 /*
- * Returns MIGRATE_TARGET if the page is within a block
- * suitable for migration to, UNMOVABLE_TARGET if the page
- * is within a MIGRATE_UNMOVABLE block, SKIP_TARGET otherwise.
+ * Returns MIGRATE_TARGET if the page is within a block suitable for migration
+ * to, UNMOVABLE_TARGET if the page is within a MIGRATE_UNMOVABLE block,
+ * SKIP_TARGET otherwise.
  */
 static enum smt_result suitable_migration_target(struct page *page,
 			      struct compact_control *cc)
diff -puN mm/internal.h~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix mm/internal.h
--- a/mm/internal.h~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix
+++ a/mm/internal.h
@@ -97,7 +97,7 @@ extern void putback_lru_page(struct page
 extern void set_pageblock_migratetype(struct page *page, int migratetype);
 extern int move_freepages_block(struct zone *zone, struct page *page,
 				int migratetype);
-extern int __count_immobile_pages(struct zone *zone, struct page *page,
+extern bool __count_immobile_pages(struct zone *zone, struct page *page,
 				  int count);
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
diff -puN mm/page_alloc.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix
+++ a/mm/page_alloc.c
@@ -221,7 +221,6 @@ int page_group_by_mobility_disabled __re
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
-
 	if (unlikely(page_group_by_mobility_disabled))
 		migratetype = MIGRATE_UNMOVABLE;
 
@@ -5472,7 +5471,7 @@ void set_pageblock_flags_group(struct pa
  * page allocater never alloc memory from ISOLATE block.
  */
 
-int __count_immobile_pages(struct zone *zone, struct page *page, int count)
+bool __count_immobile_pages(struct zone *zone, struct page *page, int count)
 {
 	unsigned long pfn, iter, found;
 	int mt;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

