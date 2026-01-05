Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8C92DCBFD;
	Mon,  5 Jan 2026 21:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647505; cv=none; b=JH1ZCRAvpekCshOEfBaKiO+j2KIHHCJzE3mPVxVwtziIOcN+NmMvqL3W1zi5vdyJoXBqSX3FgvKgTZrHSAxKYvsniIaXWu4Zawsbl5yjDjFo68oVnYa6pSgHTMgk8aYSpNkZmoFtkAzUs6JKz9imMiozbI23SZkrPxdiK3LKB5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647505; c=relaxed/simple;
	bh=um+0hVOV/mq3rat3zLY0jIw5JcgawgkPap4SkUOrQeA=;
	h=Date:To:From:Subject:Message-Id; b=sp55ovGorXRBAqy9w31HWadvqMnen4OWR3RuEvHWgu4xd01pW2h37fcHGa6Y0kYfWo22wt/STAxCH/H8SiVbM6qYuFLOZw9XcjTT4Oj0njYIzS3Gk0cJR95EAId3iQJkt5uQfMqy2YZVWYs/gai/BDeqelKoaTxeFqw0Jo+MOw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IZ/tmnJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IZ/tmnJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDE3C116D0;
	Mon,  5 Jan 2026 21:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767647504;
	bh=um+0hVOV/mq3rat3zLY0jIw5JcgawgkPap4SkUOrQeA=;
	h=Date:To:From:Subject:From;
	b=IZ/tmnJBNmlhIiaq39+eYaTPyZIxBvUAF258Kfj+YzjZlFMbULwooFvD8b+DT7waX
	 3PF0M6y5pLS4cjPvrG0JBhLJdgvVUqn1s0RzNQHDPOmv3rkHctax6uZg2rqPpLhW2V
	 YbgmBtJkE6RMIsKtT9d3178OMX8y8f5fj60k0omk=
Date: Mon, 05 Jan 2026 13:11:44 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,pfalcato@suse.de,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,aha310510@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch added to mm-hotfixes-unstable branch
Message-Id: <20260105211144.AEDE3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add tests for !tgt, src mremap() merges
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: add tests for !tgt, src mremap() merges
Date: Mon, 5 Jan 2026 20:11:48 +0000

Test that mremap()'ing a VMA into a position such that the target VMA on
merge is unfaulted and the source faulted is correctly performed.

We cover 4 cases:

    1. Previous VMA unfaulted:

                  copied -----|
                              v
            |-----------|.............|
            | unfaulted |(faulted VMA)|
            |-----------|.............|
                 prev

    target = prev, expand prev to cover.

    2. Next VMA unfaulted:

                  copied -----|
                              v
                        |.............|-----------|
                        |(faulted VMA)| unfaulted |
                        |.............|-----------|
                                          next

    target = next, expand next to cover.

    3. Both adjacent VMAs unfaulted:

                  copied -----|
                              v
            |-----------|.............|-----------|
            | unfaulted |(faulted VMA)| unfaulted |
            |-----------|.............|-----------|
                 prev                      next

    target = prev, expand prev to cover.

    4. prev unfaulted, next faulted:

                  copied -----|
                              v
            |-----------|.............|-----------|
            | unfaulted |(faulted VMA)|  faulted  |
            |-----------|.............|-----------|
                 prev                      next

    target = prev, expand prev to cover. Essentially equivalent to 3, but
    with additional requirement that next's anon_vma is the same as the
    copied VMA's.

Each of these are performed with MREMAP_DONTUNMAP set, which will cause a
KASAN assert for UAF or an assert on zero refcount anon_vma if a bug
exists with correctly propagating anon_vma state in each scenario.

Link: https://lkml.kernel.org/r/f903af2930c7c2c6e0948c886b58d0f42d8e8ba3.1767638272.git.lorenzo.stoakes@oracle.com
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |  232 +++++++++++++++++++++++++++
 1 file changed, 232 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-tests-for-tgt-src-mremap-merges
+++ a/tools/testing/selftests/mm/merge.c
@@ -1171,4 +1171,236 @@ TEST_F(merge, mremap_correct_placed_faul
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
+TEST_F(merge, mremap_faulted_to_unfaulted_prev)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b;
+
+	/*
+	 * mremap() such that A and B merge:
+	 *
+	 *                             |------------|
+	 *                             |    \       |
+	 *           |-----------|     |    /  |---------|
+	 *           | unfaulted |     v    \  | faulted |
+	 *           |-----------|          /  |---------|
+	 *                 B                \       A
+	 */
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size + 3 * page_size],
+		     3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+	/* Fault it in. */
+	ptr_a[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMA B in position,
+	 * unfaulted.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/*
+	 * Now move VMA A into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b;
+
+	/*
+	 * mremap() such that A and B merge:
+	 *
+	 *      |---------------------------|
+	 *      |                   \       |
+	 *      |    |-----------|  /  |---------|
+	 *      v    | unfaulted |  \  | faulted |
+	 *           |-----------|  /  |---------|
+	 *                 B        \       A
+	 *
+	 * Then unmap VMA A to trigger the bug.
+	 */
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+	/* Fault it in. */
+	ptr_a[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMA B in position,
+	 * unfaulted.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size + 3 * page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/*
+	 * Now move VMA A into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_a = mremap(ptr_a, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size]);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 6 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b, *ptr_c;
+
+	/*
+	 * mremap() with MREMAP_DONTUNMAP such that A, B and C merge:
+	 *
+	 *                  |---------------------------|
+	 *                  |                   \       |
+	 * |-----------|    |    |-----------|  /  |---------|
+	 * | unfaulted |    v    | unfaulted |  \  | faulted |
+	 * |-----------|         |-----------|  /  |---------|
+	 *       A                     C        \        B
+	 */
+
+	/* Map VMA B into place. */
+	ptr_b = mmap(&self->carveout[page_size + 3 * page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+	/* Fault it in. */
+	ptr_b[0] = 'x';
+
+	/*
+	 * Now move it out of the way so we can place VMAs A, C in position,
+	 * unfaulted.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* Map VMA A into place. */
+
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/* Map VMA C into place. */
+	ptr_c = mmap(&self->carveout[page_size + 3 * page_size + 3 * page_size],
+		     3 * page_size, PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_c, MAP_FAILED);
+
+	/*
+	 * Now move VMA B into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+}
+
+TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *ptr_a, *ptr_b, *ptr_bc;
+
+	/*
+	 * mremap() with MREMAP_DONTUNMAP such that A, B and C merge:
+	 *
+	 *                  |---------------------------|
+	 *                  |                   \       |
+	 * |-----------|    |    |-----------|  /  |---------|
+	 * | unfaulted |    v    |  faulted  |  \  | faulted |
+	 * |-----------|         |-----------|  /  |---------|
+	 *       A                     C        \       B
+	 */
+
+	/*
+	 * Map VMA B and C into place. We have to map them together so their
+	 * anon_vma is the same and the vma->vm_pgoff's are correctly aligned.
+	 */
+	ptr_bc = mmap(&self->carveout[page_size + 3 * page_size],
+		      3 * page_size + 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_bc, MAP_FAILED);
+
+	/* Fault it in. */
+	ptr_bc[0] = 'x';
+
+	/*
+	 * Now move VMA B out the way (splitting VMA BC) so we can place VMA A
+	 * in position, unfaulted, and leave the remainder of the VMA we just
+	 * moved in place, faulted, as VMA C.
+	 */
+	ptr_b = mremap(ptr_bc, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE, &self->carveout[20 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* Map VMA A into place. */
+	ptr_a = mmap(&self->carveout[page_size], 3 * page_size,
+		     PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr_a, MAP_FAILED);
+
+	/*
+	 * Now move VMA B into position with MREMAP_DONTUNMAP to catch incorrect
+	 * anon_vma propagation.
+	 */
+	ptr_b = mremap(ptr_b, 3 * page_size, 3 * page_size,
+		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
+		       &self->carveout[page_size + 3 * page_size]);
+	ASSERT_NE(ptr_b, MAP_FAILED);
+
+	/* The VMAs should have merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch

