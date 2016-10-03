From: akpm@linux-foundation.org
Subject: + mm-warn-about-allocations-which-stall-for-too-long.patch added
 to -mm tree
Date: Mon, 03 Oct 2016 14:48:48 -0700
Message-ID: <57f2d240.18z763UTmNY8c7No%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752787AbcJCVst (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2016 17:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, dave.hansen@intel.com, hannes@cmpxchg.org, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: warn about allocations which stall for too long
has been added to the -mm tree.  Its filename is
     mm-warn-about-allocations-which-stall-for-too-long.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-warn-about-allocations-which-stall-for-too-long.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-warn-about-allocations-which-stall-for-too-long.patch

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
Subject: mm: warn about allocations which stall for too long

Currently we do warn only about allocation failures but small allocations
are basically nofail and they might loop in the page allocator for a long
time.  Especially when the reclaim cannot make any progress - e.g. 
GFP_NOFS cannot invoke the oom killer and rely on a different context to
make a forward progress in case there is a lot memory used by filesystems.

Give us at least a clue when something like this happens and warn about
allocations which take more than 10s.  Print the basic allocation context
information along with the cumulative time spent in the allocation as well
as the allocation stack.  Repeat the warning after every 10 seconds so
that we know that the problem is permanent rather than ephemeral.

Link: http://lkml.kernel.org/r/20160929084407.7004-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/page_alloc.c~mm-warn-about-allocations-which-stall-for-too-long mm/page_alloc.c
--- a/mm/page_alloc.c~mm-warn-about-allocations-which-stall-for-too-long
+++ a/mm/page_alloc.c
@@ -3493,6 +3493,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	enum compact_result compact_result;
 	int compaction_retries = 0;
 	int no_progress_loops = 0;
+	unsigned long alloc_start = jiffies;
+	unsigned int stall_timeout = 10 * HZ;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -3648,6 +3650,14 @@ retry:
 	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
 		goto nopage;
 
+	/* Make sure we know about allocations which stall for too long */
+	if (time_after(jiffies, alloc_start + stall_timeout)) {
+		warn_alloc(gfp_mask,
+			"page alloction stalls for %ums, order:%u\n",
+			jiffies_to_msecs(jiffies-alloc_start), order);
+		stall_timeout += 10 * HZ;
+	}
+
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
 				 did_some_progress > 0, &no_progress_loops))
 		goto retry;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-get-rid-of-throttle_vm_writeout.patch
oom-keep-mm-of-the-killed-task-available.patch
kernel-oom-fix-potential-pgd_lock-deadlock-from-__mmdrop.patch
mm-oom-get-rid-of-signal_struct-oom_victims.patch
oom-suspend-fix-oom_killer_disable-vs-pm-suspend-properly.patch
mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory.patch
oom-oom_reaper-allow-to-reap-mm-shared-by-the-kthreads.patch
oom-warn-if-we-go-oom-for-higher-order-and-compaction-is-disabled.patch
oom-print-nodemask-in-the-oom-report.patch
mm-consolidate-warn_alloc_failed-users.patch
mm-warn-about-allocations-which-stall-for-too-long.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit.patch
mm-split-gfp_mask-and-mapping-flags-into-separate-fields.patch

