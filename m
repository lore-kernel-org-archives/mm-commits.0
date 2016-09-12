From: akpm@linux-foundation.org
Subject: + mm-fix-the-page_swap_info-bug_on-check.patch added to -mm tree
Date: Mon, 12 Sep 2016 14:23:43 -0700
Message-ID: <57d71cdf.St4ED2BJapbhWRkm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50365 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbcILVXo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 17:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santosh.shilimkar@oracle.com, a.p.zijlstra@chello.nl, axboe@fb.com, davem@davemloft.net, hughd@google.com, joe@perches.com, mgorman@suse.de, mhocko@suse.com, riel@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix the page_swap_info() BUG_ON check
has been added to the -mm tree.  Its filename is
     mm-fix-the-page_swap_info-bug_on-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-page_swap_info-bug_on-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-page_swap_info-bug_on-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: mm: fix the page_swap_info() BUG_ON check

62c230bc1790 ("mm: add support for a filesystem to activate swap files and
use direct_IO for writing swap pages") replaced swap_aops dirty hook from
__set_page_dirty_no_writeback() to swap_set_page_dirty().  As such for
normal cases without these special SWP flags code path falls back to
__set_page_dirty_no_writeback() so behaviour is expected to be same as
before.

But swap_set_page_dirty() makes use of helper page_swap_info() to get
sis(swap_info_struct) to check for the flags like SWP_FILE, SWP_BLKDEV etc
as desired for those features.  This helper has
BUG_ON(!PageSwapCache(page)) which is racy and safe only for
set_page_dirty_lock() path.  For set_page_dirty() path which is often
needed for cases to be called from irq context, kswapd() can togele the
flag behind the back while the call is getting executed when system is low
on memory and heavy swapping is ongoing.

This ends up with undesired kernel panic.  Patch just moves the check
outside the helper to its users appropriately to fix kernel panic for the
described path.  Couple of users of helpers already take care of SwapCache
condition so I skipped them.

Link: http://lkml.kernel.org/r/1473460718-31013-1-git-send-email-santosh.shilimkar@oracle.com
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jens Axboe <axboe@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c  |    3 +++
 mm/swapfile.c |    1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_io.c~mm-fix-the-page_swap_info-bug_on-check mm/page_io.c
--- a/mm/page_io.c~mm-fix-the-page_swap_info-bug_on-check
+++ a/mm/page_io.c
@@ -264,6 +264,7 @@ int __swap_writepage(struct page *page,
 	int ret;
 	struct swap_info_struct *sis = page_swap_info(page);
 
+	BUG_ON(!PageSwapCache(page));
 	if (sis->flags & SWP_FILE) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
@@ -337,6 +338,7 @@ int swap_readpage(struct page *page)
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
 
+	BUG_ON(!PageSwapCache(page));
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageUptodate(page), page);
 	if (frontswap_load(page) == 0) {
@@ -386,6 +388,7 @@ int swap_set_page_dirty(struct page *pag
 
 	if (sis->flags & SWP_FILE) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
+		BUG_ON(!PageSwapCache(page));
 		return mapping->a_ops->set_page_dirty(page);
 	} else {
 		return __set_page_dirty_no_writeback(page);
diff -puN mm/swapfile.c~mm-fix-the-page_swap_info-bug_on-check mm/swapfile.c
--- a/mm/swapfile.c~mm-fix-the-page_swap_info-bug_on-check
+++ a/mm/swapfile.c
@@ -2717,7 +2717,6 @@ int swapcache_prepare(swp_entry_t entry)
 struct swap_info_struct *page_swap_info(struct page *page)
 {
 	swp_entry_t swap = { .val = page_private(page) };
-	BUG_ON(!PageSwapCache(page));
 	return swap_info[swp_type(swap)];
 }
 
_

Patches currently in -mm which might be from santosh.shilimkar@oracle.com are

mm-fix-the-page_swap_info-bug_on-check.patch

