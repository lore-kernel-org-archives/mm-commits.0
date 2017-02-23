From: akpm@linux-foundation.org
Subject: [merged] mm-throttle-show_mem-from-warn_alloc.patch removed from
 -mm tree
Date: Thu, 23 Feb 2017 13:12:55 -0800
Message-ID: <58af5057.8rgLh40N7PfXDlRA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVM4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: throttle show_mem() from warn_alloc()
has been removed from the -mm tree.  Its filename was
     mm-throttle-show_mem-from-warn_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: throttle show_mem() from warn_alloc()

Tetsuo has been stressing OOM killer path with many parallel allocation
requests when he has noticed that it is not all that hard to swamp kernel
logs with warn_alloc messages caused by allocation stalls.  Even though
the allocation stall message is triggered only once in 10s there might be
many different tasks hitting it roughly around the same time.

A big part of the output is show_mem() which can generate a lot of output
even on a small machines.  There is no reason to show the state of memory
counter for each allocation stall, especially when multiple of them are
reported in a short time period.  Chances are that not much has changed
since the last report.  This patch simply rate limits show_mem called from
warn_alloc to only dump something once per second.  This should be enough
to give us a clue why an allocation might be stalling while burst of
warnings will not swamp log with too much data.

While we are at it, extract all the show_mem related handling (filters)
into a separate function warn_alloc_show_mem.  This will make the code
cleaner and as a bonus point we can distinguish which part of warn_alloc
got throttled due to rate limiting as ___ratelimit dumps the caller.

[akpm@linux-foundation.org: reduce scope of the ratelimit_states]
Link: http://lkml.kernel.org/r/20161215101510.9030-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-throttle-show_mem-from-warn_alloc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-throttle-show_mem-from-warn_alloc
+++ a/mm/page_alloc.c
@@ -3007,18 +3007,12 @@ static inline bool should_suppress_show_
 	return ret;
 }
 
-static DEFINE_RATELIMIT_STATE(nopage_rs,
-		DEFAULT_RATELIMIT_INTERVAL,
-		DEFAULT_RATELIMIT_BURST);
-
-void warn_alloc(gfp_t gfp_mask, const char *fmt, ...)
+static void warn_alloc_show_mem(gfp_t gfp_mask)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
-	struct va_format vaf;
-	va_list args;
+	static DEFINE_RATELIMIT_STATE(show_mem_rs, HZ, 1);
 
-	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
-	    debug_guardpage_minorder() > 0)
+	if (should_suppress_show_mem() || !__ratelimit(&show_mem_rs))
 		return;
 
 	/*
@@ -3033,6 +3027,20 @@ void warn_alloc(gfp_t gfp_mask, const ch
 	if (in_interrupt() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
+	show_mem(filter);
+}
+
+void warn_alloc(gfp_t gfp_mask, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+
+	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
+	    debug_guardpage_minorder() > 0)
+		return;
+
 	pr_warn("%s: ", current->comm);
 
 	va_start(args, fmt);
@@ -3044,8 +3052,7 @@ void warn_alloc(gfp_t gfp_mask, const ch
 	pr_cont(", mode:%#x(%pGg)\n", gfp_mask, &gfp_mask);
 
 	dump_stack();
-	if (!should_suppress_show_mem())
-		show_mem(filter);
+	warn_alloc_show_mem(gfp_mask);
 }
 
 static inline struct page *
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-page_alloc-do-not-depend-on-cpu-hotplug-locks-inside-the-allocator.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps-fix.patch
vmalloc-back-of-when-the-current-is-killed.patch

