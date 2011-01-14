From: akpm@linux-foundation.org
Subject: [merged] thp-use-compaction-for-all-allocation-orders.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:25 -0800
Message-ID: <201101142251.p0EMpF2P005488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab1ANWv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: use compaction for all allocation orders
has been removed from the -mm tree.  Its filename was
     thp-use-compaction-for-all-allocation-orders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: use compaction for all allocation orders
From: Andrea Arcangeli <aarcange@redhat.com>

It makes no sense not to enable compaction for small order pages as we
don't want to end up with bad order 2 allocations and good and graceful
order 9 allocations.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~thp-use-compaction-for-all-allocation-orders mm/compaction.c
--- a/mm/compaction.c~thp-use-compaction-for-all-allocation-orders
+++ a/mm/compaction.c
@@ -578,7 +578,7 @@ unsigned long try_to_compact_pages(struc
 	 * made because an assumption is made that the page allocator can satisfy
 	 * the "cheaper" orders without taking special steps
 	 */
-	if (order <= PAGE_ALLOC_COSTLY_ORDER || !may_enter_fs || !may_perform_io)
+	if (!order || !may_enter_fs || !may_perform_io)
 		return rc;
 
 	count_vm_event(COMPACTSTALL);
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

