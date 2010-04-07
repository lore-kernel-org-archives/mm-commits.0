From: akpm@linux-foundation.org
Subject: + mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch added to -mm tree
Date: Tue, 06 Apr 2010 17:06:57 -0700
Message-ID: <201004070006.o3706vck016376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932281Ab0DGAHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 20:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: share the anon_vma ref counts between KSM and page migration
has been added to the -mm tree.  Its filename is
     mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: share the anon_vma ref counts between KSM and page migration
From: Mel Gorman <mel@csn.ul.ie>

For clarity of review, KSM and page migration have separate refcounts on
the anon_vma.  While clear, this is a waste of memory.  This patch gets
KSM and page migration to share their toys in a spirit of harmony.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   50 ++++++++++++++---------------------------
 mm/ksm.c             |    4 +--
 mm/migrate.c         |    4 +--
 mm/rmap.c            |    6 +---
 4 files changed, 24 insertions(+), 40 deletions(-)

diff -puN include/linux/rmap.h~mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration include/linux/rmap.h
--- a/include/linux/rmap.h~mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration
+++ a/include/linux/rmap.h
@@ -26,11 +26,17 @@
  */
 struct anon_vma {
 	spinlock_t lock;	/* Serialize access to vma list */
-#ifdef CONFIG_KSM
-	atomic_t ksm_refcount;
-#endif
-#ifdef CONFIG_MIGRATION
-	atomic_t migrate_refcount;
+#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
+
+	/*
+	 * The external_refcount is taken by either KSM or page migration
+	 * to take a reference to an anon_vma when there is no
+	 * guarantee that the vma of page tables will exist for
+	 * the duration of the operation. A caller that takes
+	 * the reference is responsible for clearing up the
+	 * anon_vma if they are the last user on release
+	 */
+	atomic_t external_refcount;
 #endif
 	/*
 	 * NOTE: the LSB of the head.next is set by
@@ -64,46 +70,26 @@ struct anon_vma_chain {
 };
 
 #ifdef CONFIG_MMU
-#ifdef CONFIG_KSM
-static inline void ksm_refcount_init(struct anon_vma *anon_vma)
+#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
+static inline void anonvma_external_refcount_init(struct anon_vma *anon_vma)
 {
-	atomic_set(&anon_vma->ksm_refcount, 0);
+	atomic_set(&anon_vma->external_refcount, 0);
 }
 
-static inline int ksm_refcount(struct anon_vma *anon_vma)
+static inline int anonvma_external_refcount(struct anon_vma *anon_vma)
 {
-	return atomic_read(&anon_vma->ksm_refcount);
+	return atomic_read(&anon_vma->external_refcount);
 }
 #else
-static inline void ksm_refcount_init(struct anon_vma *anon_vma)
+static inline void anonvma_external_refcount_init(struct anon_vma *anon_vma)
 {
 }
 
-static inline int ksm_refcount(struct anon_vma *anon_vma)
+static inline int anonvma_external_refcount(struct anon_vma *anon_vma)
 {
 	return 0;
 }
 #endif /* CONFIG_KSM */
-#ifdef CONFIG_MIGRATION
-static inline void migrate_refcount_init(struct anon_vma *anon_vma)
-{
-	atomic_set(&anon_vma->migrate_refcount, 0);
-}
-
-static inline int migrate_refcount(struct anon_vma *anon_vma)
-{
-	return atomic_read(&anon_vma->migrate_refcount);
-}
-#else
-static inline void migrate_refcount_init(struct anon_vma *anon_vma)
-{
-}
-
-static inline int migrate_refcount(struct anon_vma *anon_vma)
-{
-	return 0;
-}
-#endif /* CONFIG_MIGRATE */
 
 static inline struct anon_vma *page_anon_vma(struct page *page)
 {
diff -puN mm/ksm.c~mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration mm/ksm.c
--- a/mm/ksm.c~mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration
+++ a/mm/ksm.c
@@ -318,14 +318,14 @@ static void hold_anon_vma(struct rmap_it
 			  struct anon_vma *anon_vma)
 {
 	rmap_item->anon_vma = anon_vma;
-	atomic_inc(&anon_vma->ksm_refcount);
+	atomic_inc(&anon_vma->external_refcount);
 }
 
 static void drop_anon_vma(struct rmap_item *rmap_item)
 {
 	struct anon_vma *anon_vma = rmap_item->anon_vma;
 
-	if (atomic_dec_and_lock(&anon_vma->ksm_refcount, &anon_vma->lock)) {
+	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
 		int empty = list_empty(&anon_vma->head);
 		spin_unlock(&anon_vma->lock);
 		if (empty)
diff -puN mm/migrate.c~mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration mm/migrate.c
--- a/mm/migrate.c~mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration
+++ a/mm/migrate.c
@@ -612,7 +612,7 @@ static int unmap_and_move(new_page_t get
 			goto rcu_unlock;
 
 		anon_vma = page_anon_vma(page);
-		atomic_inc(&anon_vma->migrate_refcount);
+		atomic_inc(&anon_vma->external_refcount);
 	}
 
 	/*
@@ -654,7 +654,7 @@ skip_unmap:
 rcu_unlock:
 
 	/* Drop an anon_vma reference if we took one */
-	if (anon_vma && atomic_dec_and_lock(&anon_vma->migrate_refcount, &anon_vma->lock)) {
+	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
 		int empty = list_empty(&anon_vma->head);
 		spin_unlock(&anon_vma->lock);
 		if (empty)
diff -puN mm/rmap.c~mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration mm/rmap.c
--- a/mm/rmap.c~mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration
+++ a/mm/rmap.c
@@ -249,8 +249,7 @@ static void anon_vma_unlink(struct anon_
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head) && !ksm_refcount(anon_vma) &&
-					!migrate_refcount(anon_vma);
+	empty = list_empty(&anon_vma->head) && !anonvma_external_refcount(anon_vma);
 	spin_unlock(&anon_vma->lock);
 
 	if (empty)
@@ -274,8 +273,7 @@ static void anon_vma_ctor(void *data)
 	struct anon_vma *anon_vma = data;
 
 	spin_lock_init(&anon_vma->lock);
-	ksm_refcount_init(anon_vma);
-	migrate_refcount_init(anon_vma);
+	anonvma_external_refcount_init(anon_vma);
 	INIT_LIST_HEAD(&anon_vma->head);
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

