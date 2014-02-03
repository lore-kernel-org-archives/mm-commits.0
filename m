From: akpm@linux-foundation.org
Subject: [merged] mm-slb-fix-misleading-comments.patch removed from -mm
 tree
Date: Mon, 03 Feb 2014 12:17:09 -0800
Message-ID: <52eff945.Xf7V8VaOC+2BOeHA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCURK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 15:17:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mpm@selenic.com, cl@linux.com, dave.hansen@linux.intel.com

Subject: [merged] mm-slb-fix-misleading-comments.patch removed from -mm tree
To: dave.hansen@linux.intel.com,cl@linux.com,mpm@selenic.com,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 12:17:09 -0800


The patch titled
     Subject: mm: sl[uo]b: fix misleading comments
has been removed from the -mm tree.  Its filename was
     mm-slb-fix-misleading-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: sl[uo]b: fix misleading comments

On x86, SLUB creates and handles <=8192-byte allocations internally.  It
passes larger ones up to the allocator.  Saying "up to order 2" is, at
best, ambiguous.  Is that order-1?  Or (order-2 bytes)?  Make it more
clear.

SLOB commits a similar sin.  It *handles* page-size requests, but the
comment says that it passes up "all page size and larger requests".

SLOB also swaps around the order of the very-similarly-named
KMALLOC_SHIFT_HIGH and KMALLOC_SHIFT_MAX #defines.  Make it consistent
with the order of the other two allocators.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/slab.h~mm-slb-fix-misleading-comments include/linux/slab.h
--- a/include/linux/slab.h~mm-slb-fix-misleading-comments
+++ a/include/linux/slab.h
@@ -205,8 +205,8 @@ struct kmem_cache {
 
 #ifdef CONFIG_SLUB
 /*
- * SLUB allocates up to order 2 pages directly and otherwise
- * passes the request to the page allocator.
+ * SLUB directly allocates requests fitting in to an order-1 page
+ * (PAGE_SIZE*2).  Larger requests are passed to the page allocator.
  */
 #define KMALLOC_SHIFT_HIGH	(PAGE_SHIFT + 1)
 #define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT)
@@ -217,12 +217,12 @@ struct kmem_cache {
 
 #ifdef CONFIG_SLOB
 /*
- * SLOB passes all page size and larger requests to the page allocator.
+ * SLOB passes all requests larger than one page to the page allocator.
  * No kmalloc array is necessary since objects of different sizes can
  * be allocated from the same page.
  */
-#define KMALLOC_SHIFT_MAX	30
 #define KMALLOC_SHIFT_HIGH	PAGE_SHIFT
+#define KMALLOC_SHIFT_MAX	30
 #ifndef KMALLOC_SHIFT_LOW
 #define KMALLOC_SHIFT_LOW	3
 #endif
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are


