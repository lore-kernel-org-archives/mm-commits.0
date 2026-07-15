Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331D941BA98
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139946; cv=none; b=CnkWdGhQFBfY2mzeFo0JS+rCzxy3bn6dKtn2Id4cdL9eq8OuOSKeN5L59lxAjHB7RWDwcwGwIxG+3tJO1U+ULeapSdEyCRvr77LRpngkTn8Bq3suIG+sbDsdTDRBaTwIC+J8rTk7ztQMl9dTTJev4/CGLnWEGYyc0pglT+mVozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139946; c=relaxed/simple;
	bh=9XNEnfXIPOBZVFgRIiCBbOnBAzp8hslY8epYmhlrB5k=;
	h=Date:To:From:Subject:Message-Id; b=tN8fFEmkH6m4rWPJRy0bMK2qQohvsYtH8WYtpY0a3gZm0ZSFQ+WqPWoALX8cDtIbob2ximVTkulK4xNmrJTeqInYtchBvJAEdlfr0M4hl5GokJXxTURv5Seu67xUfTkfsKj8s6ghNrNa7+OVyQNXHir0hR8fyWh3xFvYpKbGsTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DL5o8EYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DL5o8EYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9972E1F000E9;
	Wed, 15 Jul 2026 18:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139933;
	bh=bOzUWmkOT4hP3m+wTdCll78PG7fK03RaxK1KlbvbouU=;
	h=Date:To:From:Subject;
	b=DL5o8EYgaPXx0F+mcbxf6YCm/kCe5mgxbcACpHo3/OESDlJkQagsZmAiVQUmUqJYC
	 VgHzEmk50baLNWkLujz5ZoXU4VSBwEqwxi8HlU0Ps6fl4tryCCKuqaNGQL71nZIQLf
	 6lPlsa36HbQeBnb6ZAhAZhnNesjdQi5DEDZ1Rm9Q=
Date: Wed, 15 Jul 2026 11:25:33 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch added to mm-new branch
Message-Id: <20260715182533.9972E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add PAGEMAP_SCAN test for THP PMD holes
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: add PAGEMAP_SCAN test for THP PMD holes
Date: Wed, 15 Jul 2026 15:42:34 +0100

Add coverage for the PMD-hole case fixed by "fs/proc/task_mmu: fix
PAGEMAP_SCAN written state for PMD holes": a MAP_PRIVATE|MAP_ANON THP that
is uffd-wp'd and then dropped with MADV_DONTNEED leaves a pmd_none hole
with no page table, which PAGEMAP_SCAN must still report as written --
checked via both the fast and generic query paths, mirroring
unpopulated_scan_test().

Include <linux/mman.h> for MADV_COLLAPSE; <sys/mman.h> lacks it on older
glibc (e.g.  2.34).  Same approach as commit fd5295afae91 ("selftests/mm:
hmm-tests: include linux/mman.h to access MADV_COLLAPSE").

Link: https://lore.kernel.org/20260715144234.442721-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   66 ++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -8,6 +8,7 @@
 #include <errno.h>
 #include <malloc.h>
 #include <linux/types.h>
+#include <linux/mman.h>
 #include <linux/memfd.h>
 #include <linux/userfaultfd.h>
 #include <linux/fs.h>
@@ -1102,6 +1103,68 @@ static void unpopulated_scan_test(void)
 	munmap(mem, mem_size);
 }
 
+/*
+ * Like unpopulated_scan_test(), but the range is a MAP_PRIVATE|MAP_ANON THP
+ * that is uffd-wp'd and then dropped with MADV_DONTNEED. That leaves a
+ * pmd_none hole with no page table, which pagemap_page_category() never sees;
+ * PAGEMAP_SCAN must still report it written via pagemap_scan_pte_hole().
+ */
+static void unpopulated_thp_scan_test(void)
+{
+	struct page_region regions[16];
+	long fast = 0, slow = 0, ret;
+	int npages, i;
+	char *area, *mem;
+
+	if (!hpage_size) {
+		ksft_test_result_skip("%s THP not supported\n", __func__);
+		return;
+	}
+	npages = hpage_size / page_size;
+
+	/* Over-allocate so a PMD-aligned, THP-sized range fits inside. */
+	area = mmap(NULL, 2 * hpage_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED) {
+		ksft_test_result_skip("%s mmap failed\n", __func__);
+		return;
+	}
+	mem = (char *)(((unsigned long)area + hpage_size - 1) & ~(hpage_size - 1));
+
+	wp_init(mem, hpage_size);
+
+	/* Populate, collapse to a THP, then drop: a pmd_none hole, no marker. */
+	memset(mem, 1, hpage_size);
+	if (madvise(mem, hpage_size, MADV_COLLAPSE) ||
+	    !check_huge_anon(mem, 1, hpage_size)) {
+		ksft_test_result_skip("%s could not form a THP\n", __func__);
+		goto out;
+	}
+	if (madvise(mem, hpage_size, MADV_DONTNEED)) {
+		ksft_test_result_skip("%s MADV_DONTNEED failed\n", __func__);
+		goto out;
+	}
+
+	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
+	ret = pagemap_ioctl(mem, hpage_size, regions, ARRAY_SIZE(regions), 0, 0,
+			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
+	for (i = 0; ret > 0 && i < ret; i++)
+		fast += LEN(regions[i]);
+
+	/* Generic path: same query expressed via category_anyof_mask. */
+	ret = pagemap_ioctl(mem, hpage_size, regions, ARRAY_SIZE(regions), 0, 0,
+			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
+	for (i = 0; ret > 0 && i < ret; i++)
+		slow += LEN(regions[i]);
+
+	ksft_test_result(fast == npages && slow == npages,
+			 "%s pmd-hole reported written by both paths (%ld, %ld of %d)\n",
+			 __func__, fast, slow, npages);
+out:
+	wp_free(mem, hpage_size);
+	munmap(area, 2 * hpage_size);
+}
+
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
@@ -1610,7 +1673,7 @@ int main(int __attribute__((unused)) arg
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(118);
+	ksft_set_plan(119);
 
 	page_size = getpagesize();
 	hpage_size = read_pmd_pagesize();
@@ -1790,6 +1853,7 @@ int main(int __attribute__((unused)) arg
 
 	/* 18. Unpopulated pte scan-path consistency */
 	unpopulated_scan_test();
+	unpopulated_thp_scan_test();
 
 	close(pagemap_fd);
 	ksft_finished();
_

Patches currently in -mm which might be from kas@kernel.org are

fs-proc-task_mmu-fix-pagemap_scan-written-state-for-unpopulated-ptes.patch
mm-hugetlb-fix-swap-entry-corruption-when-clearing-uffd-wp-at-fork.patch
fs-proc-task_mmu-fix-pagemap_scan-written-state-for-pmd-holes.patch
mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch
selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch

