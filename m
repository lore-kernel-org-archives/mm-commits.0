From: akpm@linux-foundation.org
Subject: + zsmalloc-always-keep-per-class-stats.patch added to -mm tree
Date: Wed, 08 Jul 2015 15:37:52 -0700
Message-ID: <559da640.ybKBflxw0V0FuZMu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbbGHWhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:37:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: always keep per-class stats
has been added to the -mm tree.  Its filename is
     zsmalloc-always-keep-per-class-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-always-keep-per-class-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-always-keep-per-class-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: always keep per-class stats

Always account per-class `zs_size_stat' stats.  This data will help us
make better decisions during compaction.  We are especially interested in
OBJ_ALLOCATED and OBJ_USED, which can tell us if class compaction will
result in any memory gain.

For instance, we know the number of allocated objects in the class, the
number of objects being used (so we also know how many objects are not
used) and the number of objects per-page.  So we can ensure if we have
enough unused objects to form at least one ZS_EMPTY zspage during
compaction.

We calculate this value on per-class basis so we can calculate a total
number of zspages that can be released.  Which is exactly what a shrinker
wants to know.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   40 ++++++++--------------------------------
 1 file changed, 8 insertions(+), 32 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-always-keep-per-class-stats mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-always-keep-per-class-stats
+++ a/mm/zsmalloc.c
@@ -169,14 +169,12 @@ enum zs_stat_type {
 	NR_ZS_STAT_TYPE,
 };
 
-#ifdef CONFIG_ZSMALLOC_STAT
-
-static struct dentry *zs_stat_root;
-
 struct zs_size_stat {
 	unsigned long objs[NR_ZS_STAT_TYPE];
 };
 
+#ifdef CONFIG_ZSMALLOC_STAT
+static struct dentry *zs_stat_root;
 #endif
 
 /*
@@ -201,6 +199,8 @@ static int zs_size_classes;
 static const int fullness_threshold_frac = 4;
 
 struct size_class {
+	spinlock_t lock;
+	struct page *fullness_list[_ZS_NR_FULLNESS_GROUPS];
 	/*
 	 * Size of objects stored in this class. Must be multiple
 	 * of ZS_ALIGN.
@@ -210,16 +210,10 @@ struct size_class {
 
 	/* Number of PAGE_SIZE sized pages to combine to form a 'zspage' */
 	int pages_per_zspage;
-	/* huge object: pages_per_zspage == 1 && maxobj_per_zspage == 1 */
-	bool huge;
-
-#ifdef CONFIG_ZSMALLOC_STAT
 	struct zs_size_stat stats;
-#endif
-
-	spinlock_t lock;
 
-	struct page *fullness_list[_ZS_NR_FULLNESS_GROUPS];
+	/* huge object: pages_per_zspage == 1 && maxobj_per_zspage == 1 */
+	bool huge;
 };
 
 /*
@@ -441,8 +435,6 @@ static int get_size_class_index(int size
 	return min(zs_size_classes - 1, idx);
 }
 
-#ifdef CONFIG_ZSMALLOC_STAT
-
 static inline void zs_stat_inc(struct size_class *class,
 				enum zs_stat_type type, unsigned long cnt)
 {
@@ -461,6 +453,8 @@ static inline unsigned long zs_stat_get(
 	return class->stats.objs[type];
 }
 
+#ifdef CONFIG_ZSMALLOC_STAT
+
 static int __init zs_stat_init(void)
 {
 	if (!debugfs_initialized())
@@ -576,23 +570,6 @@ static void zs_pool_stat_destroy(struct
 }
 
 #else /* CONFIG_ZSMALLOC_STAT */
-
-static inline void zs_stat_inc(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-}
-
-static inline void zs_stat_dec(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-}
-
-static inline unsigned long zs_stat_get(struct size_class *class,
-				enum zs_stat_type type)
-{
-	return 0;
-}
-
 static int __init zs_stat_init(void)
 {
 	return 0;
@@ -610,7 +587,6 @@ static inline int zs_pool_stat_create(ch
 static inline void zs_pool_stat_destroy(struct zs_pool *pool)
 {
 }
