From: akpm@linux-foundation.org
Subject: [folded-merged]
 revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 28 Jul 2016 15:14:34 -0700
Message-ID: <579a83ca.wjjQKAbql7vrw642%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcG1WOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch

This patch was dropped because it was folded into revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#90: FILE: mm/mempool.c:311:
+void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)

total: 5 errors, 0 warnings, 52 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempool.c~revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes mm/mempool.c
--- a/mm/mempool.c~revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes
+++ a/mm/mempool.c
@@ -308,7 +308,7 @@ EXPORT_SYMBOL(mempool_resize);
  * fail if called from an IRQ context.)
  * Note: using __GFP_ZERO is not supported.
  */
-void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
+void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
 	void *element;
 	unsigned long flags;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch

