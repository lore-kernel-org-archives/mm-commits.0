Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4ED13C81B
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745444973; cv=none; b=r1QUk4WSoGDDJxZi7DzR/PsI6Yb8zCFbo9cXEO4z9i7p4y4+hGX2f3eyDGW+8VA+V9DiwfdgByGu+cfwHUNSfV2332zw/Nw/8Cmk4sF5OEGfMeJG/ltBtShj8n6n8pSzeiSkhMf4KbpobeSxgsl3kDXmdOwtowsfXz46mliLTZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745444973; c=relaxed/simple;
	bh=6jLIkHoJ+alNstSNnahk9DxYVhczAbLSFEzqiRum3bA=;
	h=Date:To:From:Subject:Message-Id; b=jN5atICtQj/WzQi/CFCDsihNihIovjHLYiHWNU8odMOXDlFYYbhKvjzRRy17zojBORC82mLT8vDvjzqbnkGvo59xEj8GwHo/u7qJEcSz/CZo+4PzTFFh4JJ2+iWtNGEcENiL2H3LjpSTGIOKOleFu4NxaLtdIsBH6MvfNfdK0l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yEYWqGJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yEYWqGJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E78C4CEE2;
	Wed, 23 Apr 2025 21:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745444972;
	bh=6jLIkHoJ+alNstSNnahk9DxYVhczAbLSFEzqiRum3bA=;
	h=Date:To:From:Subject:From;
	b=yEYWqGJs3Z4DC8QfsBYdrwNySuAchdou9Z71w/plcVlVbUdok4zEd3vWwj8ovW8Lh
	 epkysLqwdcZWW1FvRYllSZd6bKHfbFG/QAuentMEtOB/AcHUESXhsgrzatQ0C2nHDF
	 SyHc3spNIS06hbX/W+QiUPIL7bXbkKA8E0mB2Xe4=
Date: Wed, 23 Apr 2025 14:49:31 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-implement-for_each_valid_pfn-for-config_flatmem.patch added to mm-new branch
Message-Id: <20250423214932.67E78C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: implement for_each_valid_pfn() for CONFIG_FLATMEM
has been added to the -mm mm-new branch.  Its filename is
     mm-implement-for_each_valid_pfn-for-config_flatmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-implement-for_each_valid_pfn-for-config_flatmem.patch

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
Subject: mm: implement for_each_valid_pfn() for CONFIG_FLATMEM
Date: Wed, 23 Apr 2025 14:33:38 +0100

In the FLATMEM case, the default pfn_valid() just checks that the PFN is
within the range [ ARCH_PFN_OFFSET ..  ARCH_PFN_OFFSET + max_mapnr ).

The for_each_valid_pfn() function can therefore be a simple for() loop
using those as min/max respectively.

Link: https://lkml.kernel.org/r/20250423133821.789413-3-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

 include/asm-generic/memory_model.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/include/asm-generic/memory_model.h~mm-implement-for_each_valid_pfn-for-config_flatmem
+++ a/include/asm-generic/memory_model.h
@@ -30,7 +30,15 @@ static inline int pfn_valid(unsigned lon
 	return pfn >= pfn_offset && (pfn - pfn_offset) < max_mapnr;
 }
 #define pfn_valid pfn_valid
-#endif
+
+#ifndef for_each_valid_pfn
+#define for_each_valid_pfn(pfn, start_pfn, end_pfn)			 \
+	for ((pfn) = max_t(unsigned long, (start_pfn), ARCH_PFN_OFFSET); \
+	     (pfn) < min_t(unsigned long, (end_pfn),			 \
+			   ARCH_PFN_OFFSET + max_mapnr);		 \
+	     (pfn)++)
+#endif /* for_each_valid_pfn */
+#endif /* valid_pfn */
 
 #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
 
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are

mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch
mm-implement-for_each_valid_pfn-for-config_flatmem.patch
mm-implement-for_each_valid_pfn-for-config_sparsemem.patch
mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch
mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch
mm-use-for_each_valid_pfn-in-memory_hotplug.patch
mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

