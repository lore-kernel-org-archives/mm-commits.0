Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A151915CD52
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714667411; cv=none; b=WLEbDf3NY95G7eXqs1iJIsP4JbWdvSeXt+DkXGZCNtTfyDN2rvcjcNyydx2rMUgvp7919ofGRHBlhALUx0RbNuirVY6KQu4+AOlplZzmFump5sIwTfVG4uBZM4WShMd6yqz7qnR0fo1TuNTkBlQBemHSGoaCVhLkrLdoSzZAAcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714667411; c=relaxed/simple;
	bh=gtiWqFODSpy9nvAC7aPHjHgyGtXwpe3EQGclFjQUnoE=;
	h=Date:To:From:Subject:Message-Id; b=LwjM1SyQMvQjk+Unec06yjyYOW7QgkHX/bsJMUSHRXePrHnoGctxK+0TmsgqE16bx+ARr20+QmXBKIaoyAtu2tBe4c9RJUXFxb6qROLo/wH81tL+uWdRnwityn+qZbqqSQd2XWlfBPI583yVASYK8xshEkuqhoGmuS9CzopSDjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzbw8AiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzbw8AiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423B1C113CC;
	Thu,  2 May 2024 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714667411;
	bh=gtiWqFODSpy9nvAC7aPHjHgyGtXwpe3EQGclFjQUnoE=;
	h=Date:To:From:Subject:From;
	b=hzbw8AiC69SzHjbBsQMLbtasrGmziEUSOCHIX+Ff4hUkLwGgjkkpRfYtlRnWXtKR5
	 flaNYwWPcdsh5iCiooMmbJrr+8uJQOJn29akoGykDwuTwn9t7B8aenIi9MhhD4xttM
	 Un/kxMzLbs4SmnMlnqxjkjR5f3Dpk0zxLYAQ3ZcE=
Date: Thu, 02 May 2024 09:30:09 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,david@redhat.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-align-cma-on-allocation-order-not-demotion-order.patch added to mm-unstable branch
Message-Id: <20240502163011.423B1C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: align cma on allocation order, not demotion order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-align-cma-on-allocation-order-not-demotion-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-align-cma-on-allocation-order-not-demotion-order.patch

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
Subject: mm/hugetlb: align cma on allocation order, not demotion order
Date: Tue, 30 Apr 2024 16:14:37 +0000

Align the CMA area for hugetlb gigantic pages to their size, not the size
that they can be demoted to.  Otherwise there might be misaligned sections
at the start and end of the CMA area that will never be used for hugetlb
page allocations.

Link: https://lkml.kernel.org/r/20240430161437.2100295-1-fvdl@google.com
Fixes: a01f43901cfb ("hugetlb: be sure to free demoted CMA pages to CMA")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-align-cma-on-allocation-order-not-demotion-order
+++ a/mm/hugetlb.c
@@ -7800,7 +7800,7 @@ void __init hugetlb_cma_reserve(int orde
 		 * huge page demotion.
 		 */
 		res = cma_declare_contiguous_nid(0, size, 0,
-					PAGE_SIZE << HUGETLB_PAGE_ORDER,
+					PAGE_SIZE << order,
 					HUGETLB_PAGE_ORDER, false, name,
 					&hugetlb_cma[nid], nid);
 		if (res) {
_

Patches currently in -mm which might be from fvdl@google.com are

mm-hugetlb-align-cma-on-allocation-order-not-demotion-order.patch

