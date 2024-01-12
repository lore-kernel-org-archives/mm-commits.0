Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C5615AC9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Oa55Ty3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925BFC433C7;
	Fri, 12 Jan 2024 19:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705088958;
	bh=dqDJUZxGZFsqsJ1ROZSBtSYymYvaAn7PlQ7kC/pwf70=;
	h=Date:To:From:Subject:From;
	b=0Oa55Ty3ZexkZWHaYxkz7sjuRUArXl3s2VQuGbyPcGU/o4SZF17MGuygh1I+rKJqL
	 aDaAKnxIbkRGkPTh2fAdnLnvFFNeCbJcAMjKnhhIcoa5ViWryDSuJqTrv5ZpCH92Be
	 YrIDREwJTWqMfWlyGJ1sdR7XWeLuCXOq8kKkoH3k=
Date: Fri, 12 Jan 2024 11:49:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lkp@intel.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch added to mm-unstable branch
Message-Id: <20240112194918.925BFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-convert-to-should_zap_page-to-should_zap_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-convert-to-should_zap_page-to-should_zap_folio-fix
Date: Fri, 12 Jan 2024 18:14:32 +0800

fix used-uninitialized warning

Link: https://lkml.kernel.org/r/962a7993-fce9-4de8-85cd-25e290f25736@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401121250.A221BL2D-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-convert-to-should_zap_page-to-should_zap_folio-fix
+++ a/mm/memory.c
@@ -1435,7 +1435,7 @@ static unsigned long zap_pte_range(struc
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = ptep_get(pte);
-		struct folio *folio;
+		struct folio *folio = NULL;
 		struct page *page;
 
 		if (pte_none(ptent))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch

