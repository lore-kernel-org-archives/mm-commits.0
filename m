From: akpm@linux-foundation.org
Subject: + swapfile-avoid-null-pointer-dereference-in-swapon-when-s_bdev-is-null.patch added to -mm tree
Date: Tue, 29 Sep 2009 12:16:39 -0700
Message-ID: <200909291916.n8TJGdYE004178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbZI2TQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sjayaraman@suse.de, hugh.dickins@tiscali.co.uk, jens.axboe@oracle.com


The patch titled
     swapfile: avoid NULL pointer dereference in swapon when s_bdev is NULL
has been added to the -mm tree.  Its filename is
     swapfile-avoid-null-pointer-dereference-in-swapon-when-s_bdev-is-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

swapfile-avoid-null-pointer-dereference-in-swapon-when-s_bdev-is-null.patch

