Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBFD224CC
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976876; cv=none; b=ZcdNeD1IsqtZECpv1triP1sKsxLbIg7/B7ofH289P6qM/h6BkBUuU1yJund2lNcAoLYa/doJkgtQkzGaiPut+F2jABf3w26OUfT+Dh85p3h8aYg9joZYdhJTjk+cQGzflnnkvYQ9BUpZ08pXleeZ4SD3Vm+VbkgtIPS0y248j4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976876; c=relaxed/simple;
	bh=dr8ENfPduYUMvvsM8WA6S74aBjlgHJyt7SKRxB1qLxQ=;
	h=Date:To:From:Subject:Message-Id; b=L8o12cs1QaiQRuTrmfze2g7SMpFvK3zRsfuVEaSfeNHoyxD6USinY8i8sBDmrvkiC9SzXF9aXmp8VCSKQUqMfsMT2g1sOU3GEwICXrEisjVvftx4KHVXGECzM76N4anoQbswEUila8HnR/3nNlxONZPilrbT4aVz5lpWA0dleMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xhX/R906; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xhX/R906"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76CBC4CEE3;
	Sun, 20 Jul 2025 02:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976876;
	bh=dr8ENfPduYUMvvsM8WA6S74aBjlgHJyt7SKRxB1qLxQ=;
	h=Date:To:From:Subject:From;
	b=xhX/R906SjwSChcL/ebYzJQ6JlYky6JakfL1zPiRRe3Z0nFhVsGw6TZm0n6jCj186
	 GPQ1YXVgmpdCm513GF0ZePgle4SrxZC1A3WlK08cW8AqIZx2OKJFg+88IGwcB0g7UE
	 OC0HYfsxiymqHFzZUaS8mFdRh0N97eO1OQRpRKAQ=
Date: Sat, 19 Jul 2025 19:01:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-the-eexist-conversion-for-move_pages.patch removed from -mm tree
Message-Id: <20250720020115.E76CBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: remove the -EEXIST conversion for move_pages()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-the-eexist-conversion-for-move_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/migrate: remove the -EEXIST conversion for move_pages()
Date: Mon, 7 Jul 2025 06:57:11 +0000

The -EEXIST conversion is introduced in commit 65462462ffb2 ("mm/gup:
follow_pfn_pte(): -EEXIST cleanup"), since follow_page() may call
follow_pfn_pte() which may return -EEXIST.

But after commit 7dff875c9436 ("mm/migrate: convert
add_page_for_migration() from follow_page() to folio_walk"), it use
folio_walk instead.  This limit the error code and won't return -EEXIST.

Remove the error code conversion here.

Link: https://lkml.kernel.org/r/20250707065711.18056-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-the-eexist-conversion-for-move_pages
+++ a/mm/migrate.c
@@ -2363,13 +2363,6 @@ static int do_pages_move(struct mm_struc
 		}
 
 		/*
-		 * The move_pages() man page does not have an -EEXIST choice, so
-		 * use -EFAULT instead.
-		 */
-		if (err == -EEXIST)
-			err = -EFAULT;
-
-		/*
 		 * If the page is already on the target node (!err), store the
 		 * node, otherwise, store the err.
 		 */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


