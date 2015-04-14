From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 14 Apr 2015 15:19:31 -0700
Message-ID: <552d9273.Rlw/9Qy++bTA2ab/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbDNWTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-mempool-do-not-allow-atomic-resizing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes

WARNING: Prefer kmalloc_array over kmalloc with multiply
#111: FILE: mm/mempool.c:149:
+	new_elements = kmalloc(new_min_nr * sizeof(*new_elements), GFP_KERNEL);

total: 0 errors, 1 warnings, 81 lines checked

./patches/mm-mempool-do-not-allow-atomic-resizing.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mempool.c~mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes mm/mempool.c
--- a/mm/mempool.c~mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes
+++ a/mm/mempool.c
@@ -146,7 +146,8 @@ int mempool_resize(mempool_t *pool, int
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	/* Grow the pool */
-	new_elements = kmalloc(new_min_nr * sizeof(*new_elements), GFP_KERNEL);
+	new_elements = kmalloc_array(new_min_nr, sizeof(*new_elements),
+				     GFP_KERNEL);
 	if (!new_elements)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition.patch
page_writeback-cleanup-mess-around-cancel_dirty_page.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
mm-mempool-do-not-allow-atomic-resizing.patch

