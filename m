Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016232701D4
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745444980; cv=none; b=ANKXxL+QYQ8fH0jlQhhwxjhZRnwZFKp6TxAyxDuhXnc4gyaUh86uRTKMrg+ZOCMT1QsjTzEZb1MRFkabgEdsX1nA0+ZOeEAfiaL16gf2hFt9j7Q1Wdp4IxjakIaOldeNOWB6AMj7hJVnIf12OXiIyGAF70r/4PHN3JYGF1mcRiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745444980; c=relaxed/simple;
	bh=sywUpqP23pHJAB1PUqDvbNy41W66s7+eaE8juRgvu50=;
	h=Date:To:From:Subject:Message-Id; b=fOCZNIqx1+vX2i2YxKSoUZuJWOf4d95p8KtPQ9IGfh+Oqk42IyZpf45+fJJdpDOrHLmNf25sWnWnu5tpkU2erNQlaPbg6z3nW+HxEh5KI1naWgU6MSFM6CZg8VU438ifk0IW04HkTc15HXco+ltlTcPhVIocU1Tn+eyNCYue77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FLWBtmJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FLWBtmJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50F4C4CEE2;
	Wed, 23 Apr 2025 21:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745444979;
	bh=sywUpqP23pHJAB1PUqDvbNy41W66s7+eaE8juRgvu50=;
	h=Date:To:From:Subject:From;
	b=FLWBtmJuzpXPRLKxy5FZm69hoGSb7/wTsbBWP6SBgXnHP0bQDOdSqNmsg/+vqGFMr
	 3b4hefvV4UwP9I0/zwcGewU7VYMDJTV1PpddbLKwWiOLkcaQx7H/lsheWgj8YP0Kk9
	 htfvzlc1GjeqPn9QQh8J0tlbuUvrABAzNBVmsuns=
Date: Wed, 23 Apr 2025 14:49:39 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch added to mm-new branch
Message-Id: <20250423214939.C50F4C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: use for_each_valid_pfn() in init_unavailable_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

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
Subject: mm/mm_init: use for_each_valid_pfn() in init_unavailable_range()
Date: Wed, 23 Apr 2025 14:33:43 +0100

Currently, memmap_init initializes pfn_hole with 0 instead of
ARCH_PFN_OFFSET. Then init_unavailable_range will start iterating each
page from the page at address zero to the first available page, but it
won't do anything for pages below ARCH_PFN_OFFSET because pfn_valid
won't pass.

If ARCH_PFN_OFFSET is very large (e.g., something like 2^64-2GiB if the
kernel is used as a library and loaded at a very high address), the
pointless iteration for pages below ARCH_PFN_OFFSET will take a very long
time, and the kernel will look stuck at boot time.

Use for_each_valid_pfn() to skip the pointless iterations.

Link: https://lkml.kernel.org/r/20250423133821.789413-8-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reported-by: Ruihan Li <lrh2000@pku.edu.cn>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range
+++ a/mm/mm_init.c
@@ -851,11 +851,7 @@ static void __init init_unavailable_rang
 	unsigned long pfn;
 	u64 pgcnt = 0;
 
-	for (pfn = spfn; pfn < epfn; pfn++) {
-		if (!pfn_valid(pageblock_start_pfn(pfn))) {
-			pfn = pageblock_end_pfn(pfn) - 1;
-			continue;
-		}
+	for_each_valid_pfn(pfn, spfn, epfn) {
 		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
 		__SetPageReserved(pfn_to_page(pfn));
 		pgcnt++;
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are

mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch
mm-implement-for_each_valid_pfn-for-config_flatmem.patch
mm-implement-for_each_valid_pfn-for-config_sparsemem.patch
mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch
mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch
mm-use-for_each_valid_pfn-in-memory_hotplug.patch
mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

