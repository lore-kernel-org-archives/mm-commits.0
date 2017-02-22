From: akpm@linux-foundation.org
Subject: [folded-merged] mm-throttle-show_mem-from-warn_alloc-fix.patch
 removed from -mm tree
Date: Wed, 22 Feb 2017 15:17:35 -0800
Message-ID: <58ae1c0f.h2yrpBCXZY/gPoAF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933777AbdBVXZ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:25:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-throttle-show_mem-from-warn_alloc-fix
has been removed from the -mm tree.  Its filename was
     mm-throttle-show_mem-from-warn_alloc-fix.patch

This patch was dropped because it was folded into mm-throttle-show_mem-from-warn_alloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-throttle-show_mem-from-warn_alloc-fix

reduce scope of the ratelimit_states

Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-throttle-show_mem-from-warn_alloc-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-throttle-show_mem-from-warn_alloc-fix
+++ a/mm/page_alloc.c
@@ -3007,15 +3007,10 @@ static inline bool should_suppress_show_
 	return ret;
 }
 
-static DEFINE_RATELIMIT_STATE(nopage_rs,
-		DEFAULT_RATELIMIT_INTERVAL,
-		DEFAULT_RATELIMIT_BURST);
-
-static DEFINE_RATELIMIT_STATE(show_mem_rs, HZ, 1);
-
 static void warn_alloc_show_mem(gfp_t gfp_mask)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
+	static DEFINE_RATELIMIT_STATE(show_mem_rs, HZ, 1);
 
 	if (should_suppress_show_mem() || !__ratelimit(&show_mem_rs))
 		return;
@@ -3039,6 +3034,8 @@ void warn_alloc(gfp_t gfp_mask, const ch
 {
 	struct va_format vaf;
 	va_list args;
+	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
 	    debug_guardpage_minorder() > 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-throttle-show_mem-from-warn_alloc.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch

