Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151262DD5EF;
	Mon,  5 Jan 2026 21:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647510; cv=none; b=ucFFgS5EIToMROk2LisTW2rtuFVPy0SnC+6I0FInBzmG2PDheXgF55oTuQcbyttRSJs7ZeyradkiudEXWM5XCm8s/o2pYQJ6EVrUT2aiRvYBD8bSPskjoLNBx3PIhVBls7TqnCDap4bS4lv4dv55cKuXATo3WVkMqswDdRriWyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647510; c=relaxed/simple;
	bh=FNWVllhWMzUZ1UBCyWfslOCyyzTZIliOqtuVvD2s9dk=;
	h=Date:To:From:Subject:Message-Id; b=rNYHiXRjCroh2WZUtfWjMZKfr2Kgxi+blXWBX6RPIeUEhnAqF7U/uVfx6A6SJcOG0xuTt+9f2A58h1BynAjtK2NS54VZsZ0cCovyDT83viwbAxSdfPm5owKctuPchzSotPf4D3/A8cSw71mQQnk4dR3f+9Rpa5+Ln7uITH36YCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o/eEXeRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o/eEXeRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0009C116D0;
	Mon,  5 Jan 2026 21:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767647509;
	bh=FNWVllhWMzUZ1UBCyWfslOCyyzTZIliOqtuVvD2s9dk=;
	h=Date:To:From:Subject:From;
	b=o/eEXeROZ+6B6EHtdXqcWJvb92Vh4r1UoYsLwEJEoj6MDMOBg86Qj1DrfYO/lkhYx
	 ZfQDlPRqD+ZTVQT4jft7bSu3tYY1eMzAqQCcUDp+fcNzckTZcd7JSJyEJMcqbj+uNV
	 WIHdcidS5Xkyu3W9kFikUlZ9Y0gwAFwSoyz1wJpY=
Date: Mon, 05 Jan 2026 13:11:49 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,pfalcato@suse.de,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,aha310510@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch added to mm-hotfixes-unstable branch
Message-Id: <20260105211149.A0009C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add forked (un)/faulted VMA merge tests
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch

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
Subject: tools/testing/selftests: add forked (un)/faulted VMA merge tests
Date: Mon, 5 Jan 2026 20:11:50 +0000

Now we correctly handle forked faulted/unfaulted merge on mremap(),
exhaustively assert that we handle this correctly.

Do this in the less duplicative way by adding a new merge_with_fork
fixture and forked/unforked variants, and abstract the forking logic as
necessary to avoid code duplication with this also.

Link: https://lkml.kernel.org/r/1daf76d89fdb9d96f38a6a0152d8f3c2e9e30ac7.1767638272.git.lorenzo.stoakes@oracle.com
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

 tools/testing/selftests/mm/merge.c |  180 ++++++++++++++++++++-------
 1 file changed, 139 insertions(+), 41 deletions(-)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-forked-un-faulted-vma-merge-tests
+++ a/tools/testing/selftests/mm/merge.c
@@ -22,12 +22,37 @@ FIXTURE(merge)
 	struct procmap_fd procmap;
 };
 
+static char *map_carveout(unsigned int page_size)
+{
+	return mmap(NULL, 30 * page_size, PROT_NONE,
+		    MAP_ANON | MAP_PRIVATE, -1, 0);
+}
+
+static pid_t do_fork(struct procmap_fd *procmap)
+{
+	pid_t pid = fork();
+
+	if (pid == -1)
+		return -1;
+	if (pid != 0) {
+		wait(NULL);
+		return pid;
+	}
+
+	/* Reopen for child. */
+	if (close_procmap(procmap))
+		return -1;
+	if (open_self_procmap(procmap))
+		return -1;
+
+	return 0;
+}
+
 FIXTURE_SETUP(merge)
 {
 	self->page_size = psize();
 	/* Carve out PROT_NONE region to map over. */
-	self->carveout = mmap(NULL, 30 * self->page_size, PROT_NONE,
-			      MAP_ANON | MAP_PRIVATE, -1, 0);
+	self->carveout = map_carveout(self->page_size);
 	ASSERT_NE(self->carveout, MAP_FAILED);
 	/* Setup PROCMAP_QUERY interface. */
 	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
@@ -36,7 +61,8 @@ FIXTURE_SETUP(merge)
 FIXTURE_TEARDOWN(merge)
 {
 	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	/* May fail for parent of forked process. */
+	close_procmap(&self->procmap);
 	/*
 	 * Clear unconditionally, as some tests set this. It is no issue if this
 	 * fails (KSM may be disabled for instance).
@@ -44,6 +70,44 @@ FIXTURE_TEARDOWN(merge)
 	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
 }
 
+FIXTURE(merge_with_fork)
+{
+	unsigned int page_size;
+	char *carveout;
+	struct procmap_fd procmap;
+};
+
+FIXTURE_VARIANT(merge_with_fork)
+{
+	bool forked;
+};
+
+FIXTURE_VARIANT_ADD(merge_with_fork, forked)
+{
+	.forked = true,
+};
+
+FIXTURE_VARIANT_ADD(merge_with_fork, unforked)
+{
+	.forked = false,
+};
+
+FIXTURE_SETUP(merge_with_fork)
+{
+	self->page_size = psize();
+	self->carveout = map_carveout(self->page_size);
+	ASSERT_NE(self->carveout, MAP_FAILED);
+	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
+}
+
+FIXTURE_TEARDOWN(merge_with_fork)
+{
+	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	/* See above. */
+	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
+}
+
 TEST_F(merge, mprotect_unfaulted_left)
 {
 	unsigned int page_size = self->page_size;
@@ -322,8 +386,8 @@ TEST_F(merge, forked_target_vma)
 	unsigned int page_size = self->page_size;
 	char *carveout = self->carveout;
 	struct procmap_fd *procmap = &self->procmap;
-	pid_t pid;
 	char *ptr, *ptr2;
+	pid_t pid;
 	int i;
 
 	/*
@@ -344,19 +408,10 @@ TEST_F(merge, forked_target_vma)
 	 */
 	ptr[0] = 'x';
 
-	pid = fork();
+	pid = do_fork(&self->procmap);
 	ASSERT_NE(pid, -1);
-
-	if (pid != 0) {
-		wait(NULL);
+	if (pid != 0)
 		return;
-	}
-
-	/* Child process below: */
-
-	/* Reopen for child. */
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
-	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
 
 	/* unCOWing everything does not cause the AVC to go away. */
 	for (i = 0; i < 5 * page_size; i += page_size)
@@ -386,8 +441,8 @@ TEST_F(merge, forked_source_vma)
 	unsigned int page_size = self->page_size;
 	char *carveout = self->carveout;
 	struct procmap_fd *procmap = &self->procmap;
-	pid_t pid;
 	char *ptr, *ptr2;
+	pid_t pid;
 	int i;
 
 	/*
@@ -408,19 +463,10 @@ TEST_F(merge, forked_source_vma)
 	 */
 	ptr[0] = 'x';
 
-	pid = fork();
+	pid = do_fork(&self->procmap);
 	ASSERT_NE(pid, -1);
-
-	if (pid != 0) {
-		wait(NULL);
+	if (pid != 0)
 		return;
-	}
-
-	/* Child process below: */
-
-	/* Reopen for child. */
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
-	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
 
 	/* unCOWing everything does not cause the AVC to go away. */
 	for (i = 0; i < 5 * page_size; i += page_size)
@@ -1171,10 +1217,11 @@ TEST_F(merge, mremap_correct_placed_faul
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b;
 
 	/*
@@ -1197,6 +1244,14 @@ TEST_F(merge, mremap_faulted_to_unfaulte
 	/* Fault it in. */
 	ptr_a[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMA B in position,
 	 * unfaulted.
@@ -1220,16 +1275,19 @@ TEST_F(merge, mremap_faulted_to_unfaulte
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_a, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+
+	offset = variant->forked ? 3 * page_size : 6 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + offset);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b;
 
 	/*
@@ -1253,6 +1311,14 @@ TEST_F(merge, mremap_faulted_to_unfaulte
 	/* Fault it in. */
 	ptr_a[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMA B in position,
 	 * unfaulted.
@@ -1276,16 +1342,18 @@ TEST_F(merge, mremap_faulted_to_unfaulte
 		       &self->carveout[page_size]);
 	ASSERT_NE(ptr_a, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 6 * page_size);
+	offset = variant->forked ? 3 * page_size : 6 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + offset);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev_unfaulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b, *ptr_c;
 
 	/*
@@ -1307,6 +1375,14 @@ TEST_F(merge, mremap_faulted_to_unfaulte
 	/* Fault it in. */
 	ptr_b[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMAs A, C in position,
 	 * unfaulted.
@@ -1337,13 +1413,21 @@ TEST_F(merge, mremap_faulted_to_unfaulte
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_b, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	offset = variant->forked ? 3 * page_size : 9 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + offset);
+
+	/* If forked, B and C should also not have merged. */
+	if (variant->forked) {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 3 * page_size);
+	}
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev_faulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
@@ -1373,6 +1457,14 @@ TEST_F(merge, mremap_faulted_to_unfaulte
 	/* Fault it in. */
 	ptr_bc[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move VMA B out the way (splitting VMA BC) so we can place VMA A
 	 * in position, unfaulted, and leave the remainder of the VMA we just
@@ -1397,10 +1489,16 @@ TEST_F(merge, mremap_faulted_to_unfaulte
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_b, MAP_FAILED);
 
-	/* The VMAs should have merged. */
-	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
-	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	/* The VMAs should have merged. A,B,C if unforked, B, C if forked. */
+	if (variant->forked) {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+	} else {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	}
 }
 
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch

