Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F5C215F5B
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535657; cv=none; b=NMw1jJcXtt4wS2BfrHh/cKVXqinuB4X8ciacY+bRdI96578y3gy0Pm3FaUSdPd1u8+kcvjPjDuR5+WqeSkdWzlKP5RcWfeBK64l22VQOdOuoyik+bOn/AwKt07wHb77JlQ9TY7B+UeRETESVv2H3JAR12Mkakl/4kSZkQ5UC2tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535657; c=relaxed/simple;
	bh=Fre0ZO8fWkR2Wq1LBzBHm8buR7cT43D9bjXm5v+i03E=;
	h=Date:To:From:Subject:Message-Id; b=AQsTsfZsTnbfbt2xqwCBS2yG4afUB1kAP1jEo7WK95OagjTOyYN/3adXTTf3TK0rfd6VACnnFmY0yYFGP6sibFbgYcPCISMW9u0Qr2zIS5eulRo7orf5pu3y4xNNZp/dev9HVcy5yWrAJvfG3q8aS0bzeNZZoqXnulCascSwXgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sOHIJP9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sOHIJP9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D524C4CEDD;
	Wed, 26 Feb 2025 02:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740535657;
	bh=Fre0ZO8fWkR2Wq1LBzBHm8buR7cT43D9bjXm5v+i03E=;
	h=Date:To:From:Subject:From;
	b=sOHIJP9I5jpgYlCtM4VntA+QoEpFIWWxxkU3VwE3W2GNrptbP/W9mt2HlN6IbXP7W
	 urv6dz4d1lJC+qlfKaZk23sF3i1v4flj2juvoQSsbj1yfjeBX/6eif91Q5SEk+Gs2V
	 k1P2c1ufDJ+M9ONOQfk85/+KP5HNCSExs1Ryl1yc=
Date: Tue, 25 Feb 2025 18:07:36 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,mel@csn.ul.ie,lee.schermerhorn@hp.com,david@redhat.com,andi@firstfloor.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch added to mm-unstable branch
Message-Id: <20250226020737.1D524C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
Date: Tue, 25 Feb 2025 22:19:33 +0800

In set_max_huge_pages(), min_count should mean the acquired persistent
huge pages, but it contains surplus huge pages.  It will leads to failing
to freeing free huge pages for a Node.

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

Link: https://lkml.kernel.org/r/20250225141933.3852667-1-tujinjiang@huawei.com
Fixes: 9a30523066cd ("hugetlb: add per node hstate attributes")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages
+++ a/mm/hugetlb.c
@@ -3933,7 +3933,7 @@ static int set_max_huge_pages(struct hst
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
 	 */
-	min_count = h->resv_huge_pages + h->nr_huge_pages - h->free_huge_pages;
+	min_count = h->resv_huge_pages + persistent_huge_pages(h) - h->free_huge_pages;
 	min_count = max(count, min_count);
 	try_to_free_low(h, min_count, nodes_allowed);
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch

