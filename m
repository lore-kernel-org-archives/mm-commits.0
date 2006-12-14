From: akpm@osdl.org
Subject: + fix-for-shmem_truncate_range-bug_on.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:31:16 -0800
Message-ID: <200612140031.kBE0VG8e026307@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbWLNAcT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:32:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, hugh@veritas.com, stable@kernel.org


The patch titled
     Fix for shmem_truncate_range() BUG_ON()
has been added to the -mm tree.  Its filename is
     fix-for-shmem_truncate_range-bug_on.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 1 deletion(-)

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
fix-for-shmem_truncate_range-bug_on.patch

