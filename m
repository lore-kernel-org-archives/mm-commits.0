Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDB33939AE
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 17:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768586359; cv=none; b=nZMjl0ijpfFyzn/0Fto7/uTMAUp7Rh9tqt1Abm1X47+SZwEQaZwRAOX02iH0I3ft8q2rLenMf+y0uK8YWtU7Vpv7mCBIO/i2H+qJzIkMBnuEqSSndXyobFhAUGuZ3PrdlojAodUoAy4H9irmuXnpyBtc24HMkI+pTMvq0ptRqNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768586359; c=relaxed/simple;
	bh=NbTKBaVjXjTpAE5JEYasiuH7x0pxj6Yn48AJuuvuNpU=;
	h=Date:To:From:Subject:Message-Id; b=DMmG7x1NTnzZ+p1QPn6RyHBIMvFRZKRmb1ncULH/m60iKtR5g4eBRw9eI5DENRtPZPK3eknpW/5GIn5YQTY03UW2aZKkL9NJG0Bv0DUzqxBq9XEXdnCzcnllW6mVbBxk2QwrT5UMFgogbAqpoboMA2IzR0F8fdj2F+e77TIt1og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QguQ0rwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QguQ0rwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AF8C116C6;
	Fri, 16 Jan 2026 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768586358;
	bh=NbTKBaVjXjTpAE5JEYasiuH7x0pxj6Yn48AJuuvuNpU=;
	h=Date:To:From:Subject:From;
	b=QguQ0rwtPCYbpRzhswz1vMe1FK25c/oQFe8xDSdCFg6HUxDn81+VzL5u7eSwUF2eB
	 b/5i5gGunxxDQNhbCYnKFM2/wNCkBdyif1Et5QRU5rgMoHYdDg87PnPBmubkqzYQi5
	 pDvAn6xQpEzSYosPISpYAI5yThh1fzpFB2g6bL/Q=
Date: Fri, 16 Jan 2026 09:59:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-support-batched-unmapping-for-file-large-folios-fix.patch added to mm-unstable branch
Message-Id: <20260116175918.D5AF8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rmap: skip batched unmapping for UFFD vmas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-support-batched-unmapping-for-file-large-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-support-batched-unmapping-for-file-large-folios-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: skip batched unmapping for UFFD vmas
Date: Sat, 17 Jan 2026 00:26:52 +0800

As Dev reported[1], it's not ready to support batched unmapping for uffd
case.  Let's still fallback to per-page unmapping for the uffd case.

Link: https://lkml.kernel.org/r/20260116162652.176054-1-baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Dev Jain <dev.jain@arm.com>
Closes: https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.com/ [1]
Suggested-by: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/rmap.c~mm-rmap-support-batched-unmapping-for-file-large-folios-fix
+++ a/mm/rmap.c
@@ -1953,6 +1953,9 @@ static inline unsigned int folio_unmap_p
 	if (pte_unused(pte))
 		return 1;
 
+	if (userfaultfd_wp(vma))
+		return 1;
+
 	return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch
arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch
arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch
arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch
mm-rmap-support-batched-unmapping-for-file-large-folios.patch
mm-rmap-support-batched-unmapping-for-file-large-folios-fix.patch

