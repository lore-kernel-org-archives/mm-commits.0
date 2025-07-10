Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB1B1A285;
	Thu, 10 Jul 2025 04:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120544; cv=none; b=PgUU7dFHQYEyV+zK6o1R0S8rDRyOb3fCtyHgNGpA/cDtku7DVe8ZiqD54MWx4XZGCRG7cGARDO6QFDDsl1XYSytcYmiiBy2Bopq+kb3/fI5JQ7sIUOdshQ2eDE4TfGSYFuoFBYu258LG0wx28ycMbPI3+dnZlRXq2QeCTYo9CuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120544; c=relaxed/simple;
	bh=VbhwAtPDhLq7fGWp7wDgKkmSc5982JOoO6N5snEgLBw=;
	h=Date:To:From:Subject:Message-Id; b=UGt5Cxkv4N4ifq0x8WjJHAlooZhHNaRcP3HhsQlniUxO5fDB+3CM91HBXpTAAqZLXOq0rPrUIpf2ojP2sY4cKfswo6ZEpgl40FtBO2jhwDhErnPz17pA+04b+l6KUvk0YGMHxt8q+ntWpZNiBxQpus8FpnigMt1u7wm+EeZYfbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBDaheWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBDaheWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6F6C4CEE3;
	Thu, 10 Jul 2025 04:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120543;
	bh=VbhwAtPDhLq7fGWp7wDgKkmSc5982JOoO6N5snEgLBw=;
	h=Date:To:From:Subject:From;
	b=pBDaheWLq6TfUUqSZ0+ti5buqGlYcLUSrgNIDbEwDCst9nJQ/Zr7RUZlqlg2C3x3Z
	 yfA9xMT6GHswk38YUghy7CAsZ8ZZcONnFiPLjoJp2AvSN31yyAJqcj9bx7wRyvKYwS
	 DNR5FVHiwEefezoABlirHFpe1m0am3C8DVnOi/V0=
Date: Wed, 09 Jul 2025 21:09:03 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,lkp@intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-leave-lazy-mmu-mode-on-pte-mapping-error.patch removed from -mm tree
Message-Id: <20250710040903.8D6F6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: leave lazy MMU mode on PTE mapping error
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-leave-lazy-mmu-mode-on-pte-mapping-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm/vmalloc: leave lazy MMU mode on PTE mapping error
Date: Mon, 23 Jun 2025 09:57:21 +0200

vmap_pages_pte_range() enters the lazy MMU mode, but fails to leave it in
case an error is encountered.

Link: https://lkml.kernel.org/r/20250623075721.2817094-1-agordeev@linux.ibm.com
Fixes: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202506132017.T1l1l6ME-lkp@intel.com/
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-leave-lazy-mmu-mode-on-pte-mapping-error
+++ a/mm/vmalloc.c
@@ -514,6 +514,7 @@ static int vmap_pages_pte_range(pmd_t *p
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
 		pgtbl_mod_mask *mask)
 {
+	int err = 0;
 	pte_t *pte;
 
 	/*
@@ -530,12 +531,18 @@ static int vmap_pages_pte_range(pmd_t *p
 	do {
 		struct page *page = pages[*nr];
 
-		if (WARN_ON(!pte_none(ptep_get(pte))))
-			return -EBUSY;
-		if (WARN_ON(!page))
-			return -ENOMEM;
-		if (WARN_ON(!pfn_valid(page_to_pfn(page))))
-			return -EINVAL;
+		if (WARN_ON(!pte_none(ptep_get(pte)))) {
+			err = -EBUSY;
+			break;
+		}
+		if (WARN_ON(!page)) {
+			err = -ENOMEM;
+			break;
+		}
+		if (WARN_ON(!pfn_valid(page_to_pfn(page)))) {
+			err = -EINVAL;
+			break;
+		}
 
 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
 		(*nr)++;
@@ -543,7 +550,8 @@ static int vmap_pages_pte_range(pmd_t *p
 
 	arch_leave_lazy_mmu_mode();
 	*mask |= PGTBL_PTE_MODIFIED;
-	return 0;
+
+	return err;
 }
 
 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


