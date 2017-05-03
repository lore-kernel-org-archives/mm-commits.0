From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch removed from
 -mm tree
Date: Wed, 03 May 2017 14:36:39 -0700
Message-ID: <590a4d67.n3AgSIZ2jrfA+s9+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45702 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbdECVgk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, qiuxishi@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-is_migrate_highatomic-to-simplify-the-code-fix
has been removed from the -mm tree.  Its filename was
     mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch

This patch was dropped because it was folded into mm-use-is_migrate_highatomic-to-simplify-the-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-is_migrate_highatomic-to-simplify-the-code-fix

use static inlines rather than macros, per mhocko

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 +------
 mm/internal.h          |   10 ++++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~mm-use-is_migrate_highatomic-to-simplify-the-code-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-use-is_migrate_highatomic-to-simplify-the-code-fix
+++ a/include/linux/mmzone.h
@@ -35,7 +35,7 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
-enum {
+enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
 	MIGRATE_RECLAIMABLE,
@@ -66,11 +66,6 @@ enum {
 /* In mm/page_alloc.c; keep in sync also with show_migration_types() there */
 extern char * const migratetype_names[MIGRATE_TYPES];
 
-#define is_migrate_highatomic(migratetype)				\
-	(migratetype == MIGRATE_HIGHATOMIC)
-#define is_migrate_highatomic_page(_page)				\
-	(get_pageblock_migratetype(_page) == MIGRATE_HIGHATOMIC)
-
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #  define is_migrate_cma_page(_page) (get_pageblock_migratetype(_page) == MIGRATE_CMA)
diff -puN mm/internal.h~mm-use-is_migrate_highatomic-to-simplify-the-code-fix mm/internal.h
--- a/mm/internal.h~mm-use-is_migrate_highatomic-to-simplify-the-code-fix
+++ a/mm/internal.h
@@ -510,4 +510,14 @@ extern const struct trace_print_flags pa
 extern const struct trace_print_flags vmaflag_names[];
 extern const struct trace_print_flags gfpflag_names[];
 
+static inline bool is_migrate_highatomic(enum migratetype migratetype)
+{
+	return migratetype == MIGRATE_HIGHATOMIC;
+}
+
+static inline bool is_migrate_highatomic_page(struct page *page)
+{
+	return get_pageblock_migratetype(page) == MIGRATE_HIGHATOMIC;
+}
+
 #endif	/* __MM_INTERNAL_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-use-is_migrate_highatomic-to-simplify-the-code.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch

