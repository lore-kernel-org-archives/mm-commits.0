Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3202C15BB
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 19:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542468; cv=none; b=Dseh3WIXp6LvYTdg4WSApVQ+tLwr49DWDxaR8uprD7zeb9bQxV6xXsYJBfP6VN2qlr9Nb0zExHIakgrft6GdnnqNnwrZoq3QNRSsVijL0X8N7AzvFDODAhb7xTL2S9OLtkdEoIr5aVde7I9KAg6sOxokfdrAkj0HdN9C6/MRE4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542468; c=relaxed/simple;
	bh=0Y6fjh6INiQROfE9PuWGiXia7NBaoYjfaHmamtKP280=;
	h=Date:To:From:Subject:Message-Id; b=OREr0lwQxmo+Vp1nRfX3k/n1sGSMhaZoq9MbE1qDRX/aaqLtSVjoj18x0v//FQinhdJcqvXF3AP3zHEWDMbVttd1YS9L88md9/icjjy5tUp5ZDJZXyPIQcCkxM9THjNpZT35ZzlF91rTtyb8OPTP4K6Hw8Yb/CF9Ttxj9pyuduY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QXL8sjzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QXL8sjzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72D5C4CEF7;
	Fri,  7 Nov 2025 19:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762542468;
	bh=0Y6fjh6INiQROfE9PuWGiXia7NBaoYjfaHmamtKP280=;
	h=Date:To:From:Subject:From;
	b=QXL8sjzB2Twsd6leAN5paq89kws25hhHzgMug6lBlCuqtZASMIHzTQJ/5UTfG6e2a
	 LJc7vdX7HonVmsvFxq3BqfeW7ifRoso/vngTBZaHY7KMixaOU1ZkwafvFomNnjBinD
	 oUrL3waImxwNFGqYFBMCejer5Cno+iGe3L7hfvZM=
Date: Fri, 07 Nov 2025 11:07:47 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch added to mm-new branch
Message-Id: <20251107190747.E72D5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests/mm: add smaps visibility guard region test
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: tools/testing/selftests/mm: add smaps visibility guard region test
Date: Fri, 7 Nov 2025 16:11:53 +0000

Assert that we observe guard regions appearing in /proc/$pid/smaps as
expected, and when split/merge is performed too (with expected sticky
behaviour).

Also add handling for file systems which don't sanely handle mmap() VMA
merging so we don't incorrectly encounter a test failure in this
situation.

Link: https://lkml.kernel.org/r/18153d558f422bd982e2e66e723b200f62ffc849.1762531708.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-vma-remove-unused-function-make-internal-functions-static.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-vma-small-vma-lock-cleanups.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic-fix.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-uses-of-is_swap_pte-when-leafent_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd.patch
mm-replace-pmd_to_swp_entry-with-leafent_from_pmd-fix.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead.patch
mm-remove-non_swap_entry-and-use-leaf-entry-helpers-instead-fix.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-leafent_from_pte.patch
mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch

