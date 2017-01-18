From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled.patch
 added to -mm tree
Date: Wed, 18 Jan 2017 13:54:28 -0800
Message-ID: <587fe414.w5xQFtCs8Kr+NGhi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdARWSb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 17:18:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: warn_alloc nodemask is NULL when cpusets are disabled
has been added to the -mm tree.  Its filename is
     mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: warn_alloc nodemask is NULL when cpusets are disabled

The patch "mm, page_alloc: warn_alloc print nodemask" implicitly sets the
allocation nodemask to cpuset_current_mems_allowed when there is no
effective mempolicy.  cpuset_current_mems_allowed is only effective when
cpusets are enabled, which is also printed by warn_alloc(), so setting the
nodemask to cpuset_current_mems_allowed is redundant and prevents
debugging issues where ac->nodemask is not set properly in the page
allocator.

This provides better debugging output since
cpuset_print_current_mems_allowed() is already provided.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701181347320.142399@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled
+++ a/mm/page_alloc.c
@@ -3037,7 +3037,6 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	va_list args;
 	static DEFINE_RATELIMIT_STATE(nopage_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
-	nodemask_t *nm = (nodemask) ? nodemask : &cpuset_current_mems_allowed;
 
 	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
 	    debug_guardpage_minorder() > 0)
@@ -3051,11 +3050,16 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	pr_cont("%pV", &vaf);
 	va_end(args);
 
-	pr_cont(", mode:%#x(%pGg), nodemask=%*pbl\n", gfp_mask, &gfp_mask, nodemask_pr_args(nm));
+	pr_cont(", mode:%#x(%pGg), nodemask=", gfp_mask, &gfp_mask);
+	if (nodemask)
+		pr_cont("%*pbl\n", nodemask_pr_args(nodemask));
+	else
+		pr_cont("(null)\n");
+
 	cpuset_print_current_mems_allowed();
 
 	dump_stack();
-	warn_alloc_show_mem(gfp_mask, nm);
+	warn_alloc_show_mem(gfp_mask, nodemask);
 }
 
 static inline struct page *
_

Patches currently in -mm which might be from rientjes@google.com are

mm-memcg-do-not-retry-precharge-charges.patch
mm-compaction-add-vmstats-for-kcompactd-work.patch
mm-thp-add-new-defermadvise-defrag-option.patch
mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled.patch

