Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595791C5D62
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 02:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744251304; cv=none; b=eYxQjGEtC0ze08Bni8sGMHVVmqMuS0I3osdLTWSSQOOPIGdbU+2o8qJ7MC2XzsFXDUcO7pv0cfnvonFDgAL8uawiylDOplWIszCIBjk+0QMYuT5lSILv6Jzh2ZR3SYVaUUUfRUH3wFEkpgn2wh0ZD9wIkg7d7j58CB47+Q4SP1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744251304; c=relaxed/simple;
	bh=/uuKI1WFu1KQ0YCDmHy1vlimSqIB4CQQEShHdWcBQrY=;
	h=Date:To:From:Subject:Message-Id; b=Wg0SIYYUlnBpNW/By4ZfWq4xXxNPksgou+JxOpQIOYIZQfNN646mxCWWc/Xh26KWYucVmrmy1pFj02CWNakWrNtP1mi0mp0MjEt4DUkVzi5ExR/qiEMlqrPUDEDil6vsH0XeNRzZxV5NnKuPDTjvb5bKEXuM+EZCXcrGMB9Ychg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zmlSqI3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zmlSqI3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0512C4CEE2;
	Thu, 10 Apr 2025 02:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744251303;
	bh=/uuKI1WFu1KQ0YCDmHy1vlimSqIB4CQQEShHdWcBQrY=;
	h=Date:To:From:Subject:From;
	b=zmlSqI3Tkc2kX92SP42tNLyNQBHNgrMGnmUKSuyR4oXwhq8V4uDssMsGSxzkG0sfT
	 QDt20cgQMG9ijPDnZ4UFd+lGJavDCoaXHsNF/QXz97zdCET/VX2Q/F3y3srhN4+1S7
	 HmTXAQh+kibX4FY06iYiCYCjU8gBy/9jtckKETZw=
Date: Wed, 09 Apr 2025 19:15:03 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410021503.A0512C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

