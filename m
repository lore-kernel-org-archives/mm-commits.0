Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC38C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiLAADU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiLAABS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A8C89321
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1647B81D12
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD85AC433D7;
        Thu,  1 Dec 2022 00:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852859;
        bh=QBkWx5Jn6hIvtieu94rNiXQzUoCKm4O47OfkV74P1/g=;
        h=Date:To:From:Subject:From;
        b=dzNBSc6Ch8JqMRNtx6I0VYIObPEQloFsri0Qijs1VJZOutA8CtVuKha9LSrQs25b9
         aH2lbUxNe/wB9URuyVqk99uIKP3KP6h/BoG7qORKSN4uob7exb4es6quyCb2Ywv5xr
         5ZBclV0KXC6eZSCM3+3+fbP5GkydGTjn+5WbAMto=
Date:   Wed, 30 Nov 2022 16:00:59 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch removed from -mm tree
Message-Id: <20221201000059.AD85AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: remap head page to newly allocated page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb_vmemmap: remap head page to newly allocated page
Date: Mon, 7 Nov 2022 15:39:22 +0000

Today with `hugetlb_free_vmemmap=on` the struct page memory that is freed
back to page allocator is as following: for a 2M hugetlb page it will reuse
the first 4K vmemmap page to remap the remaining 7 vmemmap pages, and for a
1G hugetlb it will remap the remaining 4095 vmemmap pages. Essentially,
that means that it breaks the first 4K of a potentially contiguous chunk of
memory of 32K (for 2M hugetlb pages) or 16M (for 1G hugetlb pages). For
this reason the memory that it's free back to page allocator cannot be used
for hugetlb to allocate huge pages of the same size, but rather only of a
smaller huge page size:

Trying to assign a 64G node to hugetlb (on a 128G 2node guest, each node
having 64G):

* Before allocation:
Free pages count per migrate type at order       0      1      2      3
4      5      6      7      8      9     10
...
Node    0, zone   Normal, type      Movable    340    100     32     15
1      2      0      0      0      1  15558

$ echo 32768 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
$ cat /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
 31987

* After:

Node    0, zone   Normal, type      Movable  30893  32006  31515      7
0      0      0      0      0      0      0

Notice how the memory freed back are put back into 4K / 8K / 16K page
pools. And it allocates a total of 31987 pages (63974M).

To fix this behaviour rather than remapping second vmemmap page (thus
breaking the contiguous block of memory backing the struct pages)
repopulate the first vmemmap page with a new one. We allocate and copy
from the currently mapped vmemmap page, and then remap it later on.
The same algorithm works if there's a pre initialized walk::reuse_page
and the head page doesn't need to be skipped and instead we remap it
when the @addr being changed is the @reuse_addr.

The new head page is allocated in vmemmap_remap_free() given that on
restore there's no need for functional change. Note that, because right
now one hugepage is remapped at a time, thus only one free 4K page at a
time is needed to remap the head page. Should it fail to allocate said
new page, it reuses the one that's already mapped just like before. As a
result, for every 64G of contiguous hugepages it can give back 1G more
of contiguous memory per 64G, while needing in total 128M new 4K pages
(for 2M hugetlb) or 256k (for 1G hugetlb).

After the changes, try to assign a 64G node to hugetlb (on a 128G 2node
guest, each node with 64G):

* Before allocation
Free pages count per migrate type at order       0      1      2      3
4      5      6      7      8      9     10
...
Node    0, zone   Normal, type      Movable      1      1      1      0
0      1      0      0      1      1  15564

$ echo 32768  > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
$ cat /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
32394

* After:

Node    0, zone   Normal, type      Movable      0     50     97    108
96     81     70     46     18      0      0

In the example above, 407 more hugeltb 2M pages are allocated i.e. 814M out
of the 32394 (64788M) allocated. So the memory freed back is indeed being
used back in hugetlb and there's no massive order-0..order-2 pages
accumulated unused.

[joao.m.martins@oracle.com: v3]
  Link: https://lkml.kernel.org/r/20221109200623.96867-1-joao.m.martins@oracle.com
[joao.m.martins@oracle.com: add smp_wmb() to ensure page contents are visible prior to PTE write]
  Link: https://lkml.kernel.org/r/20221110121214.6297-1-joao.m.martins@oracle.com
Link: https://lkml.kernel.org/r/20221107153922.77094-1-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page
+++ a/mm/hugetlb_vmemmap.c
@@ -203,12 +203,7 @@ static int vmemmap_remap_range(unsigned
 			return ret;
 	} while (pgd++, addr = next, addr != end);
 
-	/*
-	 * We only change the mapping of the vmemmap virtual address range
-	 * [@start + PAGE_SIZE, end), so we only need to flush the TLB which
-	 * belongs to the range.
-	 */
-	flush_tlb_kernel_range(start + PAGE_SIZE, end);
+	flush_tlb_kernel_range(start, end);
 
 	return 0;
 }
@@ -244,9 +239,23 @@ static void vmemmap_remap_pte(pte_t *pte
 	 * to the tail pages.
 	 */
 	pgprot_t pgprot = PAGE_KERNEL_RO;
-	pte_t entry = mk_pte(walk->reuse_page, pgprot);
 	struct page *page = pte_page(*pte);
+	pte_t entry;
+
+	/* Remapping the head page requires r/w */
+	if (unlikely(addr == walk->reuse_addr)) {
+		pgprot = PAGE_KERNEL;
+		list_del(&walk->reuse_page->lru);
+
+		/*
+		 * Makes sure that preceding stores to the page contents from
+		 * vmemmap_remap_free() become visible before the set_pte_at()
+		 * write.
+		 */
+		smp_wmb();
+	}
 
+	entry = mk_pte(walk->reuse_page, pgprot);
 	list_add_tail(&page->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
 }
@@ -315,6 +324,24 @@ static int vmemmap_remap_free(unsigned l
 		.reuse_addr	= reuse,
 		.vmemmap_pages	= &vmemmap_pages,
 	};
+	int nid = page_to_nid((struct page *)start);
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_THISNODE | __GFP_NORETRY |
+			__GFP_NOWARN;
+
+	/*
+	 * Allocate a new head vmemmap page to avoid breaking a contiguous
+	 * block of struct page memory when freeing it back to page allocator
+	 * in free_vmemmap_page_list(). This will allow the likely contiguous
+	 * struct page backing memory to be kept contiguous and allowing for
+	 * more allocations of hugepages. Fallback to the currently
+	 * mapped head page in case should it fail to allocate.
+	 */
+	walk.reuse_page = alloc_pages_node(nid, gfp_mask, 0);
+	if (walk.reuse_page) {
+		copy_page(page_to_virt(walk.reuse_page),
+			  (void *)walk.reuse_addr);
+		list_add(&walk.reuse_page->lru, &vmemmap_pages);
+	}
 
 	/*
 	 * In order to make remapping routine most efficient for the huge pages,
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are


