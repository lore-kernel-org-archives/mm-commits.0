Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFF7142635
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291643; cv=none; b=ahkMP65EL/fgOPErEMocdZNEFEHkz3W6KhFtujowRT8wtOJeadh7JiAT8qF3RutUmFiY59CAjo0DlORyUOEm2TC79aPsyrTL0SXNUYvtFhv2kYNOg14nC+/ImTjNaepgjBfCnUep04qxraX4sdH8Za9iGTmEpGKOsVp1+IOqi6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291643; c=relaxed/simple;
	bh=o9LkPwz2Q7KKuXaG0QQjO+GIep9SO4bHvnwXqnA9U6o=;
	h=Date:To:From:Subject:Message-Id; b=nHhK4evTJZU4hQzwFBXnA8kUrTS7hf5QTvDOZ16QBGOSwnfZCRo7KkRQPsCUVc25j6JxSV+YRIMlNVYSbhRVZz4CfeZSLMHY2tktA59oz9YIf0wyUFlO2meyEqebDDXPo7CYVV+vqLs7fRuyWYeRTt71pY7LiaMXo1YrwBSvYUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QsTDiXOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QsTDiXOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7633AC32782;
	Tue, 25 Jun 2024 05:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291643;
	bh=o9LkPwz2Q7KKuXaG0QQjO+GIep9SO4bHvnwXqnA9U6o=;
	h=Date:To:From:Subject:From;
	b=QsTDiXOFJ9R5nXxjiCOreYRjZ8j5+WdtcxUuPGmpuJpOX5Xqk7tgGib9MGLofhmnz
	 tDschWPG3zhMVpRW3W0+dH2i4abLZwjgbFH/uKND1yksYYdSPh6bdp1g4Kqd5Wjxmg
	 fwjXwAKFlUOdtvzDj73x4vcthzTjkT449VBojdfE=
Date: Mon, 24 Jun 2024 22:00:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,minchan@kernel.org,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch removed from -mm tree
Message-Id: <20240625050043.7633AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: reuse exclusive folio directly instead of wp page faults
has been removed from the -mm tree.  Its filename was
     mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: swap: reuse exclusive folio directly instead of wp page faults
Date: Sun, 2 Jun 2024 12:45:02 +1200

After swapping out, we perform a swap-in operation.  If we first read and
then write, we encounter a major fault in do_swap_page for reading, along
with additional minor faults in do_wp_page for writing.  However, the
latter appears to be unnecessary and inefficient.  Instead, we can
directly reuse in do_swap_page and completely eliminate the need for
do_wp_page.

This patch achieves that optimization specifically for exclusive folios. 
The following microbenchmark demonstrates the significant reduction in
minor faults.

 #define DATA_SIZE (2UL * 1024 * 1024)
 #define PAGE_SIZE (4UL * 1024)

 static void *read_write_data(char *addr)
 {
         char tmp;

         for (int i = 0; i < DATA_SIZE; i += PAGE_SIZE) {
                 tmp = *(volatile char *)(addr + i);
                 *(volatile char *)(addr + i) = tmp;
         }
 }

 int main(int argc, char **argv)
 {
         struct rusage ru;

         char *addr = mmap(NULL, DATA_SIZE, PROT_READ | PROT_WRITE,
                         MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
         memset(addr, 0x11, DATA_SIZE);

         do {
                 long old_ru_minflt, old_ru_majflt;
                 long new_ru_minflt, new_ru_majflt;

                 madvise(addr, DATA_SIZE, MADV_PAGEOUT);

                 getrusage(RUSAGE_SELF, &ru);
                 old_ru_minflt = ru.ru_minflt;
                 old_ru_majflt = ru.ru_majflt;

                 read_write_data(addr);
                 getrusage(RUSAGE_SELF, &ru);
                 new_ru_minflt = ru.ru_minflt;
                 new_ru_majflt = ru.ru_majflt;

                 printf("minor faults:%ld major faults:%ld\n",
                         new_ru_minflt - old_ru_minflt,
                         new_ru_majflt - old_ru_majflt);
         } while(0);

         return 0;
 }

w/o patch,
/ # ~/a.out
minor faults:512 major faults:512

w/ patch,
/ # ~/a.out
minor faults:0 major faults:512

Minor faults decrease to 0!

Link: https://lkml.kernel.org/r/20240602004502.26895-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults
+++ a/mm/memory.c
@@ -4310,6 +4310,10 @@ check_folio:
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
+	if (pte_swp_soft_dirty(vmf->orig_pte))
+		pte = pte_mksoft_dirty(pte);
+	if (pte_swp_uffd_wp(vmf->orig_pte))
+		pte = pte_mkuffd_wp(pte);
 
 	/*
 	 * Same logic as in do_wp_page(); however, optimize for pages that are
@@ -4319,18 +4323,18 @@ check_folio:
 	 */
 	if (!folio_test_ksm(folio) &&
 	    (exclusive || folio_ref_count(folio) == 1)) {
-		if (vmf->flags & FAULT_FLAG_WRITE) {
-			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
-			vmf->flags &= ~FAULT_FLAG_WRITE;
+		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
+		    !vma_soft_dirty_enabled(vma)) {
+			pte = pte_mkwrite(pte, vma);
+			if (vmf->flags & FAULT_FLAG_WRITE) {
+				pte = pte_mkdirty(pte);
+				vmf->flags &= ~FAULT_FLAG_WRITE;
+			}
 		}
 		rmap_flags |= RMAP_EXCLUSIVE;
 	}
 	folio_ref_add(folio, nr_pages - 1);
 	flush_icache_pages(vma, page, nr_pages);
-	if (pte_swp_soft_dirty(vmf->orig_pte))
-		pte = pte_mksoft_dirty(pte);
-	if (pte_swp_uffd_wp(vmf->orig_pte))
-		pte = pte_mkuffd_wp(pte);
 	vmf->orig_pte = pte_advance_pfn(pte, page_idx);
 
 	/* ksm created a completely new copy */
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

