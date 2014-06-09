From: akpm@linux-foundation.org
Subject: [merged]
 mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:40:41 -0700
Message-ID: <53960db9.wIm/PPp3o/OV1Tz6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaFITkl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com

Subject: [merged] mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch removed from -mm tree
To: catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:41 -0700


The patch titled
     Subject: mm/mempool.c: update the kmemleak stack trace for mempool allocations
has been removed from the -mm tree.  Its filename was
     mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm/mempool.c: update the kmemleak stack trace for mempool allocations

When mempool_alloc() returns an existing pool object, kmemleak_alloc() is
no longer called and the stack trace corresponds to the original object
allocation.  This patch updates the kmemleak allocation stack trace for
such objects to make it more useful for debugging.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/mempool.c~mm-update-the-kmemleak-stack-trace-for-mempool-allocations mm/mempool.c
--- a/mm/mempool.c~mm-update-the-kmemleak-stack-trace-for-mempool-allocations
+++ a/mm/mempool.c
@@ -10,6 +10,7 @@
 
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/kmemleak.h>
 #include <linux/export.h>
 #include <linux/mempool.h>
 #include <linux/blkdev.h>
@@ -222,6 +223,11 @@ repeat_alloc:
 		spin_unlock_irqrestore(&pool->lock, flags);
 		/* paired with rmb in mempool_free(), read comment there */
 		smp_wmb();
+		/*
+		 * Update the allocation stack trace as this is more useful
+		 * for debugging.
+		 */
+		kmemleak_update_trace(element);
 		return element;
 	}
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

