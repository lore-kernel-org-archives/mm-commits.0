Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4660190676
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 03:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743652262; cv=none; b=SNqvgPrMVKqlhCggaPce0QRq0tXdrNJMoWSsUXfvh6fDZvXCwyYwFCNGXA6pHM2wBdOcS2MAzSeoqHg6c4V6KhOLajtB3etwluwphIBYu24vEeJQi727L+UwOSkP25EozW4vaYTvt91n2j5psNCdwUtBCwXUANLl79uuJq0mfM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743652262; c=relaxed/simple;
	bh=ENdn/b12okj2TpSNURVPWjet0mHEX42CdIymeQiQipI=;
	h=Date:To:From:Subject:Message-Id; b=Mgl/vE2tOdkEDTrY4hR3T3+TUv5R0fMx7Nu7jy/22AdV61QhIr2HcPOebW9czq4yl7t/uZ4FsW0PvxqPphlq44W9rGM7bol4DIjJPcGzGeLNQa2ExgxPf7SUUMwo0IDEEMyq/aKXQ/jFSo+biRMW70S2EJeRVRiytT7sMoJixn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wCs4lsXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wCs4lsXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B0AC4CEE3;
	Thu,  3 Apr 2025 03:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743652262;
	bh=ENdn/b12okj2TpSNURVPWjet0mHEX42CdIymeQiQipI=;
	h=Date:To:From:Subject:From;
	b=wCs4lsXqZo7SugtSUPttpi1QpDv0TbBe+271eFBEFYnHD3OctmxdsUIp1cSg3afA8
	 E9yiF34aV9PbZfopGNHvjnJgA8q0kejj6Cg4c4VmEQ1R7eND/euQ+Xue7K5q6iEHYS
	 kB8WdTNbE37dhWpkZxyadWoP0oFnmdVB702UV3kA=
Date: Wed, 02 Apr 2025 20:51:01 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch added to mm-new branch
Message-Id: <20250403035102.33B0AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

This patch will later appear in the mm-new branch at
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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
Date: Tue, 1 Apr 2025 16:23:39 +0800

In set_max_huge_pages(), min_count should mean the acquired persistent
huge pages, but it contains surplus huge pages.  It will leads to failing
to freeing free huge pages for a Node.

Steps to reproduce:
1) create 5 hugetlb folios in Node0
2) run a program to use all the hugetlb folios
3) echo 0 > nr_hugepages for Node0 to free the hugetlb folios. Thus the 5
hugetlb folios in Node0 are accounted as surplus.
4) create 5 hugetlb folios in Node1
5) echo 0 > nr_hugepages for Node1 to free the hugetlb folios

The result:
        Node0    Node1
Total     5         5
Free      0         5
Surp      5         5

We couldn't subtract surplus_huge_pages from min_mount, since free hugetlb
folios may be surplus due to HVO.  In __update_and_free_hugetlb_folio(),
hugetlb_vmemmap_restore_folio() may fail, add the folio back to pool and
treat it as surplus.  If we directly subtract surplus_huge_pages from
min_mount, some free folios will be subtracted twice.

To fix it, check if count is less than the num of free huge pages that
could be destroyed (i.e., available_huge_pages(h)), and remove hugetlb
folios if so.

Since there may exist free surplus hugetlb folios, we should remove
surplus folios first to make surplus count correct.

The result with this patch:
        Node0    Node1
Total     5         0
Free      0         0
Surp      5         0

Link: https://lkml.kernel.org/r/20250401082339.676723-1-tujinjiang@huawei.com
Fixes: 9a30523066cd ("hugetlb: add per node hstate attributes")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages
+++ a/mm/hugetlb.c
@@ -3778,7 +3778,7 @@ static void try_to_free_low(struct hstat
 		struct folio *folio, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(folio, next, freel, lru) {
-			if (count >= h->nr_huge_pages)
+			if (count >= available_huge_pages(h))
 				goto out;
 			if (folio_test_highmem(folio))
 				continue;
@@ -3832,11 +3832,30 @@ found:
 	return 1;
 }
 
+static struct folio *remove_surplus_pool_hugetlb_folio(struct hstate *h,
+		nodemask_t *nodes_allowed)
+{
+	int nr_nodes, node;
+	struct folio *folio = NULL;
+
+	lockdep_assert_held(&hugetlb_lock);
+	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
+		if (h->surplus_huge_pages_node[node] &&
+		    !list_empty(&h->hugepage_freelists[node])) {
+			folio = list_entry(h->hugepage_freelists[node].next,
+					  struct folio, lru);
+			remove_hugetlb_folio(h, folio, true);
+			break;
+		}
+	}
+
+	return folio;
+}
+
 #define persistent_huge_pages(h) (h->nr_huge_pages - h->surplus_huge_pages)
 static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 			      nodemask_t *nodes_allowed)
 {
-	unsigned long min_count;
 	unsigned long allocated;
 	struct folio *folio;
 	LIST_HEAD(page_list);
@@ -3971,15 +3990,29 @@ static int set_max_huge_pages(struct hst
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
 	 */
-	min_count = h->resv_huge_pages + h->nr_huge_pages - h->free_huge_pages;
-	min_count = max(count, min_count);
-	try_to_free_low(h, min_count, nodes_allowed);
+	try_to_free_low(h, count, nodes_allowed);
 
 	/*
 	 * Collect pages to be removed on list without dropping lock
-	 */
-	while (min_count < persistent_huge_pages(h)) {
-		folio = remove_pool_hugetlb_folio(h, nodes_allowed, 0);
+	 *
+	 * There may be free surplus huge pages due to HVO, see comments
+	 * in __update_and_free_hugetlb_folio() when calling
+	 * hugetlb_vmemmap_restore_folio(). Collect surplus pages first.
+	 */
+	while (count < available_huge_pages(h)) {
+		if (h->surplus_huge_pages && h->free_huge_pages) {
+			folio = remove_surplus_pool_hugetlb_folio(h, nodes_allowed);
+			if (!folio)
+				break;
+
+			list_add(&folio->lru, &page_list);
+		} else {
+			break;
+		}
+	}
+
+	while (count < available_huge_pages(h)) {
+		folio = remove_pool_hugetlb_folio(h, nodes_allowed, false);
 		if (!folio)
 			break;
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch
mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

