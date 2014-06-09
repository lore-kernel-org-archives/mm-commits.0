From: akpm@linux-foundation.org
Subject: [merged]
 lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:40:36 -0700
Message-ID: <53960db4.jthz8+oHMfyPutCe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFITkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, catalin.marinas@arm.com

Subject: [merged] lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch removed from -mm tree
To: catalin.marinas@arm.com,hannes@cmpxchg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:40:36 -0700


The patch titled
     Subject: lib/radix-tree.c: update the kmemleak stack trace for radix tree allocations
has been removed from the -mm tree.  Its filename was
     lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

