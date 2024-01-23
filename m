Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFA85BADC
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970478; cv=none; b=sUUKaiJFW4wgXMnoUZuXmz+uZ9ANfxWOgmjwdWyvUIfaHts65h+Ck+y9BRYyHNwcoR40bG7Y7IUXYDez4QsoOza9J6Oee6+sMwDDqNtq/mB67yn4wj7qE+cfruyL+v9I1OGmW5pdfLPt0ylsSD+Im9dJRLS2pmhazNR/zi+WJPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970478; c=relaxed/simple;
	bh=lOWWJfq91n6iQLMar2fwmbDZIe2NWcZ0W2i1JYHC4jA=;
	h=Date:To:From:Subject:Message-Id; b=sQYjC0jaSnaMn2aSvCIbVK53CSKpeJL896FEqwfQpC8sMzw6LZ8IS/fogLH7OJryDtqq3ZIuQSMYyvFkmZV1VeRp4MC2yA1jJyMaXvPCrl+mab2J9Q0tNr+04c/A0RSoRjb8ib5ZJeyZXBGxzsu2lbgJYUwx9qY/tnT7NtCHCi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p1RBBqYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p1RBBqYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7891EC43390;
	Tue, 23 Jan 2024 00:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970478;
	bh=lOWWJfq91n6iQLMar2fwmbDZIe2NWcZ0W2i1JYHC4jA=;
	h=Date:To:From:Subject:From;
	b=p1RBBqYnASdGpu2OkW4NUD6MFEvFxtTkmxqqZQj++4kAVgLJYjv3YgZaO7Ed+Zubr
	 2TNvYdi0yJfcGizywXz5tb0FPf+wc+zNqAiYu/Yq1ZA87Cd+OA2dNfW/6L9vkk4hEd
	 dy7xSpH80SXM9sE7XdC8/3tu8f4dR0xFvPfULSBw=
Date: Mon, 22 Jan 2024 16:41:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64.patch added to mm-unstable branch
Message-Id: <20240123004117.7891EC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm/pgtable: define PFN_PTE_SHIFT on arm and arm64
has been added to the -mm mm-unstable branch.  Its filename is
     arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64.patch

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
Subject: arm/pgtable: define PFN_PTE_SHIFT on arm and arm64
Date: Mon, 22 Jan 2024 20:41:50 +0100

Patch series "mm/memory: optimize fork() with PTE-mapped THP".

Now that the rmap overhaul[1] is upstream that provides a clean interface
for rmap batching, let's implement PTE batching during fork when
processing PTE-mapped THPs.

This series is partially based on Ryan's previous work[2] to implement
cont-pte support on arm64, but its a complete rewrite based on [1] to
optimize all architectures independent of any such PTE bits, and to use
the new rmap batching functions that simplify the code and prepare for
further rmap accounting changes.

We collect consecutive PTEs that map consecutive pages of the same large
folio, making sure that the other PTE bits are compatible, and (a) adjust
the refcount only once per batch, (b) call rmap handling functions only
once per batch and (c) perform batch PTE setting/updates.

While this series should be beneficial for adding cont-pte support on
ARM64[2], it's one of the requirements for maintaining a total mapcount[3]
for large folios with minimal added overhead and further changes[4] that
build up on top of the total mapcount.

Independent of all that, this series results in a speedup during fork with
PTE-mapped THP, which is the default with THPs that are smaller than a PMD
(for example, 16KiB to 1024KiB mTHPs for anonymous memory[5]).

On an Intel Xeon Silver 4210R CPU, fork'ing with 1GiB of PTE-mapped folios
of the same size (stddev < 1%) results in the following runtimes for
fork() (shorter is better):

Folio Size | v6.8-rc1 |      New | Change
------------------------------------------
      4KiB | 0.014328 | 0.014265 |     0%
     16KiB | 0.014263 | 0.013293 |   - 7%
     32KiB | 0.014334 | 0.012355 |   -14%
     64KiB | 0.014046 | 0.011837 |   -16%
    128KiB | 0.014011 | 0.011536 |   -18%
    256KiB | 0.013993 | 0.01134  |   -19%
    512KiB | 0.013983 | 0.011311 |   -19%
   1024KiB | 0.013986 | 0.011282 |   -19%
   2048KiB | 0.014305 | 0.011496 |   -20%

Next up is PTE batching when unmapping, that I'll probably send out
based on this series this/next week.

Only tested on x86-64. Compile-tested on most other architectures. Will
do more testing and double-check the arch changes while this is getting
some review.

[1] https://lkml.kernel.org/r/20231220224504.646757-1-david@redhat.com
[2] https://lkml.kernel.org/r/20231218105100.172635-1-ryan.roberts@arm.com
[3] https://lkml.kernel.org/r/20230809083256.699513-1-david@redhat.com
[4] https://lkml.kernel.org/r/20231124132626.235350-1-david@redhat.com
[5] https://lkml.kernel.org/r/20231207161211.2374093-1-ryan.roberts@arm.com


This patch (of 11):

We want to make use of pte_next_pfn() outside of set_ptes().  Let's
simpliy define PFN_PTE_SHIFT, required by pte_next_pfn().

Link: https://lkml.kernel.org/r/20240122194200.381241-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240122194200.381241-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable.h   |    2 ++
 arch/arm64/include/asm/pgtable.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64
+++ a/arch/arm64/include/asm/pgtable.h
@@ -341,6 +341,8 @@ static inline void __sync_cache_and_tags
 		mte_sync_tags(pte, nr_pages);
 }
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
+
 static inline void set_ptes(struct mm_struct *mm,
 			    unsigned long __always_unused addr,
 			    pte_t *ptep, pte_t pte, unsigned int nr)
--- a/arch/arm/include/asm/pgtable.h~arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64
+++ a/arch/arm/include/asm/pgtable.h
@@ -209,6 +209,8 @@ static inline void __sync_icache_dcache(
 extern void __sync_icache_dcache(pte_t pteval);
 #endif
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
+
 void set_ptes(struct mm_struct *mm, unsigned long addr,
 		      pte_t *ptep, pte_t pteval, unsigned int nr);
 #define set_ptes set_ptes
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

