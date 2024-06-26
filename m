Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60461D53F
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 02:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719368912; cv=none; b=Iw4lC18ZXxh+GdZYJtuRrG9NbWiVNepAFGQ+VxSKjOntAv3NAOf7SxczQ1fbz75p1HJzSJtURSsEVw9abI5ux62VbGzIo905REn5czmLl0gAHith1RkVFgrilgUwnaOYbgWcOAt/SrWdFUaaU0FksbrlTv5dRUda5SZglbAXFWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719368912; c=relaxed/simple;
	bh=pCErraZCAvXpGcjZbghR/izB3P+kyJcIm+HdLM91cuE=;
	h=Date:To:From:Subject:Message-Id; b=XpBIFGwvudvCgNihWWgXbBPoX8Sng38bgWtXj7Cz6DZhnStfsjXpGIue8Hy1itRWL7iTdYrgGMW5wgZ9FYhHtvzgRAtDCUpi0ILuvDVaAc0fKNfB1xI0sTYkOu3eGthxaV+GK3vihHcgkVERnGCXTmyCe4G+7AvyCuD+KpfjbjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fu+yBmAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fu+yBmAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EABFC32781;
	Wed, 26 Jun 2024 02:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719368911;
	bh=pCErraZCAvXpGcjZbghR/izB3P+kyJcIm+HdLM91cuE=;
	h=Date:To:From:Subject:From;
	b=fu+yBmAHVFSjmnGofHqdPIm3e4iU5PfNnnXP4u/DZXYWOR5l5vqH+ZcGkp9sTqwOk
	 mWG1IbErkBePut3qeCY6OLccH+DoxpVMCnqFGxmvdUEBa+rHlnjo4ITpEx60alb4ey
	 Q1pfv6iVnVyP49maqUnhV400v8akTI0de1RdKbY4=
Date: Tue, 25 Jun 2024 19:28:29 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,ioworker0@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memoryc-fix-used-uninitialized.patch added to mm-unstable branch
Message-Id: <20240626022831.4EABFC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory.c: fix used-uninitialized
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memoryc-fix-used-uninitialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memoryc-fix-used-uninitialized.patch

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

mm-huge_memoryc-fix-used-uninitialized.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code-fix.patch

