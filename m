From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-schedule-when-potentially-allocating-many-hugepages.patch added
 to -mm tree
Date: Thu, 15 Jun 2017 15:37:01 -0700
Message-ID: <59430c0d.yOcRy11/GaU5EmRZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbdFOWhC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 18:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aneesh.kumar@linux.vnet.ibm.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: schedule when potentially allocating many hugepages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-schedule-when-potentially-allocating-many-hugepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-schedule-when-potentially-allocating-many-hugepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-schedule-when-potentially-allocating-many-hugepages.patch

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
Subject: mm, hugetlb: schedule when potentially allocating many hugepages

A few hugetlb allocators loop while calling the page allocator and can
potentially prevent rescheduling if the page allocator slowpath is not
utilized.

Conditionally schedule when large numbers of hugepages can be allocated.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1706091535300.66176@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-schedule-when-potentially-allocating-many-hugepages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-schedule-when-potentially-allocating-many-hugepages
+++ a/mm/hugetlb.c
@@ -1781,6 +1781,7 @@ retry:
 			break;
 		}
 		list_add(&page->lru, &surplus_list);
+		cond_resched();
 	}
 	allocated += i;
 
@@ -2249,6 +2250,7 @@ static void __init hugetlb_hstate_alloc_
 		} else if (!alloc_fresh_huge_page(h,
 					 &node_states[N_MEMORY]))
 			break;
+		cond_resched();
 	}
 	if (i < h->max_huge_pages) {
 		char buf[32];
_

Patches currently in -mm which might be from rientjes@google.com are

mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low.patch
mm-vmpressure-pass-through-notification-support.patch
mm-hugetlb-schedule-when-potentially-allocating-many-hugepages.patch
fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch

