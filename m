Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC9B1CFEC6
	for <mm-commits@vger.kernel.org>; Thu, 22 Aug 2024 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724351073; cv=none; b=fUEzx54Fn8XqasTGNzagvtJ/9fGPGcaHbIicXSBOxfcAYp7ws+wbYmCzT7xTDdgX/HeI/KtpCULgPfzmRyainsoTl6DN1m5mrPGhE5a6oLJMoxuBin560XjpUVk5IC36rmN7w4ext7w9YyadqnbACp46PwNIn7t1Q0k2VngZvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724351073; c=relaxed/simple;
	bh=/074bTdV7cRIvnwlS3JZpaoXWBP5qf8JoFLyUsm4TmE=;
	h=Date:To:From:Subject:Message-Id; b=STw83p33dxdlxjhpjj7Bhn5t0/BbB5nszKpvWFHLTiVe76FGK2DTnbw/d7QGry0tBVi10LuomHlB7ZJPorgAVd96NdcGwi+hy5Lsk3FJx1R2tJNrZkaTnRH3k2AozhFuHoaFiUuODyvUCTsGrG/f3pybHF1nU0YRfFCP3msfoQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H68/UuYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H68/UuYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B1DC32782;
	Thu, 22 Aug 2024 18:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724351072;
	bh=/074bTdV7cRIvnwlS3JZpaoXWBP5qf8JoFLyUsm4TmE=;
	h=Date:To:From:Subject:From;
	b=H68/UuYbUZwxBa/oqput3sck7s+r0DLA+78VSEQs3GvAx/n8pX6cNyKkxRnVBZWQd
	 NyeIhhvB6Tn7x+aQm5DdlnAICV4JO2ZpOvgNlXItiKWkAIgb2pS/DmVVNyBEZLmlIx
	 PypxDgKVQdtIA86/b9yvwl4N4KHB5++4IzQLZTNQ=
Date: Thu, 22 Aug 2024 11:24:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pageactive-fix.patch added to mm-unstable branch
Message-Id: <20240822182432.93B1DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-remove-pageactive-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pageactive-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pageactive-fix.patch

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
Subject: mm-remove-pageactive-fix
Date: Thu Aug 22 11:21:31 AM PDT 2024

fix arch/powerpc/mm/pgtable-frag.c

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable-frag.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/pgtable-frag.c~mm-remove-pageactive-fix
+++ a/arch/powerpc/mm/pgtable-frag.c
@@ -136,10 +136,10 @@ void pte_fragment_free(unsigned long *ta
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable)
 {
-	struct page *page;
+	struct folio *folio;
 
-	page = virt_to_page(pgtable);
-	SetPageActive(page);
+	folio = virt_to_folio(pgtable);
+	folio_set_active(folio);
 	pte_fragment_free((unsigned long *)pgtable, 0);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch
mm-memory-failure-add-unmap_posioned_folio-fix.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
mm-remove-pageactive-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

