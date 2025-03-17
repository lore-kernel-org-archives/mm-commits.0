Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA7E217F46
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188477; cv=none; b=abrPOvM98KHkGvyJbp/SpLneeCt2B6W83iou/7aAB425W/AN+hdNURdv8kdwJGaaLv4uAmtLJZ6dQVMVoml5+/FNHwEN8UQWK6uA+MwknvHqOZOuGYKz04EVl1Q8zh9p0BG9UiU6eqDJO0JpNNPRUwvs4tycy6PInvbFx2FNB7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188477; c=relaxed/simple;
	bh=pxA7YbzAlQtLSjFbC3mNRHxA46TlZk3uh5wkiM0iNiU=;
	h=Date:To:From:Subject:Message-Id; b=X92MUuFM4idGogcmZyiOpUDVY5GAR2pG2kI3X8x6wB+b3maJWOy3TYOsWZDRh7y2rV73O9RmzTOdfZKsFljWPJGqQCyMWzkyVkCvwR2+suMLvPMYlY1i5v162jn93I2+tSZyDNHBuB+T3VxyU+qdQOyDEQqzAD8A7YIIQ6FAJbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oS4qXzIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oS4qXzIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4085FC4CEEC;
	Mon, 17 Mar 2025 05:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188477;
	bh=pxA7YbzAlQtLSjFbC3mNRHxA46TlZk3uh5wkiM0iNiU=;
	h=Date:To:From:Subject:From;
	b=oS4qXzIYhKhHxtZa+IIL9wsKXKr1OSxybG1uT7O+K+TnI6mc1a92MFbj63x+29+TX
	 fGSzNgGFXQaz51awjB+WA0XMty+lAXk2KYlPQabJmesdb9f/ROdgSRJU7bJKlNdQVz
	 Jf+mZAetwZQAd13yy3mVL9OLYZUg0yDMS8XX7ulo=
Date: Sun, 16 Mar 2025 22:14:36 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mel@csn.ul.ie,lee.schermerhorn@hp.com,david@redhat.com,andi@firstfloor.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch removed from -mm tree
Message-Id: <20250317051437.4085FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
Date: Tue, 25 Feb 2025 22:19:33 +0800

In set_max_huge_pages(), min_count should mean the acquired persistent
huge pages, but it contains surplus huge pages.  It will lead to failing
to free free huge pages for a node.

Steps to reproduce:
1) create 5 huge pages in Node 0
2) run a program to use all the huge pages
3) create 5 huge pages in Node 1
4) echo 0 > nr_hugepages for Node 1 to free the huge pages

The result:
        Node 0    Node 1
Total     5         5
Free      0         5
Surp      5         5

With this patch, step 4) destroys the 5 huge pages in Node 1

The result with this patch:
        Node 0    Node 1
Total     5         0
Free      0         0
Surp      5         0

Link: https://lkml.kernel.org/r/20250225141933.3852667-1-tujinjiang@huawei.com
Fixes: 9a30523066cd ("hugetlb: add per node hstate attributes")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages
+++ a/mm/hugetlb.c
@@ -3937,7 +3937,7 @@ static int set_max_huge_pages(struct hst
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
 	 */
-	min_count = h->resv_huge_pages + h->nr_huge_pages - h->free_huge_pages;
+	min_count = h->resv_huge_pages + persistent_huge_pages(h) - h->free_huge_pages;
 	min_count = max(count, min_count);
 	try_to_free_low(h, min_count, nodes_allowed);
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

