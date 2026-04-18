Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAE5370D5B
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498920; cv=none; b=Umd/bqRlQB9vpHJPpzR3jkjr1BKejxOcZ9xDuCG0FIlz44I5/uv/s+wXiEgHuzN6e8zM9oMUc7ll1lqv5hlxdI/1wp04M7ya7rQuUVMEcyPEgW99K9UMLJZA9l88oWJeW5108dJNS3yKSb91TCgV536TUrP3AEYcekSpS/O7UK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498920; c=relaxed/simple;
	bh=85BKBR9FrDEhty+qG2qXLVWX9XetWPRfTwMfCGNBunw=;
	h=Date:To:From:Subject:Message-Id; b=g1pRkN2kdu65nuojpiSz5Rb19oH2LP05MDRx14B4d8nsJBizlNV4qWsdVFPcpoFgmEVu+mITzuRcc4wInAFAntDnMMm7nRuqFyXMBDqTI1a2vDJ2UXpVX/g9BJ7qBfCx3eHPe4tyVdZiCaQNIw27xqVB6al0T+yS617hRpq3Ciw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U7cpjqH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U7cpjqH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A476C19424;
	Sat, 18 Apr 2026 07:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498920;
	bh=85BKBR9FrDEhty+qG2qXLVWX9XetWPRfTwMfCGNBunw=;
	h=Date:To:From:Subject:From;
	b=U7cpjqH4F/Bd2v1W9IBmOOFd8YPObAT8dufz/lM45cAP8Sd0JeID3fb+ceBpZBKmW
	 fbvyz6RhcQt3q8HiHaISUJ1o/GvFw2MnF2IWGkWrhgIYjGPQXOnWJD/p4/G0ASzpom
	 1aCgPE5qMNG9GTx34MAB9FM1pYGsiny3NoRkDD4o=
Date: Sat, 18 Apr 2026 00:55:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch removed from -mm tree
Message-Id: <20260418075519.7A476C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests: add merge test for partial msealed range
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[rppt@kernel.org: fix inclusions, to fix handle_uprobe_upon_merged_vma()]
  Link: https://lore.kernel.org/ac_mCIUQWRAbuH8F@kernel.org
[ljs@kernel.org: simplifications per Pedro]
  Link: https://lore.kernel.org/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local
Link: https://lore.kernel.org/20260331073627.50010-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   88 +++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-merge-test-for-partial-msealed-range
+++ a/tools/testing/selftests/mm/merge.c
@@ -48,6 +48,19 @@ static pid_t do_fork(struct procmap_fd *
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
@@ -1217,6 +1230,81 @@ TEST_F(merge, mremap_correct_placed_faul
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
+	carveout = mmap(NULL, 5 * page_size, PROT_NONE,
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
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
+		    PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr3 = mmap(&carveout[3 * page_size], page_size, PROT_READ,
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
+	ASSERT_EQ(sys_mseal(ptr2, page_size, 0), 0);
+
+	/* Make first VMA mergeable upon mseal. */
+	ASSERT_EQ(mprotect(ptr, page_size,
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
+	ASSERT_EQ(sys_mseal(ptr, 3 * page_size, 0), 0);
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
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
_

Patches currently in -mm which might be from ljs@kernel.org are


