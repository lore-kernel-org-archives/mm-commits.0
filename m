Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9174F1C3E
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717202107; cv=none; b=ittEtSj5ASqu1TSr0GCi9TmQauzQ5GlCcJqh67/1DbXMp8JRU3hx84dY9DfGpBF5EY92F2yCgkXx0wuZU0C9vla02ZxuxsBX8slnTF6X61zqquAn0ZZMnOXl5rkSeCbh5QXY0zANsuZpthz2BuRCZ+XmtKwKxyQod8hKbawg+wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717202107; c=relaxed/simple;
	bh=eY7YhkcTcmoeOxOccL9tTIx/bDYLTYoIyysx72fOADo=;
	h=Date:To:From:Subject:Message-Id; b=lG/+m0f92e7kdX80fCArHmHSCl8ZYemCmIN7RUJnWQSGQ01UuD2FtuDmrO+iu9fyfSs8MWY5TlytgZfN2LJE2rOE+41KfdrH+Rw1UexelGkdcIQtwWyxRDmSKC6HkPSIdHRdNAvSJVMLyFUqJaxu8bhsq3F3ImWkcsNg4r6BfZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JVHNklZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JVHNklZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DE2C116B1;
	Sat,  1 Jun 2024 00:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717202107;
	bh=eY7YhkcTcmoeOxOccL9tTIx/bDYLTYoIyysx72fOADo=;
	h=Date:To:From:Subject:From;
	b=JVHNklZFELuTBX+za9KxcVozF0/qNRwntyhMSHbX1ZgoVaD2+jUi2Q753LLpQjir7
	 CXvtIL/YCKB6Q2QvVYP3xProvmj6Vuy9+dPVx/+u6REpLO76E14BGrpB5SiYlnpXI4
	 jVu4wKmhDqy4ImkaahotSWW75K4dMN02uX+d5V9A=
Date: Fri, 31 May 2024 17:35:06 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch added to mm-unstable branch
Message-Id: <20240601003507.02DE2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: use deferred_init_mem_pfn_range_in_zone() to decide loop condition
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch

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
@@ -2168,20 +2168,15 @@ static int __init deferred_init_memmap(v
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
@@ -2189,10 +2184,8 @@ static int __init deferred_init_memmap(v
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

mm-mm_initc-get-the-highest-zone-directly.patch
mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch
mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch

