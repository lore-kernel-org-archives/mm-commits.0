From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unlikely-from-the-current_order-test.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:55 -0700
Message-ID: <51dc9a9b.AK72GAWhvulxQ+Ru%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3GIXTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-remove-unlikely-from-the-current_order-test.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:55 -0700


The patch titled
     Subject: mm/page_alloc.c: remove unlikely() from the current_order test
has been removed from the -mm tree.  Its filename was
     mm-remove-unlikely-from-the-current_order-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/page_alloc.c: remove unlikely() from the current_order test

In __rmqueue_fallback(), current_order loops down from MAX_ORDER - 1 to
the order passed.  MAX_ORDER is typically 11 and pageblock_order is
typically 9 on x86.  Integer division truncates, so pageblock_order / 2 is
4.  For the first eight iterations, it's guaranteed that current_order >=
pageblock_order / 2 if it even gets that far!

So just remove the unlikely(), it's completely bogus.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-remove-unlikely-from-the-current_order-test mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-unlikely-from-the-current_order-test
+++ a/mm/page_alloc.c
@@ -1046,7 +1046,7 @@ __rmqueue_fallback(struct zone *zone, in
 			 * MIGRATE_CMA areas.
 			 */
 			if (!is_migrate_cma(migratetype) &&
-			    (unlikely(current_order >= pageblock_order / 2) ||
+			    (current_order >= pageblock_order / 2 ||
 			     start_migratetype == MIGRATE_RECLAIMABLE ||
 			     page_group_by_mobility_disabled)) {
 				int pages;
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch

