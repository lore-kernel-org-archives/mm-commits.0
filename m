From: akpm@linux-foundation.org
Subject: + mm-page_alloc-add-missing-check-for-memory-holes.patch added to -mm tree
Date: Tue, 07 Mar 2017 15:48:38 -0800
Message-ID: <58bf46d6.aYv29pbBvneNYtQZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdCHAGm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 19:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony.luck@intel.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: add missing check for memory holes
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-missing-check-for-memory-holes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-missing-check-for-memory-holes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-missing-check-for-memory-holes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm, page_alloc: add missing check for memory holes

13ad59df67f197 ("mm, page_alloc: avoid page_to_pfn() when merging
buddies") moved the check for memory holes out of page_is_buddy() and had
the callers do the check.

But this wasn't done correctly in one place which caused ia64 to crash
very early in boot.

Update to fix that and make ia64 boot again.

Fixes: 13ad59df67f1 ("avoid page_to_pfn() when merging buddies")
Link: http://lkml.kernel.org/r/1488929150-13629-1-git-send-email-tony.luck@intel.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-add-missing-check-for-memory-holes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-missing-check-for-memory-holes
+++ a/mm/page_alloc.c
@@ -873,7 +873,8 @@ done_merging:
 		higher_page = page + (combined_pfn - pfn);
 		buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
 		higher_buddy = higher_page + (buddy_pfn - combined_pfn);
-		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
+		if (pfn_valid_within(page_to_pfn(higher_buddy)) &&
+		    page_is_buddy(higher_page, higher_buddy, order + 1)) {
 			list_add_tail(&page->lru,
 				&zone->free_area[order].free_list[migratetype]);
 			goto out;
_

Patches currently in -mm which might be from tony.luck@intel.com are

mm-page_alloc-add-missing-check-for-memory-holes.patch

