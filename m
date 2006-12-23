From: akpm@osdl.org
Subject: - fix-for-shmem_truncate_range-bug_on.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:31 -0800
Message-ID: <200612230753.kBN7rVFn010130@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbWLWHyM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, hugh@veritas.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix for shmem_truncate_range() BUG_ON()
has been removed from the -mm tree.  Its filename was
     fix-for-shmem_truncate_range-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix for shmem_truncate_range() BUG_ON()
From: Badari Pulavarty <pbadari@us.ibm.com>

Ran into BUG() while doing madvise(REMOVE) testing.  If we are punching a
hole into shared memory segment using madvise(REMOVE) and the entire hole
is below the indirect blocks, we hit following assert.

	        BUG_ON(limit <= SHMEM_NR_DIRECT);

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/shmem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~fix-for-shmem_truncate_range-bug_on mm/shmem.c
--- a/mm/shmem.c~fix-for-shmem_truncate_range-bug_on
+++ a/mm/shmem.c
@@ -515,7 +515,12 @@ static void shmem_truncate_range(struct 
 			size = SHMEM_NR_DIRECT;
 		nr_swaps_freed = shmem_free_swp(ptr+idx, ptr+size);
 	}
-	if (!topdir)
+
+	/*
+	 * If there are no indirect blocks or we are punching a hole
+	 * below indirect blocks, nothing to be done.
+	 */
+	if (!topdir || (punch_hole && (limit <= SHMEM_NR_DIRECT)))
 		goto done2;
 
 	BUG_ON(limit <= SHMEM_NR_DIRECT);
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch

