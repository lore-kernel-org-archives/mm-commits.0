Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31657CD37AF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 23:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjIOXbY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 19:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjIOXbR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 19:31:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741B71FF5
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 16:31:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096ADC433CB;
        Fri, 15 Sep 2023 23:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694820672;
        bh=bDLjxOPJ19FfbCb07PUGEis7ChoXLNhH90FGVKUQBx0=;
        h=Date:To:From:Subject:From;
        b=QPBhdqXO86wiGsD5mv4gdVKhe0VrYTctojagiC4sja1ZeFBD7/pWJJOMTLqTPxMZz
         KnF+1p+pV9YR4ME7Y1grV8gaGJt+WbDF15mYxWjexKCpxn7QJc7suHGSJauiNNE29z
         4q7Vs54bWsvtJXbQaNnrv+QiEk98URV6FbAnwkVc=
Date:   Fri, 15 Sep 2023 16:31:11 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mike.kravetz@oracle.com,
        mhocko@suse.com, linmiaohe@huawei.com, jthoughton@google.com,
        joao.m.martins@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, anshuman.khandual@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-use-a-folio-in-free_hpage_workfn.patch added to mm-unstable branch
Message-Id: <20230915233112.096ADC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: use a folio in free_hpage_workfn()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-use-a-folio-in-free_hpage_workfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-use-a-folio-in-free_hpage_workfn.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: use a folio in free_hpage_workfn()
Date: Fri, 15 Sep 2023 15:15:35 -0700

Patch series "Batch hugetlb vmemmap modification operations", v3.

When hugetlb vmemmap optimization was introduced, the overhead of enabling
the option was measured as described in commit 426e5c429d16 [1].  The
summary states that allocating a hugetlb page should be ~2x slower with
optimization and freeing a hugetlb page should be ~2-3x slower.  Such
overhead was deemed an acceptable trade off for the memory savings
obtained by freeing vmemmap pages.

It was recently reported that the overhead associated with enabling
vmemmap optimization could be as high as 190x for hugetlb page
allocations.  Yes, 190x!  Some actual numbers from other environments are:

Bare Metal 8 socket Intel(R) Xeon(R) CPU E7-8895
------------------------------------------------
Unmodified next-20230824, vm.hugetlb_optimize_vmemmap = 0
time echo 500000 > .../hugepages-2048kB/nr_hugepages
real    0m4.119s
time echo 0 > .../hugepages-2048kB/nr_hugepages
real    0m4.477s

Unmodified next-20230824, vm.hugetlb_optimize_vmemmap = 1
time echo 500000 > .../hugepages-2048kB/nr_hugepages
real    0m28.973s
time echo 0 > .../hugepages-2048kB/nr_hugepages
real    0m36.748s

VM with 252 vcpus on host with 2 socket AMD EPYC 7J13 Milan
-----------------------------------------------------------
Unmodified next-20230824, vm.hugetlb_optimize_vmemmap = 0
time echo 524288 > .../hugepages-2048kB/nr_hugepages
real    0m2.463s
time echo 0 > .../hugepages-2048kB/nr_hugepages
real    0m2.931s

Unmodified next-20230824, vm.hugetlb_optimize_vmemmap = 1
time echo 524288 > .../hugepages-2048kB/nr_hugepages
real    2m27.609s
time echo 0 > .../hugepages-2048kB/nr_hugepages
real    2m29.924s

In the VM environment, the slowdown of enabling hugetlb vmemmap optimization
resulted in allocation times being 61x slower.

A quick profile showed that the vast majority of this overhead was due to
TLB flushing.  Each time we modify the kernel pagetable we need to flush
the TLB.  For each hugetlb that is optimized, there could be potentially
two TLB flushes performed.  One for the vmemmap pages associated with the
hugetlb page, and potentially another one if the vmemmap pages are mapped
at the PMD level and must be split.  The TLB flushes required for the
kernel pagetable, result in a broadcast IPI with each CPU having to flush
a range of pages, or do a global flush if a threshold is exceeded.  So,
the flush time increases with the number of CPUs.  In addition, in virtual
environments the broadcast IPI can’t be accelerated by hypervisor
hardware and leads to traps that need to wakeup/IPI all vCPUs which is
very expensive.  Because of this the slowdown in virtual environments is
even worse than bare metal as the number of vCPUS/CPUs is increased.

The following series attempts to reduce amount of time spent in TLB
flushing.  The idea is to batch the vmemmap modification operations for
multiple hugetlb pages.  Instead of doing one or two TLB flushes for each
page, we do two TLB flushes for each batch of pages.  One flush after
splitting pages mapped at the PMD level, and another after remapping
vmemmap associated with all hugetlb pages.  Results of such batching are
as follows:

Bare Metal 8 socket Intel(R) Xeon(R) CPU E7-8895
------------------------------------------------
next-20230824 + Batching patches, vm.hugetlb_optimize_vmemmap = 0
time echo 500000 > .../hugepages-2048kB/nr_hugepages
real    0m4.719s
time echo 0 > .../hugepages-2048kB/nr_hugepages
real    0m4.245s

next-20230824 + Batching patches, vm.hugetlb_optimize_vmemmap = 1
time echo 500000 > .../hugepages-2048kB/nr_hugepages
real    0m7.267s
time echo 0 > .../hugepages-2048kB/nr_hugepages
real    0m13.199s

VM with 252 vcpus on host with 2 socket AMD EPYC 7J13 Milan
-----------------------------------------------------------
next-20230824 + Batching patches, vm.hugetlb_optimize_vmemmap = 0
time echo 524288 > .../hugepages-2048kB/nr_hugepages
real    0m2.715s
time echo 0 > .../hugepages-2048kB/nr_hugepages
real    0m3.186s

next-20230824 + Batching patches, vm.hugetlb_optimize_vmemmap = 1
time echo 524288 > .../hugepages-2048kB/nr_hugepages
real    0m4.799s
time echo 0 > .../hugepages-2048kB/nr_hugepages
real    0m5.273s

With batching, results are back in the 2-3x slowdown range.

This series is based on next-20230913.
The first 3 patches of the series are modifications currently going into the
mm tree that modify the same area, or fix BUGs hit easily when exercising
this series.  They are not directly related to the batching changes.
Patch 4 (hugetlb: optimize update_and_free_pages_bulk to avoid lock cycles)
is where batching changes begin.


This patch (of 11):

update_and_free_hugetlb_folio puts the memory on hpage_freelist as a folio
so we can take it off the list as a folio.

Link: https://lkml.kernel.org/r/20230915221548.552084-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20230915221548.552084-3-mike.kravetz@oracle.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: James Houghton <jthoughton@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-a-folio-in-free_hpage_workfn
+++ a/mm/hugetlb.c
@@ -1780,22 +1780,22 @@ static void free_hpage_workfn(struct wor
 	node = llist_del_all(&hpage_freelist);
 
 	while (node) {
-		struct page *page;
+		struct folio *folio;
 		struct hstate *h;
 
-		page = container_of((struct address_space **)node,
-				     struct page, mapping);
+		folio = container_of((struct address_space **)node,
+				     struct folio, mapping);
 		node = node->next;
-		page->mapping = NULL;
+		folio->mapping = NULL;
 		/*
 		 * The VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio) in
 		 * folio_hstate() is going to trigger because a previous call to
 		 * remove_hugetlb_folio() will clear the hugetlb bit, so do
 		 * not use folio_hstate() directly.
 		 */
-		h = size_to_hstate(page_size(page));
+		h = size_to_hstate(folio_size(folio));
 
-		__update_and_free_hugetlb_folio(h, page_folio(page));
+		__update_and_free_hugetlb_folio(h, folio);
 
 		cond_resched();
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch

