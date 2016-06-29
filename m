From: akpm@linux-foundation.org
Subject: [merged] jbd2-get-rid-of-superfluous-__gfp_repeat.patch removed
 from -mm tree
Date: Tue, 28 Jun 2016 19:02:24 -0700
Message-ID: <57732c30.SBJtH1NmNxFrk80p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbcF2CCZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, jack@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: get rid of superfluous __GFP_REPEAT
has been removed from the -mm tree.  Its filename was
     jbd2-get-rid-of-superfluous-__gfp_repeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: jbd2: get rid of superfluous __GFP_REPEAT

jbd2_alloc is explicit about its allocation preferences wrt. the
allocation size. Sub page allocations go to the slab allocator
and larger are using either the page allocator or vmalloc. This
is all good but the logic is unnecessarily complex.

1) as per Ted, the vmalloc fallback is a left-over:

 : jbd2_alloc is only passed in the bh->b_size, which can't be PAGE_SIZE, so
 : the code path that calls vmalloc() should never get called.  When we
 : conveted jbd2_alloc() to suppor sub-page size allocations in commit
 : d2eecb039368, there was an assumption that it could be called with a size
 : greater than PAGE_SIZE, but that's certaily not true today.

Moreover vmalloc allocation might even lead to a deadlock because the
callers expect GFP_NOFS context while vmalloc is GFP_KERNEL.

2) __GFP_REPEAT for requests <= PAGE_ALLOC_COSTLY_ORDER is ignored
   since the flag was introduced.

Let's simplify the code flow and use the slab allocator for sub-page
requests and the page allocator for others.  Even though order > 0 is not
currently used as per above leave that option open.

Link: http://lkml.kernel.org/r/1464599699-30131-18-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-get-rid-of-superfluous-__gfp_repeat fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-get-rid-of-superfluous-__gfp_repeat
+++ a/fs/jbd2/journal.c
@@ -2329,18 +2329,10 @@ void *jbd2_alloc(size_t size, gfp_t flag
 
 	BUG_ON(size & (size-1)); /* Must be a power of 2 */
 
-	flags |= __GFP_REPEAT;
-	if (size == PAGE_SIZE)
-		ptr = (void *)__get_free_pages(flags, 0);
-	else if (size > PAGE_SIZE) {
-		int order = get_order(size);
-
-		if (order < 3)
-			ptr = (void *)__get_free_pages(flags, order);
-		else
-			ptr = vmalloc(size);
-	} else
+	if (size < PAGE_SIZE)
 		ptr = kmem_cache_alloc(get_slab(size), flags);
+	else
+		ptr = (void *)__get_free_pages(flags, get_order(size));
 
 	/* Check alignment; SLUB has gotten this wrong in the past,
 	 * and this can lead to user data corruption! */
@@ -2351,20 +2343,10 @@ void *jbd2_alloc(size_t size, gfp_t flag
 
 void jbd2_free(void *ptr, size_t size)
 {
-	if (size == PAGE_SIZE) {
-		free_pages((unsigned long)ptr, 0);
-		return;
-	}
-	if (size > PAGE_SIZE) {
-		int order = get_order(size);
-
-		if (order < 3)
-			free_pages((unsigned long)ptr, order);
-		else
-			vfree(ptr);
-		return;
-	}
-	kmem_cache_free(get_slab(size), ptr);
+	if (size < PAGE_SIZE)
+		kmem_cache_free(get_slab(size), ptr);
+	else
+		free_pages((unsigned long)ptr, get_order(size));
 };
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.com are

arm-get-rid-of-superfluous-__gfp_repeat.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch

