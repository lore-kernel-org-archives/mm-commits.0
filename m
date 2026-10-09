Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8203F39FA
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525382; cv=none; b=gO1ArUPA0taugD01AOUEFoONiZNQPZ+LMe/MufKcTAPR/wxnTfHtvlJQUzhefzm7jl2sirGV9WjR8pr9udGTSQVY+RvoIiWJOSllGGxlFhBuRfW2bcpVbwurowK1vZmGAeE4upmGjdqMAjcjAgLycd2Au03hZOWXUDLn6r8ssMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525382; c=relaxed/simple;
	bh=qIhQPKieAzEd8jxM9P20prYyzM/QU4rw1DsBdE66EzE=;
	h=Date:To:From:Subject:Message-Id; b=oQUaXptmYmLyWWqxWrGBMgP5tYIephLOh+5/VHHK987zRR6mg6J/eCckuDvA8ZCUMXhPQbKsajyTKEqs6zGS5JHq0EV0lLmwtQfOXcoqg26drH0R/UDHPFt9aJtUllYrXUCrYQBtdeTcetoMDzZKjwEd9ZyxNWjeSTRYZsCY7k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cmjidvgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cmjidvgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD1E1F000FF;
	Fri,  9 Oct 2026 05:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525380;
	bh=ONJK0+P8xyHahs0hj7WBKKTVM+K3Z4AGpTWwXVndaSg=;
	h=Date:To:From:Subject;
	b=cmjidvgA/Y9D/DV72EYgBd42g8MaF5RHOVCRC3JO4Igy1gLTeM6gcWNE+Q5k/EiyC
	 OXYsEvdrOVaYOZVpPX5Tu2rtVon3vA87qEc4fRuGnpiji1F9j8RDPtPQdUnIVIP/1Q
	 2j1b8ujyQUZVaJyl3AsAOzOX/+FseNptTwSMtW8w=
Date: Thu, 08 Oct 2026 22:56:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,riel@surriel.com,lkp@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_vma_mapped-guard-check_pmd-with-config_transparent_hugepage.patch removed from -mm tree
Message-Id: <20261009055620.BAD1E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_vma_mapped: guard check_pmd() with CONFIG_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-guard-check_pmd-with-config_transparent_hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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


