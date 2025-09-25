Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACD419C546
	for <mm-commits@vger.kernel.org>; Thu, 25 Sep 2025 22:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758840891; cv=none; b=NOqQFONY9trYdeUckAaREM16aVKT0U6l177PfZWcARRvPx1kfW4rx8UDkvvfVUpsvUH7OKOUE9kbm+s5Qqv9PCN0YzCOhRf2bYhwbIH1s8MtPtkLWg9RVe0VXs8BEJFojeNyW/JI1BeCep1eeVkzKVX2MNEjCvphYU7bUWwegwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758840891; c=relaxed/simple;
	bh=SMTYkMLFuCaCooM/xNuKtkLFm9tOlt2oFIcY93goqrY=;
	h=Date:To:From:Subject:Message-Id; b=gumDlujeaUEj3qByT4+ywaYg8b2CbqpUcPvVvzsrL0KLWfYds8izstyrlVuL9SIpYeE1HHGvncx5daosQkdR5PuUP5kVuRSx2ma2UODI0voDFhQBCoIwVH96HIIX/1R+9yaeOJIMCoq9EKllk/n1yfJrIFUTI4hN1EX27cUZpHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jeifyjbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jeifyjbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB274C4CEF0;
	Thu, 25 Sep 2025 22:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758840891;
	bh=SMTYkMLFuCaCooM/xNuKtkLFm9tOlt2oFIcY93goqrY=;
	h=Date:To:From:Subject:From;
	b=Jeifyjbpt5HLIAk8f5y0Hl9lIEV+32Kwu5O2FAXbpNGp0TQ8yUnHaYFMhGzHHTgQ+
	 PDzPJluvjB2ZXu12Yup7wDJ8ADy8Lgg7/33UPRX2LOTU6KN4/adHDc47DqZCUqPmV7
	 ALgjh20Sym4CgBOYeE8lRM/eX/Zkmi3XMghBjBcI=
Date: Thu, 25 Sep 2025 15:54:50 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,lkp@intel.com,balbirs@nvidia.com,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch removed from -mm tree
Message-Id: <20250925225450.DB274C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix
has been removed from the -mm tree.  Its filename was
     kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch

This patch was dropped because it was folded into kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix
Date: Fri Sep 12 10:55:48 PM PDT 2025

fix s390 build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509131255.x9EfvIGt-lkp@intel.com/
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/shadow.c~kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix
+++ a/mm/kasan/shadow.c
@@ -319,7 +319,7 @@ static int kasan_populate_vmalloc_pte(pt
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
-	(void)arch_enter_lazy_mmu_mode();
+	arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
@@ -494,7 +494,7 @@ static int kasan_depopulate_vmalloc_pte(
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
-	(void)arch_enter_lazy_mmu_mode();
+	arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode.patch
mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

