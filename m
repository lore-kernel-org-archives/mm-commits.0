From: akpm@linux-foundation.org
Subject: + ext3-fix-ext3-block-reservation-early-enospc-issue.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:23:19 -0700
Message-ID: <200808282323.m7SNNKjb019835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYH1XXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com, tytso@mit.edu


The patch titled
     ext3: fix ext3  block reservation early ENOSPC issue
has been added to the -mm tree.  Its filename is
     ext3-fix-ext3-block-reservation-early-enospc-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix ext3  block reservation early ENOSPC issue
From: Mingming Cao <cmm@us.ibm.com>

We could run into ENOSPC error on ext3, even when there is free blocks on
the filesystem.

The problem is triggered in the case the goal block group has 0 free
blocks , and the rest block groups are skipped due to the check of
"free_blocks < windowsz/2".  Current code could fall back to non
reservation allocation to prevent early ENOSPC after examing all the block
groups with reservation on , but this code was bypassed if the reservation
window is turned off already, which is true in this case.

This patch fixed two issues:
1) We don't need to turn off block reservation if the goal block group has
0 free blocks left and continue search for the rest of block groups.

Current code the intention is to turn off the block reservation if the
goal allocation group has a few (some) free blocks left (not enough for
make the desired reservation window),to try to allocation in the goal
block group, to get better locality.  But if the goal blocks have 0 free
blocks, it should leave the block reservation on, and continues search for
the next block groups,rather than turn off block reservation completely.

2) we don't need to check the window size if the block reservation is off.

The problem was originally found and fixed in ext4.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/balloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext3/balloc.c~ext3-fix-ext3-block-reservation-early-enospc-issue fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-fix-ext3-block-reservation-early-enospc-issue
+++ a/fs/ext3/balloc.c
@@ -1547,6 +1547,7 @@ retry_alloc:
 	 * turn off reservation for this allocation
 	 */
 	if (my_rsv && (free_blocks < windowsz)
+		&& (free_blocks > 0)
 		&& (rsv_is_empty(&my_rsv->rsv_window)))
 		my_rsv = NULL;
 
@@ -1585,7 +1586,7 @@ retry_alloc:
 		 * free blocks is less than half of the reservation
 		 * window size.
 		 */
-		if (free_blocks <= (windowsz/2))
+		if (my_rsv && (free_blocks <= (windowsz/2)))
 			continue;
 
 		brelse(bitmap_bh);
_

Patches currently in -mm which might be from cmm@us.ibm.com are

origin.patch
vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails.patch
vmscan-set-try_to_release_pages-gfp_mask-to-0.patch
percpu-counters-clean-up-percpu_counter_sum_and_set-interface.patch
ext2-fix-ext2-block-reservation-early-enospc-issue.patch
ext3-fix-ext3-block-reservation-early-enospc-issue.patch

