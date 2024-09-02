Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781C844C81
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247703; cv=none; b=COEi3PrvKs7Tou2hO9XJfMJ/PeHEh0UsZtg7ZwtnA7RjiYYOQ8gJiAPJcq1Ht20IfAhrj2u5AZjsB5LmoJn9Wg2ILqf698/oM4sEmQi24K8xpGh7FOyz1yahO/zsoq9hrnbDgtLZfO+f++V93PotpytSKySViwgs3UOzKEyiLV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247703; c=relaxed/simple;
	bh=VZnxKSnsVEmFONq0rjOXhEKVpyvder6Qiqa7S0C/6Vw=;
	h=Date:To:From:Subject:Message-Id; b=iuxJ0p8K4VHas2xVwpHa71lJlxlDDDErWWlWAFSyxz50XTkL7jsMnntpB3A3gbordWqFf1Uh7ZGLnItSXB2EzsfoQv1yMNirVGpEbYELisCf17MWdmJxrgTVYQ2iyIX9vVhg2aeVrPvCUxVRQG+wMjD+7YeW7O5fdsH/uWLd1bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bSFc+tvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bSFc+tvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E39C4CEC2;
	Mon,  2 Sep 2024 03:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247703;
	bh=VZnxKSnsVEmFONq0rjOXhEKVpyvder6Qiqa7S0C/6Vw=;
	h=Date:To:From:Subject:From;
	b=bSFc+tvJofHYLZ+q6QwcXNYYkPheY7rTe94C6tYi8++rw4cjYe+cbj5O+MK5sWeNY
	 +q6t3hulq7L0kVKHDBhWGt0XvDDVmF5dKw74svXlAJhwoUWMrAPnNmbfjB25FH8dzx
	 omKhNfPVcEpMpeqKFjX6SyXaAAZS2vaVQgU65gGI=
Date: Sun, 01 Sep 2024 20:28:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-convert-to-arch_make_folio_accessible.patch removed from -mm tree
Message-Id: <20240902032823.43E39C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: convert to arch_make_folio_accessible()
has been removed from the -mm tree.  Its filename was
     mm-gup-convert-to-arch_make_folio_accessible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: convert to arch_make_folio_accessible()
Date: Mon, 29 Jul 2024 20:38:43 +0200

Let's use arch_make_folio_accessible() instead so we can get rid of
arch_make_page_accessible().

Link: https://lkml.kernel.org/r/20240729183844.388481-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

