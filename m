Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5F5289831
	for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2025 23:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534182; cv=none; b=HLzEyNIl1+xH58YBKBNrbxa9lyiaFB8wL3cN9VDBINhBn2vqoR73+m9+WFrHIyDzP66n3/vpWUrlA0mCZB4rm4TSoYXF92DpELW37fFt+F7tCwKNcMSyCG2qE/QwCaGRc7uxgcdgX/jBUXTMRXe7A9GSQPOywAHxb+EeJcbccc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534182; c=relaxed/simple;
	bh=TZe9TMakyYxtaLIp+DbIlYWu5rfGiGg4KCsaDM6joEQ=;
	h=Date:To:From:Subject:Message-Id; b=fQdljTh1igSwjaFr+bFQ7YNk2+4pa6aPAwRL+o811qRXOq20sgKg6pykbTIZfjV9lUjwyAN121pY7D55HeFq0At/kJMo1492SuCnoPTC1j65NuRoeVDIyni7imgVSJlSDSuwF+ndpfKfhEhuCDkY7+ValFlfSP2MxbXj0H+OuIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cZLcTQLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cZLcTQLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BDDC4AF13;
	Mon, 14 Jul 2025 23:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752534182;
	bh=TZe9TMakyYxtaLIp+DbIlYWu5rfGiGg4KCsaDM6joEQ=;
	h=Date:To:From:Subject:From;
	b=cZLcTQLCY9/zxdX2nnOSJOUe6F0cBvV3Mn3cwcKQBZDLeenZAFJD/xOruvcQv2rfy
	 DGNteHgk1viZmZVkMgVfFyTkeP11uJpKd6zAWcQmlCcE46GLj8hXIndhHe7HIzuKHO
	 uGV6lj0RvIdb8OdOeJ6GL9wmQahTxhiIuOTXT1T8=
Date: Mon, 14 Jul 2025 16:03:01 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch added to mm-unstable branch
Message-Id: <20250714230302.39BDDC4AF13@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: use folio_expected_ref_count() to calculate ref_count
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: use folio_expected_ref_count() to calculate ref_count
Date: Mon, 14 Jul 2025 13:18:23 -0400

Patch series "__folio_split() clean up." v3.

Based on the prior discussion[1], this patch improves
__split_unmapped_folio() by making it reusable for splitting unmapped
folios.  This helps avoid the need for a new boolean unmapped parameter to
guard mapping-related code.

An additional benefit is that __split_unmapped_folio() could be called on
after-split folios by __folio_split().  It can enable new split methods. 
For example, at deferred split time, unmapped subpages can scatter
arbitrarily within a large folio, neither uniform nor non-uniform split
can maximize after-split folio orders for mapped subpages.  The hope is
that by calling __split_unmapped_folio() multiple times, a better split
result can be achieved.


This patch (of 2):

Instead of open coding the ref_count calculation, use
folio_expected_ref_count().

Link: https://lkml.kernel.org/r/20250714171823.3626213-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count
+++ a/mm/huge_memory.c
@@ -3724,6 +3724,7 @@ static int __folio_split(struct folio *f
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct address_space *swap_cache = NULL;
 		struct lruvec *lruvec;
+		int expected_refs;
 
 		if (folio_order(folio) > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
@@ -3794,11 +3795,8 @@ static int __folio_split(struct folio *f
 		     new_folio = next) {
 			next = folio_next(new_folio);
 
-			folio_ref_unfreeze(
-				new_folio,
-				1 + ((mapping || swap_cache) ?
-					     folio_nr_pages(new_folio) :
-					     0));
+			expected_refs = folio_expected_ref_count(new_folio) + 1;
+			folio_ref_unfreeze(new_folio, expected_refs);
 
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -3828,8 +3826,8 @@ static int __folio_split(struct folio *f
 		 * Otherwise, a parallel folio_try_get() can grab origin_folio
 		 * and its caller can see stale page cache entries.
 		 */
-		folio_ref_unfreeze(folio, 1 +
-			((mapping || swap_cache) ? folio_nr_pages(folio) : 0));
+		expected_refs = folio_expected_ref_count(folio) + 1;
+		folio_ref_unfreeze(folio, expected_refs);
 
 		unlock_page_lruvec(lruvec);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

