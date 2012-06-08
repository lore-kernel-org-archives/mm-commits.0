From: akpm@linux-foundation.org
Subject: + mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch added to -mm tree
Date: Fri, 08 Jun 2012 14:18:44 -0700
Message-ID: <20120608211845.0D335A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60868 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964848Ab2FHVSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 17:18:47 -0400
Received: by eeit10 with SMTP id t10so132167eei.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 14:18:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, b.zolnierkie@samsung.com


The patch titled
     Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch

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
Subject: Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

