From: akpm@linux-foundation.org
Subject: +
 lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch added
 to -mm tree
Date: Fri, 02 May 2014 15:49:15 -0700
Message-ID: <536420eb.1u4XXMhF1XZscURu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaEBWtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, catalin.marinas@arm.com

Subject: + lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch added to -mm tree
To: catalin.marinas@arm.com,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:49:15 -0700


The patch titled
     Subject: lib/radix-tree.c: update the kmemleak stack trace for radix tree allocations
has been added to the -mm tree.  Its filename is
     lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch

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
Subject: lib/radix-tree.c: update the kmemleak stack trace for radix tree allocations

Since radix_tree_preload() stack trace is not always useful for debugging
an actual radix tree memory leak, this patch updates the kmemleak
allocation stack trace in the radix_tree_node_alloc() function.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN lib/radix-tree.c~lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations lib/radix-tree.c
--- a/lib/radix-tree.c~lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations
+++ a/lib/radix-tree.c
@@ -27,6 +27,7 @@
 #include <linux/radix-tree.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
+#include <linux/kmemleak.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/string.h>
@@ -200,6 +201,11 @@ radix_tree_node_alloc(struct radix_tree_
 			rtp->nodes[rtp->nr - 1] = NULL;
 			rtp->nr--;
 		}
+		/*
+		 * Update the allocation stack trace as this is more useful
+		 * for debugging.
+		 */
+		kmemleak_update_trace(ret);
 	}
 	if (ret == NULL)
 		ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
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

