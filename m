Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125812905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126202; cv=none; b=NgaKtDuiwCs/ENDj3no+xKuwk0ZTftjXyMfuIhTcv043MjbI3icuC2483LDQt+N2ro8hyqCzs7RB91sjS3cg4NyTOobwm8pOoHvby+LHJm09FDpKID6bb/jrokkKoBLmQQJBzSyaagBE7nt+GIkmQLrxlRCaAMxgwAJSfxCNscA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126202; c=relaxed/simple;
	bh=UciGOvMGX4VZ6kNcdhJEfIMXdjbsCpPR8wk1vevMa2U=;
	h=Date:To:From:Subject:Message-Id; b=sypoHqV1jCDQQOrEZ57Q7dgtM6KFwk9twlfxOlNrazvcxTdYfDQ333Ui1C3n8AGmvuZ9fcYd/c1UM/1WfILBYlc+rAWP2zBC6brRfFyk7CpQGaeHwwo3X9ESDBA7vbcEI6R4AqiIZzuVSUkgWP9h3fSwWAmlINjGB5ncFVY/b5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mb2SI+FB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mb2SI+FB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C088C4CEE3;
	Thu, 10 Jul 2025 05:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126201;
	bh=UciGOvMGX4VZ6kNcdhJEfIMXdjbsCpPR8wk1vevMa2U=;
	h=Date:To:From:Subject:From;
	b=mb2SI+FBzZNd059iqMp2GHWVxeLBmKzKPh5fv5RLU0AmbUYLkHB0EQDyec8TuNA9l
	 l3jJneFf7Hjj/o6CgVO3trJtRRrMJH1pG1c/zRwVi1hwW7ZUjYfSnmqudf0KF8kCXe
	 J7ziw/eVJQfNK3AsoiunxQC/1ylsG3NXjUenNRV0=
Date: Wed, 09 Jul 2025 22:43:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-hugetlb_change_protection-to-folios.patch removed from -mm tree
Message-Id: <20250710054321.8C088C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: convert hugetlb_change_protection() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-hugetlb_change_protection-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlb_change_protection() to folios
Date: Wed, 28 May 2025 15:20:13 -0400

The for loop inside hugetlb_change_protection() increments by the huge
page size:

psize = huge_page_size(h);
for (; address < end; address += psize)

so we are operating on the head page of the huge pages between address and
end.  We can safely convert the struct page usage to struct folio.

Link: https://lkml.kernel.org/r/20250528192013.91130-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlb_change_protection-to-folios
+++ a/mm/hugetlb.c
@@ -7166,11 +7166,11 @@ long hugetlb_change_protection(struct vm
 			/* Nothing to do. */
 		} else if (unlikely(is_hugetlb_entry_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
-			struct page *page = pfn_swap_entry_to_page(entry);
+			struct folio *folio = pfn_swap_entry_folio(entry);
 			pte_t newpte = pte;
 
 			if (is_writable_migration_entry(entry)) {
-				if (PageAnon(page))
+				if (folio_test_anon(folio))
 					entry = make_readable_exclusive_migration_entry(
 								swp_offset(entry));
 				else
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


