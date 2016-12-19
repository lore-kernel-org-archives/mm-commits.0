From: akpm@linux-foundation.org
Subject: + mm-throttle-show_mem-from-warn_alloc.patch added to -mm tree
Date: Mon, 19 Dec 2016 15:21:31 -0800
Message-ID: <58586b7b.utAFLlsEa2NAIav+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48616 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932585AbcLSXUb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 18:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: throttle show_mem() from warn_alloc()
has been added to the -mm tree.  Its filename is
     mm-throttle-show_mem-from-warn_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-throttle-show_mem-from-warn_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-throttle-show_mem-from-warn_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20161215101510.9030-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-throttle-show_mem-from-warn_alloc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-throttle-show_mem-from-warn_alloc
+++ a/mm/page_alloc.c
@@ -3022,14 +3022,13 @@ static DEFINE_RATELIMIT_STATE(nopage_rs,
 		DEFAULT_RATELIMIT_INTERVAL,
 		DEFAULT_RATELIMIT_BURST);
 
-void warn_alloc(gfp_t gfp_mask, const char *fmt, ...)
+static DEFINE_RATELIMIT_STATE(show_mem_rs, HZ, 1);
+
+static void warn_alloc_show_mem(gfp_t gfp_mask)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
-	struct va_format vaf;
-	va_list args;
 
-	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
-	    debug_guardpage_minorder() > 0)
+	if (should_suppress_show_mem() || !__ratelimit(&show_mem_rs))
 		return;
 
 	/*
@@ -3044,6 +3043,18 @@ void warn_alloc(gfp_t gfp_mask, const ch
 	if (in_interrupt() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
+	show_mem(filter);
+}
+
+void warn_alloc(gfp_t gfp_mask, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
+	    debug_guardpage_minorder() > 0)
+		return;
+
 	pr_warn("%s: ", current->comm);
 
 	va_start(args, fmt);
@@ -3055,8 +3066,7 @@ void warn_alloc(gfp_t gfp_mask, const ch
 	pr_cont(", mode:%#x(%pGg)\n", gfp_mask, &gfp_mask);
 
 	dump_stack();
-	if (!should_suppress_show_mem())
-		show_mem(filter);
+	warn_alloc_show_mem(gfp_mask);
 }
 
 static inline struct page *
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch

