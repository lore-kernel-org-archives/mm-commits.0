Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D38EBE
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100589; cv=none; b=lyxMKGDGBvVhynEXOar5UW8f3bwquGqrscfpsAxMBGgRCfLk37xCVwwz5abV8+QQbflxQUVSnkChK4ajnD0jak93SEvwo0oxH+nwvz6UO/KDqvz+0uqCJMvzr4unCYISL9smKmc7RRKBxkVIqc9OKy/H7jSk69K/HtSa/PYmijU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100589; c=relaxed/simple;
	bh=SXeTIufNkqjtuMBubRAkCEVLPnkp6tW8ZEQIN3nOSZE=;
	h=Date:To:From:Subject:Message-Id; b=BFj02zV46j0mrniraQ8KM25TWTaoggML1D8cSumDk5ojOlgrVjMVxlG1iXP9QhoknGx1ZNy6gS+XTpi1Z0rErG7p1CEhS5fmzAcC/BSMCTDrFqpbSx/ToYencrwiplcBP3jccebtuLk/V+1LhTvRBd/pb0hTnDYw6l7RJgGDUN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPxWgzIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPxWgzIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C91EC113CC;
	Fri, 26 Apr 2024 03:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100588;
	bh=SXeTIufNkqjtuMBubRAkCEVLPnkp6tW8ZEQIN3nOSZE=;
	h=Date:To:From:Subject:From;
	b=sPxWgzInwqpNHOtv7CwNekpvRMgKX6oRUVbfVZPu6R61kO0+HXNhVU09nd/t1kdFo
	 glV5Z3wgvcgE+Q4VmGmQ1TkLKR7a0SCz+Nzji2BTxNEBqaZN+WzGbSug1cbZckkkxx
	 X3+Kd00HHVo+PsjrzZuKntJuPaClYDTPZJ2I0Fl0=
Date: Thu, 25 Apr 2024 20:03:07 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch removed from -mm tree
Message-Id: <20240426030308.5C91EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix
has been removed from the -mm tree.  Its filename was
     mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch

This patch was dropped because it was folded into mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix
Date: Tue Mar 19 02:14:43 PM PDT 2024

s/;;/;/, per Muchun

Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/mm/hugetlbpage.c~mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -409,7 +409,7 @@ pte_t huge_ptep_get_and_clear(struct mm_
 
 int pmd_huge(pmd_t pmd)
 {
-	return pmd_leaf(pmd);;
+	return pmd_leaf(pmd);
 }
 
 int pud_huge(pud_t pud)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

