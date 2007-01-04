From: akpm@osdl.org
Subject: + fix-bug_onpageslab-from-fallback_alloc.patch added to -mm tree
Date: Thu, 04 Jan 2007 10:22:47 -0800
Message-ID: <200701041822.l04IMlZo026900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:41942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965063AbXADSX4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 13:23:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     fix BUG_ON(!PageSlab) from fallback_alloc
has been added to the -mm tree.  Its filename is
     fix-bug_onpageslab-from-fallback_alloc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix BUG_ON(!PageSlab) from fallback_alloc
From: Hugh Dickins <hugh@veritas.com>

pdflush hit the BUG_ON(!PageSlab(page)) in kmem_freepages called from
fallback_alloc: cache_grow already freed those pages when alloc_slabmgmt
failed.  But it wouldn't have freed them if __GFP_NO_GROW, so make sure
fallback_alloc doesn't waste its time on that case.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~fix-bug_onpageslab-from-fallback_alloc mm/slab.c
--- a/mm/slab.c~fix-bug_onpageslab-from-fallback_alloc
+++ a/mm/slab.c
@@ -3281,7 +3281,7 @@ retry:
 					flags | GFP_THISNODE, nid);
 	}
 
-	if (!obj) {
+	if (!obj && !(flags & __GFP_NO_GROW)) {
 		/*
 		 * This allocation will be performed within the constraints
 		 * of the current cpuset / memory policy requirements.
@@ -3310,7 +3310,7 @@ retry:
 					 */
 					goto retry;
 			} else {
-				kmem_freepages(cache, obj);
+				/* cache_grow already freed obj */
 				obj = NULL;
 			}
 		}
_

Patches currently in -mm which might be from hugh@veritas.com are

fix-bug_onpageslab-from-fallback_alloc.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
