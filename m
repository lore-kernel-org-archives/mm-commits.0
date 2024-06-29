Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768D97494
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628191; cv=none; b=n2/Sau4ywwF654rtU/E06dr3cTgMQfIIct3aqMQgiM8jadWq7IO8BgybHMs1DdWXX0+m6Sf6MdM3qG9dk4aux2CmccdVtKTHUUr7GayTsbrs19GLhQoBB/O1AW3N0+j/VdApHE7iMAsOeMWCXGi4mxYKvahUc2ffDJ9krkiUi3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628191; c=relaxed/simple;
	bh=eIXsOjlo8xwjOKdqaiRIicfAPP7/FkaBlYYr30NLU+M=;
	h=Date:To:From:Subject:Message-Id; b=gE/y4ZRqS8YRMgWyihWYxqhfgy/A6FTNZpLHzC3DB8BUzjYPZps7SzwsbKZIuV0ZZ+zMlNmhB+aXJQL4ABimMwoOYZ6Ykl+eMpM0hOQg9EFjGwaHWy/b9rSE6FXhB4K5AETeNe4XLfEAMlfvuL/Hp32Dfk8tSjje78VljdEs6hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lTH0UFad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lTH0UFad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00C8C116B1;
	Sat, 29 Jun 2024 02:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628190;
	bh=eIXsOjlo8xwjOKdqaiRIicfAPP7/FkaBlYYr30NLU+M=;
	h=Date:To:From:Subject:From;
	b=lTH0UFadwNZzjdFB6OsNZa3fYh7Z5NMCyHal3xSzvOjOREqR2fUn6H5DsOfpgNs1i
	 s4EAA8SzKjszbIuGnxwW0UCUVmgnYCxQbe+k9QDhrGP6UW0875u+iGw1lj1PdZ0W2j
	 uZ0nHQzggSu6pYfOKKgcynKHi9H8ZrVQFrbfOw3o=
Date: Fri, 28 Jun 2024 19:29:50 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,ioworker0@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memoryc-fix-used-uninitialized.patch removed from -mm tree
Message-Id: <20240629022950.D00C8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory.c: fix used-uninitialized
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-fix-used-uninitialized.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/huge_memory.c: fix used-uninitialized
Date: Tue Jun 25 02:51:36 PM PDT 2024

Fix used-uninitialized of `page'.

Fixes: dce7d10be4bb ("mm/madvise: optimize lazyfreeing with mTHP in madvise_free")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406260514.SLhNM9kQ-lkp@intel.com
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-fix-used-uninitialized
+++ a/mm/huge_memory.c
@@ -2696,7 +2696,6 @@ static bool __discard_anon_folio_pmd_loc
 	struct mm_struct *mm = vma->vm_mm;
 	int ref_count, map_count;
 	pmd_t orig_pmd = *pmdp;
-	struct page *page;
 
 	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
 		return false;
@@ -2732,7 +2731,7 @@ static bool __discard_anon_folio_pmd_loc
 		return false;
 	}
 
-	folio_remove_rmap_pmd(folio, page, vma);
+	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
 	zap_deposited_table(mm, pmdp);
 	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	if (vma->vm_flags & VM_LOCKED)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

