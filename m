From: akpm@linux-foundation.org
Subject: [patch 11/51] z3fold: fix potential race in z3fold_reclaim_page
Date: Tue, 03 Oct 2017 16:14:47 -0700
Message-ID: <59d419e7.YpNmRvfwX3LfXmC6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXOs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vitalywool@gmail.com, ddstreet@ieee.org, Oleksiy.Avramchenko@sony.com

From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: fix potential race in z3fold_reclaim_page

It is possible that on a (partially) unsuccessful page reclaim, kref_put()
called in z3fold_reclaim_page() does not yield page release, but the page
is released shortly afterwards by another thread.  Then
z3fold_reclaim_page() would try to list_add() that (released) page again
which is obviously a bug.

To avoid that, spin_lock() has to be taken earlier, before the kref_put()
call mentioned earlier.

Link: http://lkml.kernel.org/r/20170913162937.bfff21c7d12b12a5f47639fd@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: <Oleksiy.Avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/z3fold.c~z3fold-fix-potential-race-in-z3fold_reclaim_page mm/z3fold.c
--- a/mm/z3fold.c~z3fold-fix-potential-race-in-z3fold_reclaim_page
+++ a/mm/z3fold.c
@@ -875,16 +875,18 @@ static int z3fold_reclaim_page(struct z3
 				goto next;
 		}
 next:
+		spin_lock(&pool->lock);
 		if (test_bit(PAGE_HEADLESS, &page->private)) {
 			if (ret == 0) {
+				spin_unlock(&pool->lock);
 				free_z3fold_page(page);
 				return 0;
 			}
 		} else if (kref_put(&zhdr->refcount, release_z3fold_page)) {
 			atomic64_dec(&pool->pages_nr);
+			spin_unlock(&pool->lock);
 			return 0;
 		}
-		spin_lock(&pool->lock);
 
 		/*
 		 * Add to the beginning of LRU.
_
