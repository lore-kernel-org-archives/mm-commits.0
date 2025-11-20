Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7933DEEB
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675096; cv=none; b=HFMKGeSX3GmfMeXJW9Mqosz7hkmFdqnOGFBtbApmhkeYaiHiqZOSs7AJEtoHP6gDMhclABhK9x76kGINLbA6cSkd1BeCiZWRBC5AoNf7vEC48v3+IqHOqwSN3/3DGjYWV5TKYHbrP+mUJHSZh4/KW6fGogfpNrDq4E9y8J0Thv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675096; c=relaxed/simple;
	bh=fC3KF37u1vV1qIQDxvs1Lf1KIG6KdMEKR2rIP0zcYEw=;
	h=Date:To:From:Subject:Message-Id; b=QL/CZFxE8v8aDIiCFIEknItHPWpvE1KWtiN/4xrmjEtSzb0hUkHcwE048Qz5ilEmeF7mROpxSLCnpNgNupWHr+VVi3LTc7zBV5eKYrQc6OuE3B/mR3h9RQh8yT1CSM2VKZfmoxZgIo4+phUsFqDYqBM3IU717+obqiWFlOaJXr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rSGns1qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rSGns1qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D157C4CEF1;
	Thu, 20 Nov 2025 21:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675096;
	bh=fC3KF37u1vV1qIQDxvs1Lf1KIG6KdMEKR2rIP0zcYEw=;
	h=Date:To:From:Subject:From;
	b=rSGns1qtH7KAftlLGjtKhb1kay0xmMwfGI1EJ3jZPjckzcEsEUHuZOvRipVRTMXcR
	 G0W2On3rj+YIcwW8KgeouM9f2VD7xgoymiZInmucTbT3T5MGw6oGjK9ZwKQXFMEczB
	 nlL0/99Vbwse0EZ82f+2luqeHsp3ybaD5P/tIJ8g=
Date: Thu, 20 Nov 2025 13:44:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,pfalcato@suse.de,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,avagin@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch removed from -mm tree
Message-Id: <20251120214456.9D157C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests/mm: add smaps visibility guard region test
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests/mm: add smaps visibility guard region test
Date: Tue, 18 Nov 2025 10:17:51 +0000

Assert that we observe guard regions appearing in /proc/$pid/smaps as
expected, and when split/merge is performed too (with expected sticky
behaviour).

Also add handling for file systems which don't sanely handle mmap() VMA
merging so we don't incorrectly encounter a test failure in this
situation.

Link: https://lkml.kernel.org/r/059e62b8c67e55e6d849878206a95ea1d7c1e885.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |  120 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c       |    5 
 tools/testing/selftests/mm/vm_util.h       |    1 
 3 files changed, 126 insertions(+)

--- a/tools/testing/selftests/mm/guard-regions.c~tools-testing-selftests-mm-add-smaps-visibility-guard-region-test
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -94,6 +94,7 @@ static void *mmap_(FIXTURE_DATA(guard_re
 	case ANON_BACKED:
 		flags |= MAP_PRIVATE | MAP_ANON;
 		fd = -1;
+		offset = 0;
 		break;
 	case SHMEM_BACKED:
 	case LOCAL_FILE_BACKED:
@@ -260,6 +261,54 @@ static bool is_buf_eq(char *buf, size_t
 	return true;
 }
 
+/*
+ * Some file systems have issues with merging due to changing merge-sensitive
+ * parameters in the .mmap callback, and prior to .mmap_prepare being
+ * implemented everywhere this will now result in an unexpected failure to
+ * merge (e.g. - overlayfs).
+ *
+ * Perform a simple test to see if the local file system suffers from this, if
+ * it does then we can skip test logic that assumes local file system merging is
+ * sane.
+ */
+static bool local_fs_has_sane_mmap(FIXTURE_DATA(guard_regions) * self,
+				   const FIXTURE_VARIANT(guard_regions) * variant)
+{
+	const unsigned long page_size = self->page_size;
+	char *ptr, *ptr2;
+	struct procmap_fd procmap;
+
+	if (variant->backing != LOCAL_FILE_BACKED)
+		return true;
+
+	/* Map 10 pages. */
+	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
+	if (ptr == MAP_FAILED)
+		return false;
+	/* Unmap the middle. */
+	munmap(&ptr[5 * page_size], page_size);
+
+	/* Map again. */
+	ptr2 = mmap_(self, variant, &ptr[5 * page_size], page_size, PROT_READ | PROT_WRITE,
+		     MAP_FIXED, 5 * page_size);
+
+	if (ptr2 == MAP_FAILED)
+		return false;
+
+	/* Now make sure they all merged. */
+	if (open_self_procmap(&procmap) != 0)
+		return false;
+	if (!find_vma_procmap(&procmap, ptr))
+		return false;
+	if (procmap.query.vma_start != (unsigned long)ptr)
+		return false;
+	if (procmap.query.vma_end != (unsigned long)ptr + 10 * page_size)
+		return false;
+	close_procmap(&procmap);
+
+	return true;
+}
+
 FIXTURE_SETUP(guard_regions)
 {
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
@@ -2203,4 +2252,75 @@ TEST_F(guard_regions, collapse)
 	}
 }
 
+TEST_F(guard_regions, smaps)
+{
+	const unsigned long page_size = self->page_size;
+	struct procmap_fd procmap;
+	char *ptr, *ptr2;
+	int i;
+
+	/* Map a region. */
+	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/* We shouldn't yet see a guard flag. */
+	ASSERT_FALSE(check_vmflag_guard(ptr));
+
+	/* Install a single guard region. */
+	ASSERT_EQ(madvise(ptr, page_size, MADV_GUARD_INSTALL), 0);
+
+	/* Now we should see a guard flag. */
+	ASSERT_TRUE(check_vmflag_guard(ptr));
+
+	/*
+	 * Removing the guard region should not change things because we simply
+	 * cannot accurately track whether a given VMA has had all of its guard
+	 * regions removed.
+	 */
+	ASSERT_EQ(madvise(ptr, page_size, MADV_GUARD_REMOVE), 0);
+	ASSERT_TRUE(check_vmflag_guard(ptr));
+
+	/* Install guard regions throughout. */
+	for (i = 0; i < 10; i++) {
+		ASSERT_EQ(madvise(&ptr[i * page_size], page_size, MADV_GUARD_INSTALL), 0);
+		/* We should always see the guard region flag. */
+		ASSERT_TRUE(check_vmflag_guard(ptr));
+	}
+
+	/* Split into two VMAs. */
+	ASSERT_EQ(munmap(&ptr[4 * page_size], page_size), 0);
+
+	/* Both VMAs should have the guard flag set. */
+	ASSERT_TRUE(check_vmflag_guard(ptr));
+	ASSERT_TRUE(check_vmflag_guard(&ptr[5 * page_size]));
+
+	/*
+	 * If the local file system is unable to merge VMAs due to having
+	 * unusual characteristics, there is no point in asserting merge
+	 * behaviour.
+	 */
+	if (!local_fs_has_sane_mmap(self, variant)) {
+		TH_LOG("local filesystem does not support sane merging skipping merge test");
+		return;
+	}
+
+	/* Map a fresh VMA between the two split VMAs. */
+	ptr2 = mmap_(self, variant, &ptr[4 * page_size], page_size,
+		     PROT_READ | PROT_WRITE, MAP_FIXED, 4 * page_size);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Check the procmap to ensure that this VMA merged with the adjacent
+	 * two. The guard region flag is 'sticky' so should not preclude
+	 * merging.
+	 */
+	ASSERT_EQ(open_self_procmap(&procmap), 0);
+	ASSERT_TRUE(find_vma_procmap(&procmap, ptr));
+	ASSERT_EQ(procmap.query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap.query.vma_end, (unsigned long)ptr + 10 * page_size);
+	ASSERT_EQ(close_procmap(&procmap), 0);
+	/* And, of course, this VMA should have the guard flag set. */
+	ASSERT_TRUE(check_vmflag_guard(ptr));
+}
+
 TEST_HARNESS_MAIN
--- a/tools/testing/selftests/mm/vm_util.c~tools-testing-selftests-mm-add-smaps-visibility-guard-region-test
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -449,6 +449,11 @@ bool check_vmflag_pfnmap(void *addr)
 	return check_vmflag(addr, "pf");
 }
 
+bool check_vmflag_guard(void *addr)
+{
+	return check_vmflag(addr, "gu");
+}
+
 bool softdirty_supported(void)
 {
 	char *addr;
--- a/tools/testing/selftests/mm/vm_util.h~tools-testing-selftests-mm-add-smaps-visibility-guard-region-test
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -98,6 +98,7 @@ int uffd_register_with_ioctls(int uffd,
 unsigned long get_free_hugepages(void);
 bool check_vmflag_io(void *addr);
 bool check_vmflag_pfnmap(void *addr);
+bool check_vmflag_guard(void *addr);
 int open_procmap(pid_t pid, struct procmap_fd *procmap_out);
 int query_procmap(struct procmap_fd *procmap);
 bool find_vma_procmap(struct procmap_fd *procmap, void *address);
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

