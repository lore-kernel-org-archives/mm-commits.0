Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9CF56773
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970525; cv=none; b=r4cTXh5zGXRnSsgEb154a7cY1ASJHPunbWn2SavQi+HeBxWwXjB0e1riIr2mASraQ505YSrXDtldibbQHttbKedo3hugQBcTJWtRBin5RXUEDM8vKKcUVyjS+0nNdUKFCfr2P48qipaEvQ6BdLUTEgArQi+J/iz6skHfSfmNhz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970525; c=relaxed/simple;
	bh=qQMTXrs7u5d2h2zCTlXFxzn7pE46kAD1GlSFvwjn4sw=;
	h=Date:To:From:Subject:Message-Id; b=ed0SVg6YdFAKYU+iQ8Em3BIVmMdB9t7O3BG93EMcEDVMlQyaZBIG7Z+TyZCSwyC7B/pGy9OkwUUJa4ecnu7lHj8yJQSH1EtIjtS2eSINDNrHXoKeOrjSu15Wc+ioiELTyUu2Q0Kbi0dogj/xSOc7vpx24GFTzeL9BFSdmHoxmbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MRKmFxjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MRKmFxjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C96C433F1;
	Tue, 23 Jan 2024 00:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970525;
	bh=qQMTXrs7u5d2h2zCTlXFxzn7pE46kAD1GlSFvwjn4sw=;
	h=Date:To:From:Subject:From;
	b=MRKmFxjX5t7vN+2G7iTC0qBS9wZRMPDvcg2KJTwwG5Lg5UQ7gRucyJJwmLroAuzeA
	 I/BCaQuKTr9jC7453ZBI+8UVAxa4cKiQ09ugMbvM0CHyNzIBuSCx2YDvXNNcpgXpkf
	 FxS0qrMS7UWzKvR7v5sq744BkpB0EDj5nEbG5/Jo=
Date: Mon, 22 Jan 2024 16:42:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-fix-folio_set_dirty-vs-folio_mark_dirty-in-zap_pte_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20240123004204.E3C96C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: fix folio_set_dirty() vs. folio_mark_dirty() in zap_pte_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-fix-folio_set_dirty-vs-folio_mark_dirty-in-zap_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-fix-folio_set_dirty-vs-folio_mark_dirty-in-zap_pte_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: fix folio_set_dirty() vs. folio_mark_dirty() in zap_pte_range()
Date: Mon, 22 Jan 2024 18:17:51 +0100

The correct folio replacement for "set_page_dirty()" is
"folio_mark_dirty()", not "folio_set_dirty()".  Using the latter won't
properly inform the FS using the dirty_folio() callback.

This has been found by code inspection, but likely this can result in some
real trouble when zapping dirty PTEs that point at clean pagecache folios.

Link: https://lkml.kernel.org/r/20240122171751.272074-1-david@redhat.com
Fixes: c46265030b0f ("mm/memory: page_remove_rmap() -> folio_remove_rmap_pte()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lkml.kernel.org/r/2445cedb-61fb-422c-8bfb-caf0a2beed62@arm.com
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-folio_set_dirty-vs-folio_mark_dirty-in-zap_pte_range
+++ a/mm/memory.c
@@ -1464,7 +1464,7 @@ static unsigned long zap_pte_range(struc
 			delay_rmap = 0;
 			if (!folio_test_anon(folio)) {
 				if (pte_dirty(ptent)) {
-					folio_set_dirty(folio);
+					folio_mark_dirty(folio);
 					if (tlb_delay_rmap(tlb)) {
 						delay_rmap = 1;
 						force_flush = 1;
_

Patches currently in -mm which might be from david@redhat.com are

uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch
mm-huge_memory-fix-folio_set_dirty-vs-folio_mark_dirty.patch
mm-memory-fix-folio_set_dirty-vs-folio_mark_dirty-in-zap_pte_range.patch
arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
risc-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

