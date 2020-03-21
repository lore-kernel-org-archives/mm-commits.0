From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-vmscanc-do=5Ftry=5Fto=5Ffree=5Fpages-clean-code-by-remov?=
 =?US-ASCII?Q?ing-unnecessary-assignment.patch?= added to -mm tree
Date: Fri, 20 Mar 2020 17:45:57 -0700
Message-ID: <20200321004557.WqbRlyFPX%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAp7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 20:45:59 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mateusznosek0@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: do_try_to_free_pages(): clean code by removing unnecessary assignment
has been added to the -mm tree.  Its filename is
     mm-vmscanc-do_try_to_free_pages-clean-code-by-removing-unnecessary-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscanc-do_try_to_free_pages-clean-code-by-removing-unnecessary-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscanc-do_try_to_free_pages-clean-code-by-removing-unnecessary-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/vmscan.c: do_try_to_free_pages(): clean code by removing unnecessary assignment

sc->memcg_low_skipped resets skipped_deactivate to 0 but this is not
needed as this code path is never reachable with skipped_deactivate != 0
due to previous sc->skipped_deactivate branch.

[mhocko@kernel.org: rewrite changelog]
Link: http://lkml.kernel.org/r/20200319165938.23354-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-do_try_to_free_pages-clean-code-by-removing-unnecessary-assignment
+++ a/mm/vmscan.c
@@ -3093,7 +3093,6 @@ retry:
 	if (sc->memcg_low_skipped) {
 		sc->priority = initial_priority;
 		sc->force_deactivate = 0;
-		sc->skipped_deactivate = 0;
 		sc->memcg_low_reclaim = 1;
 		sc->memcg_low_skipped = 0;
 		goto retry;
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path.patch
mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch
mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch
mm-vmscanc-do_try_to_free_pages-clean-code-by-removing-unnecessary-assignment.patch
mm-compactionc-clean-code-by-removing-unnecessary-assignment.patch
mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch
mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch
