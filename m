Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D18919E97B
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 03:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788404616; cv=none; b=IEbKTwrpXf9skKDdXXhJ1R58fULs9dqTwsTOCG09bl5+rOcwp5LAZZsA3aIA5bXUREX30KYQLN1C9ORLWNc4WixvHeKcwxfnWo7NT19wRw8MShGXN4iBBxCSs76P4w8BWJhnjBacyFll5ZPSr5vpiETK2Eee629QxZDJOcQ/P88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788404616; c=relaxed/simple;
	bh=YZCpe6lzFe+nz403fcJSkZKj30kadL2fQi/F6RI8aYc=;
	h=Date:To:From:Subject:Message-Id; b=fWBGthh4RMoIYD+/IZ+5Bfw0D0/2O0CF8he3JlTfgEujt9MPHa0WdqCWYxerrg2KEWu6/dOiMqClS0rEfpJbTH8jOBr72k2n2Q6d1fTRNe130Wh4HKcY7WE5EasrKZhJuNt5EVmNtRRV88fDIDS7SAnEOml3xnV/uevqM0g9kpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBipy4+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBipy4+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812121F000E9;
	Thu,  3 Sep 2026 03:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788404614;
	bh=Yh42vAwsFzOM15tySUfbO+7ZlnKb+eR/69tLT7Krgio=;
	h=Date:To:From:Subject;
	b=vBipy4+oNNN5a9y4gOg1yVbpBjZlGGXE0UewvXv3LUmZIPQc8/fggoBfJ8kYYD1nB
	 PE/NB3lvyvuOhBRAMGvtBMiHyyJgzTTlKc1tISV1ZI7gSbujLggE3LELQCxVQQ/HHL
	 ozr7Xo4QETaXW2tiEtyDkK4C4Zh0fu3FqIq3aIFs=
Date: Wed, 02 Sep 2026 20:03:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,riel@surriel.com,lkp@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mapped-guard-check_pmd-with-config_transparent_hugepage.patch added to mm-new branch
Message-Id: <20260903030334.812121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_vma_mapped: guard check_pmd() with CONFIG_TRANSPARENT_HUGEPAGE
has been added to the -mm mm-new branch.  Its filename is
     mm-page_vma_mapped-guard-check_pmd-with-config_transparent_hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mapped-guard-check_pmd-with-config_transparent_hugepage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_vma_mapped: guard check_pmd() with CONFIG_TRANSPARENT_HUGEPAGE
Date: Wed, 24 Jun 2026 08:23:59 +0000

The kernel test robot reported a build failure on the parisc architecture
when expanding HPAGE_PMD_NR in check_pmd().

   mm/page_vma_mapped.c:142:13: note: in expansion of macro 'HPAGE_PMD_NR'
     if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
                ^~~~~~~~~~~~

The config [1] in report link shows neither TRANSPARENT_HUGEPAGE nor
HUGETLB_PAGE is defined.  Then trigger the BUILD_BUG.

Fix it by define check_pmd() under CONFIG_TRANSPARENT_HUGEPAGE.

Link: https://lore.kernel.org/20260624082359.2869-1-richard.weiyang@gmail.com
Link: https://download.01.org/0day-ci/archive/20260624/202606240042.ffPsEXVc-lkp@intel.com/config [1]
Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606240042.ffPsEXVc-lkp@intel.com/
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-guard-check_pmd-with-config_transparent_hugepage
+++ a/mm/page_vma_mapped.c
@@ -142,6 +142,7 @@ static bool check_pte(struct page_vma_ma
 	return true;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* Returns true if the two ranges overlap.  Careful to not overflow. */
 static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
 {
@@ -151,6 +152,12 @@ static bool check_pmd(unsigned long pfn,
 		return false;
 	return true;
 }
+#else
+static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
+{
+	return false;
+}
+#endif
 
 static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
 {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-adjust-out-dated-document-of-__gfp_nofail.patch
mm-page_vma_mapped-guard-check_pmd-with-config_transparent_hugepage.patch

