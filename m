From: akpm@linux-foundation.org
Subject: + mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:14:58 -0700
Message-ID: <20130327201458.6E2D331C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:42638 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3C0UO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:14:59 -0400
Received: by mail-ve0-f201.google.com with SMTP id ox1so187833veb.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:14:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, dan.carpenter@oracle.com, mgorman@suse.de


The patch titled
     Subject: mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix

Dan Carpenter has reported that (alloc_flags & ALLOC_WMARK_MIN) test
doesn't make much sense as the flag is 0 and it is in fact intended for
wmark indexing rather than being used as a flag.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix
+++ a/mm/page_alloc.c
@@ -1955,7 +1955,7 @@ zonelist_scan:
 				 * when the watermark is between the low and
 				 * min watermarks.
 				 */
-				if ((alloc_flags & ALLOC_WMARK_MIN) ||
+				if (((alloc_flags & ALLOC_WMARK_MASK) == ALLOC_WMARK_MIN) ||
 				    ret == ZONE_RECLAIM_SOME)
 					goto this_zone_full;
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
mm-export-split_page.patch
mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
rmap-recompute-pgoff-for-unmapping-huge-page.patch
memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch
memcg-rework-mem_cgroup_iter-to-use-cgroup-iterators.patch
memcg-relax-memcg-iter-caching.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
memcg-simplify-mem_cgroup_iter.patch
memcg-further-simplify-mem_cgroup_iter.patch
cgroup-remove-css_get_next.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
memcg-do-not-check-for-do_swap_account-in-mem_cgroup_readwritereset.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim.patch
mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

