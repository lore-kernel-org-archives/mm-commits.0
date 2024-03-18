Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F81E381C8
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 18:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788010; cv=none; b=pT6v0wbTVNw6aurino+Y+5AF6CZgTwh9uxHwuJ1lnb7t+sKjsRrhiDiV+FPRYVHfs1ijXN43prZFa9iO/5pehq5EK6aypUCCdgTGtEHznVk8BKciMyqDZHMXOHNmhgkARk3C1oYNKUTPkgSSKOXlCql9kKfEx2SfeM+oQIOlimI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788010; c=relaxed/simple;
	bh=/q16MWwNb7AS8tig08qsP9Z/UTj0LekiO0bBVWKGwT4=;
	h=Date:To:From:Subject:Message-Id; b=OzLkTwRYHtPwiXmPtI3PoI+2tgev4oAgwl8XY82sWDgHajmvTIJ2uZYA5LNYK/oYqLtc8pg2zATzAE8e8Oq1gncHF1uxsTkThNAXoTDh+adGQi+Z0awnTGLxYnzCZHBQp1bOft0jzZZ7WCk3nmzGLq07TtaOyPaFRtQSLyHb2U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DTpGA8pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DTpGA8pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8199C433C7;
	Mon, 18 Mar 2024 18:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710788009;
	bh=/q16MWwNb7AS8tig08qsP9Z/UTj0LekiO0bBVWKGwT4=;
	h=Date:To:From:Subject:From;
	b=DTpGA8pimK1WYCIkpf+IyMWq5A/7SOnAlprfqKLHbPKq5dl0E3AIoqkF+MPiHrClh
	 WaiX8lRmqmkXW3V3EKDFsTwYWKmngx+FJ6EDIH3p2jhxUYHoYs3xdE7fy5wC2JEIfU
	 hNAy4zJDzwM16lTvkGr9qeLxpvs3L8pJ4O4TptiM=
Date: Mon, 18 Mar 2024 11:53:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-unneeded-calc_memmap_size.patch added to mm-unstable branch
Message-Id: <20240318185329.D8199C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: remove unneeded calc_memmap_size()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-unneeded-calc_memmap_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-unneeded-calc_memmap_size.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove unneeded calc_memmap_size()
Date: Mon, 18 Mar 2024 22:21:37 +0800

Nobody calls calc_memmap_size() now.

Link: https://lkml.kernel.org/r/20240318142138.783350-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-unneeded-calc_memmap_size
+++ a/mm/mm_init.c
@@ -1331,26 +1331,6 @@ static void __init calculate_node_totalp
 	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
 }
 
-static unsigned long __init calc_memmap_size(unsigned long spanned_pages,
-						unsigned long present_pages)
-{
-	unsigned long pages = spanned_pages;
-
-	/*
-	 * Provide a more accurate estimation if there are holes within
-	 * the zone and SPARSEMEM is in use. If there are holes within the
-	 * zone, each populated memory region may cost us one or two extra
-	 * memmap pages due to alignment because memmap pages for each
-	 * populated regions may not be naturally aligned on page boundary.
-	 * So the (present_pages >> 4) heuristic is a tradeoff for that.
-	 */
-	if (spanned_pages > present_pages + (present_pages >> 4) &&
-	    IS_ENABLED(CONFIG_SPARSEMEM))
-		pages = present_pages;
-
-	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void pgdat_init_split_queue(struct pglist_data *pgdat)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-mm_initc-remove-the-useless-dma_reserve.patch
x86-remove-memblock_find_dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

