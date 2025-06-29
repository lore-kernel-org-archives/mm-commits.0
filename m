Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83AD1DE891
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 23:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751238373; cv=none; b=QOo4fIRJJ5DWcrSOyv7vJ7CAObXcISvL2SSR2IRY8BbGsXG1aa/+bHcSSkJ15608KVrfgu3mL3f3vLMdXZAul9mWsKBDYvf1H9HkNmVfzPjfEiZ8/qk0TDrxQBmSdj4gF1KzyF+E+0ZqTbsc54I+3nnzvP92Ybh7JNx6F32chl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751238373; c=relaxed/simple;
	bh=OQfAsGvsvNB5YdzGy3F3N/YKFTq0jtbBiH2UlGApAyU=;
	h=Date:To:From:Subject:Message-Id; b=LluPNHAplxRPDmWqn7IdYACt5ojjC4Y3mlCekDUnzG87PbHTt1pUvsGvL1Y8Dt2iifFS0jkhJX9QwUXSk45arhePx3Wt1lu/vWzTCBm6t5+3F1Q53//KhOPi2PpSU2ACQI7VBLD6+33piVssPYcmYoJ31b+/8vTVz6dZVJD4JI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GcdmfOjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GcdmfOjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ECDC4CEEB;
	Sun, 29 Jun 2025 23:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751238373;
	bh=OQfAsGvsvNB5YdzGy3F3N/YKFTq0jtbBiH2UlGApAyU=;
	h=Date:To:From:Subject:From;
	b=GcdmfOjxm+jApOB6ka7Ov9yYu6UAkrlN/QnO/Nd40BZbU8nIuy8bfTkIpcW7aVCPF
	 2WjAzrSFyVIi1FpeKKEC+NEegp1axV3dZ/iGNf1ZDer73tkfEHhvQVL1KCBVR3221+
	 E8fahibKioVgura0U8T2xw/FTg8tVNhcF+RhbZGk=
Date: Sun, 29 Jun 2025 16:06:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch added to mm-new branch
Message-Id: <20250629230613.56ECDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: optimize mprotect() for MM_CP_PROT_NUMA by batch-skipping PTEs
has been added to the -mm mm-new branch.  Its filename is
     mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch

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
Subject: mm: optimize mprotect() for MM_CP_PROT_NUMA by batch-skipping PTEs
Date: Sat, 28 Jun 2025 17:04:32 +0530

Patch series "Optimize mprotect() for large folios", v4.

This patchset optimizes the mprotect() system call for large folios by
PTE-batching.  No issues were observed with mm-selftests, build tested on
x86_64.

We use the following test cases to measure performance, mprotect()'ing the
mapped memory to read-only then read-write 40 times:

Test case 1: Mapping 1G of memory, touching it to get PMD-THPs, then
pte-mapping those THPs
Test case 2: Mapping 1G of memory with 64K mTHPs
Test case 3: Mapping 1G of memory with 4K pages

Average execution time on arm64, Apple M3:
Before the patchset:
T1: 7.9 seconds   T2: 7.9 seconds   T3: 4.2 seconds

After the patchset:
T1: 2.1 seconds   T2: 2.2 seconds   T3: 4.3 seconds

Observing T1/T2 and T3 before the patchset, we also remove the regression
introduced by ptep_get() on a contpte block.  And, for large folios we get
an almost 74% performance improvement, albeit the trade-off being a slight
degradation in the small folio case.

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


This patch (of 4):

In case of prot_numa, there are various cases in which we can skip to the
next iteration.  Since the skip condition is based on the folio and not
the PTEs, we can skip a PTE batch.  Additionally refactor all of this into
a new function to clean up the existing code.

Link: https://lkml.kernel.org/r/20250628113435.46678-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20250628113435.46678-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
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
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

 mm/mprotect.c |  134 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 47 deletions(-)

--- a/mm/mprotect.c~mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes
+++ a/mm/mprotect.c
@@ -83,6 +83,83 @@ bool can_change_pte_writable(struct vm_a
 	return pte_dirty(pte);
 }
 
+static int mprotect_folio_pte_batch(struct folio *folio, unsigned long addr,
+		pte_t *ptep, pte_t pte, int max_nr_ptes)
+{
+	const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
+
+	if (!folio || !folio_test_large(folio) || (max_nr_ptes == 1))
+		return 1;
+
+	return folio_pte_batch(folio, addr, ptep, pte, max_nr_ptes, flags,
+			       NULL, NULL, NULL);
+}
+
+static int prot_numa_skip_ptes(struct folio **foliop, struct vm_area_struct *vma,
+		unsigned long addr, pte_t oldpte, pte_t *pte, int target_node,
+		int max_nr_ptes)
+{
+	struct folio *folio = NULL;
+	int nr_ptes = 1;
+	bool toptier;
+	int nid;
+
+	/* Avoid TLB flush if possible */
+	if (pte_protnone(oldpte))
+		goto skip_batch;
+
+	folio = vm_normal_folio(vma, addr, oldpte);
+	if (!folio)
+		goto skip_batch;
+
+	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
+		goto skip_batch;
+
+	/* Also skip shared copy-on-write pages */
+	if (is_cow_mapping(vma->vm_flags) &&
+	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+		goto skip_batch;
+
+	/*
+	 * While migration can move some dirty pages,
+	 * it cannot move them all from MIGRATE_ASYNC
+	 * context.
+	 */
+	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
+		goto skip_batch;
+
+	/*
+	 * Don't mess with PTEs if page is already on the node
+	 * a single-threaded process is running on.
+	 */
+	nid = folio_nid(folio);
+	if (target_node == nid)
+		goto skip_batch;
+
+	toptier = node_is_toptier(nid);
+
+	/*
+	 * Skip scanning top tier node if normal numa
+	 * balancing is disabled
+	 */
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
+		goto skip_batch;
+
+	if (folio_use_access_time(folio)) {
+		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
+
+		/* Do not skip in this case */
+		nr_ptes = 0;
+		goto out;
+	}
+
+skip_batch:
+	nr_ptes = mprotect_folio_pte_batch(folio, addr, pte, oldpte, max_nr_ptes);
+out:
+	*foliop = folio;
+	return nr_ptes;
+}
+
 static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -94,6 +171,7 @@ static long change_pte_range(struct mmu_
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	int nr_ptes;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
@@ -108,8 +186,11 @@ static long change_pte_range(struct mmu_
 	flush_tlb_batched_pending(vma->vm_mm);
 	arch_enter_lazy_mmu_mode();
 	do {
+		nr_ptes = 1;
 		oldpte = ptep_get(pte);
 		if (pte_present(oldpte)) {
+			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
+			struct folio *folio = NULL;
 			pte_t ptent;
 
 			/*
@@ -117,53 +198,12 @@ static long change_pte_range(struct mmu_
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
+				nr_ptes = prot_numa_skip_ptes(&folio, vma,
+							      addr, oldpte, pte,
+							      target_node,
+							      max_nr_ptes);
+				if (nr_ptes)
 					continue;
-				if (folio_use_access_time(folio))
-					folio_xchg_access_time(folio,
-						jiffies_to_msecs(jiffies));
 			}
 
 			oldpte = ptep_modify_prot_start(vma, addr, pte);
@@ -280,7 +320,7 @@ static long change_pte_range(struct mmu_
 				pages++;
 			}
 		}
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (pte += nr_ptes, addr += nr_ptes * PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch
maple-tree-use-goto-label-to-simplify-code.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

