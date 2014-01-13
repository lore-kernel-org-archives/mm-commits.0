From: akpm@linux-foundation.org
Subject: [merged] mm-blk-mq-uses-page-list-incorrectly.patch removed from
 -mm tree
Date: Mon, 13 Jan 2014 13:21:45 -0800
Message-ID: <52d458e9.gB1LdVdMwUbo3jm2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaAMVVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 16:21:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kirill.shutemov@linux.intel.com, axboe@kernel.dk, dave.hansen@linux.intel.com

Subject: [merged] mm-blk-mq-uses-page-list-incorrectly.patch removed from -mm tree
To: dave.hansen@linux.intel.com,axboe@kernel.dk,kirill.shutemov@linux.intel.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 13:21:45 -0800


The patch titled
     Subject: mm: blk-mq: uses page->list incorrectly
has been removed from the -mm tree.  Its filename was
     mm-blk-mq-uses-page-list-incorrectly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: blk-mq: uses page->list incorrectly

'struct page' has two list_head fields: 'lru' and 'list'.  Conveniently,
they are unioned together.  This means that code can use them
interchangably, which gets horribly confusing.

The blk-mq made the logical decision to try to use page->list.  But, that
field was actually introduced just for the slub code.  ->lru is the right
field to use outside of slab/slub.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-mq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN block/blk-mq.c~mm-blk-mq-uses-page-list-incorrectly block/blk-mq.c
--- a/block/blk-mq.c~mm-blk-mq-uses-page-list-incorrectly
+++ a/block/blk-mq.c
@@ -1091,8 +1091,8 @@ static void blk_mq_free_rq_map(struct bl
 	struct page *page;
 
 	while (!list_empty(&hctx->page_list)) {
-		page = list_first_entry(&hctx->page_list, struct page, list);
-		list_del_init(&page->list);
+		page = list_first_entry(&hctx->page_list, struct page, lru);
+		list_del_init(&page->lru);
 		__free_pages(page, page->private);
 	}
 
@@ -1156,7 +1156,7 @@ static int blk_mq_init_rq_map(struct blk
 			break;
 
 		page->private = this_order;
-		list_add_tail(&page->list, &hctx->page_list);
+		list_add_tail(&page->lru, &hctx->page_list);
 
 		p = page_address(page);
 		entries_per_page = order_to_size(this_order) / rq_size;
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-add-overcommit_kbytes-sysctl-variable.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
mm-print-more-details-for-bad_page.patch
mm-print-more-details-for-bad_page-fix.patch
linux-next.patch

