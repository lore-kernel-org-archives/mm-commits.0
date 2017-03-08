From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-page_alloc-add-missing-check-for-memory-holes.patch removed from -mm
 tree
Date: Wed, 08 Mar 2017 14:26:01 -0800
Message-ID: <58c084f9.yex3onmHTKeKHumc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753103AbdCHW0D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2017 17:26:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony.luck@intel.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: add missing check for memory holes
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-missing-check-for-memory-holes.patch

This patch was dropped because an alternative patch was merged

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


