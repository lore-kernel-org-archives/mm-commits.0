From: akpm@linux-foundation.org
Subject: [merged] mm-remove-misleading-alignment-claims.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:33:02 -0800
Message-ID: <20180201193302.fdELYrwQI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754563AbeBATdD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:33:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm: remove misleading alignment claims
has been removed from the -mm tree.  Its filename was
     mm-remove-misleading-alignment-claims.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: mm: remove misleading alignment claims

The "third double word block" isn't on 32-bit systems.  The layout looks
like this:

	unsigned long flags;
	struct address_space *mapping
	pgoff_t index;
	atomic_t _mapcount;
	atomic_t _refcount;

which is 32 bytes on 64-bit, but 20 bytes on 32-bit.  Nobody is trying to
use the fact that it's double-word aligned today, so just remove the
misleading claims.

Link: http://lkml.kernel.org/r/20171220155552.15884-4-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN include/linux/mm_types.h~mm-remove-misleading-alignment-claims include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-remove-misleading-alignment-claims
+++ a/include/linux/mm_types.h
@@ -33,11 +33,11 @@ struct hmm;
  * a page, though if it is a pagecache page, rmap structures can tell us
  * who is mapping it.
  *
- * The objects in struct page are organized in double word blocks in
- * order to allows us to use atomic double word operations on portions
- * of struct page. That is currently only used by slub but the arrangement
- * allows the use of atomic double word operations on the flags/mapping
- * and lru list pointers also.
+ * SLUB uses cmpxchg_double() to atomically update its freelist and
+ * counters.  That requires that freelist & counters be adjacent and
+ * double-word aligned.  We align all struct pages to double-word
+ * boundaries, and ensure that 'freelist' is aligned within the
+ * struct.
  */
 #ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
 #define _struct_page_alignment	__aligned(2 * sizeof(unsigned long))
@@ -113,8 +113,6 @@ struct page {
 	};
 
 	/*
-	 * Third double word block
-	 *
 	 * WARNING: bit 0 of the first word encode PageTail(). That means
 	 * the rest users of the storage space MUST NOT use the bit to
 	 * avoid collision and false-positive PageTail().
@@ -175,7 +173,6 @@ struct page {
 #endif
 	};
 
-	/* Remainder is not double word aligned */
 	union {
 		unsigned long private;		/* Mapping-private opaque data:
 					 	 * usually used for buffer_heads
_

Patches currently in -mm which might be from mawilcox@microsoft.com are


