From: akpm@linux-foundation.org
Subject: + mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch added
 to -mm tree
Date: Tue, 04 Feb 2014 16:34:08 -0800
Message-ID: <52f18700.JeKec1NEkw3GYm6H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBEAeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 19:34:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, iamjoonsoo.kim@lge.com, davidlohr@hp.com, rientjes@google.com

Subject: + mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch added to -mm tree
To: rientjes@google.com,davidlohr@hp.com,iamjoonsoo.kim@lge.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 16:34:08 -0800


The patch titled
     Subject: mm, hugetlb: mark some bootstrap functions as __init
has been added to the -mm tree.  Its filename is
     mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch

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
Subject: mm, hugetlb: mark some bootstrap functions as __init

Both prep_compound_huge_page() and prep_compound_gigantic_page() are only
called at bootstrap and can be marked as __init.

The __SetPageTail(page) in prep_compound_gigantic_page() happening before
page->first_page is initialized is not concerning since this is bootstrap.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-mark-some-bootstrap-functions-as-__init mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-mark-some-bootstrap-functions-as-__init
+++ a/mm/hugetlb.c
@@ -689,7 +689,8 @@ static void prep_new_huge_page(struct hs
 	put_page(page); /* free it into the hugepage allocator */
 }
 
-static void prep_compound_gigantic_page(struct page *page, unsigned long order)
+static void __init prep_compound_gigantic_page(struct page *page,
+					       unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
@@ -1319,7 +1320,7 @@ found:
 	return 1;
 }
 
-static void prep_compound_huge_page(struct page *page, int order)
+static void __init prep_compound_huge_page(struct page *page, int order)
 {
 	if (unlikely(order > (MAX_ORDER - 1)))
 		prep_compound_gigantic_page(page, order);
_

Patches currently in -mm which might be from rientjes@google.com are

documentation-kernel-parameterstxt-fix-memmap=-language.patch
mm-__set_page_dirty_nobuffers-uses-spin_lock_irqseve-instead-of-spin_lock_irq.patch
mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch
fs-filec-fdtable-avoid-triggering-ooms-from-alloc_fdmem.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-utilc-add-kstrimdup.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

