Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE5F18D4D2
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 21:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722287271; cv=none; b=r+JuV/0zbiODv5G92cn74MtI1//Cy4ddLZ5vV+xTPckyWaa/gn9rmaZkglCepwH4H4HhU7xbl2k/njkP381TjPlgzwjljq3XKdjfa2TnfvHjKXNSpeziMRB4qZBPfZwMkC6xE/LwGysXLP43sosBgnTw6MO/C24rSfnHwMr8XM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722287271; c=relaxed/simple;
	bh=Fk2zjNVTVk6yUMLUgehEsFRbxDbvzymJPQqsD9wpHjo=;
	h=Date:To:From:Subject:Message-Id; b=hOdUDIe02zSTd7mws2vOLoF562ruzARSag+bWQ3IBVijEATtLoHdQUoqaIYqGXf5b3zs1+u22LVBccvzymtucqy42MZXeveYabt87fDv/8M71UFXLrAGzIhQL7bVfnW9kqYuX6ps7PSdhxmGMcCQ4LEWV1MEU4sNybAa6PNLzdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BXzWKEw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BXzWKEw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6436C4AF09;
	Mon, 29 Jul 2024 21:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722287270;
	bh=Fk2zjNVTVk6yUMLUgehEsFRbxDbvzymJPQqsD9wpHjo=;
	h=Date:To:From:Subject:From;
	b=BXzWKEw5jgwZQeffYiX9+Om8XMOULL1IJ+Sk8bTpC3Lj47YkuCYLzC/DawO0FA+aq
	 sM2s2WR6FcEm0oRFL2d94v5+qUEJQZbdmg9irgt5242G72HzD3JS+SI1uU1tTM+dt/
	 NcGOO/nfUriO7N3U7GF7hQvcOpDbfTrQ3Sd26+fk=
Date: Mon, 29 Jul 2024 14:07:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-convert-to-arch_make_folio_accessible.patch added to mm-unstable branch
Message-Id: <20240729210750.D6436C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: convert to arch_make_folio_accessible()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-convert-to-arch_make_folio_accessible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-convert-to-arch_make_folio_accessible.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: convert to arch_make_folio_accessible()
Date: Mon, 29 Jul 2024 20:38:43 +0200

Let's use arch_make_folio_accessible() instead so we can get rid of
arch_make_page_accessible().

Link: https://lkml.kernel.org/r/20240729183844.388481-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-convert-to-arch_make_folio_accessible
+++ a/mm/gup.c
@@ -819,6 +819,7 @@ static struct page *follow_page_pte(stru
 		struct dev_pagemap **pgmap)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio *folio;
 	struct page *page;
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
@@ -876,6 +877,7 @@ static struct page *follow_page_pte(stru
 			goto out;
 		}
 	}
+	folio = page_folio(page);
 
 	if (!pte_write(pte) && gup_must_unshare(vma, flags, page)) {
 		page = ERR_PTR(-EMLINK);
@@ -886,7 +888,7 @@ static struct page *follow_page_pte(stru
 		       !PageAnonExclusive(page), page);
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	ret = try_grab_folio(page_folio(page), 1, flags);
+	ret = try_grab_folio(folio, 1, flags);
 	if (unlikely(ret)) {
 		page = ERR_PTR(ret);
 		goto out;
@@ -898,7 +900,7 @@ static struct page *follow_page_pte(stru
 	 * Documentation/core-api/pin_user_pages.rst for details.
 	 */
 	if (flags & FOLL_PIN) {
-		ret = arch_make_page_accessible(page);
+		ret = arch_make_folio_accessible(folio);
 		if (ret) {
 			unpin_user_page(page);
 			page = ERR_PTR(ret);
@@ -2919,7 +2921,7 @@ static int gup_fast_pte_range(pmd_t pmd,
 		 * details.
 		 */
 		if (flags & FOLL_PIN) {
-			ret = arch_make_page_accessible(page);
+			ret = arch_make_folio_accessible(folio);
 			if (ret) {
 				gup_put_folio(folio, 1, flags);
 				goto pte_unmap;
_

Patches currently in -mm which might be from david@redhat.com are

mm-let-pte_lockptr-consume-a-pte_t-pointer.patch
mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch
mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch

