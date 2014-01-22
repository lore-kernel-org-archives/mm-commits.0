From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:15:02 -0800
Message-ID: <52e026c6.et1mwyAMkng2aJ62%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbaAVUPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:15:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, mgorman@suse.de, akpm@linux-foundation.org, rientjes@google.com

Subject: [merged] mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch removed from -mm tree
To: rientjes@google.com,akpm@linux-foundation.org,mgorman@suse.de,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:15:02 -0800


The patch titled
     Subject: mm, page_alloc: warn for non-blockable __GFP_NOFAIL allocation failure
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: warn for non-blockable __GFP_NOFAIL allocation failure

__GFP_NOFAIL may return NULL when coupled with GFP_NOWAIT or GFP_ATOMIC.

Luckily, nothing currently does such craziness.  So instead of causing
such allocations to loop (potentially forever), we maintain the current
behavior and also warn about the new users of the deprecated flag.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure
+++ a/mm/page_alloc.c
@@ -2525,8 +2525,15 @@ rebalance:
 	}
 
 	/* Atomic allocations - we can't balance anything */
-	if (!wait)
+	if (!wait) {
+		/*
+		 * All existing users of the deprecated __GFP_NOFAIL are
+		 * blockable, so warn of any new users that actually allow this
+		 * type of allocation to fail.
+		 */
+		WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL);
 		goto nopage;
+	}
 
 	/* Avoid recursion of direct reclaim */
 	if (current->flags & PF_MEMALLOC)
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-nobootmem-free_all_bootmem-again-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
linux-next.patch

