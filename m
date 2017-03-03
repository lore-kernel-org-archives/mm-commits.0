From: akpm@linux-foundation.org
Subject: + mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
 added to -mm tree
Date: Fri, 03 Mar 2017 15:06:32 -0800
Message-ID: <58b9f6f8.9RLPWyZ/yohueG5s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdCCXPy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:15:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, qiuxishi@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-is_migrate_highatomic-to-simplify-the-code-fix
has been added to the -mm tree.  Its filename is
     mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch

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
@@ -503,4 +503,14 @@ extern const struct trace_print_flags pa
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

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

