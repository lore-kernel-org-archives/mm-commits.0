Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F32913F00D
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876063; cv=none; b=gPLJscIWGhy+yrGF0Q42FdZdjQJPU+yIa7tG/CpSwCQWxdI+/6p3IQhTKF9MfhCvrqePL7c3KsV78ZK2ZtlzRWYBv5XDKLMqDWcg0+Y2sYdwNWtzYaI/ei856NTa5vAkKBHFqaGdbJr8REWcgGFssOFNt644t91atQl/bno0HbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876063; c=relaxed/simple;
	bh=IaCNzD+fCMd+Whq1fV8r6T/Ee/8gF5dZSnnOkPezqMU=;
	h=Date:To:From:Subject:Message-Id; b=QMu+CJyOI6uqTFG5oCR6St853mMjmafwsOwixD+477voz1z0CZSUipuB9URcUA0IjZ1sHY4KqUhiyE3BW3H1Zbgllo1L+h0vPcVWpsHP1TV3Z1TQY2bKKhZ9EHsZ6wZ40WvohzF+/gi3YzuDAkCNu6+DD2xJZ8SQ/I9RQq/XOYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hZwmL/RN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hZwmL/RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C89CC433F1;
	Fri,  2 Feb 2024 12:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876062;
	bh=IaCNzD+fCMd+Whq1fV8r6T/Ee/8gF5dZSnnOkPezqMU=;
	h=Date:To:From:Subject:From;
	b=hZwmL/RNNMhKdrQSeSTbTqWzJ64YGgKj2k/OVKxjxg/RcebrsqJYAd39bkfmYqvdv
	 Tx8ZrRefCOgfdfQE3r/xyAcx/AZBwSO3Q6LrHw2O3mxF5WRRFNrix3gqvOKQzkkJZC
	 blmi0bL1oZI9VK+KMtI1mrHhOF3tOWGcQDHONUJY=
Date: Fri, 02 Feb 2024 04:14:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-pass-pte-to-copy_present_pte.patch added to mm-unstable branch
Message-Id: <20240202121422.4C89CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: pass PTE to copy_present_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-pass-pte-to-copy_present_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-pass-pte-to-copy_present_pte.patch

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
Subject: mm/memory: pass PTE to copy_present_pte()
Date: Mon, 29 Jan 2024 13:46:46 +0100

We already read it, let's just forward it.

This patch is based on work by Ryan Roberts.

Link: https://lkml.kernel.org/r/20240129124649.189745-13-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-pass-pte-to-copy_present_pte
+++ a/mm/memory.c
@@ -959,10 +959,9 @@ static inline void __copy_present_pte(st
  */
 static inline int
 copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
-		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		 struct folio **prealloc)
+		 pte_t *dst_pte, pte_t *src_pte, pte_t pte, unsigned long addr,
+		 int *rss, struct folio **prealloc)
 {
-	pte_t pte = ptep_get(src_pte);
 	struct page *page;
 	struct folio *folio;
 
@@ -1103,7 +1102,7 @@ again:
 		}
 		/* copy_present_pte() will clear `*prealloc' if consumed */
 		ret = copy_present_pte(dst_vma, src_vma, dst_pte, src_pte,
-				       addr, rss, &prealloc);
+				       ptent, addr, rss, &prealloc);
 		/*
 		 * If we need a pre-allocated page for this pte, drop the
 		 * locks, allocate, and try again.
_

Patches currently in -mm which might be from david@redhat.com are

arm-pgtable-define-pfn_pte_shift.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
riscv-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch
arm-mm-use-pte_next_pfn-in-set_ptes.patch
powerpc-mm-use-pte_next_pfn-in-set_ptes.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

