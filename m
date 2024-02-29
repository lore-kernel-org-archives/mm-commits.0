Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0FB160629
	for <mm-commits@vger.kernel.org>; Thu, 29 Feb 2024 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709232643; cv=none; b=Fr2RtMwap1Y1hf55DOYx8OMq7fNYKur6Btkh6bSIWQ4CfsBdxkdM9ANcKOMSXzvoPl0WevDqswgh2uBKl1GnvNvhmuw/9Uz6mIDA1lV++TWJ2oFTykm341eE411vqIclBJAGm7W0+4sg3vc4JTEskw1r1ahiOq5NQKFgd/QqgPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709232643; c=relaxed/simple;
	bh=UQZ32bz/WXgZX6zU+q6KEOjfKJszc+y7fKYDc4yRtxQ=;
	h=Date:To:From:Subject:Message-Id; b=fy1wiT7aJKwgDVLbwzQLVb1BFkiU9drSSTzOFuLYgYveyRum1JrgaUd5ANX2xErl2BdIkxil9q/N/krnZ6WD4po74EW4YywDJm78b36BjWD1Uz8UqDC3DWoR0gaehR+gKgTjoR9aUFU/in5S2BodUQxKlzyTjKzV+bRVCq+mpmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I6kurNLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I6kurNLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6E8C433F1;
	Thu, 29 Feb 2024 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709232643;
	bh=UQZ32bz/WXgZX6zU+q6KEOjfKJszc+y7fKYDc4yRtxQ=;
	h=Date:To:From:Subject:From;
	b=I6kurNLrzLNTQc0bJzqx5ribrqrVKxOljvnkRbl1PPPC8mndBsf4vPnEXAObl3RxM
	 RUyWuRM+7z27x4snytPuQk0iNPkrkrORphw9vu2zPIRw0frQd+MWIhc4KAWg7GjoL8
	 EfMZFjd9dYqRy9S9MVB8SOVaUf0yQ6cUdLyZp1F4=
Date: Thu, 29 Feb 2024 10:50:42 -0800
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-div64_ul-instead-of-do_div.patch added to mm-unstable branch
Message-Id: <20240229185043.2B6E8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: use div64_ul() instead of do_div()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-div64_ul-instead-of-do_div.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-div64_ul-instead-of-do_div.patch

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
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: mm: page_alloc: use div64_ul() instead of do_div()
Date: Wed, 28 Feb 2024 23:49:12 +0100

Fixes Coccinelle/coccicheck warning reported by do_div.cocci.

Compared to do_div(), div64_ul() does not implicitly cast the divisor and
does not unnecessarily calculate the remainder.

Link: https://lkml.kernel.org/r/20240228224911.1164-2-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-div64_ul-instead-of-do_div
+++ a/mm/page_alloc.c
@@ -5850,7 +5850,7 @@ static void __setup_per_zone_wmarks(void
 
 		spin_lock_irqsave(&zone->lock, flags);
 		tmp = (u64)pages_min * zone_managed_pages(zone);
-		do_div(tmp, lowmem_pages);
+		tmp = div64_ul(tmp, lowmem_pages);
 		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {
 			/*
 			 * __GFP_HIGH and PF_MEMALLOC allocations usually don't
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

mm-page_alloc-use-div64_ul-instead-of-do_div.patch

