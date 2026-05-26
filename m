Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7098E3D3CE9
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813870; cv=none; b=FesKglav09cIfOF8J9fa72RD95JG1H4IkzE3H0W0ovCyQYmdTao0HPdCm3SM82CeJ3FkoEIDIEXvPk/fPS4z1wD2GqmBKfxBeBlMEOW7EGit5ZSNFX6lkKxAUEpY2YWfGOkKNImS6WOSTFrF/Iyr+ytDwKcPl1t+67/+w9jd/hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813870; c=relaxed/simple;
	bh=TAErXzuKWTFvDRnk+H8bwLBXUyu9fw0heq/6voTJ650=;
	h=Date:To:From:Subject:Message-Id; b=b3rcoBhNbv/3bJgAgMPGZJwTT34JMqzqhGWmh6Thq7nSpWuGgWqq51p5nupYvWtlFFEc+vJOaAjlykvmgAmB4EXpo+YkTx/Exwt99I8vsFgVsaHVTcvRYBy9pI8D0OOTspIfIiCM3ChalXIuZ2RCpb/j+97KhMSs72wnJJNWPqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LucGWPHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LucGWPHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D9C1F000E9;
	Tue, 26 May 2026 16:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779813869;
	bh=JwaMwjcEHHgNVcrOtXh5NZCiZee8TV55DlxT3XTqSNg=;
	h=Date:To:From:Subject;
	b=LucGWPHXPTm02pRXl/5Bj8P5MaS8b4AcqX0efs9OlqxJTFFAadZlHYMmvkh72/dk+
	 ftZLUDKV7roezGJxMbTqwUg4X0CtvxSvltJxj4BfmLNAMjXUBJlBUG5InAEpzmklL2
	 8s9dFtwMyTg9VjEd6ncXjbIE5GFJsbJec+5IXLmo=
Date: Tue, 26 May 2026 09:44:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support-fix.patch added to mm-unstable branch
Message-Id: <20260526164429.03D9C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cleanup collapse_max_ptes_none
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: cleanup collapse_max_ptes_none
Date: Tue May 26 05:40:03 2026 -0600

make max_ptes_none a const and cleanup the pr_warn_once

Link: https://lore.kernel.org/b5fa19c5-4b3e-40b8-8e78-fc31169a7a79@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support-fix
+++ a/mm/khugepaged.c
@@ -360,7 +360,7 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
@@ -376,14 +376,13 @@ static unsigned int collapse_max_ptes_no
 	 */
 	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
-	if (!max_ptes_none)
-		return 0;
 	/*
 	 * For mTHP collapse of values other than 0 or KHUGEPAGED_MAX_PTES_LIMIT,
 	 * emit a warning and return 0.
 	 */
-	pr_warn_once("mTHP collapse does not support max_ptes_none values"
-		     " other than 0 or %u, defaulting to 0.\n",
+	if (max_ptes_none)
+		pr_warn_once("mTHP collapse does not support max_ptes_none"
+		     " values other than 0 or %u, defaulting to 0.\n",
 		     KHUGEPAGED_MAX_PTES_LIMIT);
 	return 0;
 }
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support-fix.patch
mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-introduce-mthp-collapse-support-fix.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse-fix.patch

