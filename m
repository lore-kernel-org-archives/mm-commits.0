Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E3C2F83CF
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675130; cv=none; b=mvMwYy9XDVqNuBlZ6sJ7LhE7yZRMoE/f5DUMWUoramEHsQQW7UtF7eJfEsEWnMTooTihupDHIlknkq82sP6jldEpgrTp/VBHQfD9/TIDRnpoUBHYhk3Mp50aMm2/JVyAAfttUIToYMUXc2JmtVn0ENe/QuYVIN6+qH0bB0M1yHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675130; c=relaxed/simple;
	bh=/C1/QFkt2AbaZXPJVRjZ4Rdu+5YBloG4a39Sv7cxt7Q=;
	h=Date:To:From:Subject:Message-Id; b=Y+6DoWd3BlJ6IFrKvktL0DSTR2hTT5+sE6UjhHUwZ35BWhZ8JYog7guSS0YGYLrYdXMyP9qELJhRVxawb71kpI15lbeaCMx9eN2QSW1T/bBXYpxXe7Y8i4JPufCN2P5tppwZIxIz6oJU1umhDxirQCGecnRCy+uxkzIRphcbQTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Myk5Zsp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Myk5Zsp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F981C113D0;
	Thu, 20 Nov 2025 21:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675130;
	bh=/C1/QFkt2AbaZXPJVRjZ4Rdu+5YBloG4a39Sv7cxt7Q=;
	h=Date:To:From:Subject:From;
	b=Myk5Zsp/MnDa2ovLODY3S2YJqjjbTL1oB2YuKIimp9KHLNSc6zC5MudClEv5uwteS
	 4sdG8L0I5m67I47J9EksIdC2dQXpt1zvRl3hsJtDo8EJBbcqmiquVR43thERfSknPY
	 q8dRIzHbZRrA21tgRarwUQsC2iUR4yDv0JUNO6kM=
Date: Thu, 20 Nov 2025 13:45:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,gorcunov@gmail.com,david@kernel.org,avagin@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] testing-selftests-mm-add-soft-dirty-merge-self-test.patch removed from -mm tree
Message-Id: <20251120214530.5F981C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: testing/selftests/mm: add soft-dirty merge self-test
has been removed from the -mm tree.  Its filename was
     testing-selftests-mm-add-soft-dirty-merge-self-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: testing/selftests/mm: add soft-dirty merge self-test
Date: Mon, 17 Nov 2025 17:33:39 +0000

Assert that we correctly merge VMAs containing VM_SOFTDIRTY flags now that
we correctly handle these as sticky.

In order to do so, we have to account for the fact the pagemap interface
checks soft dirty PTEs and additionally that newly merged VMAs are marked
VM_SOFTDIRTY.

We do this by using use unfaulted anon VMAs, establishing one and clearing
references on that one, before establishing another and merging the two
before checking that soft-dirty is propagated as expected.

We check that this functions correctly with mremap() and mprotect() as
sample cases, because VMA merge of adjacent newly mapped VMAs will
automatically be made soft-dirty due to existing logic which does so.

We are therefore exercising other means of merging VMAs.

Link: https://lkml.kernel.org/r/d5a0f735783fb4f30a604f570ede02ccc5e29be9.1763399675.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrey Vagin <avagin@gmail.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/soft-dirty.c |  127 +++++++++++++++++++++-
 1 file changed, 126 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/soft-dirty.c~testing-selftests-mm-add-soft-dirty-merge-self-test
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -184,6 +184,130 @@ static void test_mprotect(int pagemap_fd
 		close(test_fd);
 }
 
+static void test_merge(int pagemap_fd, int pagesize)
+{
+	char *reserved, *map, *map2;
+
+	/*
+	 * Reserve space for tests:
+	 *
+	 *   ---padding to ---
+	 *   |   avoid adj.  |
+	 *   v     merge     v
+	 * |---|---|---|---|---|
+	 * |   | 1 | 2 | 3 |   |
+	 * |---|---|---|---|---|
+	 */
+	reserved = mmap(NULL, 5 * pagesize, PROT_NONE,
+			MAP_ANON | MAP_PRIVATE, -1, 0);
+	if (reserved == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	munmap(reserved, 4 * pagesize);
+
+	/*
+	 * Establish initial VMA:
+	 *
+	 *      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* This will clear VM_SOFTDIRTY too. */
+	clear_softdirty();
+
+	/*
+	 * Now place a new mapping which will be marked VM_SOFTDIRTY. Away from
+	 * map:
+	 *
+	 *       -      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   | 2 |   |
+	 * |---|---|---|---|---|
+	 */
+	map2 = mmap(&reserved[3 * pagesize], pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now remap it immediately adjacent to map, if the merge correctly
+	 * propagates VM_SOFTDIRTY, we should then observe the VMA as a whole
+	 * being marked soft-dirty:
+	 *
+	 *       merge
+	 *        S/D
+	 * |---|-------|---|---|
+	 * |   |   1   |   |   |
+	 * |---|-------|---|---|
+	 */
+	map2 = mremap(map2, pagesize, pagesize, MREMAP_FIXED | MREMAP_MAYMOVE,
+		      &reserved[2 * pagesize]);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mremap failed\n");
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after remap merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after remap merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+
+	/*
+	 * Now establish another VMA:
+	 *
+	 *      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* Clear VM_SOFTDIRTY... */
+	clear_softdirty();
+	/* ...and establish incompatible adjacent VMA:
+	 *
+	 *       -  S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 | 2 |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map2 = mmap(&reserved[2 * pagesize], pagesize,
+	PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now mprotect() VMA 1 so it's compatible with 2 and therefore merges:
+	 *
+	 *       merge
+	 *        S/D
+	 * |---|-------|---|---|
+	 * |   |   1   |   |   |
+	 * |---|-------|---|---|
+	 */
+	if (mprotect(map, pagesize, PROT_READ | PROT_WRITE | PROT_EXEC))
+		ksft_exit_fail_msg("mprotect failed\n");
+
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after mprotect merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after mprotect merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+}
+
 static void test_mprotect_anon(int pagemap_fd, int pagesize)
 {
 	test_mprotect(pagemap_fd, pagesize, true);
@@ -204,7 +328,7 @@ int main(int argc, char **argv)
 	if (!softdirty_supported())
 		ksft_exit_skip("soft-dirty is not support\n");
 
-	ksft_set_plan(15);
+	ksft_set_plan(19);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
@@ -216,6 +340,7 @@ int main(int argc, char **argv)
 	test_hugepage(pagemap_fd, pagesize);
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
+	test_merge(pagemap_fd, pagesize);
 
 	close(pagemap_fd);
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch

