From: akpm@linux-foundation.org
Subject: [patch 033/115] mm, hugetlb: schedule when potentially
 allocating many hugepages
Date: Mon, 10 Jul 2017 15:48:50 -0700
Message-ID: <20170710224850.5i7pipftp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754696AbdGJWtC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, torvalds@linux-foundation.org

From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: schedule when potentially allocating many hugepages

A few hugetlb allocators loop while calling the page allocator and can
potentially prevent rescheduling if the page allocator slowpath is not
utilized.

Conditionally schedule when large numbers of hugepages can be allocated.

Anshuman: "Fixes a task which was getting hung while writing like 10000
hugepages (16MB on POWER8) into /proc/sys/vm/nr_hugepages."

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1706091535300.66176@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Tested-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
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
