From: akpm@linux-foundation.org
Subject: [merged] mm-de-indent-struct-page.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:32:59 -0800
Message-ID: <20180201193259.FXlRRa5ad%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59024 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754563AbeBATdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:33:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm: de-indent struct page
has been removed from the -mm tree.  Its filename was
     mm-de-indent-struct-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: mm: de-indent struct page

I found the struct { union { struct { union { struct { } } } } }
layout rather confusing.  Fortunately, there is an easier way to write
this.  The innermost union is of four things which are the size of an
int, so the ones which are used by slab/slob/slub can be pulled up
two levels to be in the outermost union with 'counters'.  That leaves
us with struct { union { struct { atomic_t; atomic_t; } } } which
has the same layout, but is easier to read.

Output from the current git version of pahole, diffed with -uw to ignore
the whitespace changes from the indentation:

 	};						/*    16     8 */
 	union {
 		long unsigned int  counters;		/*    24     8 */
-		struct {
-			union {
-				atomic_t _mapcount;	/*    24     4 */
 				unsigned int active;	/*    24     4 */
 				struct {
 					unsigned int inuse:16; /*    24:16  4 */
@@ -21,7 +18,8 @@
 					unsigned int frozen:1; /*    24: 0  4 */
 				};			/*    24     4 */
 				int units;		/*    24     4 */
-			};				/*    24     4 */
+		struct {
+			atomic_t   _mapcount;		/*    24     4 */
 			atomic_t   _refcount;		/*    28     4 */
 		};					/*    24     8 */
 	};						/*    24     8 */

Link: http://lkml.kernel.org/r/20171220155552.15884-3-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   38 +++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff -puN include/linux/mm_types.h~mm-de-indent-struct-page include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-de-indent-struct-page
+++ a/include/linux/mm_types.h
@@ -84,28 +84,26 @@ struct page {
 		 */
 		unsigned counters;
 #endif
-		struct {
+		unsigned int active;		/* SLAB */
+		struct {			/* SLUB */
+			unsigned inuse:16;
+			unsigned objects:15;
+			unsigned frozen:1;
+		};
+		int units;			/* SLOB */
 
-			union {
-				/*
-				 * Count of ptes mapped in mms, to show when
-				 * page is mapped & limit reverse map searches.
-				 *
-				 * Extra information about page type may be
-				 * stored here for pages that are never mapped,
-				 * in which case the value MUST BE <= -2.
-				 * See page-flags.h for more details.
-				 */
-				atomic_t _mapcount;
+		struct {			/* Page cache */
+			/*
+			 * Count of ptes mapped in mms, to show when
+			 * page is mapped & limit reverse map searches.
+			 *
+			 * Extra information about page type may be
+			 * stored here for pages that are never mapped,
+			 * in which case the value MUST BE <= -2.
+			 * See page-flags.h for more details.
+			 */
+			atomic_t _mapcount;
 
-				unsigned int active;		/* SLAB */
-				struct {			/* SLUB */
-					unsigned inuse:16;
-					unsigned objects:15;
-					unsigned frozen:1;
-				};
-				int units;			/* SLOB */
-			};
 			/*
 			 * Usage count, *USE WRAPPER FUNCTION* when manual
 			 * accounting. See page_ref.h
_

Patches currently in -mm which might be from mawilcox@microsoft.com are


