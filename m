From: akpm@linux-foundation.org
Subject: [merged] readahead-reduce-unnecessary-mmap_miss-increases.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:46 -0700
Message-ID: <201105252028.p4PKS9vh014651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab1EYU2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, fengguang.wu@intel.com, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     readahead: reduce unnecessary mmap_miss increases
has been removed from the -mm tree.  Its filename was
     readahead-reduce-unnecessary-mmap_miss-increases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: reduce unnecessary mmap_miss increases
From: Andi Kleen <ak@linux.intel.com>

The original INT_MAX is too large, reduce it to

- avoid unnecessarily dirtying/bouncing the cache line

- restore mmap read-around faster on changed access pattern

Background: in the mosbench exim benchmark which does multi-threaded page
faults on shared struct file, the ra->mmap_miss updates are found to cause
excessive cache line bouncing on tmpfs.  The ra state updates are needless
for tmpfs because it actually disabled readahead totally
(shmem_backing_dev_info.ra_pages == 0).

Tested-by: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~readahead-reduce-unnecessary-mmap_miss-increases mm/filemap.c
--- a/mm/filemap.c~readahead-reduce-unnecessary-mmap_miss-increases
+++ a/mm/filemap.c
@@ -1566,7 +1566,8 @@ static void do_sync_mmap_readahead(struc
 		return;
 	}
 
-	if (ra->mmap_miss < INT_MAX)
+	/* Avoid banging the cache line if not needed */
+	if (ra->mmap_miss < MMAP_LOTSAMISS * 10)
 		ra->mmap_miss++;
 
 	/*
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch

