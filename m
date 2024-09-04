Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A901F1527B1
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 21:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725484406; cv=none; b=XaM12ZNeBKItWlwz1WV3gQimTdoIaZHMQPkw1ZMnxzcPkPy7K/RyHNJMjIQ0Lg+Lr6ZyFm0kzAzcpSJQyF9g0Aibl5I3oeza6vBjexrYH93bmKRR75MwOnCmnYTOrFzBuS/FyCtqeH6KPW/RpxdrJAM8ofNVzh7oMGbbOQoNPII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725484406; c=relaxed/simple;
	bh=9mkA/f0XLC+nqtTbUxnkh2asLkOhgYi2F/9WZW6NRJU=;
	h=Date:To:From:Subject:Message-Id; b=Sy0jPbzII6WxLKXTK6o2fBc0aUBKFs0Eh/H2QBcp0ZR9Xqu49ltoBMtKUc0SJ8X1hkCEDTJnf6Crxpdgdh+PGCvGQstCkBj3Ty5GHRP1g8jwZkRfkeI6zV9HkvSoR41UCknXes7eN0lG+ijvFvuo49SpG1QjCLwP62ZbFxqZ7dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HrpMKiSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HrpMKiSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F63DC4CEC2;
	Wed,  4 Sep 2024 21:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725484406;
	bh=9mkA/f0XLC+nqtTbUxnkh2asLkOhgYi2F/9WZW6NRJU=;
	h=Date:To:From:Subject:From;
	b=HrpMKiSeKTmu5RA2BFfr5gnmw1l1B0v5YrYir42XoU5o7MRZxfDmOMkkExlYUaqwZ
	 zaN44CxXQ5sfSsHYsObtOdb1luxIBpOOjHTtJ8ejUr4olxmnPTAndSA3ejGZ2T3XKx
	 tdJJINHFXfOIQzNLt2/kt+MuI9nqQ1xrqQdA2qII=
Date: Wed, 04 Sep 2024 14:13:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterz@infradead.org,mgorman@techsingularity.net,jackmanb@google.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-missed-updates-of-pgfree-in-free_unref_page-folios.patch added to mm-unstable branch
Message-Id: <20240904211326.1F63DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: fix missed updates of PGFREE in free_unref_{page/folios}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-missed-updates-of-pgfree-in-free_unref_page-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-missed-updates-of-pgfree-in-free_unref_page-folios.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: page_alloc: fix missed updates of PGFREE in free_unref_{page/folios}
Date: Wed, 4 Sep 2024 20:54:19 +0000

PGFREE is currently updated in two code paths:

- __free_pages_ok(): for pages freed to the buddy allocator.
- free_unref_page_commit(): for pages freed to the pcplists.

Before commit df1acc856923 ("mm/page_alloc: avoid conflating IRQs disabled
with zone->lock"), free_unref_page_commit() used to fallback to freeing
isolated pages directly to the buddy allocator through free_one_page(). 
This was done _after_ updating PGFREE, so the counter was correctly
updated.

However, that commit moved the fallback logic to its callers (now called
free_unref_page() and free_unref_folios()), so PGFREE was no longer
updated in this fallback case.

Now that the code has developed, there are more cases in free_unref_page()
and free_unref_folios() where we fallback to calling free_one_page() (e.g.
!pcp_allowed_order(), pcp_spin_trylock() fails).  These cases also miss
updating PGFREE.

To make sure PGFREE is updated in all cases where pages are freed to the
buddy allocator, move the update down the stack to free_one_page().

This was noticed through code inspection, although it should be noticeable
at runtime (at least with some workloads).

Link: https://lkml.kernel.org/r/20240904205419.821776-1-yosryahmed@google.com
Fixes: df1acc856923 ("mm/page_alloc: avoid conflating IRQs disabled with zone->lock")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-missed-updates-of-pgfree-in-free_unref_page-folios
+++ a/mm/page_alloc.c
@@ -1238,6 +1238,8 @@ static void free_one_page(struct zone *z
 	spin_lock_irqsave(&zone->lock, flags);
 	split_large_buddy(zone, page, pfn, order, fpi_flags);
 	spin_unlock_irqrestore(&zone->lock, flags);
+
+	__count_vm_events(PGFREE, 1 << order);
 }
 
 static void __free_pages_ok(struct page *page, unsigned int order,
@@ -1246,12 +1248,8 @@ static void __free_pages_ok(struct page
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (!free_pages_prepare(page, order))
-		return;
-
-	free_one_page(zone, page, pfn, order, fpi_flags);
-
-	__count_vm_events(PGFREE, 1 << order);
+	if (free_pages_prepare(page, order))
+		free_one_page(zone, page, pfn, order, fpi_flags);
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-page_alloc-fix-missed-updates-of-pgfree-in-free_unref_page-folios.patch

