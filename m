Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FF6297A49
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 23:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745624296; cv=none; b=Dlikp/TiyNCD7wcHRj2lpCVwMbmIPNGd9UcpOlDxdxXHPr2pxUFojzQlvhAtIu0IFE8QzbPRNcSeG/M2t7eHw+izzhtk2AQOOAI4U670OhGFO4TVe5IJyvdn+6XP0EWfRykeMzzeE6bIJUAQigtWYTr4ZDMPEQJ421zoYN5o8+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745624296; c=relaxed/simple;
	bh=Lag8B1w5kFN2SinSknEl4UtjescDux2PuJ+x9kvCLnU=;
	h=Date:To:From:Subject:Message-Id; b=U6wCFsODtwNOeo2g2EIAub3J+PkG49PYIpnBL+nznEQaRihKkRGbAC45s6a39/G0U1/nzL2TmuyvZbGt3O471tnTpTyyPEA4NEk13Pwo4NcgdtJzGUf6a7FCoVtn25fXHzmgjeIKiSiI+bPRrZPXSFV0/Xp+HTA0osCvmHfhW5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FmGvAWd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FmGvAWd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143A1C4CEEB;
	Fri, 25 Apr 2025 23:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745624296;
	bh=Lag8B1w5kFN2SinSknEl4UtjescDux2PuJ+x9kvCLnU=;
	h=Date:To:From:Subject:From;
	b=FmGvAWd4iKpBy1CgviKPaFXqnBxFjnCUn1W+/36+wLWBrhYbVnru09rSblJmKXLAK
	 nzqJW3JDMnW8IXxxCLvbK8ZxCBnEoCztp52LQQNWOVD0lVosPJlN+K5LgI1Rpjj9b7
	 h/mKps9Hb62imQpLXJWr4fIVFOJ0EOeAVZmsfPfY=
Date: Fri, 25 Apr 2025 16:38:15 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,lorenzo.stoakes@oracle.com,dwmw@amazon.co.uk,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw2@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range-fix.patch added to mm-new branch
Message-Id: <20250425233816.143A1C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Woodhouse <dwmw2@infradead.org>
Subject: mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range-fix
Date: Sat, 26 Apr 2025 00:04:46 +0100

fix next_valid_pfn() for sparsemem

Link: https://lkml.kernel.org/r/c15100fcf6781a60b852c4dbb43bdc98a678fcf0.camel@infradead.org
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range-fix
+++ a/include/linux/mmzone.h
@@ -2190,10 +2190,10 @@ static inline unsigned long next_valid_p
 	/*
 	 * Either every PFN within the section (or subsection for VMEMMAP) is
 	 * valid, or none of them are. So there's no point repeating the check
-	 * for every PFN; only call first_valid_pfn() the first time, and when
-	 * crossing a (sub)section boundary (i.e. !(pfn & ~PFN_VALID_MASK)).
+	 * for every PFN; only call first_valid_pfn() again when crossing a
+	 * (sub)section boundary (i.e. !(pfn & ~PAGE_{SUB,}SECTION_MASK)).
 	 */
-	if (pfn & (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) ?
+	if (pfn & ~(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) ?
 		   PAGE_SUBSECTION_MASK : PAGE_SECTION_MASK))
 		return pfn;
 
_

Patches currently in -mm which might be from dwmw2@infradead.org are

mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range-fix.patch

