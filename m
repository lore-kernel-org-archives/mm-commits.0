From: akpm@linux-foundation.org
Subject: +
 mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch added to
 -mm tree
Date: Fri, 02 May 2014 15:49:16 -0700
Message-ID: <536420ec.Wf6yX8J6uB7smB6x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaEBWtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com

Subject: + mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch added to -mm tree
To: catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:49:16 -0700


The patch titled
     Subject: mm/mempool.c: update the kmemleak stack trace for mempool allocations
has been added to the -mm tree.  Its filename is
     mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-kmemleakc-use-%u-to-print-checksum.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch
mm-call-kmemleak-directly-from-memblock_allocfree.patch
mm-postpone-the-disabling-of-kmemleak-early-logging.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch

