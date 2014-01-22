From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch removed from -mm
 tree
Date: Wed, 22 Jan 2014 12:12:19 -0800
Message-ID: <52e02623.+0ss6n9todBFiDyI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbaAVUMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com

Subject: [merged] mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch removed from -mm tree
To: aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:19 -0800


The patch titled
     Subject: mm: hugetlb: use get_page_foll() in follow_hugetlb_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: hugetlb: use get_page_foll() in follow_hugetlb_page()

get_page_foll() is more optimal and is always safe to use under the PT
lock.  More so for hugetlbfs as there's no risk of race conditions with
split_huge_page regardless of the PT lock.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page
+++ a/mm/hugetlb.c
@@ -3079,7 +3079,7 @@ long follow_hugetlb_page(struct mm_struc
 same_page:
 		if (pages) {
 			pages[i] = mem_map_offset(page, pfn_offset);
-			get_page(pages[i]);
+			get_page_foll(pages[i]);
 		}
 
 		if (vmas)
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch

