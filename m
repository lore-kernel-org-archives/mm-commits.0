Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3932F50A8E
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970507; cv=none; b=SUmeAqXCThD+zG4voiI7pE7PdslPukD2A3bkiINUm3fr9Tlc7IA9nTQJgXznJeKG72TaRN+k0lNtmiyxWPEQPW/UG9CnkszyZlm730LvTQQZrMq1oZ6tfI4/SrMnfuiNZihBLdMRaGwwkWRZK+8bS2V7/ofQaCaswNYxm5j0W/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970507; c=relaxed/simple;
	bh=B+JjHb7c50q65cRPp3HhZ2tf70AQwXoZxbOVbCbBcpc=;
	h=Date:To:From:Subject:Message-Id; b=U00+zlcWiKrQ2MYwad5cVkzKsUQbMK3XdhUxIMidT2FSApLBfHxcrpIlqlp02ywh5UEFm+O5gCMLmiot/44thrsivgK/arw+EbeTWuMqQlZkrjdNtcubS8K55ri9Tszv1cv7TrzbtC1NP7tBiJe/XEtRYbYhy/v8GUOZ/UG5fAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vdvkYm8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vdvkYm8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933C4C433F1;
	Tue, 23 Jan 2024 00:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970507;
	bh=B+JjHb7c50q65cRPp3HhZ2tf70AQwXoZxbOVbCbBcpc=;
	h=Date:To:From:Subject:From;
	b=vdvkYm8vKAa1roPcxk8zuqDJdPDmoIf3VwnITz+6t3s02zOeH23J/eq39OLitAAWa
	 l9wQvrujTZQzUyqyHskXQ7xHfFhAki+BaA2M0bIoX+OTVdhTw6i/jVXI+e3VETyv79
	 4sE4Sbcfz9A1up6oG8xILqIF1ibMsklMBFtrkUVY=
Date: Mon, 22 Jan 2024 16:41:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch added to mm-unstable branch
Message-Id: <20240123004146.933C4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: ignore dirty/accessed/soft-dirty bits in folio_pte_batch()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: ignore dirty/accessed/soft-dirty bits in folio_pte_batch()
Date: Mon, 22 Jan 2024 20:41:59 +0100

Let's ignore these bits: they are irrelevant for fork, and will likely be
irrelevant for upcoming users such as page unmapping.

Link: https://lkml.kernel.org/r/20240122194200.381241-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch
+++ a/mm/memory.c
@@ -953,24 +953,30 @@ static __always_inline void __copy_prese
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
+static inline pte_t __pte_batch_clear_ignored(pte_t pte)
+{
+	return pte_clear_soft_dirty(pte_mkclean(pte_mkold(pte)));
+}
+
 /*
  * Detect a PTE batch: consecutive (present) PTEs that map consecutive
  * pages of the same folio.
  *
  * All PTEs inside a PTE batch have the same PTE bits set, excluding the PFN.
+ * the accessed bit, dirty bit and soft-dirty bit.
  */
 static inline int folio_pte_batch(struct folio *folio, unsigned long addr,
 		pte_t *start_ptep, pte_t pte, int max_nr)
 {
 	unsigned long folio_end_pfn = folio_pfn(folio) + folio_nr_pages(folio);
 	const pte_t *end_ptep = start_ptep + max_nr;
-	pte_t expected_pte = pte_next_pfn(pte);
+	pte_t expected_pte = __pte_batch_clear_ignored(pte_next_pfn(pte));
 	pte_t *ptep = start_ptep + 1;
 
 	VM_WARN_ON_FOLIO(!pte_present(pte), folio);
 
 	while (ptep != end_ptep) {
-		pte = ptep_get(ptep);
+		pte = __pte_batch_clear_ignored(ptep_get(ptep));
 
 		if (!pte_same(pte, expected_pte))
 			break;
_

Patches currently in -mm which might be from david@redhat.com are

uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch
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

