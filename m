From: akpm@linux-foundation.org
Subject: [merged] swapfile-avoid-null-pointer-dereference-in-swapon-when-s_bdev-is-null.patch removed from -mm tree
Date: Thu, 01 Oct 2009 11:44:46 -0700
Message-ID: <200910011844.n91IikB4013663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843AbZJASo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 14:44:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sjayaraman@suse.de, hugh.dickins@tiscali.co.uk, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     swapfile: avoid NULL pointer dereference in swapon when s_bdev is NULL
has been removed from the -mm tree.  Its filename was
     swapfile-avoid-null-pointer-dereference-in-swapon-when-s_bdev-is-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: avoid NULL pointer dereference in swapon when s_bdev is NULL
From: Suresh Jayaraman <sjayaraman@suse.de>

While testing Swap over NFS patchset, I noticed an oops that was triggered
during swapon.  Investigating further, the NULL pointer deference is due
to the SSD device check/optimization in the swapon code that assumes
s_bdev could never be NULL.

inode->i_sb->s_bdev could be NULL in a few cases.  For e.g.  one such case
is loopback NFS mount, there could be others as well.  Fix this by
ensuring s_bdev is not NULL before we try to deference s_bdev.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~swapfile-avoid-null-pointer-dereference-in-swapon-when-s_bdev-is-null mm/swapfile.c
--- a/mm/swapfile.c~swapfile-avoid-null-pointer-dereference-in-swapon-when-s_bdev-is-null
+++ a/mm/swapfile.c
@@ -1974,12 +1974,14 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 	}
 
-	if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
-		p->flags |= SWP_SOLIDSTATE;
-		p->cluster_next = 1 + (random32() % p->highest_bit);
+	if (p->bdev) {
+		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+			p->flags |= SWP_SOLIDSTATE;
+			p->cluster_next = 1 + (random32() % p->highest_bit);
+		}
+		if (discard_swap(p) == 0)
+			p->flags |= SWP_DISCARDABLE;
 	}
-	if (discard_swap(p) == 0)
-		p->flags |= SWP_DISCARDABLE;
 
 	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
_

Patches currently in -mm which might be from sjayaraman@suse.de are

linux-next.patch

