From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed.patch added to -mm tree
Date: Wed, 04 May 2016 14:00:38 -0700
Message-ID: <572a62f6.8OICCo56GhoPz3/S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbcEDVAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2016 17:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: restore the original nodemask if the fast path allocation failed
has been added to the -mm tree.  Its filename is
     mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: restore the original nodemask if the fast path allocation failed

The page allocator fast path uses either the requested nodemask or
cpuset_current_mems_allowed if cpusets are enabled.  If the allocation
context allows watermarks to be ignored then it can also ignore memory
policies.  However, on entering the allocator slowpath the nodemask may
still be cpuset_current_mems_allowed and the policies are enforced.  This
patch resets the nodemask appropriately before entering the slowpath.

Link: http://lkml.kernel.org/r/20160504143628.GU2858@techsingularity.net
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed
+++ a/mm/page_alloc.c
@@ -3636,6 +3636,12 @@ retry_cpuset:
 	alloc_mask = memalloc_noio_flags(gfp_mask);
 	ac.spread_dirty_pages = false;
 
+	/*
+	 * Restore the original nodemask if it was potentially replaced with
+	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
+	 */
+	if (cpusets_enabled())
+		ac.nodemask = nodemask;
 	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
 no_zone:
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch
mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch
mm-page_alloc-restore-the-original-nodemask-if-the-fast-path-allocation-failed.patch

