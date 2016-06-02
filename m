From: akpm@linux-foundation.org
Subject: + mm-remove-pointless-struct-in-struct-page-definition.patch
 added to -mm tree
Date: Thu, 02 Jun 2016 16:09:03 -0700
Message-ID: <5750bc8f.5mptg0GlQwEoU6Zq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbcFBXJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove pointless struct in struct page definition
has been added to the -mm tree.  Its filename is
     mm-remove-pointless-struct-in-struct-page-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-pointless-struct-in-struct-page-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-pointless-struct-in-struct-page-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-zap-zone_oom_locked.patch
mm-oom-add-memcg-to-oom_control.patch
mm-remove-pointless-struct-in-struct-page-definition.patch
mm-clean-up-non-standard-page-_mapcount-users.patch
mm-memcontrol-cleanup-kmem-charge-functions.patch
mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths.patch
mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages.patch
arch-x86-charge-page-tables-to-kmemcg.patch
pipe-account-to-kmemcg.patch
af_unix-charge-buffers-to-kmemcg.patch

