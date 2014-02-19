From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
 added to -mm tree
Date: Wed, 19 Feb 2014 14:32:09 -0800
Message-ID: <530530e9.cqKYHYSu2jbemNVt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaBSWcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 17:32:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, weijie.yang@samsung.com

Subject: + mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch added to -mm tree
To: weijie.yang@samsung.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 14:32:09 -0800


The patch titled
     Subject: mm/vmscan: restore sc->gfp_mask after promoting it to __GFP_HIGHMEM
has been added to the -mm tree.  Its filename is
     mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/vmscan: restore sc->gfp_mask after promoting it to __GFP_HIGHMEM

We promote sc->gfp_mask to __GFP_HIGHMEM to forcibly scan highmem if there
are too many buffer_heads pinning highmem.  See cc715d99e5 ("mm: vmscan:
forcibly scan highmem if there are too many buffer_heads pinning
highmem").

This patch restores sc->gfp_mask to its caller original value after
finishing the scan job, to avoid the impact on other invocations from its
upper caller, such as vmpressure_prio(), shrink_slab().

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem
+++ a/mm/vmscan.c
@@ -2314,6 +2314,7 @@ static bool shrink_zones(struct zonelist
 	unsigned long lru_pages = 0;
 	bool aborted_reclaim = false;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
+	gfp_t orig_mask;
 	struct shrink_control shrink = {
 		.gfp_mask = sc->gfp_mask,
 	};
@@ -2323,6 +2324,7 @@ static bool shrink_zones(struct zonelist
 	 * allowed level, force direct reclaim to scan the highmem zone as
 	 * highmem pages could be pinning lowmem pages storing buffer_heads
 	 */
+	orig_mask = sc->gfp_mask;
 	if (buffer_heads_over_limit)
 		sc->gfp_mask |= __GFP_HIGHMEM;
 
@@ -2393,6 +2395,12 @@ static bool shrink_zones(struct zonelist
 		}
 	}
 
+	/*
+	 * Restore to original mask to avoid the impact on the caller if we
+	 * promoted it to __GFP_HIGHMEM.
+	 */
+	sc->gfp_mask = orig_mask;
+
 	return aborted_reclaim;
 }
 
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch
linux-next.patch

