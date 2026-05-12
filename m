Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2287734C9A6
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620659; cv=none; b=JKMTxTyVTj9hOPXWSGxyQygVQ9W9UD6vka4+ThCcjBc5xd6v0iePmHAvwNlv68Rqp/i/f87/q/Mtrx77In/H6f/yPbbyDXU2Zek7IGlLJNPWYL6+MJPTNd+KNCnf/85o4r1Kg2HvnFDj8AYPAuivVey41r2ld/mGTItibbEPh1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620659; c=relaxed/simple;
	bh=xyF0TMI4xIlj/c2KuZd75mxkks1Sl+ffeFY+s0hRqlI=;
	h=Date:To:From:Subject:Message-Id; b=ihtAmzKKBJQiCuB4wE1fPgnMhmSSR6Z7eP2vE2+HAohw6hv+a7syG2BFic+b94LD4Bao+uS7GiwctApXn7RmWrn9LrtS1I105diA+sHkj54EavPk/tdaYEXwiX3VtvzEJJDVCi+rv6BOyrnb7n9ERfj5MTQn0U/3L1qdCOqgfJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=btR8AVN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="btR8AVN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE45C2BCB0;
	Tue, 12 May 2026 21:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778620658;
	bh=xyF0TMI4xIlj/c2KuZd75mxkks1Sl+ffeFY+s0hRqlI=;
	h=Date:To:From:Subject:From;
	b=btR8AVN69TCRFOL7F4ssAL5wC80Yqfm7hwL2UtrXpC0G1UJZNV9glNbhKCa/Ep9d5
	 0i1a+ObMivae7s12eEVZy8ADMnmWSovZ6d+RDfnFxgFCCwwhBWJau2prx4i+S6RgIm
	 6v9qsCE5kCHrkyNkCmdZtlSWTCQdVYdR3x6VV6IE=
Date: Tue, 12 May 2026 14:17:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch added to mm-new branch
Message-Id: <20260512211738.BEE45C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/bootmem_info: remove call to kmemleak_free_part_phys()
has been added to the -mm mm-new branch.  Its filename is
     mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: remove call to kmemleak_free_part_phys()
Date: Mon, 11 May 2026 16:05:32 +0200

The call to kmemleak_free_part_phys() was added in 2022 in
commit dd0ff4d12dd2 ("bootmem: remove the vmemmap pages from kmemleak in
put_page_bootmem").

In 2025, commit b2aad24b5333 ("mm/memmap: prevent double scanning of memmap
by kmemleak") started to use MEMBLOCK_ALLOC_NOLEAKTRACE when allocating
the memmap to skip the kmemleak_alloc_phys() in the buddy.

So remove the call to kmemleak_free_part_phys(). If this would still
be required for other purposes, either free_reserved_page() should take
care of it, or selected users.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem_info.h |    1 -
 mm/bootmem_info.c            |    1 -
 2 files changed, 2 deletions(-)

--- a/include/linux/bootmem_info.h~mm-bootmem_info-remove-call-to-kmemleak_free_part_phys
+++ a/include/linux/bootmem_info.h
@@ -82,7 +82,6 @@ static inline void get_page_bootmem(unsi
 
 static inline void free_bootmem_page(struct page *page)
 {
-	kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 	free_reserved_page(page);
 }
 #endif
--- a/mm/bootmem_info.c~mm-bootmem_info-remove-call-to-kmemleak_free_part_phys
+++ a/mm/bootmem_info.c
@@ -32,7 +32,6 @@ void put_page_bootmem(struct page *page)
 
 	if (page_ref_dec_return(page) == 1) {
 		set_page_private(page, 0);
-		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 		free_reserved_page(page);
 	}
 }
_

Patches currently in -mm which might be from david@kernel.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch
mm-fix-__vm_normal_page-to-handle-missing-support-for-pmd_special-pud_special.patch
sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch
sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

