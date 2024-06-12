Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DE81EB2A
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718219666; cv=none; b=XJscX53WYKg6IbLyQm7dk+kPM0WFH/jQpBY9eX8kQdzi1Ak5pQ0RJSBfyCea0R96ZoG/8Q2aSxzzBpRoQfhi/EVtD0c4Nv8/m3X6bwpnS8Hk9PhhFlxCZnG0ZqK+5/FH13jIiSkA0MNozM8AjYWu/rrb4s6Jpytr7pehQNp2x/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718219666; c=relaxed/simple;
	bh=MlihDFmFv4rwk2IxLNy4qOMZ+WrMYKzgU2VqHfehPRE=;
	h=Date:To:From:Subject:Message-Id; b=Y5jU76DbyhqDpWnN2f9mSpPT+MD3khDyZHZ81Mnh+DRVr7PqlpmH0am2FrKunzYqzXxTYlVbHVWstNyNIZ4+JIwShVkCuZeSrGPEVqJ/ELiHvqVjyp89AD3rKUjakzbcIEUruB6rR+XcUYrX1urjmDMwuH8mPyJrpn8QyZX2awc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NGa3CjqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NGa3CjqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD24C116B1;
	Wed, 12 Jun 2024 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718219666;
	bh=MlihDFmFv4rwk2IxLNy4qOMZ+WrMYKzgU2VqHfehPRE=;
	h=Date:To:From:Subject:From;
	b=NGa3CjqJVODg3EFNN4QnUJQYu0t+//GAPVoeFgEE6OTTjL1mhTt6nt+cBlUy8eX17
	 4r+3e7rO2LkkCiDWXcpr2SzjqB0ignJFUHk8eIALDsWVN60fTbD2xmu/ucEUoTOnpj
	 kda2Ap/zV6C3ozYOCfnFFkvPmpFkVDTIVFrYebxI=
Date: Wed, 12 Jun 2024 12:14:25 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-simplify-logic-of-deferred__pages.patch added to mm-unstable branch
Message-Id: <20240612191426.5FD24C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: simplify logic of deferred_[init|free]_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-simplify-logic-of-deferred__pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-simplify-logic-of-deferred__pages.patch

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
Subject: mm/mm_init.c: simplify logic of deferred_[init|free]_pages
Date: Wed, 12 Jun 2024 02:04:21 +0000

Function deferred_[init|free]_pages are only used in
deferred_init_maxorder(), which makes sure the range to init/free is
within MAX_ORDER_NR_PAGES size.

With this knowledge, we can simplify these two functions. Since

  * only the first pfn could be IS_MAX_ORDER_ALIGNED()

Also since the range passed to deferred_[init|free]_pages is always from
memblock.memory for those we have already allocated memmap to cover,
pfn_valid() always return true.  Then we can remove related check.

Link: https://lkml.kernel.org/r/20240612020421.31975-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   63 ++++++-------------------------------------------
 1 file changed, 8 insertions(+), 55 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-simplify-logic-of-deferred__pages
+++ a/mm/mm_init.c
@@ -1922,7 +1922,7 @@ unsigned long __init node_map_pfn_alignm
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-static void __init deferred_free_range(unsigned long pfn,
+static void __init deferred_free_pages(unsigned long pfn,
 				       unsigned long nr_pages)
 {
 	struct page *page;
@@ -1962,68 +1962,21 @@ static inline void __init pgdat_init_rep
 }
 
 /*
- * Returns true if page needs to be initialized or freed to buddy allocator.
- *
- * We check if a current MAX_PAGE_ORDER block is valid by only checking the
- * validity of the head pfn.
- */
-static inline bool __init deferred_pfn_valid(unsigned long pfn)
-{
-	if (IS_MAX_ORDER_ALIGNED(pfn) && !pfn_valid(pfn))
-		return false;
-	return true;
-}
-
-/*
- * Free pages to buddy allocator. Try to free aligned pages in
- * MAX_ORDER_NR_PAGES sizes.
- */
-static void __init deferred_free_pages(unsigned long pfn,
-				       unsigned long end_pfn)
-{
-	unsigned long nr_free = 0;
-
-	for (; pfn < end_pfn; pfn++) {
-		if (!deferred_pfn_valid(pfn)) {
-			deferred_free_range(pfn - nr_free, nr_free);
-			nr_free = 0;
-		} else if (IS_MAX_ORDER_ALIGNED(pfn)) {
-			deferred_free_range(pfn - nr_free, nr_free);
-			nr_free = 1;
-		} else {
-			nr_free++;
-		}
-	}
-	/* Free the last block of pages to allocator */
-	deferred_free_range(pfn - nr_free, nr_free);
-}
-
-/*
  * Initialize struct pages.  We minimize pfn page lookups and scheduler checks
  * by performing it only once every MAX_ORDER_NR_PAGES.
  * Return number of pages initialized.
  */
-static unsigned long  __init deferred_init_pages(struct zone *zone,
-						 unsigned long pfn,
-						 unsigned long end_pfn)
+static unsigned long __init deferred_init_pages(struct zone *zone,
+						unsigned long pfn,
+						unsigned long end_pfn)
 {
 	int nid = zone_to_nid(zone);
-	unsigned long nr_pages = 0;
+	unsigned long nr_pages = end_pfn - pfn;
 	int zid = zone_idx(zone);
-	struct page *page = NULL;
+	struct page *page = pfn_to_page(pfn);
 
-	for (; pfn < end_pfn; pfn++) {
-		if (!deferred_pfn_valid(pfn)) {
-			page = NULL;
-			continue;
-		} else if (!page || IS_MAX_ORDER_ALIGNED(pfn)) {
-			page = pfn_to_page(pfn);
-		} else {
-			page++;
-		}
+	for (; pfn < end_pfn; pfn++, page++)
 		__init_single_page(page, pfn, zid, nid);
-		nr_pages++;
-	}
 	return nr_pages;
 }
 
@@ -2102,7 +2055,7 @@ deferred_init_maxorder(u64 *i, struct zo
 			break;
 
 		t = min(mo_pfn, epfn);
-		deferred_free_pages(spfn, t);
+		deferred_free_pages(spfn, t - spfn);
 
 		if (mo_pfn <= epfn)
 			break;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch
mm-mm_initc-simplify-logic-of-deferred__pages.patch

