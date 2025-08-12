Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF672512F5
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 22:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755038235; cv=none; b=mqUzONvz/UDVBx+Zk/E2o1LLppPJA6XHHnopeX5KLM6/3yEnF3QU2MztIoM7RdhZ0MoOXxn4qNiAeU9TFXFGu4Ml56SA5GudM8BHg4ejldxna4gRWZDgx2FVtsR6smJvv/jZFWG/qAioewql4hTVGccJOOPr4sCuJ/8tRY6Xn6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755038235; c=relaxed/simple;
	bh=NJgg3lqDIiOrChLfhg/xQwbLOnrN2lOelUXRZP8xWgI=;
	h=Date:To:From:Subject:Message-Id; b=DbtcNltsayBlw2uZV1f4GJl+hygG2ZJzcxDtJyszLv1Bk3mR70//GZul4R6M1YS5rIzkGd3M0P2syHLFuWd6PuOjsRmZADS2Kj3on7R98PZ/ZpS3ESkmtFZPosecpS0cgXnJNW75Z+/DlAlNPVMJ/FU6tv1//7zbqr7boIzXYl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=igQNOOOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="igQNOOOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CF5C4CEF0;
	Tue, 12 Aug 2025 22:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755038234;
	bh=NJgg3lqDIiOrChLfhg/xQwbLOnrN2lOelUXRZP8xWgI=;
	h=Date:To:From:Subject:From;
	b=igQNOOOVdruY73o6UIEim9Y8xJBF9Ps9usPBGWJ2PP7BrjKDGJSi0LFbXEtiZnhzb
	 k3T9kiy82pPqiiy6cVK+p5fz48/UjHeDJtOrgrqlL9e/HS0eyMa01Mr3IfWUonSQkz
	 6+E+R31/MfshV/hKqlo4E9kr1WlNOyjYfdmpy6HE=
Date: Tue, 12 Aug 2025 15:37:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch added to mm-new branch
Message-Id: <20250812223714.84CF5C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: reimplement is_backed_by_thp() with more precise check
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: reimplement is_backed_by_thp() with more precise check
Date: Tue, 12 Aug 2025 11:55:11 -0400

and rename it to is_backed_by_folio().

is_backed_by_folio() checks if the given vaddr is backed a folio with
a given order. It does so by:
1. getting the pfn of the vaddr;
2. checking kpageflags of the pfn;

if order is greater than 0:
3. checking kpageflags of the head pfn;
4. checking kpageflags of all tail pfns.

pmd_order is added to split_huge_page_test.c and replaces max_order.

Link: https://lkml.kernel.org/r/20250812155512.926011-4-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   67 ++++++++----
 tools/testing/selftests/mm/vm_util.c              |    2 
 tools/testing/selftests/mm/vm_util.h              |    1 
 3 files changed, 48 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -25,6 +25,7 @@
 uint64_t pagesize;
 unsigned int pageshift;
 uint64_t pmd_pagesize;
+unsigned int pmd_order;
 
 #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
 #define SMAP_PATH "/proc/self/smaps"
@@ -36,23 +37,48 @@ uint64_t pmd_pagesize;
 
 #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
 
-int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
+int is_backed_by_folio(char *vaddr, int order, int pagemap_fd, int kpageflags_fd)
 {
-	uint64_t paddr;
-	uint64_t page_flags;
+	unsigned long pfn_head;
+	uint64_t pfn_flags;
+	unsigned long pfn;
+	unsigned long i;
 
-	if (pagemap_file) {
-		pread(pagemap_file, &paddr, sizeof(paddr),
-			((long)vaddr >> pageshift) * sizeof(paddr));
+	if (!pagemap_fd || !kpageflags_fd)
+		return 0;
 
-		if (kpageflags_file) {
-			pread(kpageflags_file, &page_flags, sizeof(page_flags),
-				PAGEMAP_PFN(paddr) * sizeof(page_flags));
+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
 
-			return !!(page_flags & KPF_THP);
-		}
+	if (pfn == -1UL)
+		return 0;
+
+	if (get_pfn_flags(pfn, kpageflags_fd, &pfn_flags))
+		return 0;
+
+	if (!order) {
+		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
+			return 0;
+		return 1;
 	}
-	return 0;
+
+	if (!(pfn_flags & KPF_THP))
+		return 0;
+
+	pfn_head = pfn & ~((1 << order) - 1);
+
+	if (get_pfn_flags(pfn_head, kpageflags_fd, &pfn_flags))
+		return 0;
+
+	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
+		return 0;
+
+	for (i = 1; i < (1UL << order) - 1; i++) {
+		if (get_pfn_flags(pfn_head + i, kpageflags_fd, &pfn_flags))
+			return 0;
+		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
+			return 0;
+	}
+	return 1;
 }
 
 static void write_file(const char *path, const char *buf, size_t buflen)
@@ -233,7 +259,7 @@ void split_pte_mapped_thp(void)
 	thp_size = 0;
 	for (i = 0; i < pagesize * 4; i++)
 		if (i % pagesize == 0 &&
-		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, kpageflags_fd))
+		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
 			thp_size++;
 
 	if (thp_size != 4)
@@ -250,7 +276,7 @@ void split_pte_mapped_thp(void)
 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
 
 		if (i % pagesize == 0 &&
-		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, kpageflags_fd))
+		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
 			thp_size++;
 	}
 
@@ -522,7 +548,6 @@ int main(int argc, char **argv)
 	const char *fs_loc;
 	bool created_tmp;
 	int offset;
-	unsigned int max_order;
 	unsigned int nr_pages;
 	unsigned int tests;
 
@@ -543,28 +568,28 @@ int main(int argc, char **argv)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
 	nr_pages = pmd_pagesize / pagesize;
-	max_order = GET_ORDER(nr_pages);
-	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
+	pmd_order = GET_ORDER(nr_pages);
+	tests = 2 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - 1) * 4 + 2;
 	ksft_set_plan(tests);
 
 	fd_size = 2 * pmd_pagesize;
 
 	split_pmd_zero_pages();
 
-	for (i = 0; i < max_order; i++)
+	for (i = 0; i < pmd_order; i++)
 		if (i != 1)
 			split_pmd_thp_to_order(i);
 
 	split_pte_mapped_thp();
-	for (i = 0; i < max_order; i++)
+	for (i = 0; i < pmd_order; i++)
 		split_file_backed_thp(i);
 
 	created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
 			&fs_loc);
-	for (i = max_order - 1; i >= 0; i--)
+	for (i = pmd_order - 1; i >= 0; i--)
 		split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, -1);
 
-	for (i = 0; i < max_order; i++)
+	for (i = 0; i < pmd_order; i++)
 		for (offset = 0;
 		     offset < nr_pages;
 		     offset += MAX(nr_pages / 4, 1 << i))
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -338,7 +338,7 @@ int detect_hugetlb_page_sizes(size_t siz
 	return count;
 }
 
-static int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
+int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
 {
 	size_t count;
 
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -92,6 +92,7 @@ unsigned long default_huge_page_size(voi
 int detect_hugetlb_page_sizes(size_t sizes[], int max);
 int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
 			int kpageflags_file, int orders[], int nr_orders);
+int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-force_read-to-read-input-value-correctly.patch
mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch
selftests-mm-add-check_folio_orders-helper.patch
selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch
selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

