From: akpm@linux-foundation.org
Subject: - mm-fix-misleading-__gfp_repeat-related-comments.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:28 -0700
Message-ID: <200804300538.m3U5cSDV028753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758126AbYD3Fno (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: fix misleading __GFP_REPEAT related comments
has been removed from the -mm tree.  Its filename was
     mm-fix-misleading-__gfp_repeat-related-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix misleading __GFP_REPEAT related comments
From: Nishanth Aravamudan <nacc@us.ibm.com>

The definition and use of __GFP_REPEAT, __GFP_NOFAIL and __GFP_NORETRY in the
core VM have somewhat differing comments as to their actual semantics. 
Annoyingly, the flags definition has inline and header comments, which might
be interpreted as not being equivalent.  Just add references to the header
comments in the inline ones so they don't go out of sync in the future.  In
their use in __alloc_pages() clarify that the current implementation treats
low-order allocations and __GFP_REPEAT allocations as distinct cases.

To clarify, the flags' semantics are:

__GFP_NORETRY means try no harder than one run through __alloc_pages

__GFP_REPEAT means __GFP_NOFAIL

__GFP_NOFAIL means repeat forever

order <= PAGE_ALLOC_COSTLY_ORDER means __GFP_NOFAIL

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    6 +++---
 mm/page_alloc.c     |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-fix-misleading-__gfp_repeat-related-comments include/linux/gfp.h
--- a/include/linux/gfp.h~mm-fix-misleading-__gfp_repeat-related-comments
+++ a/include/linux/gfp.h
@@ -40,9 +40,9 @@ struct vm_area_struct;
 #define __GFP_FS	((__force gfp_t)0x80u)	/* Can call down to low-level FS? */
 #define __GFP_COLD	((__force gfp_t)0x100u)	/* Cache-cold page required */
 #define __GFP_NOWARN	((__force gfp_t)0x200u)	/* Suppress page allocation failure warning */
-#define __GFP_REPEAT	((__force gfp_t)0x400u)	/* Retry the allocation.  Might fail */
-#define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* Retry for ever.  Cannot fail */
-#define __GFP_NORETRY	((__force gfp_t)0x1000u)/* Do not retry.  Might fail */
+#define __GFP_REPEAT	((__force gfp_t)0x400u)	/* See above */
+#define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* See above */
+#define __GFP_NORETRY	((__force gfp_t)0x1000u)/* See above */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
diff -puN mm/page_alloc.c~mm-fix-misleading-__gfp_repeat-related-comments mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-misleading-__gfp_repeat-related-comments
+++ a/mm/page_alloc.c
@@ -1611,8 +1611,9 @@ nofail_alloc:
 	 * Don't let big-order allocations loop unless the caller explicitly
 	 * requests that.  Wait for some write requests to complete then retry.
 	 *
-	 * In this implementation, __GFP_REPEAT means __GFP_NOFAIL for order
-	 * <= 3, but that may not be true in other implementations.
+	 * In this implementation, either order <= PAGE_ALLOC_COSTLY_ORDER or
+	 * __GFP_REPEAT mean __GFP_NOFAIL, but that may not be true in other
+	 * implementations.
 	 */
 	do_retry = 0;
 	if (!(gfp_mask & __GFP_NORETRY)) {
_

Patches currently in -mm which might be from nacc@us.ibm.com are

origin.patch

