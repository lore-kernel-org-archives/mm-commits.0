From: akpm@linux-foundation.org
Subject: + hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
 added to -mm tree
Date: Thu, 17 Apr 2014 16:01:22 -0700
Message-ID: <53505d42.F6ywZiNu0uxcutrH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDQXBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 19:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, rientjes@google.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mtosatti@redhat.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidlohr@hp.com, aarcange@redhat.com, lcapitulino@redhat.com

Subject: + hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch added to -mm tree
To: lcapitulino@redhat.com,aarcange@redhat.com,davidlohr@hp.com,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,mtosatti@redhat.com,n-horiguchi@ah.jp.nec.com,riel@redhat.com,rientjes@google.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 16:01:22 -0700


The patch titled
     Subject: hugetlb: prep_compound_gigantic_page(): drop __init marker
has been added to the -mm tree.  Its filename is
     hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: prep_compound_gigantic_page(): drop __init marker

The HugeTLB subsystem uses the buddy allocator to allocate hugepages
during runtime.  This means that hugepages allocation during runtime is
limited to MAX_ORDER order.  For archs supporting gigantic pages (that is,
page sizes greater than MAX_ORDER), this in turn means that those pages
can't be allocated at runtime.

HugeTLB supports gigantic page allocation during boottime, via the boot
allocator.  To this end the kernel provides the command-line options
hugepagesz= and hugepages=, which can be used to instruct the kernel to
allocate N gigantic pages during boot.

For example, x86_64 supports 2M and 1G hugepages, but only 2M hugepages
can be allocated and freed at runtime.  If one wants to allocate 1G
gigantic pages, this has to be done at boot via the hugepagesz= and
hugepages= command-line options.

Now, gigantic page allocation at boottime has two serious problems:

 1. Boottime allocation is not NUMA aware. On a NUMA machine the kernel
    evenly distributes boottime allocated hugepages among nodes.

    For example, suppose you have a four-node NUMA machine and want
    to allocate four 1G gigantic pages at boottime. The kernel will
    allocate one gigantic page per node.

    On the other hand, we do have users who want to be able to specify
    which NUMA node gigantic pages should allocated from. So that they
    can place virtual machines on a specific NUMA node.

 2. Gigantic pages allocated at boottime can't be freed

At this point it's important to observe that regular hugepages allocated
at runtime don't have those problems.  This is so because HugeTLB
interface for runtime allocation in sysfs supports NUMA and runtime
allocated pages can be freed just fine via the buddy allocator.

This series adds support for allocating gigantic pages at runtime.  It
does so by allocating gigantic pages via CMA instead of the buddy
allocator.  Releasing gigantic pages is also supported via CMA.  As this
series builds on top of the existing HugeTLB interface, it makes gigantic
page allocation and releasing just like regular sized hugepages.  This
also means that NUMA support just works.

For example, to allocate two 1G gigantic pages on node 1, one can do:

 # echo 2 > \
   /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages

And, to release all gigantic pages on the same node:

 # echo 0 > \
   /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages

Please, refer to patch 5/5 for full technical details.

Finally, please note that this series is a follow up for a previous series
that tried to extend the command-line options set to be NUMA aware:

 http://marc.info/?l=linux-mm&m=139593335312191&w=2

During the discussion of that series it was agreed that having runtime
allocation support for gigantic pages was a better solution.



This patch (of 5):

This function is going to be used by non-init code in a future
commit.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-prep_compound_gigantic_page-drop-__init-marker mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-prep_compound_gigantic_page-drop-__init-marker
+++ a/mm/hugetlb.c
@@ -691,8 +691,7 @@ static void prep_new_huge_page(struct hs
 	put_page(page); /* free it into the hugepage allocator */
 }
 
-static void __init prep_compound_gigantic_page(struct page *page,
-					       unsigned long order)
+static void prep_compound_gigantic_page(struct page *page, unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch

