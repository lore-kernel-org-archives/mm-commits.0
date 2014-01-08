From: akpm@linux-foundation.org
Subject: + mm-blk-mq-uses-page-list-incorrectly.patch added to -mm tree
Date: Wed, 08 Jan 2014 15:17:34 -0800
Message-ID: <52cddc8e.lIKZ1J8dXzHyABn4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaAHXRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 18:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kirill.shutemov@linux.intel.com, axboe@kernel.dk, dave.hansen@linux.intel.com

Subject: + mm-blk-mq-uses-page-list-incorrectly.patch added to -mm tree
To: dave.hansen@linux.intel.com,axboe@kernel.dk,kirill.shutemov@linux.intel.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 15:17:34 -0800


The patch titled
     Subject: mm: blk-mq: uses page->list incorrectly
has been added to the -mm tree.  Its filename is
     mm-blk-mq-uses-page-list-incorrectly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-blk-mq-uses-page-list-incorrectly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-blk-mq-uses-page-list-incorrectly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1050,8 +1050,8 @@ static void blk_mq_free_rq_map(struct bl
 	struct page *page;
 
 	while (!list_empty(&hctx->page_list)) {
-		page = list_first_entry(&hctx->page_list, struct page, list);
-		list_del_init(&page->list);
+		page = list_first_entry(&hctx->page_list, struct page, lru);
+		list_del_init(&page->lru);
 		__free_pages(page, page->private);
 	}
 
@@ -1115,7 +1115,7 @@ static int blk_mq_init_rq_map(struct blk
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
mm-blk-mq-uses-page-list-incorrectly.patch

