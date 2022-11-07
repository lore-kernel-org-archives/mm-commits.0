Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB728C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 20:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiKGUcy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Nov 2022 15:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbiKGUcw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2022 15:32:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A314028E10
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 12:32:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D716B81619
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 20:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC978C433D6;
        Mon,  7 Nov 2022 20:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667853169;
        bh=LFUDXUgzLDFAdHNExlz419SLOTvjG+KqlX9jax+XJjE=;
        h=Date:To:From:Subject:From;
        b=oQrobcScXdPcmREslz/+3xd7jfbY9tOkuoOXSyVBhLSasQwyWOnZrseqyyGQuAulL
         Gl2gn/ra8DpbZ55iCP032W8Y57X3QeQTcfir/CS9qbjwNIPgaxc6eF/H2FIARSM4Fj
         56KxMl4HxeG0y7cxy/Kxf1Rz6BdWtXDXLHHjEcyE=
Date:   Mon, 07 Nov 2022 12:32:48 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch added to mm-unstable branch
Message-Id: <20221107203248.DC978C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_vmemmap: remap head page to newly allocated page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch

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
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/hugetlb_vmemmap: remap head page to newly allocated page
Date: Mon, 7 Nov 2022 15:39:22 +0000

Today with `hugetlb_free_vmemmap=on` the struct page memory that is freed
back to page allocator is as following: for a 2M hugetlb page it will
reuse the first 4K vmemmap page to remap the remaining 7 vmemmap pages,
and for a 1G hugetlb it will remap the remaining 4095 vmemmap pages. 
Essentially, that means that it breaks the first 4K of a potentially
contiguous chunk of memory of 32K (for 2M hugetlb pages) or 16M (for 1G
hugetlb pages).  For this reason the memory that it's free back to page
allocator cannot be used for hugetlb to allocate huge pages of the same
size, but rather only of a smaller huge page size:

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
pools.  And it allocates a total of 31974 pages (63948M).

To fix this behaviour rather than remapping one page (thus breaking the
contiguous block of memory backing the struct pages) repopulate with a new
page for the head vmemmap page.  It will copying the data from the
currently mapped vmemmap page, and then remap it to this new page. 
Additionally, change the remap_pte callback to look at the newly added
walk::head_page which needs to be mapped as r/w compared to the tail page
vmemmap reuse that uses r/o.

The new head page is allocated by the caller of vmemmap_remap_free() given
that on restore it should still be using the same code path as before. 
Note that, because right now one hugepage is remapped at a time, thus only
one free 4K page at a time is needed to remap the head page.  Should it
fail to allocate said new page, it reuses the one that's already mapped
just like before.  As a result, for every 64G of contiguous hugepages it
can give back 1G more of contiguous memory per 64G, while needing in total
128M new 4K pages (for 2M hugetlb) or 256k (for 1G hugetlb).

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

In the example above, 407 more hugeltb 2M pages are allocated i.e.  814M
out of the 32394 (64796M) allocated.  So the memory freed back is indeed
being used back in hugetlb and there's no massive order-0..order-2 pages
accumulated unused.

Link: https://lkml.kernel.org/r/20221107153922.77094-1-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   59 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 7 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page
+++ a/mm/hugetlb_vmemmap.c
@@ -22,6 +22,7 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
+ * @head_page:		the page which replaces the head vmemmap page.
  * @reuse_page:		the page which is reused for the tail vmemmap pages.
  * @reuse_addr:		the virtual address of the @reuse_page page.
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
@@ -31,6 +32,7 @@ struct vmemmap_remap_walk {
 	void			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
 	unsigned long		nr_walked;
+	struct page		*head_page;
 	struct page		*reuse_page;
 	unsigned long		reuse_addr;
 	struct list_head	*vmemmap_pages;
@@ -105,10 +107,26 @@ static void vmemmap_pte_range(pmd_t *pmd
 	 * remapping (which is calling @walk->remap_pte).
 	 */
 	if (!walk->reuse_page) {
-		walk->reuse_page = pte_page(*pte);
+		struct page *page = pte_page(*pte);
+
+		/*
+		 * Copy the data from the original head, and remap to
+		 * the newly allocated page.
+		 */
+		if (walk->head_page) {
+			memcpy(page_address(walk->head_page),
+			       page_address(page), PAGE_SIZE);
+			walk->remap_pte(pte, addr, walk);
+			page = walk->head_page;
+		}
+
+		walk->reuse_page = page;
+
 		/*
-		 * Because the reuse address is part of the range that we are
-		 * walking, skip the reuse address range.
+		 * Because the reuse address is part of the range that
+		 * we are walking or the head page was remapped to a
+		 * new page, skip the reuse address range.
+		 * .
 		 */
 		addr += PAGE_SIZE;
 		pte++;
@@ -204,11 +222,11 @@ static int vmemmap_remap_range(unsigned
 	} while (pgd++, addr = next, addr != end);
 
 	/*
-	 * We only change the mapping of the vmemmap virtual address range
-	 * [@start + PAGE_SIZE, end), so we only need to flush the TLB which
+	 * We change the mapping of the vmemmap virtual address range
+	 * [@start, end], so we only need to flush the TLB which
 	 * belongs to the range.
 	 */
-	flush_tlb_kernel_range(start + PAGE_SIZE, end);
+	flush_tlb_kernel_range(start, end);
 
 	return 0;
 }
@@ -244,9 +262,21 @@ static void vmemmap_remap_pte(pte_t *pte
 	 * to the tail pages.
 	 */
 	pgprot_t pgprot = PAGE_KERNEL_RO;
-	pte_t entry = mk_pte(walk->reuse_page, pgprot);
+	struct page *reuse = walk->reuse_page;
 	struct page *page = pte_page(*pte);
+	pte_t entry;
+
+	/*
+	 * When there's no walk::reuse_page, it means we allocated a new head
+	 * page (stored in walk::head_page) and copied from the old head page.
+	 * In that case use the walk::head_page as the page to remap.
+	 */
+	if (!reuse) {
+		pgprot = PAGE_KERNEL;
+		reuse = walk->head_page;
+	}
 
+	entry = mk_pte(reuse, pgprot);
 	list_add_tail(&page->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
 }
@@ -315,6 +345,21 @@ static int vmemmap_remap_free(unsigned l
 		.reuse_addr	= reuse,
 		.vmemmap_pages	= &vmemmap_pages,
 	};
+	gfp_t gfp_mask = GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_NOWARN;
+	int nid = page_to_nid((struct page *)start);
+	struct page *page = NULL;
+
+	/*
+	 * Allocate a new head vmemmap page to avoid breaking a contiguous
+	 * block of struct page memory when freeing it back to page allocator
+	 * in free_vmemmap_page_list(). This will allow the likely contiguous
+	 * struct page backing memory to be kept contiguous and allowing for
+	 * more allocations of hugepages. Fallback to the currently
+	 * mapped head page in case should it fail to allocate.
+	 */
+	if (IS_ALIGNED((unsigned long)start, PAGE_SIZE))
+		page = alloc_pages_node(nid, gfp_mask, 0);
+	walk.head_page = page;
 
 	/*
 	 * In order to make remapping routine most efficient for the huge pages,
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch

