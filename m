Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0DE219301;
	Mon, 23 Jun 2025 22:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750718899; cv=none; b=HWLblul3hzAlNT7iheg7aQTFrmm3IAti+/xOLCRUA0L4JwKXdWFBjudTVJHL6APCAXl2UJYxZKv84ufEue0fv+MYiP9rwmtKmzNvaeF7lxDFN8yYybKleFaJx5c7ApOeEZUVkgYPUM2X/cPJZ1UKCsvRGaSup6Asa6Kq2Abztuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750718899; c=relaxed/simple;
	bh=XI2BST/F+2NR+LRpGUB+PmBuAIA+krq5mB/OjzIYOeA=;
	h=Date:To:From:Subject:Message-Id; b=oW47jJK0oOM71YVESSSKxOXHw66nEiOBNUz8F5cQm0zVvdss+DRcUyy7Q/dqqUjUPFJXYtmyYxNlu9NmO1zJDvbUQjx7sAuM7WmVha2bdWms3ZeWptpYsd1TjJkEQxeLPqZ4KvIr54zTbn4WIx2HExIyQthB+c2RgsFEj4lzTTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TZIvIZ1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TZIvIZ1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20834C4CEEA;
	Mon, 23 Jun 2025 22:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750718899;
	bh=XI2BST/F+2NR+LRpGUB+PmBuAIA+krq5mB/OjzIYOeA=;
	h=Date:To:From:Subject:From;
	b=TZIvIZ1PA+NHbz5303UNgBKyj0Cgv5NJcpvdSgaKEeUUo++V62pVOrTLitpMxEpU8
	 vSB1shSk2ECoU04qT94INUmjFd8GW3tQ6xInQjXXwtp0Hk+GKnPDhhheYJNLr4/xWk
	 qhsymbYDYZC/OmJKJpIIqeJ6jUqvd/5M8HLU/YFI=
Date: Mon, 23 Jun 2025 15:48:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,lkp@intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-leave-lazy-mmu-mode-on-pte-mapping-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20250623224819.20834C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: leave lazy MMU mode on PTE mapping error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-leave-lazy-mmu-mode-on-pte-mapping-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-leave-lazy-mmu-mode-on-pte-mapping-error.patch

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

mm-vmalloc-leave-lazy-mmu-mode-on-pte-mapping-error.patch

