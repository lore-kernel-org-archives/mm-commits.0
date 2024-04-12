Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7D34C6E
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 22:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712962374; cv=none; b=TUU5Q2XNqibFWIHQsqmLIlk6lc4sOpUWYyprkUbWIEyvc5wyJLW2ADnENOUogsNh+rP9I76yrhmvZ8bW77dz1BAAT1CvE9q9oRjGO+qqRQu9P8qHv/jC5U5y/8SsRUDPIWjjesSuEwuYckM68h6ULua21rayjK5JVdoak+YjSLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712962374; c=relaxed/simple;
	bh=mE5NZ3nVSr63tVCI1H7HLrqsRkzEN81nLSyFqEBClfE=;
	h=Date:To:From:Subject:Message-Id; b=HebkeEsxCA6AL38hAAfn5b0TugzZbXsNJSzF7MOoby3/JyMU6UD4mE+x2RvotAOTvKmTxsZQ9Uw32NaFcFlavl/PWq2bGLsmVBaGs65879RfhZOgwFlYcxyfVA1P58Ig0Ubkzuov1DEcMfs+LcLh7EXdb1dkGy1Fh1BAZoSWI2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fbjpNMIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fbjpNMIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE672C113CC;
	Fri, 12 Apr 2024 22:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712962374;
	bh=mE5NZ3nVSr63tVCI1H7HLrqsRkzEN81nLSyFqEBClfE=;
	h=Date:To:From:Subject:From;
	b=fbjpNMImA01wMKT3wD8BpE2x4wU/lEcYOz308DMzAROgLS4but8/mT3ib7TTkiRFi
	 DAxlSGsvlCQ7GG0/8Jzv+B51huifQsIkYL5f1ya651YtHNRbGJwF+UUw/Hm+GPypTU
	 jef8g1RWIJIUC6K9t2L2ia/2fA9wTTr6Yhgax4zY=
Date: Fri, 12 Apr 2024 15:52:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch added to mm-unstable branch
Message-Id: <20240412225253.EE672C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: convert dissolve_free_huge_pages() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert dissolve_free_huge_pages() to folios
Date: Fri, 12 Apr 2024 11:21:38 -0700

Change additional comments which reference hugepages to hugetlb folios per
Miaohe Lin.  

Link: https://lkml.kernel.org/r/20240412182139.120871-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |    4 ++--
 mm/memory-failure.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2
+++ a/mm/hugetlb.c
@@ -2378,7 +2378,7 @@ static struct folio *remove_pool_hugetlb
 
 /*
  * Dissolve a given free hugetlb folio into free buddy pages. This function
- * does nothing for in-use hugepages and non-hugepages.
+ * does nothing for in-use hugetlb folios and non-hugetlb folios.
  * This function returns values like below:
  *
  *  -ENOMEM: failed to allocate vmemmap pages to free the freed hugepages
@@ -2470,7 +2470,7 @@ out:
  * Note that this will dissolve a free gigantic hugepage completely, if any
  * part of it lies within the given range.
  * Also note that if dissolve_free_hugetlb_folio() returns with an error, all
- * free hugepages that were dissolved before that error are lost.
+ * free hugetlb folios that were dissolved before that error are lost.
  */
 int dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
--- a/mm/memory-failure.c~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2
+++ a/mm/memory-failure.c
@@ -172,8 +172,8 @@ static bool page_handle_poison(struct pa
 {
 	if (hugepage_or_freepage) {
 		/*
-		 * Doing this check for free pages is also fine since dissolve_free_huge_page
-		 * returns 0 for non-hugetlb pages as well.
+		 * Doing this check for free pages is also fine since
+		 * dissolve_free_hugetlb_folio() returns 0 for non-hugetlb folios as well.
 		 */
 		if (__page_handle_poison(page) <= 0)
 			/*
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch

