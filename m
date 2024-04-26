Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F57E757F8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101888; cv=none; b=VtQ5rCmLgkuAsucJlTEVdvXIzUz9a4M7woU4zO1wAY7EloYGsf2D+q3IgAuNXArDRLbq/YJjP+0GUBN7pjKjuu1XfsrHi/dCiq63r8Neh9Q9JSfOs1XhpbhBqqd+mRa1ORt/ILtzREE4efKf/uas+RX6e+Zv4dHnGSbA8GQVhbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101888; c=relaxed/simple;
	bh=R52UKPOtiOfiynDMbn3Z/q1bC0uRI92KQuxUKqCLLM0=;
	h=Date:To:From:Subject:Message-Id; b=hIvJP+eXGy638o0ABd+4HCr3Ixtovek/TN0BC04bFiSD+UmMc/tabk3M4CunZoS6tX6PCRxqHZMEYpkF58uLKLvH0bDkWeqnAJLTzyhDBdXH90rUx3Y7qSvJvS2ELZqEnUG5mTDyiAZdzgEYMf/QewuOA9XxsGG4Ss5BdkmUFDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W8f7gXL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W8f7gXL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14256C113CD;
	Fri, 26 Apr 2024 03:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101888;
	bh=R52UKPOtiOfiynDMbn3Z/q1bC0uRI92KQuxUKqCLLM0=;
	h=Date:To:From:Subject:From;
	b=W8f7gXL5VVgZuMfm9RUqmyGL3gsbhhQUQCYuwcl64DlYSS+vzo3JR+r3kguHQXG+R
	 7NikVJCRyNpaENUimiQhHMOKmUO9VkWnwW2NUxAQ5b/i/Hho+h8PY+8tAggRpJBG4X
	 4qwzn+FdMAJwfiOehSq9oLeVZP4ctcovP6scN+SE=
Date: Thu, 25 Apr 2024 20:24:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,naresh.kamboju@linaro.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch removed from -mm tree
Message-Id: <20240426032448.14256C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh-remove-use-of-pg_arch_1-on-individual-pages-fix
has been removed from the -mm tree.  Its filename was
     sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch

This patch was dropped because it was folded into sh-remove-use-of-pg_arch_1-on-individual-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sh-remove-use-of-pg_arch_1-on-individual-pages-fix
Date: Thu Mar 28 11:44:56 AM PDT 2024

fix folio_flags call

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/cache-sh4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/mm/cache-sh4.c~sh-remove-use-of-pg_arch_1-on-individual-pages-fix
+++ a/arch/sh/mm/cache-sh4.c
@@ -247,7 +247,7 @@ static void sh4_flush_cache_page(void *a
 		 * another ASID than the current one.
 		 */
 		map_coherent = (current_cpu_data.dcache.n_aliases &&
-			test_bit(PG_dcache_clean, folio_flags(folio)) &&
+			test_bit(PG_dcache_clean, folio_flags(folio, 0)) &&
 			page_mapped(page));
 		if (map_coherent)
 			vaddr = kmap_coherent(page, address);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sh-remove-use-of-pg_arch_1-on-individual-pages.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

