Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84535142E67
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744161475; cv=none; b=q95nU4vM+OTkU0VtHBSma3k2V+URSrndfS6S63p2OQwjQImkHOy1uh4BAQ2HXSqXGkzPBubqiMd0gp+kWLK/lRqxqUkoOnwk6eqYMmKexBYJMXqj7AGH/sd/kBlSPXSTiT9KOoEzgcAoi1Su7WId0SkVxROY3a6TAVXZLV0nAjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744161475; c=relaxed/simple;
	bh=9MH8UIUD4fK+FtMTA/ZTd6ByEO/nmAEPO6ghwockZR4=;
	h=Date:To:From:Subject:Message-Id; b=oaxrUXpuF3KHNyS76VMwUsTZswGraM8n6skwUYMJj+8eI+jUSRemsg2JLIldxdYjzdDzQWkTIGfPXISXeqPR6tEyQDUC3rSDOzWWplsx15VHTu6EB4lFLA/HMfrG2r8RF//LBDvhr2lbT4YRzmt2iWuCLIs5tfPRJpW++h2622c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T3mTNYoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T3mTNYoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C52C4CEE5;
	Wed,  9 Apr 2025 01:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744161475;
	bh=9MH8UIUD4fK+FtMTA/ZTd6ByEO/nmAEPO6ghwockZR4=;
	h=Date:To:From:Subject:From;
	b=T3mTNYoXnulcostNXPrPoAn38SYdKBY6GYBUUu+cW5vR6bKPZ2MunNNSpYQYbOOuT
	 sUKud1QoKgLeDUC5VoFVNKl+0AvFCg6mf6/tcTHxC8xBLdDHDkkTCyGHx5VVJqAAut
	 KSuqVmHoFJi9j6UF6uVeemWmvJ6VxfL6EacYy0fA=
Date: Tue, 08 Apr 2025 18:17:54 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,riel@surriel.com,richard.weiyang@gmail.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch added to mm-new branch
Message-Id: <20250409011755.40C52C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: assert that anon merge cases behave as expected
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch

This patch will later appear in the mm-new branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: assert that anon merge cases behave as expected
Date: Tue, 8 Apr 2025 10:29:33 +0100

Prior to the recently applied commit that permits this merge,
mprotect()'ing a faulted VMA, adjacent to an unfaulted VMA, such that the
two share characteristics would fail to merge due to what appear to be
unintended consequences of commit 965f55dea0e3 ("mmap: avoid merging
cloned VMAs").

Now we have fixed this bug, assert that we can indeed merge anonymous VMAs
this way.

Also assert that forked source/target VMAs are equally rejected. 
Previously, all empty target anon merges with one VMA faulted and the
other unfaulted would be rejected incorrectly, now we ensure that unforked
merge, but forked do not.

Additionally, add the new test file to the MEMORY MAPPING section in
MAINTAINERS, as these tests are explicitly memory mapping related.

Link: https://lkml.kernel.org/r/2b69330274a3b71721f7042c5eabe91143934415.1744104124.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                               |    1 
 tools/testing/selftests/mm/.gitignore     |    1 
 tools/testing/selftests/mm/Makefile       |    1 
 tools/testing/selftests/mm/merge.c        |  455 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |    4 
 5 files changed, 462 insertions(+)

--- a/MAINTAINERS~tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected
+++ a/MAINTAINERS
@@ -15563,6 +15563,7 @@ F:	mm/mseal.c
 F:	mm/vma.c
 F:	mm/vma.h
 F:	mm/vma_internal.h
+F:	tools/testing/selftests/mm/merge.c
 F:	tools/testing/vma/
 
 MEMORY TECHNOLOGY DEVICES (MTD)
--- a/tools/testing/selftests/mm/.gitignore~tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected
+++ a/tools/testing/selftests/mm/.gitignore
@@ -58,3 +58,4 @@ hugetlb_dio
 pkey_sighandler_tests_32
 pkey_sighandler_tests_64
 guard-regions
+merge
--- a/tools/testing/selftests/mm/Makefile~tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected
+++ a/tools/testing/selftests/mm/Makefile
@@ -98,6 +98,7 @@ TEST_GEN_FILES += hugetlb_madv_vs_map
 TEST_GEN_FILES += hugetlb_dio
 TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
+TEST_GEN_FILES += merge
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/merge.c a/tools/testing/selftests/mm/merge.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/merge.c
@@ -0,0 +1,455 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#define _GNU_SOURCE
+#include "../kselftest_harness.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include "vm_util.h"
+
+FIXTURE(merge)
+{
+	unsigned int page_size;
+	char *carveout;
+	struct procmap_fd procmap;
+};
+
+FIXTURE_SETUP(merge)
+{
+	self->page_size = psize();
+	/* Carve out PROT_NONE region to map over. */
+	self->carveout = mmap(NULL, 12 * self->page_size, PROT_NONE,
+			      MAP_ANON | MAP_PRIVATE, -1, 0);
+	ASSERT_NE(self->carveout, MAP_FAILED);
+	/* Setup PROCMAP_QUERY interface. */
+	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
+}
+
+FIXTURE_TEARDOWN(merge)
+{
+	ASSERT_EQ(munmap(self->carveout, 12 * self->page_size), 0);
+	ASSERT_EQ(close_procmap(&self->procmap), 0);
+}
+
+TEST_F(merge, mprotect_unfaulted_left)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr;
+
+	/*
+	 * Map 10 pages of R/W memory within. MAP_NORESERVE so we don't hit
+	 * merge failure due to lack of VM_ACCOUNT flag by mistake.
+	 *
+	 * |-----------------------|
+	 * |       unfaulted       |
+	 * |-----------------------|
+	 */
+	ptr = mmap(&carveout[page_size], 10 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED | MAP_NORESERVE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	/*
+	 * Now make the first 5 pages read-only, splitting the VMA:
+	 *
+	 *      RO          RW
+	 * |-----------|-----------|
+	 * | unfaulted | unfaulted |
+	 * |-----------|-----------|
+	 */
+	ASSERT_EQ(mprotect(ptr, 5 * page_size, PROT_READ), 0);
+	/*
+	 * Fault in the first of the last 5 pages so it gets an anon_vma and
+	 * thus the whole VMA becomes 'faulted':
+	 *
+	 *      RO          RW
+	 * |-----------|-----------|
+	 * | unfaulted |  faulted  |
+	 * |-----------|-----------|
+	 */
+	ptr[5 * page_size] = 'x';
+	/*
+	 * Now mprotect() the RW region read-only, we should merge (though for
+	 * ~15 years we did not! :):
+	 *
+	 *             RO
+	 * |-----------------------|
+	 * |        faulted        |
+	 * |-----------------------|
+	 */
+	ASSERT_EQ(mprotect(&ptr[5 * page_size], 5 * page_size, PROT_READ), 0);
+
+	/* Assert that the merge succeeded using PROCMAP_QUERY. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
+TEST_F(merge, mprotect_unfaulted_right)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr;
+
+	/*
+	 * |-----------------------|
+	 * |       unfaulted       |
+	 * |-----------------------|
+	 */
+	ptr = mmap(&carveout[page_size], 10 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED | MAP_NORESERVE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	/*
+	 * Now make the last 5 pages read-only, splitting the VMA:
+	 *
+	 *      RW          RO
+	 * |-----------|-----------|
+	 * | unfaulted | unfaulted |
+	 * |-----------|-----------|
+	 */
+	ASSERT_EQ(mprotect(&ptr[5 * page_size], 5 * page_size, PROT_READ), 0);
+	/*
+	 * Fault in the first of the first 5 pages so it gets an anon_vma and
+	 * thus the whole VMA becomes 'faulted':
+	 *
+	 *      RW          RO
+	 * |-----------|-----------|
+	 * |  faulted  | unfaulted |
+	 * |-----------|-----------|
+	 */
+	ptr[0] = 'x';
+	/*
+	 * Now mprotect() the RW region read-only, we should merge:
+	 *
+	 *             RO
+	 * |-----------------------|
+	 * |        faulted        |
+	 * |-----------------------|
+	 */
+	ASSERT_EQ(mprotect(ptr, 5 * page_size, PROT_READ), 0);
+
+	/* Assert that the merge succeeded using PROCMAP_QUERY. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
+TEST_F(merge, mprotect_unfaulted_both)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr;
+
+	/*
+	 * |-----------------------|
+	 * |       unfaulted       |
+	 * |-----------------------|
+	 */
+	ptr = mmap(&carveout[2 * page_size], 9 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED | MAP_NORESERVE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	/*
+	 * Now make the first and last 3 pages read-only, splitting the VMA:
+	 *
+	 *      RO          RW          RO
+	 * |-----------|-----------|-----------|
+	 * | unfaulted | unfaulted | unfaulted |
+	 * |-----------|-----------|-----------|
+	 */
+	ASSERT_EQ(mprotect(ptr, 3 * page_size, PROT_READ), 0);
+	ASSERT_EQ(mprotect(&ptr[6 * page_size], 3 * page_size, PROT_READ), 0);
+	/*
+	 * Fault in the first of the middle 3 pages so it gets an anon_vma and
+	 * thus the whole VMA becomes 'faulted':
+	 *
+	 *      RO          RW          RO
+	 * |-----------|-----------|-----------|
+	 * | unfaulted |  faulted  | unfaulted |
+	 * |-----------|-----------|-----------|
+	 */
+	ptr[3 * page_size] = 'x';
+	/*
+	 * Now mprotect() the RW region read-only, we should merge:
+	 *
+	 *             RO
+	 * |-----------------------|
+	 * |        faulted        |
+	 * |-----------------------|
+	 */
+	ASSERT_EQ(mprotect(&ptr[3 * page_size], 3 * page_size, PROT_READ), 0);
+
+	/* Assert that the merge succeeded using PROCMAP_QUERY. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 9 * page_size);
+}
+
+TEST_F(merge, mprotect_faulted_left_unfaulted_right)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr;
+
+	/*
+	 * |-----------------------|
+	 * |       unfaulted       |
+	 * |-----------------------|
+	 */
+	ptr = mmap(&carveout[2 * page_size], 9 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED | MAP_NORESERVE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	/*
+	 * Now make the last 3 pages read-only, splitting the VMA:
+	 *
+	 *             RW               RO
+	 * |-----------------------|-----------|
+	 * |       unfaulted       | unfaulted |
+	 * |-----------------------|-----------|
+	 */
+	ASSERT_EQ(mprotect(&ptr[6 * page_size], 3 * page_size, PROT_READ), 0);
+	/*
+	 * Fault in the first of the first 6 pages so it gets an anon_vma and
+	 * thus the whole VMA becomes 'faulted':
+	 *
+	 *             RW               RO
+	 * |-----------------------|-----------|
+	 * |       unfaulted       | unfaulted |
+	 * |-----------------------|-----------|
+	 */
+	ptr[0] = 'x';
+	/*
+	 * Now make the first 3 pages read-only, splitting the VMA:
+	 *
+	 *      RO          RW          RO
+	 * |-----------|-----------|-----------|
+	 * |  faulted  |  faulted  | unfaulted |
+	 * |-----------|-----------|-----------|
+	 */
+	ASSERT_EQ(mprotect(ptr, 3 * page_size, PROT_READ), 0);
+	/*
+	 * Now mprotect() the RW region read-only, we should merge:
+	 *
+	 *             RO
+	 * |-----------------------|
+	 * |        faulted        |
+	 * |-----------------------|
+	 */
+	ASSERT_EQ(mprotect(&ptr[3 * page_size], 3 * page_size, PROT_READ), 0);
+
+	/* Assert that the merge succeeded using PROCMAP_QUERY. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 9 * page_size);
+}
+
+TEST_F(merge, mprotect_unfaulted_left_faulted_right)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr;
+
+	/*
+	 * |-----------------------|
+	 * |       unfaulted       |
+	 * |-----------------------|
+	 */
+	ptr = mmap(&carveout[2 * page_size], 9 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED | MAP_NORESERVE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	/*
+	 * Now make the first 3 pages read-only, splitting the VMA:
+	 *
+	 *      RO                RW
+	 * |-----------|-----------------------|
+	 * | unfaulted |       unfaulted       |
+	 * |-----------|-----------------------|
+	 */
+	ASSERT_EQ(mprotect(ptr, 3 * page_size, PROT_READ), 0);
+	/*
+	 * Fault in the first of the last 6 pages so it gets an anon_vma and
+	 * thus the whole VMA becomes 'faulted':
+	 *
+	 *      RO                RW
+	 * |-----------|-----------------------|
+	 * | unfaulted |        faulted        |
+	 * |-----------|-----------------------|
+	 */
+	ptr[3 * page_size] = 'x';
+	/*
+	 * Now make the last 3 pages read-only, splitting the VMA:
+	 *
+	 *      RO          RW          RO
+	 * |-----------|-----------|-----------|
+	 * | unfaulted |  faulted  |  faulted  |
+	 * |-----------|-----------|-----------|
+	 */
+	ASSERT_EQ(mprotect(&ptr[6 * page_size], 3 * page_size, PROT_READ), 0);
+	/*
+	 * Now mprotect() the RW region read-only, we should merge:
+	 *
+	 *             RO
+	 * |-----------------------|
+	 * |        faulted        |
+	 * |-----------------------|
+	 */
+	ASSERT_EQ(mprotect(&ptr[3 * page_size], 3 * page_size, PROT_READ), 0);
+
+	/* Assert that the merge succeeded using PROCMAP_QUERY. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 9 * page_size);
+}
+
+TEST_F(merge, forked_target_vma)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	pid_t pid;
+	char *ptr, *ptr2;
+	int i;
+
+	/*
+	 * |-----------|
+	 * | unfaulted |
+	 * |-----------|
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Fault in process.
+	 *
+	 * |-----------|
+	 * |  faulted  |
+	 * |-----------|
+	 */
+	ptr[0] = 'x';
+
+	pid = fork();
+	ASSERT_NE(pid, -1);
+
+	if (pid != 0) {
+		wait(NULL);
+		return;
+	}
+
+	/* Child process below: */
+
+	/* Reopen for child. */
+	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
+
+	/* unCOWing everything does not cause the AVC to go away. */
+	for (i = 0; i < 5 * page_size; i += page_size)
+		ptr[i] = 'x';
+
+	/*
+	 * Map in adjacent VMA in child.
+	 *
+	 *     forked
+	 * |-----------|-----------|
+	 * |  faulted  | unfaulted |
+	 * |-----------|-----------|
+	 *      ptr         ptr2
+	 */
+	ptr2 = mmap(&ptr[5 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Make sure not merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
+}
+
+TEST_F(merge, forked_source_vma)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	pid_t pid;
+	char *ptr, *ptr2;
+	int i;
+
+	/*
+	 * |-----------|------------|
+	 * | unfaulted | <unmapped> |
+	 * |-----------|------------|
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED | MAP_NORESERVE, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Fault in process.
+	 *
+	 * |-----------|------------|
+	 * |  faulted  | <unmapped> |
+	 * |-----------|------------|
+	 */
+	ptr[0] = 'x';
+
+	pid = fork();
+	ASSERT_NE(pid, -1);
+
+	if (pid != 0) {
+		wait(NULL);
+		return;
+	}
+
+	/* Child process below: */
+
+	/* Reopen for child. */
+	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
+
+	/* unCOWing everything does not cause the AVC to go away. */
+	for (i = 0; i < 5 * page_size; i += page_size)
+		ptr[i] = 'x';
+
+	/*
+	 * Map in adjacent VMA in child, ptr2 after ptr, but incompatible.
+	 *
+	 *   forked RW      RWX
+	 * |-----------|-----------|
+	 * |  faulted  | unfaulted |
+	 * |-----------|-----------|
+	 *      ptr        ptr2
+	 */
+	ptr2 = mmap(&carveout[6 * page_size], 5 * page_size, PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED | MAP_NORESERVE, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Make sure not merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr2));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr2);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr2 + 5 * page_size);
+
+	/*
+	 * Now mprotect forked region to RWX so it becomes the source for the
+	 * merge to unfaulted region:
+	 *
+	 *  forked RWX      RWX
+	 * |-----------|-----------|
+	 * |  faulted  | unfaulted |
+	 * |-----------|-----------|
+	 *      ptr         ptr2
+	 *
+	 * This should NOT result in a merge, as ptr was forked.
+	 */
+	ASSERT_EQ(mprotect(ptr, 5 * page_size, PROT_READ | PROT_WRITE | PROT_EXEC), 0);
+	/* Again, make sure not merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr2));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr2);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr2 + 5 * page_size);
+}
+
+TEST_HARNESS_MAIN
--- a/tools/testing/selftests/mm/run_vmtests.sh~tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -79,6 +79,8 @@ separated by spaces:
 	test prctl(PR_SET_MDWE, ...)
 - page_frag
 	test handling of page fragment allocation and freeing
+- vma_merge
+	test VMA merge cases behave as expected
 
 example: ./run_vmtests.sh -t "hmm mmap ksm"
 EOF
@@ -421,6 +423,8 @@ CATEGORY="madv_guard" run_test ./guard-r
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+CATEGORY="vma_merge" run_test ./merge
+
 if [ -x ./memfd_secret ]
 then
 (echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-add-give_up_on_oom-option-on-modify-merge-use-in-uffd-release.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch

