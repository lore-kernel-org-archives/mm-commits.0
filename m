Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1336C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97151610E6
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347808AbhIBVyp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347864AbhIBVy0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB54C610D2;
        Thu,  2 Sep 2021 21:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619608;
        bh=One6ca/+rOEehmgvE6X2XpYQexkqM3adGMXwLS7hwX0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZpTFDjmNt1MAi0oChaXBKze9RBLCMgP+LprLRhB/kkUgdkgO9BiVPeVgd5MZ3iIj7
         v0op1uhxVSkZGrkYGASeYN3dB4l8iVljCJDSbCqouff001YLG6/uz0Z2P03Yv72ylE
         IIz37+bjVfePGsnEqZmGDRUi5W2Q5dXOR4V0oXaA=
Date:   Thu, 02 Sep 2021 14:53:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, tj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 066/212] writeback: memcg: simplify
 cgroup_writeback_by_id
Message-ID: <20210902215327.cFSNXjGv5%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: writeback: memcg: simplify cgroup_writeback_by_id

Currently cgroup_writeback_by_id calls mem_cgroup_wb_stats() to get dirty
pages for a memcg.  However mem_cgroup_wb_stats() does a lot more than
just get the number of dirty pages.  Just directly get the number of dirty
pages instead of calling mem_cgroup_wb_stats().  Also
cgroup_writeback_by_id() is only called for best-effort dirty flushing, so
remove the unused 'nr' parameter and no need to explicitly flush memcg
stats.

Link: https://lkml.kernel.org/r/20210722182627.2267368-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c          |   20 +++++++++-----------
 include/linux/memcontrol.h |   15 +++++++++++++++
 include/linux/writeback.h  |    2 +-
 mm/memcontrol.c            |   13 +------------
 4 files changed, 26 insertions(+), 24 deletions(-)

--- a/fs/fs-writeback.c~writeback-memcg-simplify-cgroup_writeback_by_id
+++ a/fs/fs-writeback.c
@@ -1039,20 +1039,20 @@ restart:
  * cgroup_writeback_by_id - initiate cgroup writeback from bdi and memcg IDs
  * @bdi_id: target bdi id
  * @memcg_id: target memcg css id
- * @nr: number of pages to write, 0 for best-effort dirty flushing
  * @reason: reason why some writeback work initiated
  * @done: target wb_completion
  *
  * Initiate flush of the bdi_writeback identified by @bdi_id and @memcg_id
  * with the specified parameters.
  */
-int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr,
+int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 			   enum wb_reason reason, struct wb_completion *done)
 {
 	struct backing_dev_info *bdi;
 	struct cgroup_subsys_state *memcg_css;
 	struct bdi_writeback *wb;
 	struct wb_writeback_work *work;
+	unsigned long dirty;
 	int ret;
 
 	/* lookup bdi and memcg */
@@ -1081,24 +1081,22 @@ int cgroup_writeback_by_id(u64 bdi_id, i
 	}
 
 	/*
-	 * If @nr is zero, the caller is attempting to write out most of
+	 * The caller is attempting to write out most of
 	 * the currently dirty pages.  Let's take the current dirty page
 	 * count and inflate it by 25% which should be large enough to
 	 * flush out most dirty pages while avoiding getting livelocked by
 	 * concurrent dirtiers.
+	 *
+	 * BTW the memcg stats are flushed periodically and this is best-effort
+	 * estimation, so some potential error is ok.
 	 */
-	if (!nr) {
-		unsigned long filepages, headroom, dirty, writeback;
-
-		mem_cgroup_wb_stats(wb, &filepages, &headroom, &dirty,
-				      &writeback);
-		nr = dirty * 10 / 8;
-	}
+	dirty = memcg_page_state(mem_cgroup_from_css(memcg_css), NR_FILE_DIRTY);
+	dirty = dirty * 10 / 8;
 
 	/* issue the writeback work */
 	work = kzalloc(sizeof(*work), GFP_NOWAIT | __GFP_NOWARN);
 	if (work) {
-		work->nr_pages = nr;
+		work->nr_pages = dirty;
 		work->sync_mode = WB_SYNC_NONE;
 		work->range_cyclic = 1;
 		work->reason = reason;
--- a/include/linux/memcontrol.h~writeback-memcg-simplify-cgroup_writeback_by_id
+++ a/include/linux/memcontrol.h
@@ -955,6 +955,16 @@ static inline void mod_memcg_state(struc
 	local_irq_restore(flags);
 }
 
+static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+{
+	long x = READ_ONCE(memcg->vmstats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
@@ -1391,6 +1401,11 @@ static inline void mod_memcg_state(struc
 {
 }
 
+static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+{
+	return 0;
+}
+
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
--- a/include/linux/writeback.h~writeback-memcg-simplify-cgroup_writeback_by_id
+++ a/include/linux/writeback.h
@@ -218,7 +218,7 @@ void wbc_attach_and_unlock_inode(struct
 void wbc_detach_inode(struct writeback_control *wbc);
 void wbc_account_cgroup_owner(struct writeback_control *wbc, struct page *page,
 			      size_t bytes);
-int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr_pages,
+int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 			   enum wb_reason reason, struct wb_completion *done);
 void cgroup_writeback_umount(void);
 bool cleanup_offline_cgwb(struct bdi_writeback *wb);
--- a/mm/memcontrol.c~writeback-memcg-simplify-cgroup_writeback_by_id
+++ a/mm/memcontrol.c
@@ -646,17 +646,6 @@ void __mod_memcg_state(struct mem_cgroup
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
-static unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
-{
-	long x = READ_ONCE(memcg->vmstats.state[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item. */
 static unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 {
 	long x = 0;
@@ -4668,7 +4657,7 @@ void mem_cgroup_flush_foreign(struct bdi
 		    atomic_read(&frn->done.cnt) == 1) {
 			frn->at = 0;
 			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
-			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id, 0,
+			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
 					       WB_REASON_FOREIGN_FLUSH,
 					       &frn->done);
 		}
_
