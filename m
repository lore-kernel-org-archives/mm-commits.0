Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F213F2D052
	for <mm-commits@vger.kernel.org>; Fri, 15 Aug 2025 00:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755219366; cv=none; b=K7dDYt6aFDbIip+v25iJIA7mfXcxmrl14zr5dC1ReD2qRLRfsCkiwANTq0fQimL/e6SAhUAyXXJYf0nn+bHjBumzyZuZC9bc0c+xOW0Alh7YEFwh080BsmH5q8DGQJPL4wq1a+v3OuVrLCGkPw5/F7bWm6x7TawqOve/tlXsUXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755219366; c=relaxed/simple;
	bh=S/+3nZAGmkP5vGvMuLr2Y9JSJjmIjuL+JltvDGP2Y0A=;
	h=Date:To:From:Subject:Message-Id; b=IcGElhAq0ONzU+fC3FLw/Xlg+PKgBkcXv9j1WIwrchZNwzYvsEkYtYRLjIzxxEEZrMsQEpzAJuDoepV2sD41Wh0JYKR0G+YMoNpc34PS6wC/wOCCOcZW1vXQc4aVlcDvzNyZHprRipKw7JF2N9Vst0DkESoZGWLUovg15Sqo2U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fYfl6Ewj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fYfl6Ewj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAD9C4CEED;
	Fri, 15 Aug 2025 00:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755219365;
	bh=S/+3nZAGmkP5vGvMuLr2Y9JSJjmIjuL+JltvDGP2Y0A=;
	h=Date:To:From:Subject:From;
	b=fYfl6EwjPrlp5l1LZrLFU/IVpMiakDICiBONLStaVjB/uM6/WkOPGPvrP2lgCDOGD
	 NqCzO/J7naqYQiza4IDrhY4xuSjXj+t0D6rd5WOCxgfTGF3c2d46f0vN0p3fNGz9jV
	 46300fNttTpo194xwNzLgje0CEOsSQjADRhsWVIo=
Date: Thu, 14 Aug 2025 17:56:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,jackmanb@google.com,hannes@cmpxchg.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-redundant-pcp-free_count-initialization-in-per_cpu_pages_init.patch added to mm-new branch
Message-Id: <20250815005605.BEAD9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: remove redundant pcp->free_count initialization in per_cpu_pages_init()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-remove-redundant-pcp-free_count-initialization-in-per_cpu_pages_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-redundant-pcp-free_count-initialization-in-per_cpu_pages_init.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/page_alloc: remove redundant pcp->free_count initialization in per_cpu_pages_init()
Date: Thu, 14 Aug 2025 15:18:28 +0800

In per_cpu_pages_init(), pcp->free_count is explicitly initialized to 0,
but this is redundant because the entire struct is already zeroed by
memset(pcp, 0, sizeof(*pcp)).

Link: https://lkml.kernel.org/r/20250814071828.12036-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-redundant-pcp-free_count-initialization-in-per_cpu_pages_init
+++ a/mm/page_alloc.c
@@ -5946,7 +5946,6 @@ static void per_cpu_pages_init(struct pe
 	pcp->high_min = BOOT_PAGESET_HIGH;
 	pcp->high_max = BOOT_PAGESET_HIGH;
 	pcp->batch = BOOT_PAGESET_BATCH;
-	pcp->free_count = 0;
 }
 
 static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high_min,
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch
mm-page_alloc-simplify-lowmem_reserve-max-calculation.patch
mm-fix-typos-in-vma-comments.patch
mm-page_alloc-remove-redundant-pcp-free_count-initialization-in-per_cpu_pages_init.patch

