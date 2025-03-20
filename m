Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AAA20FA85
	for <mm-commits@vger.kernel.org>; Thu, 20 Mar 2025 21:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742504488; cv=none; b=YzhyyawrvW3R46sQCxep9Sl2UIFvAdh0xbBpN22Nbp+rOBWuuiSIk+Upkp9UdgW5By5BJmhAAumdGNzGCumA0uoZdDTqkA9BwPzhjM/dagyejlEo592oHQPIiRB2u12aFO7kiEk8fkLNE7wgjcOE717WQgwbzNdb5PFewy9tKm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742504488; c=relaxed/simple;
	bh=X+CAedc6LhD+1t5Xpb0me89d+V0qQ5abVquass1DS24=;
	h=Date:To:From:Subject:Message-Id; b=XLS29S3k/RO6QefTlaHStsK/TUWVi6Gc4lx1zeMf049v2X54VOw1XaSAcGZTkIcs9Cwv1pF5kGO33Y5N3uP0hULPpKV/Oja2PBcFqxv+w78HZJgPg1+8li27FkcSi14qni9JewAimG09O5bUGKWFE6KatVZf2erkaO8Cq9lLPEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qCkzdsV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qCkzdsV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC7AC4CEDD;
	Thu, 20 Mar 2025 21:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742504487;
	bh=X+CAedc6LhD+1t5Xpb0me89d+V0qQ5abVquass1DS24=;
	h=Date:To:From:Subject:From;
	b=qCkzdsV3sXoorAYjYk6UIPFcmZYoXEarZajrCDnM6ADw54sHy4C6Ozo31ukV8bgGj
	 CyIFRcZzxUuTFRMCjvYL8XaXYYWBohwD+4DiuHPwQ2Nyj04W4KuxVf5Ddmfv2j5lXV
	 uQShcxK3SXbRH+KxRRUoC+ILVYYyoBw7LtHxR4Ow=
Date: Thu, 20 Mar 2025 14:01:25 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,kbusch@kernel.org,ddutile@redhat.com,catalin.marinas@arm.com,alex.williamson@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arm64-drop-dead-code-for-pud-special-bit-handling.patch added to mm-unstable branch
Message-Id: <20250320210127.1BC7AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/arm64: drop dead code for pud special bit handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-arm64-drop-dead-code-for-pud-special-bit-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arm64-drop-dead-code-for-pud-special-bit-handling.patch

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
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>
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
mm-arm64-drop-dead-code-for-pud-special-bit-handling.patch

