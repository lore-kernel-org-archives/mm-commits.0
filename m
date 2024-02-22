Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714A2A3D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560165; cv=none; b=Y7P+rjAYQfK3FxV3XoYMB+wxgFWllSELnTUqoo572O5qGH+a99XTlhOP0r58+kQAb1kMPZd+5pQVAzQ4gUINDpFQ1AblSMI5nhnYQlq8NBxMlj3uPqoyo2YdRGiLLnjpQUihN4luIDTpFGzy6UAUfktHRgtnK9DRwhWWLW+bpDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560165; c=relaxed/simple;
	bh=avUU+3DeWgKxRFbWKK10vX5EWpxXsgtTcwdEgCwcPX4=;
	h=Date:To:From:Subject:Message-Id; b=GPx4XeYnaid8oyFeZVdhRIiZhr+QukRRHdr1wHExii9I2KmmDhWM9TdnMWBhm3yvz4+vqcwwWfPmO8LuKuMdWdIxiBIBr5Y8AXwp2M0TEFUwiRcYzUwv95KJNUAbFG/mOi0NBFSsMMKwawDsaIbCZMJjcCcbOwVjeKUB6r7GuWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rFdWiSOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rFdWiSOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35799C43390;
	Thu, 22 Feb 2024 00:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560165;
	bh=avUU+3DeWgKxRFbWKK10vX5EWpxXsgtTcwdEgCwcPX4=;
	h=Date:To:From:Subject:From;
	b=rFdWiSOCiZP6W5bqC8ulQ8yOv/CLmIn7GOV9gcvIYXLaPcTicsfbve7EhT/jDQcSj
	 O6RdLQTLY8cz2XeY3lSTKGSLwdHvj4D5PUPge3hCjA/Blfc0bmHTamiqZGTzKdxMG1
	 ClDOVBu3kuF1Rdfzn0fa+mEJRExWzLDi+xfCwgxE=
Date: Wed, 21 Feb 2024 16:02:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch removed from -mm tree
Message-Id: <20240222000245.35799C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: make set_ptes() robust when OAs cross 48-bit boundary
has been removed from the -mm tree.  Its filename was
     arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: make set_ptes() robust when OAs cross 48-bit boundary
Date: Mon, 29 Jan 2024 13:46:35 +0100

Patch series "mm/memory: optimize fork() with PTE-mapped THP", v3.

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
      4KiB | 0.014328 | 0.014035 |   - 2%
     16KiB | 0.014263 | 0.01196  |   -16%
     32KiB | 0.014334 | 0.01094  |   -24%
     64KiB | 0.014046 | 0.010444 |   -26%
    128KiB | 0.014011 | 0.010063 |   -28%
    256KiB | 0.013993 | 0.009938 |   -29%
    512KiB | 0.013983 | 0.00985  |   -30%
   1024KiB | 0.013986 | 0.00982  |   -30%
   2048KiB | 0.014305 | 0.010076 |   -30%

Note that these numbers are even better than the ones from v1 (verified
over multiple reboots), even though there were only minimal code changes. 
Well, I removed a pte_mkclean() call for anon folios, maybe that also
plays a role.

But my experience is that fork() is extremely sensitive to code size,
inlining, ...  so I suspect we'll see on other architectures rather a
change of -20% instead of -30%, and it will be easy to "lose" some of that
speedup in the future by subtle code changes.

Next up is PTE batching when unmapping.  Only tested on x86-64. 
Compile-tested on most other architectures.

[1] https://lkml.kernel.org/r/20231220224504.646757-1-david@redhat.com
[2] https://lkml.kernel.org/r/20231218105100.172635-1-ryan.roberts@arm.com
[3] https://lkml.kernel.org/r/20230809083256.699513-1-david@redhat.com
[4] https://lkml.kernel.org/r/20231124132626.235350-1-david@redhat.com
[5] https://lkml.kernel.org/r/20231207161211.2374093-1-ryan.roberts@arm.com


This patch (of 15):

Since the high bits [51:48] of an OA are not stored contiguously in the
PTE, there is a theoretical bug in set_ptes(), which just adds PAGE_SIZE
to the pte to get the pte with the next pfn.  This works until the pfn
crosses the 48-bit boundary, at which point we overflow into the upper
attributes.

Of course one could argue (and Matthew Wilcox has :) that we will never
see a folio cross this boundary because we only allow naturally aligned
power-of-2 allocation, so this would require a half-petabyte folio.  So
its only a theoretical bug.  But its better that the code is robust
regardless.

I've implemented pte_next_pfn() as part of the fix, which is an opt-in
core-mm interface.  So that is now available to the core-mm, which will be
needed shortly to support forthcoming fork()-batching optimizations.

Link: https://lkml.kernel.org/r/20240129124649.189745-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240125173534.1659317-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20240129124649.189745-2-david@redhat.com
Fixes: 4a169d61c2ed ("arm64: implement the new page table range API")
Closes: https://lore.kernel.org/linux-mm/fdaeb9a5-d890-499a-92c8-d171df43ad01@arm.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
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
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary
+++ a/arch/arm64/include/asm/pgtable.h
@@ -341,6 +341,22 @@ static inline void __sync_cache_and_tags
 		mte_sync_tags(pte, nr_pages);
 }
 
+/*
+ * Select all bits except the pfn
+ */
+static inline pgprot_t pte_pgprot(pte_t pte)
+{
+	unsigned long pfn = pte_pfn(pte);
+
+	return __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
+}
+
+#define pte_next_pfn pte_next_pfn
+static inline pte_t pte_next_pfn(pte_t pte)
+{
+	return pfn_pte(pte_pfn(pte) + 1, pte_pgprot(pte));
+}
+
 static inline void set_ptes(struct mm_struct *mm,
 			    unsigned long __always_unused addr,
 			    pte_t *ptep, pte_t pte, unsigned int nr)
@@ -354,7 +370,7 @@ static inline void set_ptes(struct mm_st
 		if (--nr == 0)
 			break;
 		ptep++;
-		pte_val(pte) += PAGE_SIZE;
+		pte = pte_next_pfn(pte);
 	}
 }
 #define set_ptes set_ptes
@@ -433,16 +449,6 @@ static inline pte_t pte_swp_clear_exclus
 	return clear_pte_bit(pte, __pgprot(PTE_SWP_EXCLUSIVE));
 }
 
-/*
- * Select all bits except the pfn
- */
-static inline pgprot_t pte_pgprot(pte_t pte)
-{
-	unsigned long pfn = pte_pfn(pte);
-
-	return __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
-}
-
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * See the comment in include/linux/pgtable.h
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-clarify-the-spec-for-set_ptes.patch
mm-thp-batch-collapse-pmd-with-set_ptes.patch
mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch
arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
mm-tidy-up-pte_next_pfn-definition.patch
arm64-mm-convert-read_onceptep-to-ptep_getptep.patch
arm64-mm-convert-set_pte_at-to-set_ptes-1.patch
arm64-mm-convert-ptep_clear-to-ptep_get_and_clear.patch
arm64-mm-new-ptep-layer-to-manage-contig-bit.patch
arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch
arm64-mm-wire-up-pte_cont-for-user-mappings.patch
arm64-mm-implement-new-wrprotect_ptes-batch-api.patch
arm64-mm-implement-new-clear_full_ptes-batch-apis.patch
mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch.patch
arm64-mm-implement-pte_batch_hint.patch
arm64-mm-__always_inline-to-improve-fork-perf.patch
arm64-mm-automatically-fold-contpte-mappings.patch

