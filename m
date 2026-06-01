Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1FF3DCD9C
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780337826; cv=none; b=Unr+JXcG8i9RqeHf/As4AUaFOFAtq+EjBRiF/Yo6K/VSQcTbK73vQoz+IDqh0Ix6EHrjTnjypLCUQugNtkNEhz9pxaprAyzLe0/0rXj6vwHkrRws5BBthrJbx2eXRBD8X1afqxQtaHhyndU5h1ijl3S72wOqMhJwvJKT3c6UJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780337826; c=relaxed/simple;
	bh=Hg7CXvWRXCakPphfvgNZOsSvFNmgfkmU2fTwKO5oHHE=;
	h=Date:To:From:Subject:Message-Id; b=B52OdrnB8K9c4ESeXiTxcIPvqKkg2ewG7wvOptsG0EHUrplzntbl/tL1mXT8sgGsFjP9QAVe8sX0s88FQ9r4Sc7w2+bfyEs1GTqQSBTBGaDe6egge9K4J+2vE72nmSuj0i6HUaNJEWLMw/Wv4SjOjk2Khyoycp5uvr5K4EPQtWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FTgCIQqN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FTgCIQqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374CF1F00898;
	Mon,  1 Jun 2026 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780337818;
	bh=j9IZaOfn2+hRvhxcvhov6/AyCh8YJ7Jth/ffSfEbfFg=;
	h=Date:To:From:Subject;
	b=FTgCIQqN5dlJZDg6ynZef/8UdmPpnK5oLxe7yl35m7YS/TYsb2IqozU1IRsxOCuKX
	 T9bcwxa6ihK12JryW/ohZ4LsTykDRiPzjwOBT3SDHwkOnRVJw6i7CgeLjQ8fYlMvcf
	 +Q0yHzxCZ6+k3bcetF2XScbAXUXtTD6FojvgbOac=
Date: Mon, 01 Jun 2026 11:16:57 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch added to mm-new branch
Message-Id: <20260601181658.374CF1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: drop vmemmap_pmd helpers and use generic code
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: arm64/mm: drop vmemmap_pmd helpers and use generic code
Date: Mon, 1 Jun 2026 16:48:41 +0800

The generic implementations now suffice; remove the arm64 copies.

Link: https://lore.kernel.org/20260601084845.3792171-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code
+++ a/arch/arm64/mm/mmu.c
@@ -1776,20 +1776,6 @@ static void free_empty_tables(unsigned l
 }
 #endif
 
-void __meminit vmemmap_set_pmd(pmd_t *pmdp, void *p, int node,
-			       unsigned long addr, unsigned long next)
-{
-	pmd_set_huge(pmdp, __pa(p), __pgprot(PROT_SECT_NORMAL));
-}
-
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	vmemmap_verify((pte_t *)pmdp, node, addr, next);
-
-	return pmd_leaf(READ_ONCE(*pmdp));
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch
mm-sparse-vmemmap-provide-generic-vmemmap_set_pmd-and-vmemmap_check_pmd.patch
arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch
riscv-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch
loongarch-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch
sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

