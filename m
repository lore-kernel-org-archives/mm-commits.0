Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5668B1EB19B
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 00:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775005031; cv=none; b=KW7AjsJyU0lxXb3kK6IUksZYjnQht5SzoHQxVfUPcOBLItYWwIvjMoc2lhBnw30DB3gL2QKYjECcdjc0WOEu0UaAm1ifXs+jSFVEzBSR71LRFyNRObpasoZif8Z9LJxtW1RPA9/gl1t6p+AGHlKK3nE60PEjtIPT9oMFuAF8Nk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775005031; c=relaxed/simple;
	bh=LMcBEAGySyJAjPb6IlDqTRUGgQgqcza9WA9SE1wkwFs=;
	h=Date:To:From:Subject:Message-Id; b=LMPGj/1V6wGVNKKbS09G7tADSC5eGCk0NybEn97Yal6tBNvMn3/XTGzIOMwhzjJ5fRUC5Br6nogYJV1tnl/8BZvWLi5klndHTF9+9gKmYnI4Oo1JMl9+pwAvijBpZoB3kX0UzS2wFCDjPDxyvIpzZPgPSx3QSQvrNlphGJnZftI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gGYDPJuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gGYDPJuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22848C19423;
	Wed,  1 Apr 2026 00:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775005031;
	bh=LMcBEAGySyJAjPb6IlDqTRUGgQgqcza9WA9SE1wkwFs=;
	h=Date:To:From:Subject:From;
	b=gGYDPJuM2XFeJpGNQgROHOxrgEkPXnQs1cMP2nOai/D7riWhPA8UWO3Hq4NQdO3Up
	 RRxJkLZvjKgTQJId1Iv/Etgi1vCHlzCliPjuzjvCLmSDuePZ6FkOoKdl5IGvFVQ7t6
	 07Sy9CjA7sgYU+Eengj7Nwr18VSRcoesEqCUMa2s=
Date: Tue, 31 Mar 2026 17:57:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch added to mm-new branch
Message-Id: <20260401005711.22848C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add merge test for partial msealed range
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch

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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools/testing/selftests: add merge test for partial msealed range
Date: Tue, 31 Mar 2026 08:36:27 +0100

Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
an issue in the loop which iterates through VMAs applying mseal, which was
triggered by mseal()'ing a range of VMAs where the second was mseal()'d
and the first mergeable with it, once mseal()'d.

Add a regression test to assert that this behaviour is correct.  We place
it in the merge selftests as this is strictly an issue with merging (via a
vma_modify() invocation).

It also asserts that mseal()'d ranges are correctly merged as you'd
expect.

The test is implemented such that it is skipped if mseal() is not
available on the system.

Link: https://lkml.kernel.org/r/20260331073627.50010-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   89 +++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-merge-test-for-partial-msealed-range
+++ a/tools/testing/selftests/mm/merge.c
@@ -2,6 +2,7 @@
 
 #define _GNU_SOURCE
 #include "kselftest_harness.h"
+#include <asm-generic/unistd.h>
 #include <linux/prctl.h>
 #include <fcntl.h>
 #include <stdio.h>
@@ -48,6 +49,19 @@ static pid_t do_fork(struct procmap_fd *
 	return 0;
 }
 
+#ifdef __NR_mseal
+static int sys_mseal(void *ptr, size_t len, unsigned long flags)
+{
+	return syscall(__NR_mseal, (unsigned long)ptr, len, flags);
+}
+#else
+static int sys_mseal(void *ptr, size_t len, unsigned long flags)
+{
+	errno = ENOSYS;
+	return -1;
+}
+#endif
+
 FIXTURE_SETUP(merge)
 {
 	self->page_size = psize();
@@ -1217,6 +1231,81 @@ TEST_F(merge, mremap_correct_placed_faul
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
+TEST_F(merge, merge_vmas_with_mseal)
+{
+	unsigned int page_size = self->page_size;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2, *ptr3;
+	/* We need our own as cannot munmap() once sealed. */
+	char *carveout;
+
+	/* Invalid mseal() call to see if implemented. */
+	ASSERT_EQ(sys_mseal(NULL, 0, ~0UL), -1);
+	if (errno == ENOSYS)
+		SKIP(return, "mseal not supported, skipping.");
+
+	/* Map carveout. */
+	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
+			MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(carveout, MAP_FAILED);
+
+	/*
+	 * Map 3 separate VMAs:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWE    |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
+		    PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/*
+	 * mseal the second VMA:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ASSERT_EQ(sys_mseal(ptr2, 5 * page_size, 0), 0);
+
+	/* Make first VMA mergeable upon mseal. */
+	ASSERT_EQ(mprotect(ptr, 5 * page_size,
+			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
+	/*
+	 * At this point we have:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RWE    |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 *
+	 * Now mseal all of the VMAs.
+	 */
+	ASSERT_EQ(sys_mseal(ptr, 15 * page_size, 0), 0);
+
+	/*
+	 * We should end up with:
+	 *
+	 * |-----------------------|-----------|
+	 * |          RWES         |    ROS    |
+	 * |-----------------------|-----------|
+	 *            ptr               ptr3
+	 */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-khugepaged-fix-issue-with-tracking-lock.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch
tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch
tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch

