From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count.patch
 added to -mm tree
Date: Fri, 20 Nov 2015 14:26:55 -0800
Message-ID: <564f9e2f.HawcIm/D7/Kud5lP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935169AbbKTW04 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Nov 2015 17:26:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, dave.hansen@intel.com, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mike.kravetz@oracle.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix hugepage memory leak caused by wrong reserve count
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: fix hugepage memory leak caused by wrong reserve count

When dequeue_huge_page_vma() in alloc_huge_page() fails, we fall back to
alloc_buddy_huge_page() to directly create a hugepage from the buddy allocator.
In that case, however, if alloc_buddy_huge_page() succeeds we don't decrement
h->resv_huge_pages, which means that successful hugetlb_fault() returns without
releasing the reserve count. As a result, subsequent hugetlb_fault() might fail
despite that there are still free hugepages.

This patch simply adds decrementing code on that code path.

I reproduced this problem when testing v4.3 kernel in the following situation:
- the test machine/VM is a NUMA system,
- hugepage overcommiting is enabled,
- most of hugepages are allocated and there's only one free hugepage
  which is on node 0 (for example),
- another program, which calls set_mempolicy(MPOL_BIND) to bind itself to
  node 1, tries to allocate a hugepage,
- the allocation should fail but the reserve count is still hold.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org> [3.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count
+++ a/mm/hugetlb.c
@@ -1886,7 +1886,10 @@ struct page *alloc_huge_page(struct vm_a
 		page = __alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
