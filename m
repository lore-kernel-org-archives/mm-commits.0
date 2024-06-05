Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B298152E00
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625832; cv=none; b=oZTIAlojeTPI2SbuJ8IxHy1K3+UmDDaH9sFASQ7mq603U5Jy+eyUh6AskR/mrrFap6KuOexTCYYqa+IXSkJNXh0ceISeXuhJGA09a4GaAJV9LK/OisYHWH+t7hEcFNw1fiRVklbxXbap1rb8Cs2a3nfbcL2L5fiFUdabuW0EcH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625832; c=relaxed/simple;
	bh=YY53tixl8AmGrYUbRtfNBRnQIRH6Qm0FndWFF9WM1bo=;
	h=Date:To:From:Subject:Message-Id; b=vFJPylBXD+G5wuu+/Tb7XYric5o0rMVqMASj558Jd7WqdqzMdebdadCO69yUvCSp/oARR+O1Osp537zmmnWhr1P8VsHds4xqpjLfBRtpN6oSd5wFyGsb/hxAF0/vMn7LmEA48sY2SEQUcguF+CoGa/EUYQletqjhnvsCD0EAvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S5vhSDZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S5vhSDZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C0CC4AF08;
	Wed,  5 Jun 2024 22:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717625831;
	bh=YY53tixl8AmGrYUbRtfNBRnQIRH6Qm0FndWFF9WM1bo=;
	h=Date:To:From:Subject:From;
	b=S5vhSDZXcs9RM567Qk0Tq0K5vk5l6gvAvFfYSxE/xnONwNf+DZw0BD2BwJBQ0uS+H
	 8zQm26ZtuOPZHMS4D9en4fZQS4/w0RBUcMUfSZv2MdVBlxWGXEaSS9gYzIqxCyvt6L
	 kasjnbL0Am8jg0mC7tO37gEdCab7fOfjZQukHkHI=
Date: Wed, 05 Jun 2024 15:17:11 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch removed from -mm tree
Message-Id: <20240605221711.90C0CC4AF08@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: use deferred_init_mem_pfn_range_in_zone() to decide loop condition
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: use deferred_init_mem_pfn_range_in_zone() to decide loop condition
Date: Fri, 31 May 2024 00:26:12 +0000

If deferred_init_mem_pfn_range_in_zone() return true, we know it finds
some range in (spfn, epfn).  Then we can use it directly for the loop
condition.

Link: https://lkml.kernel.org/r/20240531002613.5231-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition
+++ a/mm/mm_init.c
@@ -2167,20 +2167,15 @@ static int __init deferred_init_memmap(v
 	/* Only the highest zone is deferred */
 	zone = pgdat->node_zones + pgdat->nr_zones - 1;
 
-	/* If the zone is empty somebody else may have cleared out the zone */
-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
-						 first_init_pfn))
-		goto zone_empty;
-
 	max_threads = deferred_page_init_max_threads(cpumask);
 
-	while (spfn < epfn) {
-		unsigned long epfn_align = ALIGN(epfn, PAGES_PER_SECTION);
+	while (deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, first_init_pfn)) {
+		first_init_pfn = ALIGN(epfn, PAGES_PER_SECTION);
 		struct padata_mt_job job = {
 			.thread_fn   = deferred_init_memmap_chunk,
 			.fn_arg      = zone,
 			.start       = spfn,
-			.size        = epfn_align - spfn,
+			.size        = first_init_pfn - spfn,
 			.align       = PAGES_PER_SECTION,
 			.min_chunk   = PAGES_PER_SECTION,
 			.max_threads = max_threads,
@@ -2188,10 +2183,8 @@ static int __init deferred_init_memmap(v
 		};
 
 		padata_do_multithreaded(&job);
-		deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
-						    epfn_align);
 	}
-zone_empty:
+
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(pgdat->nr_zones < MAX_NR_ZONES && populated_zone(++zone));
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch

