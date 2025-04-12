Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379E9134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418023; cv=none; b=nf/EMM28AP2jM17iVzHl5fmSVCkwBglPbTH41Sngzxdtm9X4GotYkh4fQZSIlLrL3DD9VY8kddgr8LlI1AVvhcu+vQzxgosyicKjre+okHu+6IOBDhelU63ZvGrlMMf81Inc4Ehai6JvTLB3my830hS9CawcR+mPYfOxarHurwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418023; c=relaxed/simple;
	bh=dUIAuuMG1p0Lt+lG6TiENQGV75G5MRgZYbrjU8v2AL0=;
	h=Date:To:From:Subject:Message-Id; b=gGCODS/TZVxrxe4vag9yywn1FjzfT2uyP7kBe0zjQMZXJohonPycwr8xUmp6ULTSb5cW6YGQ6IxiHKxgKrXFnVV8T+iqTG2sV4mCP0VComVbNi+mhkdc0ZoqFl1SL/1e8Uk/eqtGNG+9Oajlb9QeTnVFsLnyr2ssF+QFVx2CCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vUZNq5Hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vUZNq5Hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C753C4CEE2;
	Sat, 12 Apr 2025 00:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418023;
	bh=dUIAuuMG1p0Lt+lG6TiENQGV75G5MRgZYbrjU8v2AL0=;
	h=Date:To:From:Subject:From;
	b=vUZNq5Hllf7A96eVTKNiFsmYJUep5oBx3IPNOquAUozoA7GEUSQeSzxEfh6HI+fRJ
	 wsY+qOBKv+K3von2QoTDWYTfPz8JNxWoKtrkezgxp2T6+117i0PMe2V0UcvvLtYQ6f
	 +1Zu40GoknxcsMh7pnFTQMVdhI2LITn+seSlfrcM=
Date: Fri, 11 Apr 2025 17:33:42 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch removed from -mm tree
Message-Id: <20250412003343.0C753C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
Date: Mon, 7 Apr 2025 20:47:06 +0800

In set_max_huge_pages(), min_count is computed taking into account surplus
huge pages, which might lead in some cases to not be able to free huge
pages and end up accounting them as surplus instead.

One way to solve it is to subtract surplus_huge_pages directly, but we
cannot do it blindly because there might be surplus pages that are also
free pages, which might happen when we fail to restore the vmemmap for
optimized hvo pages.  So we could be subtracting the same page twice.

In order to work this around, let us first compute the number of free
persistent pages, and use that along with surplus pages to compute
min_count.

Steps to reproduce:
1) create 5 hugetlb folios in Node0
2) run a program to use all the hugetlb folios
3) echo 0 > nr_hugepages for Node0 to free the hugetlb folios.  Thus
   the 5 hugetlb folios in Node0 are accounted as surplus.
4) create 5 hugetlb folios in Node1
5) echo 0 > nr_hugepages for Node1 to free the hugetlb folios

The result:
        Node0    Node1
Total     5         5
Free      0         5
Surp      5         5

The result with this patch:
        Node0    Node1
Total     5         0
Free      0         0
Surp      5         0

Link: https://lkml.kernel.org/r/20250409055957.3774471-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20250407124706.2688092-1-tujinjiang@huawei.com
Fixes: 9a30523066cd ("hugetlb: add per node hstate attributes")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages
+++ a/mm/hugetlb.c
@@ -3825,6 +3825,7 @@ found:
 static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 			      nodemask_t *nodes_allowed)
 {
+	unsigned long persistent_free_count;
 	unsigned long min_count;
 	unsigned long allocated;
 	struct folio *folio;
@@ -3959,8 +3960,24 @@ static int set_max_huge_pages(struct hst
 	 * though, we'll note that we're not allowed to exceed surplus
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
-	 */
-	min_count = h->resv_huge_pages + h->nr_huge_pages - h->free_huge_pages;
+	 *
+	 * min_count is the expected number of persistent pages, we
+	 * shouldn't calculate min_count by using
+	 * resv_huge_pages + persistent_huge_pages() - free_huge_pages,
+	 * because there may exist free surplus huge pages, and this will
+	 * lead to subtracting twice. Free surplus huge pages come from HVO
+	 * failing to restore vmemmap, see comments in the callers of
+	 * hugetlb_vmemmap_restore_folio(). Thus, we should calculate
+	 * persistent free count first.
+	 */
+	persistent_free_count = h->free_huge_pages;
+	if (h->free_huge_pages > persistent_huge_pages(h)) {
+		if (h->free_huge_pages > h->surplus_huge_pages)
+			persistent_free_count -= h->surplus_huge_pages;
+		else
+			persistent_free_count = 0;
+	}
+	min_count = h->resv_huge_pages + persistent_huge_pages(h) - persistent_free_count;
 	min_count = max(count, min_count);
 	try_to_free_low(h, min_count, nodes_allowed);
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch
mm-swap-set-active-flag-after-adding-the-folio-to-activate-fbatch.patch

