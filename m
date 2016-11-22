From: akpm@linux-foundation.org
Subject: + mm-support-anonymous-stable-page.patch added to -mm tree
Date: Mon, 21 Nov 2016 20:56:37 -0800
Message-ID: <5833d005.LwMPwMQIHAf99Fzb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbcKVE4i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2016 23:56:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, darrick.wong@oracle.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: support anonymous stable page
has been added to the -mm tree.  Its filename is
     mm-support-anonymous-stable-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-anonymous-stable-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-anonymous-stable-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: support anonymous stable page

For developemnt for zram-swap asynchronous writeback, I found strange
corruption of compressed page.  With investigation, it reveals currently
stable page doesn't support anonymous page.  IOW, reuse_swap_page can
reuse the page without waiting writeback completion so that it can corrupt
data during zram compression.  It can affect every swap device which
supports asynchronous writeback and CRC checking as well as zRAM.

Unfortunately, reuse_swap_page should be atomic so that we cannot wait on
writeback in there so the approach in this patch is simply return false if
we found it needs stable page.  Although it increases memory footprint
temporarily, it happens rarely and it should be reclaimed easily althoug
it happened.  Also, It would be better than waiting of IO completion,
which is critial path for application latency.

Link: http://lkml.kernel.org/r/20161120233015.GA14113@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 ++-
 mm/swapfile.c        |   20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~mm-support-anonymous-stable-page include/linux/swap.h
--- a/include/linux/swap.h~mm-support-anonymous-stable-page
+++ a/include/linux/swap.h
@@ -150,8 +150,9 @@ enum {
 	SWP_FILE	= (1 << 7),	/* set after swap_activate success */
 	SWP_AREA_DISCARD = (1 << 8),	/* single-time swap area discards */
 	SWP_PAGE_DISCARD = (1 << 9),	/* freed swap page-cluster discards */
+	SWP_STABLE_WRITES = (1 << 10),	/* no overwrite PG_writeback pages */
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 10),	/* refcount in scan_swap_map */
+	SWP_SCANNING	= (1 << 11),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff -puN mm/swapfile.c~mm-support-anonymous-stable-page mm/swapfile.c
--- a/mm/swapfile.c~mm-support-anonymous-stable-page
+++ a/mm/swapfile.c
@@ -943,11 +943,25 @@ bool reuse_swap_page(struct page *page,
 	count = page_trans_huge_mapcount(page, total_mapcount);
 	if (count <= 1 && PageSwapCache(page)) {
 		count += page_swapcount(page);
-		if (count == 1 && !PageWriteback(page)) {
+		if (count != 1)
+			goto out;
+		if (!PageWriteback(page)) {
 			delete_from_swap_cache(page);
 			SetPageDirty(page);
+		} else {
+			swp_entry_t entry;
+			struct swap_info_struct *p;
+
+			entry.val = page_private(page);
+			p = swap_info_get(entry);
+			if (p->flags & SWP_STABLE_WRITES) {
+				spin_unlock(&p->lock);
+				return false;
+			}
+			spin_unlock(&p->lock);
 		}
 	}
+out:
 	return count <= 1;
 }
 
@@ -2449,6 +2463,10 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = -ENOMEM;
 		goto bad_swap;
 	}
+
+	if (bdi_cap_stable_pages_required(inode_to_bdi(inode)))
+		p->flags |= SWP_STABLE_WRITES;
+
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		int cpu;
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-dont-steal-highatomic-pageblock.patch
mm-prevent-double-decrease-of-nr_reserved_highatomic.patch
mm-try-to-exhaust-highatomic-reserve-before-the-oom.patch
mm-make-unreserve-highatomic-functions-reliable.patch
mm-support-anonymous-stable-page.patch

