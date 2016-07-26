From: akpm@linux-foundation.org
Subject: [patch 067/126] mm: remove pointless struct in struct page
 definition
Date: Tue, 26 Jul 2016 15:24:16 -0700
Message-ID: <5797e310.BmDqXkoKWdjf0e+W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339AbcGZWYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: remove pointless struct in struct page definition

This patchset implements per kmemcg accounting of page tables (x86-only),
pipe buffers, and unix socket buffers.

Patches 1-3 are just cleanups that are not supposed to introduce any
functional changes.  Patches 4 and 5 move charge/uncharge to generic page
allocator paths for the sake of accounting pipe and unix socket buffers. 
Patches 5-7 make x86 page tables, pipe buffers, and unix socket buffers
accountable.



This patch (of 8):

... to reduce indentation level thus leaving more space for comments.

Link: http://lkml.kernel.org/r/f34ffe70fce2b0b9220856437f77972d67c14275.1464079537.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   68 +++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff -puN include/linux/mm_types.h~mm-remove-pointless-struct-in-struct-page-definition include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-remove-pointless-struct-in-struct-page-definition
+++ a/include/linux/mm_types.h
@@ -60,51 +60,47 @@ struct page {
 	};
 
 	/* Second double word */
-	struct {
-		union {
-			pgoff_t index;		/* Our offset within mapping. */
-			void *freelist;		/* sl[aou]b first free object */
-			/* page_deferred_list().prev	-- second tail page */
-		};
+	union {
+		pgoff_t index;		/* Our offset within mapping. */
+		void *freelist;		/* sl[aou]b first free object */
+		/* page_deferred_list().prev	-- second tail page */
+	};
 
-		union {
+	union {
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
 	defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
-			/* Used for cmpxchg_double in slub */
-			unsigned long counters;
+		/* Used for cmpxchg_double in slub */
+		unsigned long counters;
 #else
-			/*
-			 * Keep _refcount separate from slub cmpxchg_double
-			 * data.  As the rest of the double word is protected by
-			 * slab_lock but _refcount is not.
-			 */
-			unsigned counters;
+		/*
+		 * Keep _refcount separate from slub cmpxchg_double data.
+		 * As the rest of the double word is protected by slab_lock
+		 * but _refcount is not.
+		 */
+		unsigned counters;
 #endif
+		struct {
 
-			struct {
-
-				union {
-					/*
-					 * Count of ptes mapped in mms, to show
-					 * when page is mapped & limit reverse
-					 * map searches.
-					 */
-					atomic_t _mapcount;
-
-					struct { /* SLUB */
-						unsigned inuse:16;
-						unsigned objects:15;
-						unsigned frozen:1;
-					};
-					int units;	/* SLOB */
-				};
+			union {
 				/*
-				 * Usage count, *USE WRAPPER FUNCTION*
-				 * when manual accounting. See page_ref.h
+				 * Count of ptes mapped in mms, to show when
+				 * page is mapped & limit reverse map searches.
 				 */
-				atomic_t _refcount;
+				atomic_t _mapcount;
+
+				unsigned int active;		/* SLAB */
+				struct {			/* SLUB */
+					unsigned inuse:16;
+					unsigned objects:15;
+					unsigned frozen:1;
+				};
+				int units;			/* SLOB */
 			};
-			unsigned int active;	/* SLAB */
+			/*
+			 * Usage count, *USE WRAPPER FUNCTION* when manual
+			 * accounting. See page_ref.h
+			 */
+			atomic_t _refcount;
 		};
 	};
 
_
