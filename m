Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BD52580CA
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 21:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799700; cv=none; b=lj0tepXAalpGxSHSrusKGYS83dt+THprM1T7qDWjRCwDZjwW2c1t1X91zWOd+BY5Y7q7PWBRwKrE+tkAMViTKhJOauyvln3gGvOWj2gsQ2oL46IDYF+nQPH1CYIxdKb7Hx9sVNqVFFaIFJ1/YeLjXI13xfb1xB7xddeKcUDMfPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799700; c=relaxed/simple;
	bh=hRbc+RGm6Kx568RTkY/QwOhbaKaJ8Nwtqh3XBNcYKFw=;
	h=Date:To:From:Subject:Message-Id; b=g3KiVggZgq/NFCEN38/CO0wAwbprCDaxh1OMl3R7M7R2/LGL0ja8Jgv5YObH2yHCXE9i8lhzGu25QwoGAVTGq05YdBC5HogcHJF+vtxO/IrIfCefOmCGx8qBlxbug6cPznj0xiu4IrdnML5qM7rJPaZ74I7DzMt06DH3ewelokE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xJw9ePWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xJw9ePWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158C0C4CEE3;
	Tue, 24 Jun 2025 21:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750799700;
	bh=hRbc+RGm6Kx568RTkY/QwOhbaKaJ8Nwtqh3XBNcYKFw=;
	h=Date:To:From:Subject:From;
	b=xJw9ePWM/BrubDuE46F7f0tEROeFNYwfOGm1LPzGQkO+fsDc22aDbsk5obVi4n9xi
	 LRRUTtAr1vYZdluMddBdlczg0a8/noAviiwLkmd/UFN50PIh9fszPRFlQOepR4IubX
	 wygtwqKqGIOcL1q3sSUToJC8G+v+Q7QZvoRPcFqM=
Date: Tue, 24 Jun 2025 14:14:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,gshan@redhat.com,dev.jain@arm.com,david@redhat.com,catalin.marinas@arm.com,baohua@kernel.org,xavier.qyxia@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-optimize-loop-to-reduce-redundant-operations-of-contpte_ptep_get.patch added to mm-new branch
Message-Id: <20250624211500.158C0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: optimize loop to reduce redundant operations of contpte_ptep_get
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-optimize-loop-to-reduce-redundant-operations-of-contpte_ptep_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-optimize-loop-to-reduce-redundant-operations-of-contpte_ptep_get.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Xavier Xia <xavier.qyxia@gmail.com>
Subject: arm64/mm: optimize loop to reduce redundant operations of contpte_ptep_get
Date: Tue, 24 Jun 2025 23:25:49 +0800

This commit optimizes the contpte_ptep_get and contpte_ptep_get_lockless
function by adding early termination logic.  It checks if the dirty and
young bits of orig_pte are already set and skips redundant bit-setting
operations during the loop.  This reduces unnecessary iterations and
improves performance.

In order to verify the optimization performance, a test function has been
designed.  The function's execution time and instruction statistics have
been traced using perf, and the following are the operation results on a
certain Qualcomm mobile phone chip:

Test Code:
	#include <stdlib.h>
	#include <sys/mman.h>
	#include <stdio.h>

	#define PAGE_SIZE 4096
	#define CONT_PTES 16
	#define TEST_SIZE (4096* CONT_PTES * PAGE_SIZE)
	#define YOUNG_BIT 8
	void rwdata(char *buf)
	{
		for (size_t i = 0; i < TEST_SIZE; i += PAGE_SIZE) {
			buf[i] = 'a';
			volatile char c = buf[i];
		}
	}
	void clear_young_dirty(char *buf)
	{
		if (madvise(buf, TEST_SIZE, MADV_FREE) == -1) {
			perror("madvise free failed");
			free(buf);
			exit(EXIT_FAILURE);
		}
		if (madvise(buf, TEST_SIZE, MADV_COLD) == -1) {
			perror("madvise free failed");
			free(buf);
			exit(EXIT_FAILURE);
		}
	}
	void set_one_young(char *buf)
	{
		for (size_t i = 0; i < TEST_SIZE; i += CONT_PTES * PAGE_SIZE) {
			volatile char c = buf[i + YOUNG_BIT * PAGE_SIZE];
		}
	}

	void test_contpte_perf() {
		char *buf;
		int ret = posix_memalign((void **)&buf, CONT_PTES * PAGE_SIZE,
				TEST_SIZE);
		if ((ret != 0) || ((unsigned long)buf % CONT_PTES * PAGE_SIZE)) {
			perror("posix_memalign failed");
			exit(EXIT_FAILURE);
		}

		rwdata(buf);
	#if TEST_CASE2 || TEST_CASE3
		clear_young_dirty(buf);
	#endif
	#if TEST_CASE2
		set_one_young(buf);
	#endif

		for (int j = 0; j < 500; j++) {
			mlock(buf, TEST_SIZE);

			munlock(buf, TEST_SIZE);
		}
		free(buf);
	}

	int main(void)
	{
		test_contpte_perf();
		return 0;
	}

	Descriptions of three test scenarios

Scenario 1
	The data of all 16 PTEs are both dirty and young.
	#define TEST_CASE2 0
	#define TEST_CASE3 0

Scenario 2
	Among the 16 PTEs, only the 8th one is young, and there are no dirty ones.
	#define TEST_CASE2 1
	#define TEST_CASE3 0

Scenario 3
	Among the 16 PTEs, there are neither young nor dirty ones.
	#define TEST_CASE2 0
	#define TEST_CASE3 1

Test results

|Scenario 1         |       Original|       Optimized|
|-------------------|---------------|----------------|
|instructions       |    37912436160|     18731580031|
|test time          |         4.2797|          2.2949|
|overhead of        |               |                |
|contpte_ptep_get() |         21.31%|           4.80%|

|Scenario 2         |       Original|       Optimized|
|-------------------|---------------|----------------|
|instructions       |    36701270862|     36115790086|
|test time          |         3.2335|          3.0874|
|Overhead of        |               |                |
|contpte_ptep_get() |         32.26%|          33.57%|

|Scenario 3         |       Original|       Optimized|
|-------------------|---------------|----------------|
|instructions       |    36706279735|     36750881878|
|test time          |         3.2008|          3.1249|
|Overhead of        |               |                |
|contpte_ptep_get() |         31.94%|          34.59%|

For Scenario 1, optimized code can achieve an instruction benefit of
50.59% and a time benefit of 46.38%.

For Scenario 2, optimized code can achieve an instruction count benefit of
1.6% and a time benefit of 4.5%.

For Scenario 3, since all the PTEs have neither the young nor the dirty
flag, the branches taken by optimized code should be the same as those of
the original code.  In fact, the test results of optimized code seem to be
closer to those of the original code.

Ryan re-ran these tests on Apple M2 with 4K base pages + 64K mTHP.

Scenario 1: reduced to 56% of baseline execution time
Scenario 2: reduced to 89% of baseline execution time
Scenario 3: reduced to 91% of baseline execution time

It can be proven through test function that the optimization for
contpte_ptep_get is effective.  Since the logic of
contpte_ptep_get_lockless is similar to that of contpte_ptep_get, the same
optimization scheme is also adopted for it.

Link: https://lkml.kernel.org/r/20250624152549.2647828-1-xavier.qyxia@gmail.com
Signed-off-by: Xavier Xia <xavier.qyxia@gmail.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/contpte.c |   72 +++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 9 deletions(-)

--- a/arch/arm64/mm/contpte.c~arm64-mm-optimize-loop-to-reduce-redundant-operations-of-contpte_ptep_get
+++ a/arch/arm64/mm/contpte.c
@@ -169,17 +169,46 @@ pte_t contpte_ptep_get(pte_t *ptep, pte_
 	for (i = 0; i < CONT_PTES; i++, ptep++) {
 		pte = __ptep_get(ptep);
 
-		if (pte_dirty(pte))
+		if (pte_dirty(pte)) {
 			orig_pte = pte_mkdirty(orig_pte);
+			for (; i < CONT_PTES; i++, ptep++) {
+				pte = __ptep_get(ptep);
+				if (pte_young(pte)) {
+					orig_pte = pte_mkyoung(orig_pte);
+					break;
+				}
+			}
+			break;
+		}
 
-		if (pte_young(pte))
+		if (pte_young(pte)) {
 			orig_pte = pte_mkyoung(orig_pte);
+			i++;
+			ptep++;
+			for (; i < CONT_PTES; i++, ptep++) {
+				pte = __ptep_get(ptep);
+				if (pte_dirty(pte)) {
+					orig_pte = pte_mkdirty(orig_pte);
+					break;
+				}
+			}
+			break;
+		}
 	}
 
 	return orig_pte;
 }
 EXPORT_SYMBOL_GPL(contpte_ptep_get);
 
+static inline bool contpte_is_consistent(pte_t pte, unsigned long pfn,
+					pgprot_t orig_prot)
+{
+	pgprot_t prot = pte_pgprot(pte_mkold(pte_mkclean(pte)));
+
+	return pte_valid_cont(pte) && pte_pfn(pte) == pfn &&
+			pgprot_val(prot) == pgprot_val(orig_prot);
+}
+
 pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
 {
 	/*
@@ -202,7 +231,6 @@ pte_t contpte_ptep_get_lockless(pte_t *o
 	pgprot_t orig_prot;
 	unsigned long pfn;
 	pte_t orig_pte;
-	pgprot_t prot;
 	pte_t *ptep;
 	pte_t pte;
 	int i;
@@ -219,18 +247,44 @@ retry:
 
 	for (i = 0; i < CONT_PTES; i++, ptep++, pfn++) {
 		pte = __ptep_get(ptep);
-		prot = pte_pgprot(pte_mkold(pte_mkclean(pte)));
 
-		if (!pte_valid_cont(pte) ||
-		   pte_pfn(pte) != pfn ||
-		   pgprot_val(prot) != pgprot_val(orig_prot))
+		if (!contpte_is_consistent(pte, pfn, orig_prot))
 			goto retry;
 
-		if (pte_dirty(pte))
+		if (pte_dirty(pte)) {
 			orig_pte = pte_mkdirty(orig_pte);
+			for (; i < CONT_PTES; i++, ptep++, pfn++) {
+				pte = __ptep_get(ptep);
+
+				if (!contpte_is_consistent(pte, pfn, orig_prot))
+					goto retry;
+
+				if (pte_young(pte)) {
+					orig_pte = pte_mkyoung(orig_pte);
+					break;
+				}
+			}
+			break;
+		}
 
-		if (pte_young(pte))
+		if (pte_young(pte)) {
 			orig_pte = pte_mkyoung(orig_pte);
+			i++;
+			ptep++;
+			pfn++;
+			for (; i < CONT_PTES; i++, ptep++, pfn++) {
+				pte = __ptep_get(ptep);
+
+				if (!contpte_is_consistent(pte, pfn, orig_prot))
+					goto retry;
+
+				if (pte_dirty(pte)) {
+					orig_pte = pte_mkdirty(orig_pte);
+					break;
+				}
+			}
+			break;
+		}
 	}
 
 	return orig_pte;
_

Patches currently in -mm which might be from xavier.qyxia@gmail.com are

arm64-mm-optimize-loop-to-reduce-redundant-operations-of-contpte_ptep_get.patch

