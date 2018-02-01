From: akpm@linux-foundation.org
Subject: [merged] mm-remove-reference-to-pg_buddy.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:33:17 -0800
Message-ID: <20180201193317.cxTzwyelp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754616AbeBATdT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:33:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm: remove reference to PG_buddy
has been removed from the -mm tree.  Its filename was
     mm-remove-reference-to-pg_buddy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: mm: remove reference to PG_buddy

PG_buddy doesn't exist any more.  It's called PageBuddy now.

Link: http://lkml.kernel.org/r/20171220155552.15884-9-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/mm_types.h~mm-remove-reference-to-pg_buddy include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-remove-reference-to-pg_buddy
+++ a/include/linux/mm_types.h
@@ -175,13 +175,13 @@ struct page {
 	};
 
 	union {
-		unsigned long private;		/* Mapping-private opaque data:
-					 	 * usually used for buffer_heads
-						 * if PagePrivate set; used for
-						 * swp_entry_t if PageSwapCache;
-						 * indicates order in the buddy
-						 * system if PG_buddy is set.
-						 */
+		/*
+		 * Mapping-private opaque data:
+		 * Usually used for buffer_heads if PagePrivate
+		 * Used for swp_entry_t if PageSwapCache
+		 * Indicates order in the buddy system if PageBuddy
+		 */
+		unsigned long private;
 #if USE_SPLIT_PTE_PTLOCKS
 #if ALLOC_SPLIT_PTLOCKS
 		spinlock_t *ptl;
_

Patches currently in -mm which might be from mawilcox@microsoft.com are


