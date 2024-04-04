Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9027C134435
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 20:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712261950; cv=none; b=djVBbDxVvbyispfQp7vOMhA/ntoBjAKG2+n5i27XLG3qRrf0JVG/2c2cvypZ15zgJUIqFgGpjZYBLTOU6b0Quy6BlkLkPIbvT29yshs9IyeN7WS8jzfbztNEeuoOCyMiKZvpCtxJrt9Jd6gSTo9uVaBg60SUoVTCErB3NUElxNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712261950; c=relaxed/simple;
	bh=YjlmAhTahAxYep7XeM85NI/N6BseL5HIhB3ogfRLxa4=;
	h=Date:To:From:Subject:Message-Id; b=iwVA6AvXRHPbxhHWS9Stg0LjipWHXaJdcrH8S9NFwApRPoAc4viV5e4T5Wu/1dtXxesobjav7iudfyzzf9+ph1Baxph1pTQPy3Na+e4U8J86RrpIuFyU8L7Le2CsT2wFF41t2SFPOfYx5ANHkA4FSe44ijQAt6e4iLfsqCubDec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=161MSoSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="161MSoSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E28AC433C7;
	Thu,  4 Apr 2024 20:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712261949;
	bh=YjlmAhTahAxYep7XeM85NI/N6BseL5HIhB3ogfRLxa4=;
	h=Date:To:From:Subject:From;
	b=161MSoSkQhr+ACAxs8r9atXC43G6g57bn7H9MOYTTi/k+pZeYiOjsj075quAT18VI
	 A2f1nkvKlbUXQIGxlvISWu8rtmFh88sFneGznrBIK2i7ca9zfFzNPXGqjNwQbDe4O1
	 tdaocdU5JFb7+z/WOm9gHlGO5YFYBO+nK//YBKk4=
Date: Thu, 04 Apr 2024 13:19:08 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,m.szyprowski@samsung.com,david@redhat.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem.patch added to mm-unstable branch
Message-Id: <20240404201909.0E28AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: drop incorrect alignment check in cma_init_reserved_mem
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: drop incorrect alignment check in cma_init_reserved_mem
Date: Thu, 4 Apr 2024 16:25:14 +0000

cma_init_reserved_mem uses IS_ALIGNED to check if the size represented by
one bit in the cma allocation bitmask is aligned with
CMA_MIN_ALIGNMENT_BYTES (pageblock size).

However, this is too strict, as this will fail if order_per_bit >
pageblock_order, which is a valid configuration.

We could check IS_ALIGNED both ways, but since both numbers are powers of
two, no check is needed at all.

Link: https://lkml.kernel.org/r/20240404162515.527802-1-fvdl@google.com
Fixes: de9e14eebf33 ("drivers: dma-contiguous: add initialization from device tree")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/cma.c~mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem
+++ a/mm/cma.c
@@ -182,10 +182,6 @@ int __init cma_init_reserved_mem(phys_ad
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
-	/* alignment should be aligned with order_per_bit */
-	if (!IS_ALIGNED(CMA_MIN_ALIGNMENT_PAGES, 1 << order_per_bit))
-		return -EINVAL;
-
 	/* ensure minimal alignment required by mm core */
 	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
 		return -EINVAL;
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem.patch
mm-hugetlb-pass-correct-order_per_bit-to-cma_declare_contiguous_nid.patch

