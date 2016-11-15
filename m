From: akpm@linux-foundation.org
Subject: + mm-support-anonymous-stable-page.patch added to -mm tree
Date: Tue, 15 Nov 2016 15:59:04 -0800
Message-ID: <582ba148.L/PnRsolYQZRe+qq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbcKOX7F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 18:59:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, cheol.lee@lge.com, darrick.wong@oracle.com, hughd@google.com, yjay.kim@lge.com, mm-commits@vger.kernel.org


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

Link: http://lkml.kernel.org/r/20161111060644.GA24342@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: yjay.kim <yjay.kim@lge.com>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-support-anonymous-stable-page mm/swapfile.c
--- a/mm/swapfile.c~mm-support-anonymous-stable-page
+++ a/mm/swapfile.c
@@ -943,11 +943,21 @@ bool reuse_swap_page(struct page *page,
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
+			struct address_space *mapping;
+
+			mapping = page_mapping(page);
+			if (bdi_cap_stable_pages_required(
+					inode_to_bdi(mapping->host)))
+				return false;
 		}
 	}
+out:
 	return count <= 1;
 }
 
@@ -2180,6 +2190,7 @@ static struct swap_info_struct *alloc_sw
 static int claim_swapfile(struct swap_info_struct *p, struct inode *inode)
 {
 	int error;
+	struct address_space *swapper_space;
 
 	if (S_ISBLK(inode->i_mode)) {
 		p->bdev = bdgrab(I_BDEV(inode));
@@ -2202,6 +2213,9 @@ static int claim_swapfile(struct swap_in
 	} else
 		return -EINVAL;
 
+	swapper_space = &swapper_spaces[p->type];
+	swapper_space->host = inode;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-dont-steal-highatomic-pageblock.patch
mm-prevent-double-decrease-of-nr_reserved_highatomic.patch
mm-try-to-exhaust-highatomic-reserve-before-the-oom.patch
mm-make-unreserve-highatomic-functions-reliable.patch
mm-support-anonymous-stable-page.patch

