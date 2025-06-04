Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375DF1E1DF2
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 19:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749064454; cv=none; b=nJ7iV326yqtdxKKbSln7AkRxmR8LDTabUplOp4OnRpqJZh8VPZKRKjEvBa4DTXMfWzsa5BvnF0fu29yt0kPql+vQ2P7WpdHXBwigTQYCuaD4/T6DduhN9YaQMSpyIYGwoOXNiolR1TO9WeTwoh+7EhB2cwCvcko+T1CDNOWSEZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749064454; c=relaxed/simple;
	bh=wAv1oISI7v7jVknuMidgFcXZulIaPMVbVeh+U0M14aQ=;
	h=Date:To:From:Subject:Message-Id; b=c49eJRWJh3i8H9u6TECjZZZX3kaiS7CO+dya9tCYc+yJ+dPyUPRd8r+QD514wH6iXlc5SznBRx30Pw/FnPU3Fw/msh4TwI+on+j7ejl8KrHVkxqT+Ght42sbF5iqIBpGPpWXkaSMATrlq22lrdX1fBHY6QB6EIgNgSba/sr8DXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vnkZr48S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vnkZr48S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99691C4CEE4;
	Wed,  4 Jun 2025 19:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749064453;
	bh=wAv1oISI7v7jVknuMidgFcXZulIaPMVbVeh+U0M14aQ=;
	h=Date:To:From:Subject:From;
	b=vnkZr48Sfgpyv1o4ptMMp6TQ5KzkoPvnsoMnIe+cY54Mp3TerDLMuCUO+eM+aiHbI
	 Nl+75H+T+zoPkpuN7QBA06My14Wxky7zm8jGTNFpEEGBDqcHiY7bRySZsZMJltlZyM
	 7/DAHpxLCjiVBr66i5858hk87Hj0zmhEGBtktf1w=
Date: Wed, 04 Jun 2025 12:14:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,gshan@redhat.com,dev.jain@arm.com,david@redhat.com,catalin.marinas@arm.com,baohua@kernel.org,xavier_qy@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] arm64-mm-optimize-loop-to-reduce-redundant-operations-of-contpte_ptep_get.patch removed from -mm tree
Message-Id: <20250604191413.99691C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: optimize loop to reduce redundant operations of contpte_ptep_get
has been removed from the -mm tree.  Its filename was
     arm64-mm-optimize-loop-to-reduce-redundant-operations-of-contpte_ptep_get.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Xavier Xia <xavier_qy@163.com>
Subject: arm64/mm: optimize loop to reduce redundant operations of contpte_ptep_get
Date: Sat, 10 May 2025 20:59:48 +0800

This commit optimizes contpte_ptep_get() and contpte_ptep_get_lockless()
by adding early termination logic.  It checks if the dirty and young bits
of orig_pte are already set and skips redundant bit-setting operations
during the loop.  This reduces unnecessary iterations and improves
performance.

In order to verify the optimization performance, a test function has been
designed.  The function's execution time and instruction statistics have
been traced using perf, and the following are the operation results on a
certain Qualcomm mobile phone chip:

Test Code:

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

It can be proven through test function that the optimization for
contpte_ptep_get is effective.  Since the logic of
contpte_ptep_get_lockless is similar to that of contpte_ptep_get, the same
optimization scheme is also adopted for it.

Link: https://lkml.kernel.org/r/20250510125948.2383778-1-xavier_qy@163.com
Signed-off-by: Xavier Xia <xavier_qy@163.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
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

Patches currently in -mm which might be from xavier_qy@163.com are


