Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B239238D56
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588779; cv=none; b=At5p5vhvdOzXS/XLIUFMFkduaODKcp4M2m1KBXES/F+yTTk5ezb2Kl3L9+1c+HMkJ078cVHKgXvOL6sL4mW+u4RvvdLVU/CprLOHfxcdt+73kgLeQwOIuW1poa9/WG7kl4NLZZXPo8M6EU8ELxeFM+Aa+AocNgYAslApawYdS8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588779; c=relaxed/simple;
	bh=6Blg5ooR+cInwE3cYTpKNr5LTPKuyCXTZfIB+eTQj5Q=;
	h=Date:To:From:Subject:Message-Id; b=MCf/Oq3w6Jsn51gH/LOBSwibGbxhwuzGQfmpYguPzeglLVgF2M44ORUlwsYR+VhDVUwdVdvmtA97Os0NsL4pDhqq6Hen/bU+kCLbsn9oDpWyXgyXn3XDcnnpdKm8xhTLW+SgRso0e+CQLmmOMHtdGQv8ve2S2vOjXHpmoGL2+mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vQPBorLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vQPBorLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55C0C4CEED;
	Tue, 10 Jun 2025 20:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749588778;
	bh=6Blg5ooR+cInwE3cYTpKNr5LTPKuyCXTZfIB+eTQj5Q=;
	h=Date:To:From:Subject:From;
	b=vQPBorLd+D07naXQrOl9JAnEJQflvNdSpAlh7BfCvi5yieOa++2uNHaOlIx85Jf6o
	 rGL3xuwXCUuom57UxAfwY8De5WJofy4AlYl6iukpExh45nbDUHJK5I6sgL07x8pS2b
	 66hCNp7HRuq0kZAc2ig5dDICzSLnchePpW+2ybQ0=
Date: Tue, 10 Jun 2025 13:52:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch added to mm-new branch
Message-Id: <20250610205258.D55C0C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: test relocate anon in split huge page test
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: test relocate anon in split huge page test
Date: Mon, 9 Jun 2025 14:26:44 +0100

It's useful to explicitly test splitting of huge pages with
MREMAP_RELOCATE_ANON set, as this exercises the undo logic and ensures
that it functions correctly.

Expand the tests to do so in the instance where anon mremap() occurs, and
utilise the shared sys_mremap() function to allow for specification of the
new mremap flag (which would otherwise be filtered by glibc).

Link: https://lkml.kernel.org/r/064971308aacfbdaaf404ebe5736666744dbd005.1749473726.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   25 ++++++++----
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~tools-testing-selftests-test-relocate-anon-in-split-huge-page-test
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -19,6 +19,7 @@
 #include <malloc.h>
 #include <stdbool.h>
 #include <time.h>
+#include <linux/mman.h>
 #include "vm_util.h"
 #include "../kselftest.h"
 
@@ -180,7 +181,7 @@ void split_pmd_thp_to_order(int order)
 	free(one_page);
 }
 
-void split_pte_mapped_thp(void)
+void split_pte_mapped_thp(bool relocate_anon)
 {
 	char *one_page, *pte_mapped, *pte_mapped2;
 	size_t len = 4 * pmd_pagesize;
@@ -221,10 +222,14 @@ void split_pte_mapped_thp(void)
 
 	/* remap the Nth pagesize of Nth THP */
 	for (i = 1; i < 4; i++) {
-		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
-				     pagesize, pagesize,
-				     MREMAP_MAYMOVE|MREMAP_FIXED,
-				     pte_mapped + pagesize * i);
+		int mremap_flags = MREMAP_MAYMOVE|MREMAP_FIXED;
+
+		if (relocate_anon)
+			mremap_flags |= MREMAP_RELOCATE_ANON;
+
+		pte_mapped2 = sys_mremap(one_page + pmd_pagesize * i + pagesize * i,
+					 pagesize, pagesize, mremap_flags,
+					 pte_mapped + pagesize * i);
 		if (pte_mapped2 == MAP_FAILED)
 			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
 	}
@@ -257,7 +262,10 @@ void split_pte_mapped_thp(void)
 	if (thp_size)
 		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
 
-	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
+	if (relocate_anon)
+		ksft_test_result_pass("Split PTE-mapped huge pages w/MREMAP_RELOCATE_ANON successful\n");
+	else
+		ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
 	munmap(one_page, len);
 	close(pagemap_fd);
 	close(kpageflags_fd);
@@ -534,7 +542,7 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(1+8+1+9+9+8*4+2);
+	ksft_set_plan(1+8+1+1+9+9+8*4+2);
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
@@ -550,7 +558,8 @@ int main(int argc, char **argv)
 		if (i != 1)
 			split_pmd_thp_to_order(i);
 
-	split_pte_mapped_thp();
+	split_pte_mapped_thp(/* relocate_anon= */false);
+	split_pte_mapped_thp(/* relocate_anon= */true);
 	for (i = 0; i < 9; i++)
 		split_file_backed_thp(i);
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

