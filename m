From: akpm@linux-foundation.org
Subject: [patch 080/127] mm/page_io.c: replace some BUG_ON()s with
 VM_BUG_ON_PAGE()
Date: Fri, 07 Oct 2016 17:00:52 -0700
Message-ID: <57f83734./2lksbHJOLxfxyPI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39375 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbcJHAAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, axboe@fb.com, davem@davemloft.net, hughd@google.com, joe@perches.com, mgorman@suse.de, mhocko@suse.com, riel@redhat.com, santosh.shilimkar@oracle.com, viro@zeniv.linux.org.uk

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_io.c: replace some BUG_ON()s with VM_BUG_ON_PAGE()

So they are CONFIG_DEBUG_VM-only and more informative.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Joe Perches <joe@perches.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_io.c~mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page mm/page_io.c
--- a/mm/page_io.c~mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page
+++ a/mm/page_io.c
@@ -264,7 +264,7 @@ int __swap_writepage(struct page *page,
 	int ret;
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	BUG_ON(!PageSwapCache(page));
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	if (sis->flags & SWP_FILE) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
@@ -338,7 +338,7 @@ int swap_readpage(struct page *page)
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	BUG_ON(!PageSwapCache(page));
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageUptodate(page), page);
 	if (frontswap_load(page) == 0) {
@@ -388,7 +388,8 @@ int swap_set_page_dirty(struct page *pag
 
 	if (sis->flags & SWP_FILE) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
-		BUG_ON(!PageSwapCache(page));
+
+		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 		return mapping->a_ops->set_page_dirty(page);
 	} else {
 		return __set_page_dirty_no_writeback(page);
_
