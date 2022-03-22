Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05DEC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiCVVrY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiCVVrK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E5E614B
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E9BB81DAF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03621C340EE;
        Tue, 22 Mar 2022 21:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985539;
        bh=EioTn1AYwKLEaPNTWCWOFb/pRNMlD4WN2TI+GFaUeJ8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=p96dNi2j6jLI67sQUAX7c5LC5z00zLvjrTTSJuis3p7GDjDQztcYow2qy+ILvXOiy
         Wr3ydweFPqsnu5NvRROkN3vX3mbGYt4TFL7ecbrUyui3Ti6WnV8V0hBYTiEbgJDuFn
         z87ieqAjqZ6WzTyqOgi44uQxT8LCRANCrsyGbi6U=
Date:   Tue, 22 Mar 2022 14:45:38 -0700
To:     willy@infradead.org, neilb@suse.de, jack@suse.de,
        djwong@kernel.org, david@fromorbit.com, hughd@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 140/227] mm/fs: delete PF_SWAPWRITE
Message-Id: <20220322214539.03621C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm/fs: delete PF_SWAPWRITE

PF_SWAPWRITE has been redundant since v3.2 commit ee72886d8ed5 ("mm:
vmscan: do not writeback filesystem pages in direct reclaim").

Coincidentally, NeilBrown's current patch "remove inode_congested()"
deletes may_write_to_inode(), which appeared to be the one function which
took notice of PF_SWAPWRITE.  But if you study the old logic, and the
conditions under which may_write_to_inode() was called, you discover that
flag and function have been pointless for a decade.

Link: https://lkml.kernel.org/r/75e80e7-742d-e3bd-531-614db8961e4@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    3 ---
 fs/xfs/libxfs/xfs_btree.c |    2 +-
 include/linux/sched.h     |    1 -
 mm/migrate.c              |    7 -------
 mm/vmscan.c               |    8 ++------
 5 files changed, 3 insertions(+), 18 deletions(-)

--- a/fs/fs-writeback.c~mm-fs-delete-pf_swapwrite
+++ a/fs/fs-writeback.c
@@ -2197,7 +2197,6 @@ void wb_workfn(struct work_struct *work)
 	long pages_written;
 
 	set_worker_desc("flush-%s", bdi_dev_name(wb->bdi));
-	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
 		   !test_bit(WB_registered, &wb->state))) {
@@ -2226,8 +2225,6 @@ void wb_workfn(struct work_struct *work)
 		wb_wakeup(wb);
 	else if (wb_has_dirty_io(wb) && dirty_writeback_interval)
 		wb_wakeup_delayed(wb);
-
-	current->flags &= ~PF_SWAPWRITE;
 }
 
 /*
--- a/fs/xfs/libxfs/xfs_btree.c~mm-fs-delete-pf_swapwrite
+++ a/fs/xfs/libxfs/xfs_btree.c
@@ -2818,7 +2818,7 @@ xfs_btree_split_worker(
 	 * in any way.
 	 */
 	if (args->kswapd)
-		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+		new_pflags |= PF_MEMALLOC | PF_KSWAPD;
 
 	current_set_flags_nested(&pflags, new_pflags);
 	xfs_trans_set_context(args->cur->bc_tp);
--- a/include/linux/sched.h~mm-fs-delete-pf_swapwrite
+++ a/include/linux/sched.h
@@ -1689,7 +1689,6 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
 #define PF_MEMALLOC_PIN		0x10000000	/* Allocation context constrained to zones which allow long term pinning. */
--- a/mm/migrate.c~mm-fs-delete-pf_swapwrite
+++ a/mm/migrate.c
@@ -1350,7 +1350,6 @@ int migrate_pages(struct list_head *from
 	bool is_thp = false;
 	struct page *page;
 	struct page *page2;
-	int swapwrite = current->flags & PF_SWAPWRITE;
 	int rc, nr_subpages;
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(thp_split_pages);
@@ -1359,9 +1358,6 @@ int migrate_pages(struct list_head *from
 
 	trace_mm_migrate_pages_start(mode, reason);
 
-	if (!swapwrite)
-		current->flags |= PF_SWAPWRITE;
-
 thp_subpage_migration:
 	for (pass = 0; pass < 10 && (retry || thp_retry); pass++) {
 		retry = 0;
@@ -1516,9 +1512,6 @@ out:
 	trace_mm_migrate_pages(nr_succeeded, nr_failed_pages, nr_thp_succeeded,
 			       nr_thp_failed, nr_thp_split, mode, reason);
 
-	if (!swapwrite)
-		current->flags &= ~PF_SWAPWRITE;
-
 	if (ret_succeeded)
 		*ret_succeeded = nr_succeeded;
 
--- a/mm/vmscan.c~mm-fs-delete-pf_swapwrite
+++ a/mm/vmscan.c
@@ -4457,7 +4457,7 @@ static int kswapd(void *p)
 	 * us from recursively trying to free more memory as we're
 	 * trying to free the first piece of memory in the first place).
 	 */
-	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+	tsk->flags |= PF_MEMALLOC | PF_KSWAPD;
 	set_freezable();
 
 	WRITE_ONCE(pgdat->kswapd_order, 0);
@@ -4508,7 +4508,7 @@ kswapd_try_sleep:
 			goto kswapd_try_sleep;
 	}
 
-	tsk->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD);
+	tsk->flags &= ~(PF_MEMALLOC | PF_KSWAPD);
 
 	return 0;
 }
@@ -4749,11 +4749,8 @@ static int __node_reclaim(struct pglist_
 	fs_reclaim_acquire(sc.gfp_mask);
 	/*
 	 * We need to be able to allocate from the reserves for RECLAIM_UNMAP
-	 * and we also need to be able to write out pages for RECLAIM_WRITE
-	 * and RECLAIM_UNMAP.
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
-	p->flags |= PF_SWAPWRITE;
 	set_task_reclaim_state(p, &sc.reclaim_state);
 
 	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages) {
@@ -4767,7 +4764,6 @@ static int __node_reclaim(struct pglist_
 	}
 
 	set_task_reclaim_state(p, NULL);
-	current->flags &= ~PF_SWAPWRITE;
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc.gfp_mask);
 	psi_memstall_leave(&pflags);
_
