Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCADC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 483C261402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWlh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWlh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937D26140E;
        Sat,  8 May 2021 22:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513634;
        bh=1P7J5JZr8ug9srN+CA+BOZFwIkMvmrP0EeGZ3ZLw8bM=;
        h=Date:From:To:Subject:From;
        b=DZJKj9w3r6O23FAUlqa/HBogZF8WKfRiRjnQRaLdZ4mvawiIxeGpmeVVciQCa13Pi
         3OvVZFwWSz86PElGRAkjFQWrurAm8GuosxmAJr1O49LG4VZX4BB76lW26Z5zKg86w4
         eJaimYdvBZGuoIPtc7AzO2thGFV59puv921F6uc0=
Date:   Sat, 08 May 2021 15:40:34 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 =?US-ASCII?Q?mm-page-writeback-simplify-memcg-handling-in-test=5Fclear=5F?=
 =?US-ASCII?Q?page=5Fwriteback.patch?= removed from -mm tree
Message-ID: <20210508224034.rdK7nyNtc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page-writeback: simplify memcg handling in test_clear_page_writeback()
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page-writeback: simplify memcg handling in test_clear_page_writeback()

Page writeback doesn't hold a page reference, which allows truncate to
free a page the second PageWriteback is cleared.  This used to require
special attention in test_clear_page_writeback(), where we had to be
careful not to rely on the unstable page->memcg binding and look up all
the necessary information before clearing the writeback flag.

Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
explicit reference on the page, and this dance is no longer needed.

Use unlock_page_memcg() and dec_lruvec_page_state() directly.

This removes the last user of the lock_page_memcg() return value, change
it to void.  Touch up the comments in there as well.  This also removes
the last extern user of __unlock_page_memcg(), make it static.  Further,
it removes the last user of dec_lruvec_state(), delete it, along with a
few other unused helpers.

Link: https://lkml.kernel.org/r/YCQbYAWg4nvBFL6h@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +--------
 include/linux/vmstat.h     |   24 ++---------------------
 mm/memcontrol.c            |   36 ++++++++++-------------------------
 mm/page-writeback.c        |    9 ++------
 4 files changed, 19 insertions(+), 60 deletions(-)

--- a/include/linux/memcontrol.h~mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback
+++ a/include/linux/memcontrol.h
@@ -867,8 +867,7 @@ void mem_cgroup_print_oom_group(struct m
 extern bool cgroup_memory_noswap;
 #endif
 
-struct mem_cgroup *lock_page_memcg(struct page *page);
-void __unlock_page_memcg(struct mem_cgroup *memcg);
+void lock_page_memcg(struct page *page);
 void unlock_page_memcg(struct page *page);
 
 /*
@@ -1289,12 +1288,7 @@ mem_cgroup_print_oom_meminfo(struct mem_
 {
 }
 
-static inline struct mem_cgroup *lock_page_memcg(struct page *page)
-{
-	return NULL;
-}
-
-static inline void __unlock_page_memcg(struct mem_cgroup *memcg)
+static inline void lock_page_memcg(struct page *page)
 {
 }
 
--- a/include/linux/vmstat.h~mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback
+++ a/include/linux/vmstat.h
@@ -512,16 +512,10 @@ static inline void mod_lruvec_page_state
 
 #endif /* CONFIG_MEMCG */
 
-static inline void __inc_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx)
-{
-	__mod_lruvec_state(lruvec, idx, 1);
-}
-
-static inline void __dec_lruvec_state(struct lruvec *lruvec,
-				      enum node_stat_item idx)
+static inline void inc_lruvec_state(struct lruvec *lruvec,
+				    enum node_stat_item idx)
 {
-	__mod_lruvec_state(lruvec, idx, -1);
+	mod_lruvec_state(lruvec, idx, 1);
 }
 
 static inline void __inc_lruvec_page_state(struct page *page,
@@ -536,18 +530,6 @@ static inline void __dec_lruvec_page_sta
 	__mod_lruvec_page_state(page, idx, -1);
 }
 
-static inline void inc_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx)
-{
-	mod_lruvec_state(lruvec, idx, 1);
-}
-
-static inline void dec_lruvec_state(struct lruvec *lruvec,
-				    enum node_stat_item idx)
-{
-	mod_lruvec_state(lruvec, idx, -1);
-}
-
 static inline void inc_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx)
 {
--- a/mm/memcontrol.c~mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback
+++ a/mm/memcontrol.c
@@ -2118,11 +2118,10 @@ void mem_cgroup_print_oom_group(struct m
  * This function protects unlocked LRU pages from being moved to
  * another cgroup.
  *
- * It ensures lifetime of the returned memcg. Caller is responsible
- * for the lifetime of the page; __unlock_page_memcg() is available
- * when @page might get freed inside the locked section.
+ * It ensures lifetime of the locked memcg. Caller is responsible
+ * for the lifetime of the page.
  */
-struct mem_cgroup *lock_page_memcg(struct page *page)
+void lock_page_memcg(struct page *page)
 {
 	struct page *head = compound_head(page); /* rmap on tail pages */
 	struct mem_cgroup *memcg;
@@ -2132,21 +2131,15 @@ struct mem_cgroup *lock_page_memcg(struc
 	 * The RCU lock is held throughout the transaction.  The fast
 	 * path can get away without acquiring the memcg->move_lock
 	 * because page moving starts with an RCU grace period.
-	 *
-	 * The RCU lock also protects the memcg from being freed when
-	 * the page state that is going to change is the only thing
-	 * preventing the page itself from being freed. E.g. writeback
-	 * doesn't hold a page reference and relies on PG_writeback to
-	 * keep off truncation, migration and so forth.
          */
 	rcu_read_lock();
 
 	if (mem_cgroup_disabled())
-		return NULL;
+		return;
 again:
 	memcg = page_memcg(head);
 	if (unlikely(!memcg))
-		return NULL;
+		return;
 
 #ifdef CONFIG_PROVE_LOCKING
 	local_irq_save(flags);
@@ -2155,7 +2148,7 @@ again:
 #endif
 
 	if (atomic_read(&memcg->moving_account) <= 0)
-		return memcg;
+		return;
 
 	spin_lock_irqsave(&memcg->move_lock, flags);
 	if (memcg != page_memcg(head)) {
@@ -2164,24 +2157,17 @@ again:
 	}
 
 	/*
-	 * When charge migration first begins, we can have locked and
-	 * unlocked page stat updates happening concurrently.  Track
-	 * the task who has the lock for unlock_page_memcg().
+	 * When charge migration first begins, we can have multiple
+	 * critical sections holding the fast-path RCU lock and one
+	 * holding the slowpath move_lock. Track the task who has the
+	 * move_lock for unlock_page_memcg().
 	 */
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
-
-	return memcg;
 }
 EXPORT_SYMBOL(lock_page_memcg);
 
-/**
- * __unlock_page_memcg - unlock and unpin a memcg
- * @memcg: the memcg
- *
- * Unlock and unpin a memcg returned by lock_page_memcg().
- */
-void __unlock_page_memcg(struct mem_cgroup *memcg)
+static void __unlock_page_memcg(struct mem_cgroup *memcg)
 {
 	if (memcg && memcg->move_lock_task == current) {
 		unsigned long flags = memcg->move_lock_flags;
--- a/mm/page-writeback.c~mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback
+++ a/mm/page-writeback.c
@@ -2722,12 +2722,9 @@ EXPORT_SYMBOL(clear_page_dirty_for_io);
 int test_clear_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
 	int ret;
 
-	memcg = lock_page_memcg(page);
-	lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+	lock_page_memcg(page);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -2755,11 +2752,11 @@ int test_clear_page_writeback(struct pag
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
-		dec_lruvec_state(lruvec, NR_WRITEBACK);
+		dec_lruvec_page_state(page, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
 	}
-	__unlock_page_memcg(memcg);
+	unlock_page_memcg(page);
 	return ret;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


