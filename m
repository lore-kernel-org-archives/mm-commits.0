Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68EA41C71
	for <mm-commits@vger.kernel.org>; Sat, 11 Jul 2026 00:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783728273; cv=none; b=WT/jvpUp9IKtrixgLy6nVfRtWp2+sKjR67LOsP6LmTap+rMO927vLP+0ESPJbn7/JSwb7gneAEf7AtwiKBH0/Ktck0wUnX/5DYtlf/PS4esPjPYl0BK/iL3XzvJG3gp3LkJhiw+uRENsxsu/LhAZoFBdTlZ91f0MUiUfZecLrgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783728273; c=relaxed/simple;
	bh=DKQI/VIpMrZ2nGhLqrb5nXK2YCCuRP5mkIBpLKUZ7tg=;
	h=Date:To:From:Subject:Message-Id; b=Zb/t1plo5UhsaGykxv7ZS++hM6xv/S0KNCaAAyoPx1IptMrdY/r6U0yvKEig+idDYVUHomypg9BD9HhC8kVXafa9Pm6sRzF8cp2123zmujxJq11SKeovDr29Hh0fJuvUF9rUzFT18hzYGnj6Q5F0hjSKEu+ewIh0Aj+OWz40YUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aFidnRqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aFidnRqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2FE1F000E9;
	Sat, 11 Jul 2026 00:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783728271;
	bh=G0zmkrQAe3OOpbsniGrqUaL8mcnCsig7a59umugSjTM=;
	h=Date:To:From:Subject;
	b=aFidnRqP6ItFUDlB+J6z6UEC3a3jAxKFg25k4jX3p1U9Vt7SvDQGult9KyN/Y8kkS
	 u9VfkQWUr+E1tloGfHJe8fMSxftolFnAASfQSBQNCqTIym2b4CwiTieVNI2Glj2TzK
	 1aIBnf/xGl17/6Er/x75xWQ7hUiTzJcXI98Mu9P0=
Date: Fri, 10 Jul 2026 17:04:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch added to mm-new branch
Message-Id: <20260711000431.4B2FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove obsolete hugetlb vmemmap test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: selftests/mm: remove obsolete hugetlb vmemmap test
Date: Fri, 10 Jul 2026 17:24:27 +0800

The hugetlb vmemmap selftest was added to check the old HVO layout where
tail vmemmap pages reused the head page.  That assumption no longer
matches the current HVO mapping layout.

HVO now keeps a private backing page for the head vmemmap page and remaps
redundant tail vmemmap pages to a shared read-only backing page.  The old
page flag check is therefore testing an obsolete implementation detail
rather than the current ABI or behavior.

Remove the stale test and its build, run, and ignore entries.

Link: https://lore.kernel.org/20260710092427.3459121-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore        |    2 
 tools/testing/selftests/mm/Makefile          |    1 
 tools/testing/selftests/mm/hugetlb-vmemmap.c |  132 -----------------
 tools/testing/selftests/mm/run_vmtests.sh    |    1 
 4 files changed, 136 deletions(-)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-remove-obsolete-hugetlb-vmemmap-test
+++ a/tools/testing/selftests/mm/.gitignore
@@ -3,11 +3,9 @@ cow
 hugepage-mmap
 hugepage-mremap
 hugepage-shm
-hugepage-vmemmap
 hugetlb-mmap
 hugetlb-mremap
 hugetlb-shm
-hugetlb-vmemmap
 hugetlb-madvise
 hugetlb-read-hwpoison
 hugetlb-soft-offline
diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c a/tools/testing/selftests/mm/hugetlb-vmemmap.c
deleted file mode 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ /dev/null
@@ -1,132 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * A test case of using hugepage memory in a user application using the
- * mmap system call with MAP_HUGETLB flag.  Before running this program
- * make sure the administrator has allocated enough default sized huge
- * pages to cover the 2 MB allocation.
- */
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/mman.h>
-#include <fcntl.h>
-#include "vm_util.h"
-#include "hugepage_settings.h"
-
-#define PAGE_COMPOUND_HEAD	(1UL << 15)
-#define PAGE_COMPOUND_TAIL	(1UL << 16)
-#define PAGE_HUGE		(1UL << 17)
-
-#define HEAD_PAGE_FLAGS		(PAGE_COMPOUND_HEAD | PAGE_HUGE)
-#define TAIL_PAGE_FLAGS		(PAGE_COMPOUND_TAIL | PAGE_HUGE)
-
-#define PM_PFRAME_BITS		55
-#define PM_PFRAME_MASK		~((1UL << PM_PFRAME_BITS) - 1)
-
-static size_t pagesize;
-static size_t maplength;
-
-static void write_bytes(char *addr, size_t length)
-{
-	unsigned long i;
-
-	for (i = 0; i < length; i++)
-		*(addr + i) = (char)i;
-}
-
-static unsigned long virt_to_pfn(void *addr)
-{
-	int fd;
-	unsigned long pagemap;
-
-	fd = open("/proc/self/pagemap", O_RDONLY);
-	if (fd < 0)
-		return -1UL;
-
-	lseek(fd, (unsigned long)addr / pagesize * sizeof(pagemap), SEEK_SET);
-	read(fd, &pagemap, sizeof(pagemap));
-	close(fd);
-
-	return pagemap & ~PM_PFRAME_MASK;
-}
-
-static int check_page_flags(unsigned long pfn)
-{
-	int fd, i;
-	unsigned long pageflags;
-
-	fd = open("/proc/kpageflags", O_RDONLY);
-	if (fd < 0)
-		return -1;
-
-	lseek(fd, pfn * sizeof(pageflags), SEEK_SET);
-
-	read(fd, &pageflags, sizeof(pageflags));
-	if ((pageflags & HEAD_PAGE_FLAGS) != HEAD_PAGE_FLAGS) {
-		close(fd);
-		ksft_print_msg("Head page flags (%lx) is invalid\n", pageflags);
-		return -1;
-	}
-
-	/*
-	 * pages other than the first page must be tail and shouldn't be head;
-	 * this also verifies kernel has correctly set the fake page_head to tail
-	 * while hugetlb_free_vmemmap is enabled.
-	 */
-	for (i = 1; i < maplength / pagesize; i++) {
-		read(fd, &pageflags, sizeof(pageflags));
-		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
-		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
-			close(fd);
-			ksft_print_msg("Tail page flags (%lx) is invalid\n", pageflags);
-			return -1;
-		}
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-int main(int argc, char **argv)
-{
-	void *addr;
-	unsigned long pfn;
-	int ret;
-
-	ksft_print_header();
-	ksft_set_plan(1);
-
-	if (!hugetlb_setup_default(1))
-		ksft_exit_skip("Not enough free huge pages\n");
-
-	pagesize  = psize();
-	maplength = default_huge_page_size();
-	if (!maplength)
-		ksft_exit_skip("Unable to determine huge page size\n");
-
-	addr = mmap(NULL, maplength, PROT_READ | PROT_WRITE,
-			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_perror("mmap");
-
-	/* Trigger allocation of HugeTLB page. */
-	write_bytes(addr, maplength);
-
-	pfn = virt_to_pfn(addr);
-	if (pfn == -1UL) {
-		ksft_perror("virt_to_pfn");
-		munmap(addr, maplength);
-		ksft_exit_fail();
-	}
-
-	ksft_print_msg("Returned address is %p whose pfn is %lx\n", addr, pfn);
-
-	ret = check_page_flags(pfn);
-
-	if (munmap(addr, maplength))
-		ksft_exit_fail_perror("munmap");
-
-	ksft_test_result(!ret, "HugeTLB vmemmap page flags\n");
-	ksft_finished();
-}
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-remove-obsolete-hugetlb-vmemmap-test
+++ a/tools/testing/selftests/mm/Makefile
@@ -66,7 +66,6 @@ TEST_GEN_FILES += hugetlb-mremap
 TEST_GEN_FILES += hugetlb-read-hwpoison
 TEST_GEN_FILES += hugetlb-shm
 TEST_GEN_FILES += hugetlb-soft-offline
-TEST_GEN_FILES += hugetlb-vmemmap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-remove-obsolete-hugetlb-vmemmap-test
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -262,7 +262,6 @@ echo "TAP version 13" | tap_output
 CATEGORY="hugetlb" run_test ./hugetlb-mmap
 CATEGORY="hugetlb" run_test ./hugetlb-shm
 CATEGORY="hugetlb" run_test ./hugetlb-mremap
-CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
 CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch
mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch
powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch
mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch
mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch
mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch
mm-sparse-move-subsection_map_init-into-sparse_init.patch
mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch
mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch
mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch
mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch
mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch
mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch
mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch
mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch
mm-hugetlb-remove-obsolete-bootmem-cross-zone-checks.patch
mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch
mm-hugetlb-remove-unused-bootmem-cma-field.patch
mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch
selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

