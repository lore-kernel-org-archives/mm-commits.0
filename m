Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794207844;
	b=Ai4t5euhRqUv8uo/dzYyRMEn79xXevFymO5/CGC0Zt3HQq/HFVEs5A9FTN1oKCu+kpDf
	 I+I6XRzP0dJ2wluzhf7RzyYrZ8B4sb7SxECM8pYGjsVAzduvPSQUncjWe2mwKxJtlhc3A
	 LXsBzsN9yL/RpUk+sUnyNhe/HXQqPDvZChVptjUvspLnLWzCwwJHj7YNU0s570slA7WlI
	 ZZGPcQwisUYDRed4YAMC5F5UJ8iOMLjbvqRKqZGcd1HDWQtcQIv7GA+HXw4sK4P/Wnp+t
	 GX1UxZEjuZ4QR+ldFptFzi7LgwdLvi3SluaWGzS2VPQcMJRznNdd7Cjz4ID913PKQ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207844;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JmGFnBejPbYUWcsHzT78VJ8j5FBvs4hbpnoNoOD6BgI=;
	b=Jjjveoz8kUo7jEYnm3VFQdEvCyPegzlzC38Pcg8kBXdHe1QDubocmyYhCOYYWCv9KD8W
	 NkIoDbtZ5crPmpYBZgK0DnRFXKsqV9kBZItRcRY7mTvUcHjUB3s9eTZW11EPAjjjU347y
	 ArtfogeeG0mebnwXCnCpe04scwNNChBbrRQrgdvgGsqYsH8YxVuCUFRnd3zq2k6oEIOrZ
	 LNoPtDUrdSDJUOYEAZbL2TZoFr3fWkTBe/loU85vgglQhytjm/k3m4gORFKK1MruMrfyh
	 j4lJ7vj8pSvyQCqr7MiHcHWmqahfr1XUF3p+Fcc5Q6aU/k8sQ+JJ5A+/O6gvGsgQSXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1PhKPQMJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C926606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 07:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1PhKPQMJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3361F0089F;
	Mon,  9 Nov 2026 07:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794207843;
	bh=JmGFnBejPbYUWcsHzT78VJ8j5FBvs4hbpnoNoOD6BgI=;
	h=Date:To:From:Subject;
	b=1PhKPQMJpEWtBD0ElI7Nt4S60PbC1OXxAuRM2MmB9/CruCESNPumvS1iB4kCVgu3z
	 /HS7yWOByyiDZUm7xV3PmzDAJRdAshaNz90yv76vvSHLssYKLWPCaNMznAgARi1mRT
	 jPJOAby6LNr2ZVEJCdUAd7xYJdIQz3J0qQMLA8Ow=
Date: Sun, 08 Nov 2026 23:04:03 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,
	jiangwenxiaomi@gmail.com,dev.jain@arm.com,david@kernel.org,
	chleroy@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,
	anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,jiangwen6@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush.patch added to mm-new branch
Message-Id: <20261109070403.AD3361F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: arm64/hugetlb: drop the init_mm special case in clear_flush()
has been added to the -mm mm-new branch.  Its filename is
     arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Wen Jiang <jiangwen6@xiaomi.com>
Subject: arm64/hugetlb: drop the init_mm special case in clear_flush()
Date: Sat, 07 Nov 2026 21:49:47 +0800

clear_flush() calls flush_tlb_kernel_range() when mm is &init_mm. This
was added by commit 06fc959fcff7 ("arm64/mm: Support huge pte-mapped
pages in vmap") because vmap called set_huge_pte_at(&init_mm, ...).

Now that vmap uses vmap_pte_set_huge()/vmap_pte_clear_huge(),
mm/vmalloc.c is no longer a caller of set_huge_pte_at() on arm64. The
only remaining callers passing &init_mm are in arch/powerpc, which uses
its own implementation. Remove the dead branch.

No functional change.

Link: https://lore.kernel.org/20261107134953.748622-5-jiangwenxiaomi@gmail.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <leo.yan@arm.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Donnellan <andrew+kernel@donnellan.id.au>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
---

 arch/arm64/mm/hugetlbpage.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -206,10 +206,7 @@ static void clear_flush(struct mm_struct
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
 		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
-	if (mm == &init_mm)
-		flush_tlb_kernel_range(saddr, addr);
-	else
-		__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
+	__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
 }
 
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
_

Patches currently in -mm which might be from jiangwen6@xiaomi.com are

arm64-mm-add-vmap_pte_set_huge-and-vmap_pte_clear_huge.patch
powerpc-8xx-add-vmap_pte_set_huge.patch
mm-vmalloc-use-vmap_pte_set_huge-vmap_pte_clear_huge-for-pte-level-block-mappings.patch
arm64-hugetlb-drop-the-init_mm-special-case-in-clear_flush.patch
mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch
mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

