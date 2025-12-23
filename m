Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87D327E076
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 02:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766457514; cv=none; b=PuOegVSC0AIaBwAXR/nresjsnJAI0wyf3HRIokEdcxWGqtYJW6ft7qO6AE0Ba2H4mw2DdvrdyVbbm0cdx7cmkiQdEqzQrcFSLCCy8/G1Lp9dReDc18q8BzrBjQaDX+Ru94uBEyaKQw8+vo2OrzEDwhwkgWDLyfBexC2Tkd/i0G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766457514; c=relaxed/simple;
	bh=BPLiFZSRnhKFLGhWFDuNt6nEi3NzKcUyhCeIlYiTAAE=;
	h=Date:To:From:Subject:Message-Id; b=XuP4IcqsmeeNl7xPAzehVAh5r8nhz6wBPrLs4MbOM20tVA3VMyC3CPw7MWHzW6wDqFYO5TNALn5KyZKvQ6b93v9EUZvsOhO9rb2LeDfeFkgne8aJQYDtZbqfLoZkAEXQkaQub5BSg5cLAXf4Tr6guWp7JjQFnW7IYmXFVGVLn2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LcZdCCJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LcZdCCJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AC3C4CEF1;
	Tue, 23 Dec 2025 02:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766457513;
	bh=BPLiFZSRnhKFLGhWFDuNt6nEi3NzKcUyhCeIlYiTAAE=;
	h=Date:To:From:Subject:From;
	b=LcZdCCJMwor9xfshyptA0iWyfC5hC1cx05bBxa//MA7PfaMjzeDxkvr0eeiuWhiQ8
	 TBgo0RAYE64ahlO4adEE7zvzhMxVZ6WuiMdHd0oJf/rhBkq2jfyKR3r6viyanKTfka
	 nhgUEree95+WGdoLNTEwQJoDz+WbAP8sTH+qjgQs=
Date: Mon, 22 Dec 2025 18:38:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-simplify-page-tracking-in-remap_page-during-folio-split.patch added to mm-new branch
Message-Id: <20251223023833.14AC3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: simplify page tracking in remap_page() during folio split
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-simplify-page-tracking-in-remap_page-during-folio-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-simplify-page-tracking-in-remap_page-during-folio-split.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm/huge_memory: simplify page tracking in remap_page() during folio split
Date: Mon, 22 Dec 2025 13:45:31 +0000

After splitting a large folio, the resulting anonymous folios must be
remapped.

Currently, the code tracks progress by recording the number of processed
pages in an index variable (e.g., @i) and comparing it against the
total. This commit simplifies the logic by directly subtracting the
processed pages from the remaining count. This approach is more
straightforward and reduces the number of local variables.

Additionally, this commit renames the variable nr to nr_pages to improve
code readability and self-documentation.

Link: https://lkml.kernel.org/r/20251222134531.20968-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-simplify-page-tracking-in-remap_page-during-folio-split
+++ a/mm/huge_memory.c
@@ -3423,17 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_are
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_page(struct folio *folio, unsigned long nr_pages, int flags)
 {
-	int i = 0;
-
 	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
-		i += folio_nr_pages(folio);
-		if (i >= nr)
+		nr_pages -= folio_nr_pages(folio);
+		if (!nr_pages)
 			break;
 		folio = folio_next(folio);
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-huge_memory-simplify-page-tracking-in-remap_page-during-folio-split.patch

