Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E214A2905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126201; cv=none; b=EmVNzFRe6DINk0HOhVpN1tvIG4wO6MD7O+kxKRlE8Ns/Gek0BA6ngTJlNsIKq/GDwh9PrJIp1/ULiS8pV6oVnYVj+m16jyQOHyknCiSvaD5d39BMJNoBjP57SQ4Oq9yWChbctdOyOaufOCtVu8Lxka54nidT9rxX5OQ0joTRVMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126201; c=relaxed/simple;
	bh=19RbCJESXlDq5vdG0I4sAabj4Q9uFK8s9sqBhpJlKZU=;
	h=Date:To:From:Subject:Message-Id; b=XhMFKLehY7rt9PupIN6xCycbcgDXJUp0VyzrK6PAkoVVntjmvaLQNIPC0USuVH0pv634eXgE3TXgR12reYLa0uNWpwqdA0srWohB+g23cbeMVnAuuk3gnDO/RLRmEgoQ+dVqGRg6jt2oAm0KznYevzLTmqB6AOKLGK8Da6ebOCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aG5Aigkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aG5Aigkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68619C4CEE3;
	Thu, 10 Jul 2025 05:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126200;
	bh=19RbCJESXlDq5vdG0I4sAabj4Q9uFK8s9sqBhpJlKZU=;
	h=Date:To:From:Subject:From;
	b=aG5Aigkk9xsR253Rqc+6vryklLcZhhSlfqbMM4qN+NTZu4b/nVfg7bCa5bfoBsB0i
	 4YPSkygCt4xbYVLpkAZQQI5df2VN+k6VskEXVz9ceiJqwaAZbrurvCreobhwZgc0mb
	 ZJVuA6lYmKYggQDThMW1n0MyuPMbSshMQ63WFk2c=
Date: Wed, 09 Jul 2025 22:43:19 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch removed from -mm tree
Message-Id: <20250710054320.68619C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests: add VMA merge tests for KSM merge
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: add VMA merge tests for KSM merge
Date: Thu, 29 May 2025 18:15:48 +0100

Add test to assert that we have now allowed merging of VMAs when KSM
merging-by-default has been set by prctl(PR_SET_MEMORY_MERGE, ...).

We simply perform a trivial mapping of adjacent VMAs expecting a merge,
however prior to recent changes implementing this mode earlier than
before, these merges would not have succeeded.

Assert that we have fixed this!

Link: https://lkml.kernel.org/r/6dec7aabf062c6b121cfac992c9c716cefdda00c.1748537921.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Tested-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   78 +++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-vma-merge-tests-for-ksm-merge
+++ a/tools/testing/selftests/mm/merge.c
@@ -2,11 +2,13 @@
 
 #define _GNU_SOURCE
 #include "../kselftest_harness.h"
+#include <linux/prctl.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <sys/prctl.h>
 #include <sys/syscall.h>
 #include <sys/wait.h>
 #include <linux/perf_event.h>
@@ -34,6 +36,11 @@ FIXTURE_TEARDOWN(merge)
 {
 	ASSERT_EQ(munmap(self->carveout, 12 * self->page_size), 0);
 	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	/*
+	 * Clear unconditionally, as some tests set this. It is no issue if this
+	 * fails (KSM may be disabled for instance).
+	 */
+	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
 }
 
 TEST_F(merge, mprotect_unfaulted_left)
@@ -498,4 +505,75 @@ out:
 	remove(probe_file);
 }
 
+TEST_F(merge, ksm_merge)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2;
+	int err;
+
+	/*
+	 * Map two R/W immediately adjacent to one another, they should
+	 * trivially merge:
+	 *
+	 * |-----------|-----------|
+	 * |    R/W    |    R/W    |
+	 * |-----------|-----------|
+	 *      ptr         ptr2
+	 */
+
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
+		    PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
+
+	/* Unmap the second half of this merged VMA. */
+	ASSERT_EQ(munmap(ptr2, page_size), 0);
+
+	/* OK, now enable global KSM merge. We clear this on test teardown. */
+	err = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
+	if (err == -1) {
+		int errnum = errno;
+
+		/* Only non-failure case... */
+		ASSERT_EQ(errnum, EINVAL);
+		/* ...but indicates we should skip. */
+		SKIP(return, "KSM memory merging not supported, skipping.");
+	}
+
+	/*
+	 * Now map a VMA adjacent to the existing that was just made
+	 * VM_MERGEABLE, this should merge as well.
+	 */
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
+		    PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
+
+	/* Now this VMA altogether. */
+	ASSERT_EQ(munmap(ptr, 2 * page_size), 0);
+
+	/* Try the same operation as before, asserting this also merges fine. */
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
+		    PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

