From: akpm@linux-foundation.org
Subject: [merged] writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:10 -0800
Message-ID: <201101142249.p0EMn0ET005251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734Ab1ANWtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     writeback: avoid unnecessary determine_dirtyable_memory call
has been removed from the -mm tree.  Its filename was
     writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: avoid unnecessary determine_dirtyable_memory call
From: Minchan Kim <minchan.kim@gmail.com>

I think determine_dirtyable_memory() is a rather costly function since it
need many atomic reads for gathering zone/global page state.  But when we
use vm_dirty_bytes && dirty_background_bytes, we don't need that costly
calculation.

This patch eliminates such unnecessary overhead.

NOTE : newly added if condition might add overhead in normal path.
       But it should be _really_ small because anyway we need the
       access both vm_dirty_bytes and dirty_background_bytes so it is
       likely to hit the cache.

[akpm@linux-foundation.org: fix used-uninitialised warning]
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-avoid-unnecessary-determine_dirtyable_memory-call mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-avoid-unnecessary-determine_dirtyable_memory-call
+++ a/mm/page-writeback.c
@@ -410,9 +410,12 @@ void global_dirty_limits(unsigned long *
 {
 	unsigned long background;
 	unsigned long dirty;
-	unsigned long available_memory = determine_dirtyable_memory();
+	unsigned long uninitialized_var(available_memory);
 	struct task_struct *tsk;
 
+	if (!vm_dirty_bytes || !dirty_background_bytes)
+		available_memory = determine_dirtyable_memory();
+
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
 	else
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-vmap-area-cache.patch
mm-vmap-area-cache-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

