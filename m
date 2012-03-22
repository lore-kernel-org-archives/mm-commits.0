From: akpm@linux-foundation.org
Subject: [merged] mm-update-stale-lock-ordering-comment-for-memory-failurec.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:49 -0700
Message-ID: <20120322201849.5F169A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48025 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab2CVUSv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:51 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so134901wej.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update stale lock ordering comment for memory-failure.c
has been removed from the -mm tree.  Its filename was
     mm-update-stale-lock-ordering-comment-for-memory-failurec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: mm: update stale lock ordering comment for memory-failure.c

When i_mmap_lock changed to a mutex the locking order in memory failure
was changed to take the sleeping lock first.  But the big fat mm lock
ordering comment (BFMLO) wasn't updated.  Do this here.

Pointed out by Andrew.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-update-stale-lock-ordering-comment-for-memory-failurec mm/filemap.c
--- a/mm/filemap.c~mm-update-stale-lock-ordering-comment-for-memory-failurec
+++ a/mm/filemap.c
@@ -101,9 +101,8 @@
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
  *
- *  (code doesn't rely on that order, so you could switch it around)
- *  ->tasklist_lock             (memory_failure, collect_procs_ao)
- *    ->i_mmap_mutex
+ * ->i_mmap_mutex
+ *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
 /*
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
brlocks-lglocks-cleanups.patch
brlocks-lglocks-cleanups-fix.patch

