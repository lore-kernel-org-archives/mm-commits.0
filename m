Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AF213DDAA
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 05:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359976; cv=none; b=pO118cdkW0DIj2693yjzx/rgfYRLlH37gH9kisdFYMfqbhDZgrlBaAvQaOxh8QrFyOhWtxGqodXJDuDNZkcnWOAJRGE/zt2opK2K/XlOcYl7nZ681B6p09TvbImyIBHMxjjA4b8oCZjWNOGUlIUj19hl76KaeWlsskpoQEgJ67A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359976; c=relaxed/simple;
	bh=BOJ5p7J2qAOIogOSG2A1DGswqTeExuzaqBxxQNLDcG8=;
	h=Date:To:From:Subject:Message-Id; b=IkjkzE4idu72BE26HssWPSaEKSclYRtioFEbarY2xBelQbJpOJ8/NhfzMI7x+BgGUYiwqGHOQPVyVjIpazSL5i6cvmmWCuogRNoypx1XepMvUy0hjyMtCoPjsriUpxxmICTw9l+RqKttqur6S96OJuqa8boWeE31T4BOhds4Smw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ukifjoir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ukifjoir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A146C4CEEB;
	Thu, 28 Aug 2025 05:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359975;
	bh=BOJ5p7J2qAOIogOSG2A1DGswqTeExuzaqBxxQNLDcG8=;
	h=Date:To:From:Subject:From;
	b=ukifjoir3ySrrpr9PZ4vadL7Iol3cdhdiqUFBY3Qi9qes/U8YHp4LndhUbYqq/O04
	 fbKHhAzO/0wGKVY7ppepHkBZc56wK0bq6F5V70OQ3dbUrziom617qy5eDxbpoDePRL
	 DKkIYpuHQgN9eLqa/8weWaEmsTffpKjOCvEhqCx4=
Date: Wed, 27 Aug 2025 22:46:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shuah@kernel.org,ryncsn@gmail.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,broonie@kernel.org,brauner@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-force_read-to-read-input-value-correctly.patch removed from -mm tree
Message-Id: <20250828054615.7A146C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix FORCE_READ to read input value correctly
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-force_read-to-read-input-value-correctly.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: fix FORCE_READ to read input value correctly
Date: Tue, 5 Aug 2025 13:51:40 -0400

FORCE_READ() converts input value x to its pointer type then reads from
address x.  This is wrong.  If x is a non-pointer, it would be caught it
easily.  But all FORCE_READ() callers are trying to read from a pointer
and FORCE_READ() basically reads a pointer to a pointer instead of the
original typed pointer.  Almost no access violation was found, except the
one from split_huge_page_test.

Fix it by implementing a simplified READ_ONCE() instead.

Link: https://lkml.kernel.org/r/20250805175140.241656-1-ziy@nvidia.com
Fixes: 3f6bfd4789a0 ("selftests/mm: reuse FORCE_READ to replace "asm volatile("" : "+r" (XXX));"")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c                  |    4 ++--
 tools/testing/selftests/mm/guard-regions.c        |    2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c      |    4 +++-
 tools/testing/selftests/mm/migration.c            |    2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c        |    2 +-
 tools/testing/selftests/mm/split_huge_page_test.c |    7 +++++--
 tools/testing/selftests/mm/vm_util.h              |    2 +-
 7 files changed, 14 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-fix-force_read-to-read-input-value-correctly
+++ a/tools/testing/selftests/mm/cow.c
@@ -1554,8 +1554,8 @@ static void run_with_zeropage(non_anon_t
 	}
 
 	/* Read from the page to populate the shared zeropage. */
-	FORCE_READ(mem);
-	FORCE_READ(smem);
+	FORCE_READ(*mem);
+	FORCE_READ(*smem);
 
 	fn(mem, smem, pagesize);
 munmap:
--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-fix-force_read-to-read-input-value-correctly
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -145,7 +145,7 @@ static bool try_access_buf(char *ptr, bo
 		if (write)
 			*ptr = 'x';
 		else
-			FORCE_READ(ptr);
+			FORCE_READ(*ptr);
 	}
 
 	signal_jump_set = false;
--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-fix-force_read-to-read-input-value-correctly
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -50,8 +50,10 @@ void read_fault_pages(void *addr, unsign
 	unsigned long i;
 
 	for (i = 0; i < nr_pages; i++) {
+		unsigned long *addr2 =
+			((unsigned long *)(addr + (i * huge_page_size)));
 		/* Prevent the compiler from optimizing out the entire loop: */
-		FORCE_READ(((unsigned long *)(addr + (i * huge_page_size))));
+		FORCE_READ(*addr2);
 	}
 }
 
--- a/tools/testing/selftests/mm/migration.c~selftests-mm-fix-force_read-to-read-input-value-correctly
+++ a/tools/testing/selftests/mm/migration.c
@@ -110,7 +110,7 @@ void *access_mem(void *ptr)
 		 * the memory access actually happens and prevents the compiler
 		 * from optimizing away this entire loop.
 		 */
-		FORCE_READ((uint64_t *)ptr);
+		FORCE_READ(*(uint64_t *)ptr);
 	}
 
 	return NULL;
--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-fix-force_read-to-read-input-value-correctly
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1525,7 +1525,7 @@ void zeropfn_tests(void)
 
 	ret = madvise(mem, hpage_size, MADV_HUGEPAGE);
 	if (!ret) {
-		FORCE_READ(mem);
+		FORCE_READ(*mem);
 
 		ret = pagemap_ioctl(mem, hpage_size, &vec, 1, 0,
 				    0, PAGE_IS_PFNZERO, 0, 0, PAGE_IS_PFNZERO);
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-fix-force_read-to-read-input-value-correctly
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -439,8 +439,11 @@ int create_pagecache_thp_and_fd(const ch
 	}
 	madvise(*addr, fd_size, MADV_HUGEPAGE);
 
-	for (size_t i = 0; i < fd_size; i++)
-		FORCE_READ((*addr + i));
+	for (size_t i = 0; i < fd_size; i++) {
+		char *addr2 = *addr + i;
+
+		FORCE_READ(*addr2);
+	}
 
 	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
 		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-fix-force_read-to-read-input-value-correctly
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -23,7 +23,7 @@
  * anything with it in order to trigger a read page fault. We therefore must use
  * volatile to stop the compiler from optimising this away.
  */
-#define FORCE_READ(x) (*(volatile typeof(x) *)x)
+#define FORCE_READ(x) (*(const volatile typeof(x) *)&(x))
 
 extern unsigned int __page_size;
 extern unsigned int __page_shift;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch
selftests-mm-mark-all-functions-static-in-split_huge_page_testc.patch
selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch
selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix.patch
selftests-mm-add-check_after_split_folio_orders-helper.patch
selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

