Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED031350EA
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 20:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712261951; cv=none; b=Kiv33dmvYsABLdktdcrc1GmizZrhtk9pQdSVlFB6tT2cDuVnGBLP7ogdk6mtffzkI808/CMpWz+di3sb6KgyBjUnQ2w1GfMtuA+o5XL9QEmRe/2IsIrO82Ale4Y2Du5VMqnPIaRB9jPfP2Dm3No91HEa7pIAP3vkG/48cOH2Y2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712261951; c=relaxed/simple;
	bh=gP0czMWRnae22jhVs7SnTgbYSO6YExt3I4eyhedwV8E=;
	h=Date:To:From:Subject:Message-Id; b=Y1BloUV8Z1BxJvicInJwy+sU/zHDJk9g/pjsQFRl7y/8JuukcDJUNHUxzj/zvJdLXFAlcaCeL7P5m/yQfnH4rll032SF6xHL0s0Aeau8a1QCsWURKjp49tRwjBNos0lFeWKFVP2m4ooZVzMLbn/VMN+s9Y31XG+Z14T3YuSxlGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nnf6nDoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nnf6nDoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EF4C433F1;
	Thu,  4 Apr 2024 20:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712261950;
	bh=gP0czMWRnae22jhVs7SnTgbYSO6YExt3I4eyhedwV8E=;
	h=Date:To:From:Subject:From;
	b=nnf6nDoI1Mo6lkKIjXavpWFyC0z4dpjlW120NDYubTs9x/5B2xwExad+sDFyQqf1G
	 oe93wRTtWGtuhrMCpVhwdUaUQXyUAzvq1U3OM65xh6fRV6rclQWDNnqU5IhRudlL/3
	 kYrVCaHXEcVwIDeeIrrW/yew8nffLLmRMw/Yd3f0=
Date: Thu, 04 Apr 2024 13:19:09 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,m.szyprowski@samsung.com,david@redhat.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid.patch added to mm-unstable branch
Message-Id: <20240404201910.86EF4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: pass correct order_per_bit to cma_declare_contiguous_nid
Date: Thu, 4 Apr 2024 16:25:15 +0000

The hugetlb_cma code passes 0 in the order_per_bit argument to
cma_declare_contiguous_nid (the alignment, computed using the page order,
is correctly passed in).

This causes a bit in the cma allocation bitmap to always represent a 4k
page, making the bitmaps potentially very large, and slower.

So, correctly pass in the order instead.

Link: https://lkml.kernel.org/r/20240404162515.527802-2-fvdl@google.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid
+++ a/mm/hugetlb.c
@@ -7783,9 +7783,9 @@ void __init hugetlb_cma_reserve(int orde
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

mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem.patch
mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid.patch

