Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DA627F00A;
	Thu, 23 Oct 2025 23:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261139; cv=none; b=OaX+omZ7gdvGSAhvZlnldSt7jbTWjHbDeOR7js+E0hc4ZHdBrQ+icsV5WB2ypilrv9XG8GCI9dP6+CIlKNxlpF6Ga67dEKX5DRm2zpGAcME5NiXIpKrH45ssEkxPoUMuXqEb5evNNoE9Cr+ZBBGTvO5HLmOkLEVAEckesQ6vJic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261139; c=relaxed/simple;
	bh=R6VHOs6crHStYqt6NpOLBoOrpNxWX9apRS5fy/uQaf4=;
	h=Date:To:From:Subject:Message-Id; b=jP3rjcCSg3UJAp28aZL13Dgcn1YB9Dv2U6s+mh1XPDOuyzkF0ygk4MYTWy8QxFyOSQ75zUx235MQtE3O98ip7aLwJxWeAsFA7mPEa3mQ8/KrBmNkoR3j+fyagygeBAYwHtnXq5wKaENuJcIaSyP0sGXtdXT4ino5S2Fh1cBeamY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jk50ZrsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jk50ZrsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECFCC4CEE7;
	Thu, 23 Oct 2025 23:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261138;
	bh=R6VHOs6crHStYqt6NpOLBoOrpNxWX9apRS5fy/uQaf4=;
	h=Date:To:From:Subject:From;
	b=Jk50ZrsW0KmsxZtep4rZOWbjKJYspv1j/TBFhPetc9vZZrfYvZaS5YCD6Gu1nwAp9
	 kB0pbaWSEzG46miwyUs1rti8pi9fCNC9SntTPjGx9O3dfzEHLHH49I/cwlXgCD2RTW
	 OFLVLjP9xzxUG/Mer5BVVgV1V0O8gctuLBFKhZbA=
Date: Thu, 23 Oct 2025 16:12:18 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,kernel@pankajraghav.com,jane.chu@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch added to mm-hotfixes-unstable branch
Message-Id: <20251023231218.AECFCC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order
Date: Wed, 22 Oct 2025 23:05:21 -0400

folio split clears PG_has_hwpoisoned, but the flag should be preserved in
after-split folios containing pages with PG_hwpoisoned flag if the folio
is split to >0 order folios.  Scan all pages in a to-be-split folio to
determine which after-split folios need the flag.

An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
avoid the scan and set it on all after-split folios, but resulting false
positive has undesirable negative impact.  To remove false positive,
caller of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page()
needs to do the scan.  That might be causing a hassle for current and
future callers and more costly than doing the scan in the split code. 
More details are discussed in [1].

This issue can be exposed via:
1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
2. truncating part of a has_hwpoisoned folio in
   truncate_inode_partial_folio().

And later accesses to a hwpoisoned page could be possible due to the
missing has_hwpoisoned folio flag.  This will lead to MCE errors.

Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20251023030521.473097-1-ziy@nvidia.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order
+++ a/mm/huge_memory.c
@@ -3263,6 +3263,14 @@ bool can_split_folio(struct folio *folio
 					caller_pins;
 }
 
+static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
+{
+	for (; nr_pages; page++, nr_pages--)
+		if (PageHWPoison(page))
+			return true;
+	return false;
+}
+
 /*
  * It splits @folio into @new_order folios and copies the @folio metadata to
  * all the resulting folios.
@@ -3270,17 +3278,24 @@ bool can_split_folio(struct folio *folio
 static void __split_folio_to_order(struct folio *folio, int old_order,
 		int new_order)
 {
+	/* Scan poisoned pages when split a poisoned folio to large folios */
+	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;
 	long new_nr_pages = 1 << new_order;
 	long nr_pages = 1 << old_order;
 	long i;
 
+	folio_clear_has_hwpoisoned(folio);
+
+	/* Check first new_nr_pages since the loop below skips them */
+	if (handle_hwpoison &&
+	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
+		folio_set_has_hwpoisoned(folio);
 	/*
 	 * Skip the first new_nr_pages, since the new folio from them have all
 	 * the flags from the original folio.
 	 */
 	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
 		struct page *new_head = &folio->page + i;
-
 		/*
 		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
 		 * Don't pass it around before clear_compound_head().
@@ -3322,6 +3337,10 @@ static void __split_folio_to_order(struc
 				 (1L << PG_dirty) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
+		if (handle_hwpoison &&
+		    page_range_has_hwpoisoned(new_head, new_nr_pages))
+			folio_set_has_hwpoisoned(new_folio);
+
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
@@ -3422,8 +3441,6 @@ static int __split_unmapped_folio(struct
 	if (folio_test_anon(folio))
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
-	folio_clear_has_hwpoisoned(folio);
-
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch
mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch

