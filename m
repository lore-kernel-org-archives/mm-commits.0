Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9640079C0
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752970700; cv=none; b=d6oKqHvrnwVYh/kXvhIKUSWTYFysr5K0uyIMgD8EeSAs9Hk4DacCkqTXKArqIthlagKgbd9v2rCffTAVU26VYQWEPzvWoucDigpRMHytQud57WceSlVL07PKdxiEWvOuXXF7wz3LO/mwlyE3xYhB20SxN0MWVcar+JohZz8wrlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752970700; c=relaxed/simple;
	bh=t4QWBzVtQ6uMjVZullTiuzIZ5mdv1pFUbHYCqBddtAg=;
	h=Date:To:From:Subject:Message-Id; b=JqhK8ylNHw0oiKqk8iPVrxR6oCfs0EMkprbNzeCBNf1+Xe9sDnsD1WPgE2BR9r7yI3MXN8PpZHjPX4zQBkgii9FPCH2Lpw5iO0bjc4F9bcmUCfoRJVlKoinoU5NRcGduIRha5LNRRN91o4KkVt91qXOrtQPn4Im3vDwAvZRyqNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FIbpA91e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FIbpA91e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD8BC4CEE3;
	Sun, 20 Jul 2025 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752970700;
	bh=t4QWBzVtQ6uMjVZullTiuzIZ5mdv1pFUbHYCqBddtAg=;
	h=Date:To:From:Subject:From;
	b=FIbpA91egZfPKidPMeORMagTe3aCft+AtFr8wqEyE5+Ykv20KUPxTzWCGkMgpXrZh
	 1sJdcCTlHVVqRhxOh/EiPOERNWB+yCBcgmhx5LxrHskKuTr1nJamIDhDUwwaGN4MbZ
	 a9ry/4UUKNofd4ap6f+SKKhnIYdaaF/t9pfxNT8Y=
Date: Sat, 19 Jul 2025 17:18:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch added to mm-new branch
Message-Id: <20250720001819.EBD8BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: refactor MM_CP_PROT_NUMA skipping case into new function
has been added to the -mm mm-new branch.  Its filename is
     mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm: refactor MM_CP_PROT_NUMA skipping case into new function
Date: Fri, 18 Jul 2025 14:32:38 +0530

Patch series "Optimize mprotect() for large folios", v5.

Use folio_pte_batch() to optimize change_pte_range().  On arm64, if the
ptes are painted with the contig bit, then ptep_get() will iterate through
all 16 entries to collect a/d bits.  Hence this optimization will result
in a 16x reduction in the number of ptep_get() calls.  Next,
ptep_modify_prot_start() will eventually call contpte_try_unfold() on
every contig block, thus flushing the TLB for the complete large folio
range.  Instead, use get_and_clear_full_ptes() so as to elide TLBIs on
each contig block, and only do them on the starting and ending contig
block.

For split folios, there will be no pte batching; the batch size returned
by folio_pte_batch() will be 1.  For pagetable split folios, the ptes will
still point to the same large folio; for arm64, this results in the
optimization described above, and for other arches, a minor improvement is
expected due to a reduction in the number of function calls.

mm-selftests pass on arm64.  I have some failing tests on my x86 VM
already; no new tests fail as a result of this patchset.

We use the following test cases to measure performance, mprotect()'ing the
mapped memory to read-only then read-write 40 times:

Test case 1: Mapping 1G of memory, touching it to get PMD-THPs, then
pte-mapping those THPs
Test case 2: Mapping 1G of memory with 64K mTHPs
Test case 3: Mapping 1G of memory with 4K pages

Average execution time on arm64, Apple M3:
Before the patchset:
T1: 2.1 seconds   T2: 2 seconds   T3: 1 second

After the patchset:
T1: 0.65 seconds   T2: 0.7 seconds   T3: 1.1 seconds

Observing T1/T2 and T3 before the patchset, we also remove the regression
introduced by ptep_get() on a contpte block.  And, for large folios we get
an almost 74% performance improvement, albeit the trade-off being a slight
degradation in the small folio case.

For x86:
Before the patchset:
T1: 3.75 seconds  T2: 3.7 seconds  T3: 3.85 seconds

After the patchset:
T1: 3.7 seconds  T2: 3.7 seconds  T3: 3.9 seconds

So there is a minor improvement due to reduction in number of function
calls, and a slight degradation in the small folio case due to the
overhead of vm_normal_folio() + folio_test_large().

Here is the test program:

 #define _GNU_SOURCE
 #include <sys/mman.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>
 #include <unistd.h>

 #define SIZE (1024*1024*1024)

unsigned long pmdsize = (1UL << 21);
unsigned long pagesize = (1UL << 12);

static void pte_map_thps(char *mem, size_t size)
{
	size_t offs;
	int ret = 0;


	/* PTE-map each THP by temporarily splitting the VMAs. */
	for (offs = 0; offs < size; offs += pmdsize) {
		ret |= madvise(mem + offs, pagesize, MADV_DONTFORK);
		ret |= madvise(mem + offs, pagesize, MADV_DOFORK);
	}

	if (ret) {
		fprintf(stderr, "ERROR: mprotect() failed\n");
		exit(1);
	}
}

int main(int argc, char *argv[])
{
	char *p;
        int ret = 0;
	p = mmap((1UL << 30), SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (p != (1UL << 30)) {
		perror("mmap");
		return 1;
	}



	memset(p, 0, SIZE);
	if (madvise(p, SIZE, MADV_NOHUGEPAGE))
		perror("madvise");
	explicit_bzero(p, SIZE);
	pte_map_thps(p, SIZE);

	for (int loops = 0; loops < 40; loops++) {
		if (mprotect(p, SIZE, PROT_READ))
			perror("mprotect"), exit(1);
		if (mprotect(p, SIZE, PROT_READ|PROT_WRITE))
			perror("mprotect"), exit(1);
		explicit_bzero(p, SIZE);
	}
}


This patch (of 7):

Reduce indentation by refactoring the prot_numa case into a new function. 
No functional change intended.

Link: https://lkml.kernel.org/r/20250718090244.21092-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20250718090244.21092-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |  101 ++++++++++++++++++++++++++----------------------
 1 file changed, 55 insertions(+), 46 deletions(-)

--- a/mm/mprotect.c~mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function
+++ a/mm/mprotect.c
@@ -83,6 +83,59 @@ bool can_change_pte_writable(struct vm_a
 	return pte_dirty(pte);
 }
 
+static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
+			   pte_t oldpte, pte_t *pte, int target_node)
+{
+	struct folio *folio;
+	bool toptier;
+	int nid;
+
+	/* Avoid TLB flush if possible */
+	if (pte_protnone(oldpte))
+		return true;
+
+	folio = vm_normal_folio(vma, addr, oldpte);
+	if (!folio)
+		return true;
+
+	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
+		return true;
+
+	/* Also skip shared copy-on-write pages */
+	if (is_cow_mapping(vma->vm_flags) &&
+	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+		return true;
+
+	/*
+	 * While migration can move some dirty pages,
+	 * it cannot move them all from MIGRATE_ASYNC
+	 * context.
+	 */
+	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
+		return true;
+
+	/*
+	 * Don't mess with PTEs if page is already on the node
+	 * a single-threaded process is running on.
+	 */
+	nid = folio_nid(folio);
+	if (target_node == nid)
+		return true;
+
+	toptier = node_is_toptier(nid);
+
+	/*
+	 * Skip scanning top tier node if normal numa
+	 * balancing is disabled
+	 */
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
+		return true;
+
+	if (folio_use_access_time(folio))
+		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
+	return false;
+}
+
 static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -117,53 +170,9 @@ static long change_pte_range(struct mmu_
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa) {
-				struct folio *folio;
-				int nid;
-				bool toptier;
-
-				/* Avoid TLB flush if possible */
-				if (pte_protnone(oldpte))
-					continue;
-
-				folio = vm_normal_folio(vma, addr, oldpte);
-				if (!folio || folio_is_zone_device(folio) ||
-				    folio_test_ksm(folio))
-					continue;
-
-				/* Also skip shared copy-on-write pages */
-				if (is_cow_mapping(vma->vm_flags) &&
-				    (folio_maybe_dma_pinned(folio) ||
-				     folio_maybe_mapped_shared(folio)))
-					continue;
-
-				/*
-				 * While migration can move some dirty pages,
-				 * it cannot move them all from MIGRATE_ASYNC
-				 * context.
-				 */
-				if (folio_is_file_lru(folio) &&
-				    folio_test_dirty(folio))
-					continue;
-
-				/*
-				 * Don't mess with PTEs if page is already on the node
-				 * a single-threaded process is running on.
-				 */
-				nid = folio_nid(folio);
-				if (target_node == nid)
-					continue;
-				toptier = node_is_toptier(nid);
-
-				/*
-				 * Skip scanning top tier node if normal numa
-				 * balancing is disabled
-				 */
-				if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-				    toptier)
+				if (prot_numa_skip(vma, addr, oldpte, pte,
+						   target_node))
 					continue;
-				if (folio_use_access_time(folio))
-					folio_xchg_access_time(folio,
-						jiffies_to_msecs(jiffies));
 			}
 
 			oldpte = ptep_modify_prot_start(vma, addr, pte);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch
mm-split-can_change_pte_writable-into-private-and-shared-parts.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

