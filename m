Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E9833F3
	for <mm-commits@vger.kernel.org>; Mon, 31 Mar 2025 01:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743384093; cv=none; b=DwUMhOomKD+a2pYL7TPvwcug+gEK5jj/hmfOsX9xuKymZoqr4cxINRGYVGmnAKQBFnVzS+hOW7CNaXF2J6oYlK9BhF8ikWPFi6YsfKPhKnNOpXXmzkw+Vtk9gYpNZvdQxHa4/sj62AWzMypsU5OxoGYeuaSKIcc2eOQaz6LULf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743384093; c=relaxed/simple;
	bh=aj7tkN2M9AJae5sXmqysbkRhSrooddf+s1pIoA2ZufA=;
	h=Date:To:From:Subject:Message-Id; b=AD+B/LGWwbp3TrbuuEcjz9KmbNbSr3w36daGTvD6EdlZimMZNSbMavgD1npiAbb9pD0mjHZ4l9dVnPcAzQsI71IIcYNh9wzh60GzWCBtbOvVxmeOCnh+sD7A12J/r01cQ2GKkySA0r1DOwZchc33737P/KwAv2alYJVUI3ZcHUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x1zjSp9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x1zjSp9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A7FC4CEDD;
	Mon, 31 Mar 2025 01:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743384091;
	bh=aj7tkN2M9AJae5sXmqysbkRhSrooddf+s1pIoA2ZufA=;
	h=Date:To:From:Subject:From;
	b=x1zjSp9hpjrznM2cc7TJpGeUooPf55jhGyBoW2a4R0UD2Lhfa0FNaAr+RVazHpXnl
	 0VhvIrbFFaQF8LaylZ+kagHIZ3JvDYUe/nRjHUnlSs/GVoMLM29R4Lflrz8wWP8Z44
	 4rKc+hYKKGxlyL9vZWLGw9xH3PNzJvHSi507IXfc=
Date: Sun, 30 Mar 2025 18:21:30 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,kbusch@kernel.org,ddutile@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,alex.williamson@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-arm64-drop-dead-code-for-pud-special-bit-handling.patch removed from -mm tree
Message-Id: <20250331012131.37A7FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/arm64: drop dead code for pud special bit handling
has been removed from the -mm tree.  Its filename was
     mm-arm64-drop-dead-code-for-pud-special-bit-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/arm64: drop dead code for pud special bit handling
Date: Thu, 20 Mar 2025 14:34:05 -0400

Keith Busch observed some incorrect macros defined in arm64 code [1].

It turns out the two lines should never be needed and won't be exposed to
anyone, because aarch64 doesn't select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD,
hence ARCH_SUPPORTS_PUD_PFNMAP is always N.  The only archs that support
THP PUDs so far are x86 and powerpc.

Instead of fixing the lines (with no way to test it..), remove the two
lines that are in reality dead code, to avoid confusing readers.

Fixes tag is attached to reflect where the wrong macros were introduced,
but explicitly not copying stable, because there's no real issue to be
fixed.  So it's only about removing the dead code so far.

[1] https://lore.kernel.org/all/Z9tDjOk-JdV_fCY4@kbusch-mbp.dhcp.thefacebook.com/#t

Link: https://lkml.kernel.org/r/20250320183405.12659-1-peterx@redhat.com
Fixes: 3e509c9b03f9 ("mm/arm64: support large pfn mappings")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-arm64-drop-dead-code-for-pud-special-bit-handling
+++ a/arch/arm64/include/asm/pgtable.h
@@ -620,11 +620,6 @@ static inline pmd_t pmd_mkspecial(pmd_t
 #define pud_pfn(pud)		((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT)
 #define pfn_pud(pfn,prot)	__pud(__phys_to_pud_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
-#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-#define pud_special(pte)	pte_special(pud_pte(pud))
-#define pud_mkspecial(pte)	pte_pud(pte_mkspecial(pud_pte(pud)))
-#endif
-
 #define pmd_pgprot pmd_pgprot
 static inline pgprot_t pmd_pgprot(pmd_t pmd)
 {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-fix-release-hang-over-concurrent-gup.patch
maintainers-add-myself-as-userfaultfd-reviewer.patch

