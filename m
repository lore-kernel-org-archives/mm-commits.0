Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EF013C81B
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745444977; cv=none; b=WfxoVds5Ok5kw92oSrApzNZBWoqmqImk8S/Np1q9LOXzQO6+GAwYbCAqOpxKwlGwwkSxIP1FABz3p07tHq2Avscox4o7aXm4nGVowOi+44sxP5lpJHl79+odhU933BIAE+rGhxe6lPiV5TO5I893cokg4mFMSq26w4VnJpiz6PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745444977; c=relaxed/simple;
	bh=S9EsBUWTseXnWQq0fYms09WqPqCCGomHDvE/i+/qum0=;
	h=Date:To:From:Subject:Message-Id; b=MwO06IfJGgkdpphz9vCdqfKBEFO1LmLwACoietrIBRwEBNAC16UtcFjvnO7yGB4gZkeKS8TUMs9bWLLv3/R4Ng2c19qL/jAP/IAl2GF+Cx0M7uxTf+wiOi+EBvAr5x/E+Hi7Y5RJi0RUxCMGtQ7KYgNdG9AFzi4rRU34Cwvnc9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OX0f/h4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OX0f/h4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FFFC4CEE2;
	Wed, 23 Apr 2025 21:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745444976;
	bh=S9EsBUWTseXnWQq0fYms09WqPqCCGomHDvE/i+/qum0=;
	h=Date:To:From:Subject:From;
	b=OX0f/h4lRSi33G9Kphtvkttkz7f2GduE9uf7ACZR0yA3facZcKewbJdI+hUzrD6YX
	 uk7X8dkwYdFtO4MozYxZ/7WtrPD564YPFa0wU263T+bFl3SypwfQsDA+TPgCLVxlbb
	 X61BzrbQZQZ5Mzan7RP6xhxAmuAvBO9COzJUi+Vc=
Date: Wed, 23 Apr 2025 14:49:36 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch added to mm-new branch
Message-Id: <20250423214936.C5FFFC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, x86: use for_each_valid_pfn() from __ioremap_check_ram()
has been added to the -mm mm-new branch.  Its filename is
     mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch

This patch will later appear in the mm-new branch at
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
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm, x86: use for_each_valid_pfn() from __ioremap_check_ram()
Date: Wed, 23 Apr 2025 14:33:41 +0100

Instead of calling pfn_valid() separately for every single PFN in the
range, use for_each_valid_pfn() and only look at the ones which are.

Link: https://lkml.kernel.org/r/20250423133821.789413-6-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/ioremap.c~mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram
+++ a/arch/x86/mm/ioremap.c
@@ -71,7 +71,7 @@ int ioremap_change_attr(unsigned long va
 static unsigned int __ioremap_check_ram(struct resource *res)
 {
 	unsigned long start_pfn, stop_pfn;
-	unsigned long i;
+	unsigned long pfn;
 
 	if ((res->flags & IORESOURCE_SYSTEM_RAM) != IORESOURCE_SYSTEM_RAM)
 		return 0;
@@ -79,9 +79,8 @@ static unsigned int __ioremap_check_ram(
 	start_pfn = (res->start + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	stop_pfn = (res->end + 1) >> PAGE_SHIFT;
 	if (stop_pfn > start_pfn) {
-		for (i = 0; i < (stop_pfn - start_pfn); ++i)
-			if (pfn_valid(start_pfn + i) &&
-			    !PageReserved(pfn_to_page(start_pfn + i)))
+		for_each_valid_pfn(pfn, start_pfn, stop_pfn)
+			if (!PageReserved(pfn_to_page(pfn)))
 				return IORES_MAP_SYSTEM_RAM;
 	}
 
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are

mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch
mm-implement-for_each_valid_pfn-for-config_flatmem.patch
mm-implement-for_each_valid_pfn-for-config_sparsemem.patch
mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch
mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch
mm-use-for_each_valid_pfn-in-memory_hotplug.patch
mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

