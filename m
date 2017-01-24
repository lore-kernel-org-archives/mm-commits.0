From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path.patch added to
 -mm tree
Date: Tue, 24 Jan 2017 13:45:55 -0800
Message-ID: <5887cb13.GqAmOAtXlSkobiXH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35484 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdAXVp4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 16:45:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, khandual@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: don't check cpuset allowed twice in fast-path
has been added to the -mm tree.  Its filename is
     mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: don't check cpuset allowed twice in fast-path

Since 682a3385e773 ("mm, page_alloc: inline the fast path of the zonelist
iterator") we replace a NULL nodemask with cpuset_current_mems_allowed in
the fast path, so that get_page_from_freelist() filters nodes allowed by
the cpuset via for_next_zone_zonelist_nodemask().  In that case it's
pointless to additionaly check __cpuset_zone_allowed() in each iteration,
which we can avoid by not adding ALLOC_CPUSET to alloc_flags in that
scenario.

This saves some cycles in the allocator fast path on systems with one or
more non-root cpuset configured.  In the slow path, ALLOC_CPUSET is reset
according to __alloc_pages_slowpath().  Without configured cpusets, this
code is disabled by a static key.

Link: http://lkml.kernel.org/r/20170124150511.5710-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path
+++ a/mm/page_alloc.c
@@ -3900,9 +3900,10 @@ static inline bool prepare_alloc_pages(g
 
 	if (cpusets_enabled()) {
 		*alloc_mask |= __GFP_HARDWALL;
-		*alloc_flags |= ALLOC_CPUSET;
 		if (!ac->nodemask)
 			ac->nodemask = &cpuset_current_mems_allowed;
+		else
+			*alloc_flags |= ALLOC_CPUSET;
 	}
 
 	lockdep_trace_alloc(gfp_mask);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-mempolicyc-do-not-put-mempolicy-before-using-its-nodemask.patch
mm-page_alloc-fix-check-for-null-preferred_zone.patch
mm-page_alloc-fix-fast-path-race-with-cpuset-update-or-removal.patch
mm-page_alloc-move-cpuset-seqcount-checking-to-slowpath.patch
mm-page_alloc-fix-premature-oom-when-racing-with-cpuset-mems-update.patch
mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch
mm-page_alloc-avoid-page_to_pfn-when-merging-buddies.patch
mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch
mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path.patch

