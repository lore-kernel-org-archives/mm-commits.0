From: akpm@osdl.org
Subject: - memory-page-alloc-minor-cleanups-fix.patch removed from -mm tree
Date: Wed, 06 Dec 2006 18:57:46 -0800
Message-ID: <200612070257.kB72vkf3026609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40382 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967778AbWLGC5u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 21:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, clameter@sgi.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     memory page_alloc revert empty zonelist check
has been removed from the -mm tree.  Its filename was
     memory-page-alloc-minor-cleanups-fix.patch

This patch was dropped because it was folded into memory-page-alloc-minor-cleanups.patch

------------------------------------------------------
Subject: memory page_alloc revert empty zonelist check
From: Paul Jackson <pj@sgi.com>

Backout one item from a previous "memory page_alloc minor cleanups" patch. 
Until and unless we are certain that no one can ever pass an empty zonelist
to __alloc_pages(), this check for an empty zonelist (or some BUG
equivalent) is essential.  The code in get_page_from_freelist() blow ups if
passed an empty zonelist.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN mm/page_alloc.c~memory-page-alloc-minor-cleanups-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memory-page-alloc-minor-cleanups-fix
+++ a/mm/page_alloc.c
@@ -994,6 +994,13 @@ __alloc_pages(gfp_t gfp_mask, unsigned i
 	might_sleep_if(wait);
 
 restart:
+	z = zonelist->zones;  /* the list of zones suitable for gfp_mask */
+
+	if (unlikely(*z == NULL)) {
+		/* Should this ever happen?? */
+		return NULL;
+	}
+
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
 				zonelist, ALLOC_WMARK_LOW|ALLOC_CPUSET);
 	if (page)
_

Patches currently in -mm which might be from pj@sgi.com are

memory-page-alloc-minor-cleanups.patch
memory-page-alloc-minor-cleanups-fix.patch
memory-page_alloc-zonelist-caching-speedup.patch
memory-page_alloc-zonelist-caching-reorder-structure.patch
cpuset-minor-code-refinements.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpuset-allow-a-larger-buffer-for-writes-to-cpuset-files.patch

