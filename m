Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDAF200120
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 21:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715558; cv=none; b=ps4PQ5HH7IDmYl3XwXjIz8rxO0hkH/GCFxDm3TJUEnair+hh5dIN1G0/n7d/vSPV0/AhyK82kK7eiL4wqjhRizJjX4zchFgy1oFpcqe7W89CvuHNHx5QsgbRN2qkl2+kFC4ucJJ7wB/PAObqdWP5iQJT857KbB1NFxrudZvmIBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715558; c=relaxed/simple;
	bh=V/RkJllgbDtP7Wu1GHqj36u06BpdzGK1t9HCEXW76HU=;
	h=Date:To:From:Subject:Message-Id; b=KRs/nvqszE7yOCuAXPqmT42ZZYyQjjAmmMVtXs4NYbUh514oOPQuVU6X3hKJ04NiyrK18l96onoaxg6LYdiiTN3YF+josgwgOcAJtwPrAoXXY4C4buzIm1pUqiA3cIXsE9tOkw068aQoI2p61Xrk/Y7h6wkOlWd36KvmZZvb2g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0eJ7KXVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0eJ7KXVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAB6C4CEE8;
	Thu,  3 Apr 2025 21:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743715558;
	bh=V/RkJllgbDtP7Wu1GHqj36u06BpdzGK1t9HCEXW76HU=;
	h=Date:To:From:Subject:From;
	b=0eJ7KXVZgZ6bzSBMCQFumHx2Nnyo34ZMpFJtOLpPeNJ3o/8dOU/8R/FJmKutq4++l
	 RNbwHTf295N7h/Qrwdyhu8CzZagNuTn+lXz8esgyRug3tpGEnole/IpKkWBpmgMlC8
	 eOJCsQLUnT4Qf33M1yW5l+wBBa5rbfdmmt19F9Ug=
Date: Thu, 03 Apr 2025 14:25:57 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch removed from -mm tree
Message-Id: <20250403212558.0DAB6C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

This patch was dropped because an updated version will be issued

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

