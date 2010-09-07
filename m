From: akpm@linux-foundation.org
Subject: + swap-discard-while-swapping-only-if-swap_flag_discard.patch added to -mm tree
Date: Tue, 07 Sep 2010 13:32:19 -0700
Message-ID: <201009072032.o87KWJsn004441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758081Ab0IGUck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 16:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, James.Bottomley@hansenpartnership.com, hch@lst.de, jaxboe@fusionio.com, martin.petersen@oracle.com, nigel@tuxonice.net, stable@kernel.org, tj@kernel.org


The patch titled
     swap: discard while swapping only if SWAP_FLAG_DISCARD
has been added to the -mm tree.  Its filename is
     swap-discard-while-swapping-only-if-swap_flag_discard.patch

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
Subject: swap: discard while swapping only if SWAP_FLAG_DISCARD
From: Hugh Dickins <hughd@google.com>

Tests with recent firmware on Intel X25-M 80GB and OCZ Vertex 60GB SSDs
show a shift since I last tested in December: in part because of firmware
updates, in part because of the necessary move from barriers to awaiting
completion at the block layer.  While discard at swapon still shows as
slightly beneficial on both, discarding 1MB swap cluster when allocating
is now disadvanteous: adds 25% overhead on Intel, adds 230% on OCZ (YMMV).

Surrender: discard as presently implemented is more hindrance than help
for swap; but might prove useful on other devices, or with improvements. 
So continue to do the discard at swapon, but make discard while swapping
conditional on a SWAP_FLAG_DISCARD to sys_swapon() (which has been using
only the lower 16 bits of int flags).

We can add a --discard or -d to swapon(8), and a "discard" to swap in
/etc/fstab: matching the mount option for btrfs, ext4, fat, gfs2, nilfs2.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nigel Cunningham <nigel@tuxonice.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 ++-
 mm/swapfile.c        |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~swap-discard-while-swapping-only-if-swap_flag_discard include/linux/swap.h
--- a/include/linux/swap.h~swap-discard-while-swapping-only-if-swap_flag_discard
+++ a/include/linux/swap.h
@@ -19,6 +19,7 @@ struct bio;
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_PRIO_SHIFT	0
+#define SWAP_FLAG_DISCARD	0x10000 /* discard swap cluster after use */
 
 static inline int current_is_kswapd(void)
 {
@@ -142,7 +143,7 @@ struct swap_extent {
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
-	SWP_DISCARDABLE = (1 << 2),	/* blkdev supports discard */
+	SWP_DISCARDABLE = (1 << 2),	/* swapon+blkdev support discard */
 	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
diff -puN mm/swapfile.c~swap-discard-while-swapping-only-if-swap_flag_discard mm/swapfile.c
--- a/mm/swapfile.c~swap-discard-while-swapping-only-if-swap_flag_discard
+++ a/mm/swapfile.c
@@ -2047,7 +2047,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			p->flags |= SWP_SOLIDSTATE;
 			p->cluster_next = 1 + (random32() % p->highest_bit);
 		}
-		if (discard_swap(p) == 0)
+		if (discard_swap(p) == 0 && (swap_flags & SWAP_FLAG_DISCARD))
 			p->flags |= SWP_DISCARDABLE;
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-fix-swapin-race-condition.patch
swap-revert-special-hibernation-allocation.patch
swap-prevent-reuse-during-hibernation.patch
swap-do-not-send-discards-as-barriers.patch
swap-discard-while-swapping-only-if-swap_flag_discard.patch
mm-compaction-fix-compactpagefailed-counting.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2.patch
prio_tree-debugging-patch.patch

