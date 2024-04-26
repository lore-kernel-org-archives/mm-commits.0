Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD9780C0A;
	Fri, 26 Apr 2024 04:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104170; cv=none; b=mjJeJzYh3OWmyVPkoCPEUFK70l28h8Uf8A/1XDc9ujtvKQdaP1GZCbWV/dOKy9E/F9qo2is5UI5n//IVs7+21sqqWhZ7XnWkl4cWT7BG3XoXeib1GgJ1HJnw6oGxJ0QkqQQSq17tzWP0yjn7NOt04cZ55fxYNcpcvfLH0AAkSgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104170; c=relaxed/simple;
	bh=PT5lyVwrl8Rfe2DBdndshX+ZVMjQBKcoKdcV7qqEjmM=;
	h=Date:To:From:Subject:Message-Id; b=QANsXdZeG6RsuLHgUSqTmaej4/pkJlAfpqkI6zUwoja2EcrjDmbWwr1AYVtd3ZrkdTGVfG5gbof+MxkV2n0yx90KT7OdXsaB60l/Nld+i+T6dYe3IlPHNkLjGUswNvD4vqC/IBgQU3wakG07EWpk455Q3XzCbcxi7NymgTNwKHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1LzAWsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1LzAWsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E52C113CD;
	Fri, 26 Apr 2024 04:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104170;
	bh=PT5lyVwrl8Rfe2DBdndshX+ZVMjQBKcoKdcV7qqEjmM=;
	h=Date:To:From:Subject:From;
	b=o1LzAWsM2sHwHb5DSamEwVe4xkJl/mcLLXHJ9K9uqXf+ezVLwCIw3oS0/6uUButbQ
	 XjjNMmp46d2BtdE9XlavrVi/VRuI2nSA7Ai03ainxBD0FwcDvDMGUuWI42Ly/AIxbX
	 NwHIzr8V0IYSl1o/VMp1z1Qc3DbtPXxNerwJDq4U=
Date: Thu, 25 Apr 2024 21:02:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,m.szyprowski@samsung.com,david@redhat.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid.patch removed from -mm tree
Message-Id: <20240426040250.81E52C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid
Date: Thu, 4 Apr 2024 16:25:15 +0000

The hugetlb_cma code passes 0 in the order_per_bit argument to
cma_declare_contiguous_nid (the alignment, computed using the page order,
is correctly passed in).

This causes a bit in the cma allocation bitmap to always represent a 4k
page, making the bitmaps potentially very large, and slower.

It would create bitmaps that would be pretty big.  E.g.  for a 4k page
size on x86, hugetlb_cma=64G would mean a bitmap size of (64G / 4k) / 8
== 2M.  With HUGETLB_PAGE_ORDER as order_per_bit, as intended, this
would be (64G / 2M) / 8 == 4k.  So, that's quite a difference.

Also, this restricted the hugetlb_cma area to ((PAGE_SIZE <<
MAX_PAGE_ORDER) * 8) * PAGE_SIZE (e.g.  128G on x86) , since
bitmap_alloc uses normal page allocation, and is thus restricted by
MAX_PAGE_ORDER.  Specifying anything about that would fail the CMA
initialization.

So, correctly pass in the order instead.

Link: https://lkml.kernel.org/r/20240404162515.527802-2-fvdl@google.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid
+++ a/mm/hugetlb.c
@@ -7794,9 +7794,9 @@ void __init hugetlb_cma_reserve(int orde
 		 * huge page demotion.
 		 */
 		res = cma_declare_contiguous_nid(0, size, 0,
-						PAGE_SIZE << HUGETLB_PAGE_ORDER,
-						 0, false, name,
-						 &hugetlb_cma[nid], nid);
+					PAGE_SIZE << HUGETLB_PAGE_ORDER,
+					HUGETLB_PAGE_ORDER, false, name,
+					&hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
 				res, nid);
_

Patches currently in -mm which might be from fvdl@google.com are


