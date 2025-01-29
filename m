Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905501DA4E
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 04:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738123803; cv=none; b=Lu4am+8IsdHs8KG0EA56kmLqBEUFirgjmn5nj3tckky4lJe2NZPn9S1EPLuNRZco4VaCiiDuibk7P1IKwBZDA2SwO/0RU+I4jPhfx8iC0vAAtnD6pc/tWQnI1JDdn24SsoHR2wH23xrabdGPb/m4u9GFaPgq7UNBFSTGbMk8ojM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738123803; c=relaxed/simple;
	bh=6iPP3iDKnqfD4XKSRKF7vbG6ji5mwb+Wh52TGidcpqc=;
	h=Date:To:From:Subject:Message-Id; b=N41dZz2xFYhbKrOlQcLeR2B3arvf5HonRUPqfLk3lJhvj++irhgbm60YvlTcVO1cQimJhOJ+8vGBtfE1QZvNFx2zBYhZCso9tVSeP4iIvkGbLtbuFdMPFCB5WOOCk3A/HAK947OSkih8ioGeKuXfH3k9DoEwwu+D+zCWEzNuXfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U7W4SvlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U7W4SvlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0B3C4CED3;
	Wed, 29 Jan 2025 04:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738123802;
	bh=6iPP3iDKnqfD4XKSRKF7vbG6ji5mwb+Wh52TGidcpqc=;
	h=Date:To:From:Subject:From;
	b=U7W4SvlYbt0beDXuKlzYXY1qFZPwKQk+1jcT7/gNmYm8UlDlIIz1DPZ3sFYs6f5AY
	 wnBEOVBzr9Q1ULs/XvMQOQqHm/UhpDEeNqSA8OAqiaC9S+knz65ZxRfzVNVNolXJo9
	 NdgFBXHQcJvZCQW6LrYcTrdbmFVDW6lp9xffhcsU=
Date: Tue, 28 Jan 2025 20:10:02 -0800
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,yosryahmed@google.com,ying.huang@intel.com,yangyicong@hisilicon.com,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shahuang@redhat.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,mfo@canonical.com,mark.rutland@arm.com,lorenzo.stoakes@oracle.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,ioworker0@gmail.com,hpa@zytor.com,gshan@redhat.com,david@redhat.com,dave.hansen@linux.intel.com,chrisl@kernel.org,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,aou@eecs.berkeley.edu,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch added to mm-unstable branch
Message-Id: <20250129041002.CE0B3C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support batched unmap for lazyfree large folios during reclamation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: support batched unmap for lazyfree large folios during reclamation
Date: Wed, 15 Jan 2025 16:38:07 +1300

Currently, the PTEs and rmap of a large folio are removed one at a time. 
This is not only slow but also causes the large folio to be unnecessarily
added to deferred_split, which can lead to races between the
deferred_split shrinker callback and memory reclamation.  This patch
releases all PTEs and rmap entries in a batch.  Currently, it only handles
lazyfree large folios.

The below microbench tries to reclaim 128MB lazyfree large folios
whose sizes are 64KiB:

 #include <stdio.h>
 #include <sys/mman.h>
 #include <string.h>
 #include <time.h>

 #define SIZE 128*1024*1024  // 128 MB

 unsigned long read_split_deferred()
 {
 	FILE *file = fopen("/sys/kernel/mm/transparent_hugepage"
			"/hugepages-64kB/stats/split_deferred", "r");
 	if (!file) {
 		perror("Error opening file");
 		return 0;
 	}

 	unsigned long value;
 	if (fscanf(file, "%lu", &value) != 1) {
 		perror("Error reading value");
 		fclose(file);
 		return 0;
 	}

 	fclose(file);
 	return value;
 }

 int main(int argc, char *argv[])
 {
 	while(1) {
 		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
 				MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

 		memset((void *)p, 1, SIZE);

 		madvise((void *)p, SIZE, MADV_FREE);

 		clock_t start_time = clock();
 		unsigned long start_split = read_split_deferred();
 		madvise((void *)p, SIZE, MADV_PAGEOUT);
 		clock_t end_time = clock();
 		unsigned long end_split = read_split_deferred();

 		double elapsed_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
 		printf("Time taken by reclamation: %f seconds, split_deferred: %ld\n",
 			elapsed_time, end_split - start_split);

 		munmap((void *)p, SIZE);
 	}
 	return 0;
 }

w/o patch:
~ # ./a.out
Time taken by reclamation: 0.177418 seconds, split_deferred: 2048
Time taken by reclamation: 0.178348 seconds, split_deferred: 2048
Time taken by reclamation: 0.174525 seconds, split_deferred: 2048
Time taken by reclamation: 0.171620 seconds, split_deferred: 2048
Time taken by reclamation: 0.172241 seconds, split_deferred: 2048
Time taken by reclamation: 0.174003 seconds, split_deferred: 2048
Time taken by reclamation: 0.171058 seconds, split_deferred: 2048
Time taken by reclamation: 0.171993 seconds, split_deferred: 2048
Time taken by reclamation: 0.169829 seconds, split_deferred: 2048
Time taken by reclamation: 0.172895 seconds, split_deferred: 2048
Time taken by reclamation: 0.176063 seconds, split_deferred: 2048
Time taken by reclamation: 0.172568 seconds, split_deferred: 2048
Time taken by reclamation: 0.171185 seconds, split_deferred: 2048
Time taken by reclamation: 0.170632 seconds, split_deferred: 2048
Time taken by reclamation: 0.170208 seconds, split_deferred: 2048
Time taken by reclamation: 0.174192 seconds, split_deferred: 2048
...

w/ patch:
~ # ./a.out
Time taken by reclamation: 0.074231 seconds, split_deferred: 0
Time taken by reclamation: 0.071026 seconds, split_deferred: 0
Time taken by reclamation: 0.072029 seconds, split_deferred: 0
Time taken by reclamation: 0.071873 seconds, split_deferred: 0
Time taken by reclamation: 0.073573 seconds, split_deferred: 0
Time taken by reclamation: 0.071906 seconds, split_deferred: 0
Time taken by reclamation: 0.073604 seconds, split_deferred: 0
Time taken by reclamation: 0.075903 seconds, split_deferred: 0
Time taken by reclamation: 0.073191 seconds, split_deferred: 0
Time taken by reclamation: 0.071228 seconds, split_deferred: 0
Time taken by reclamation: 0.071391 seconds, split_deferred: 0
Time taken by reclamation: 0.071468 seconds, split_deferred: 0
Time taken by reclamation: 0.071896 seconds, split_deferred: 0
Time taken by reclamation: 0.072508 seconds, split_deferred: 0
Time taken by reclamation: 0.071884 seconds, split_deferred: 0
Time taken by reclamation: 0.072433 seconds, split_deferred: 0
Time taken by reclamation: 0.071939 seconds, split_deferred: 0
...

Link: https://lkml.kernel.org/r/20250115033808.40641-4-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mauricio Faria de Oliveira <mfo@canonical.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

--- a/mm/rmap.c~mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation
+++ a/mm/rmap.c
@@ -1642,6 +1642,25 @@ void folio_remove_rmap_pmd(struct folio
 #endif
 }
 
+/* We support batch unmapping of PTEs for lazyfree large folios */
+static inline bool can_batch_unmap_folio_ptes(unsigned long addr,
+			struct folio *folio, pte_t *ptep)
+{
+	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
+	int max_nr = folio_nr_pages(folio);
+	pte_t pte = ptep_get(ptep);
+
+	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
+		return false;
+	if (pte_none(pte) || pte_unused(pte) || !pte_present(pte))
+		return false;
+	if (pte_pfn(pte) != folio_pfn(folio))
+		return false;
+
+	return folio_pte_batch(folio, addr, ptep, pte, max_nr, fpb_flags, NULL,
+			       NULL, NULL) == max_nr;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1655,6 +1674,7 @@ static bool try_to_unmap_one(struct foli
 	bool anon_exclusive, ret = true;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	int nr_pages = 1;
 	unsigned long pfn;
 	unsigned long hsz = 0;
 
@@ -1780,6 +1800,16 @@ static bool try_to_unmap_one(struct foli
 				hugetlb_vma_unlock_write(vma);
 			}
 			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+		} else if (folio_test_large(folio) && !(flags & TTU_HWPOISON) &&
+				can_batch_unmap_folio_ptes(address, folio, pvmw.pte)) {
+			nr_pages = folio_nr_pages(folio);
+			flush_cache_range(vma, range.start, range.end);
+			pteval = get_and_clear_full_ptes(mm, address, pvmw.pte, nr_pages, 0);
+			if (should_defer_flush(mm, flags))
+				set_tlb_ubc_flush_pending(mm, pteval, address,
+					address + folio_size(folio));
+			else
+				flush_tlb_range(vma, range.start, range.end);
 		} else {
 			flush_cache_page(vma, address, pfn);
 			/* Nuke the page table entry. */
@@ -1875,7 +1905,7 @@ static bool try_to_unmap_one(struct foli
 					 * redirtied either using the page table or a previously
 					 * obtained GUP reference.
 					 */
-					set_pte_at(mm, address, pvmw.pte, pteval);
+					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					folio_set_swapbacked(folio);
 					goto walk_abort;
 				} else if (ref_count != 1 + map_count) {
@@ -1888,10 +1918,10 @@ static bool try_to_unmap_one(struct foli
 					 * We'll come back here later and detect if the folio was
 					 * dirtied when the additional reference is gone.
 					 */
-					set_pte_at(mm, address, pvmw.pte, pteval);
+					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					goto walk_abort;
 				}
-				dec_mm_counter(mm, MM_ANONPAGES);
+				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
 				goto discard;
 			}
 
@@ -1943,13 +1973,18 @@ static bool try_to_unmap_one(struct foli
 			dec_mm_counter(mm, mm_counter_file(folio));
 		}
 discard:
-		if (unlikely(folio_test_hugetlb(folio)))
+		if (unlikely(folio_test_hugetlb(folio))) {
 			hugetlb_remove_rmap(folio);
-		else
-			folio_remove_rmap_pte(folio, subpage, vma);
+		} else {
+			folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
+			folio_ref_sub(folio, nr_pages - 1);
+		}
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
+		/* We have already batched the entire folio */
+		if (nr_pages > 1)
+			goto walk_done;
 		continue;
 walk_abort:
 		ret = false;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch
mm-support-tlbbatch-flush-for-a-range-of-ptes.patch
mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch
mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch

