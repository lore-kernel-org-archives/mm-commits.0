Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABD818E377
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925301; cv=none; b=McCam5wVVH5JPZu6GNHWjC/lf1MHSrPU6bk0F74ECWiElS5iTm2VVF69oCN0I0ZRuXVER+WAOXLJk8CZ5qyFhRPVrR9kMkmM4a34zLWoAZMYTyh26FvGaA36TNEtj92/UCZG0pHGi+MrR4yAiWTur7MnxD6cfG3T5n20VNltLbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925301; c=relaxed/simple;
	bh=iGdeEvJHlH3h6mlOcTo0Dw1SCF1dgtDBOdPIZTNBSHM=;
	h=Date:To:From:Subject:Message-Id; b=ezbD3BWx7SPGNo9pxNZQVieIfblpn0LjNnvLdjHc5qFIrMSb0HCcwzhWZ66fHSEI6N6mdGRBnpjOSGStsEcXp8WUqRNIlScSTa187sDIhW5HPZ2GI3cqSXPa9mkuf8646VHJ3t6RlhIq5gr1f6FzbAhWXc7lkHF63VTWW+y+Q9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=crnX5VoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="crnX5VoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D287EC4CEC5;
	Mon,  9 Sep 2024 23:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925300;
	bh=iGdeEvJHlH3h6mlOcTo0Dw1SCF1dgtDBOdPIZTNBSHM=;
	h=Date:To:From:Subject:From;
	b=crnX5VoJ/3MPAzQwST0XgPIL6ynvCMRie8gkGCoFUwSJfkEmbI7xtCRYkqYOSh4dX
	 BZ4JTYuj6Pc2XTcBwtQ9HME3OzCaRVzys8HAAvZgqRNxk22+RPIPqKkPSFzq5MdUdK
	 DVaPAvgeSxTxITepsXT3BDEqAvr9wxsMpu+QrvrI=
Date: Mon, 09 Sep 2024 16:41:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterz@infradead.org,mgorman@techsingularity.net,jackmanb@google.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-missed-updates-of-pgfree-in-free_unref_page-folios.patch removed from -mm tree
Message-Id: <20240909234140.D287EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: fix missed updates of PGFREE in free_unref_{page/folios}
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-missed-updates-of-pgfree-in-free_unref_page-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1231,6 +1231,8 @@ static void free_one_page(struct zone *z
 	spin_lock_irqsave(&zone->lock, flags);
 	split_large_buddy(zone, page, pfn, order, fpi_flags);
 	spin_unlock_irqrestore(&zone->lock, flags);
+
+	__count_vm_events(PGFREE, 1 << order);
 }
 
 static void __free_pages_ok(struct page *page, unsigned int order,
@@ -1239,12 +1241,8 @@ static void __free_pages_ok(struct page
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

mm-z3fold-deprecate-config_z3fold.patch

