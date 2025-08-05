Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08D2524F
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 21:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754428880; cv=none; b=GddaRcfJcEYP/xRKAYLcvzu1lykjes/Td/dJnlkMaEd+d1Bj6Sl6Bx206Icb7z+HNzTMS9yyQvGj4zRdOYW5N1DbjRRWPF0VFVqR7jWWUmHY7aKrpm1TLSqJYNED52OvhUNNLf+BllP/o8QKJLOAkS0x7Qn3u+z1NE9+mtIr/G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754428880; c=relaxed/simple;
	bh=GFK3KqH/3DHsE1MXDwssZFUZIkPfxxFJM7kZpwM8Khk=;
	h=Date:To:From:Subject:Message-Id; b=PGWa9uQc5StuIA7EZTo3poUi3UXbTcZ2NcZnz9qIJ1d2iK3B63lD+yUer8u1Gh3Dx8qhc0BXv/LpyFat1WG/ogf0dsZ1WfLjqKOqBwwCF431L9CtoPo6xOw2Lm84dtReRK/SlhvIUHW1Aa+t3cC6GAzSpoID1Ke0clSPoAQUwgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YLlWEsV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YLlWEsV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EA0C4CEF0;
	Tue,  5 Aug 2025 21:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754428879;
	bh=GFK3KqH/3DHsE1MXDwssZFUZIkPfxxFJM7kZpwM8Khk=;
	h=Date:To:From:Subject:From;
	b=YLlWEsV5OidpubrkVmRbpfFWEp0qeEPfVgu6foVCzbSD+I8zpSz1uF0vIOApX2bOw
	 l6HOnehWuJQUIbEgfwXalVmi14zyNq2Ap29+BGBpyUajKp9rkF/ZJNSQs7Rm28Ik1b
	 NobKJwtIzLDKjGXjygVPgWV+TVb4tDjrAmYVxhxM=
Date: Tue, 05 Aug 2025 14:21:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shuah@kernel.org,ryncsn@gmail.com,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,broonie@kernel.org,brauner@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-force_read-to-read-input-value-correctly.patch added to mm-hotfixes-unstable branch
Message-Id: <20250805212119.63EA0C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix FORCE_READ to read input value correctly.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-force_read-to-read-input-value-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-force_read-to-read-input-value-correctly.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: fix FORCE_READ to read input value correctly.
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
Cc: wang lian <lianux.mm@gmail.com>,
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
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

selftests-mm-fix-force_read-to-read-input-value-correctly.patch

