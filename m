Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683E2166F14
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750535; cv=none; b=puCCVgOgZdookUXrl+ArWFGDMxeHy5oVd/dcx1S9V30ZvRloGQNdsBydG7bxemM9twubFuAlBU9VFhRFdW9dSSNaZbi3Y8K8qNd2Nw3sjTzdIAPogzN8ar3MQ+c9dckvus2h7BJp5zErB63Q5k4Xoc31Yxe944DBJCp/EYmet2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750535; c=relaxed/simple;
	bh=cHnW8KhQhAnFI7HB7keYD5l7okuUcjeGItUXEWsIYbs=;
	h=Date:To:From:Subject:Message-Id; b=XlW2MLjML52pFjRbhrI9aN8xUYfizAWj/mYfQPLdoPehYLf7IHhZ7J5yVzgD5mtjOLWujfk3LhWA5MvOwH7DegjFwlqnFlcO6TvDFVt37zq0ZnvNZQeZwdf5ca7TG4nfpJEvjrtgtsdLyOBqNJBW7JoUDDz6WZ+u3b8jsqjDJP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oeAHskra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oeAHskra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405C9C4CEE4;
	Thu, 24 Oct 2024 06:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750535;
	bh=cHnW8KhQhAnFI7HB7keYD5l7okuUcjeGItUXEWsIYbs=;
	h=Date:To:From:Subject:From;
	b=oeAHskraieOqXOWmqA/ZvYy70zKD1r5D6aJEOLdQ6p/c/lear7dRqrcue2eNCWepx
	 KAC8BGDEj3rpzgFkiQQRvJb0Ok63mJW0OeLx448jsK0W6TrMiz/PmWk5lx4HMH0J58
	 JWTzzMNnui31GXSdTFzaKLWDLbnUki1ZahL43yI4=
Date: Wed, 23 Oct 2024 23:15:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,oliver.sang@intel.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-testing-add-expand-only-mode-vma-test.patch removed from -mm tree
Message-Id: <20241024061535.405C9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: testing: add expand-only mode VMA test
has been removed from the -mm tree.  Its filename was
     tools-testing-add-expand-only-mode-vma-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools: testing: add expand-only mode VMA test
Date: Thu, 17 Oct 2024 15:31:46 +0100

Add a test to assert that VMG_FLAG_JUST_EXPAND functions as expected - that
is, when the VMA iterator is positioned at the previous VMA and no VMAs
proceed it, we observe an expansion with all state as expected.

Explicitly place a prior VMA that would otherwise fail this test if the
mode were not enabled (as it would traverse to the previous-previous VMA).

Link: https://lkml.kernel.org/r/d2f88330254a6448092412bf7dfe077a579ab0dc.1729174352.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma.c |   40 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/tools/testing/vma/vma.c~tools-testing-add-expand-only-mode-vma-test
+++ a/tools/testing/vma/vma.c
@@ -1522,6 +1522,45 @@ static bool test_copy_vma(void)
 	return true;
 }
 
+static bool test_expand_only_mode(void)
+{
+	unsigned long flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
+	struct mm_struct mm = {};
+	VMA_ITERATOR(vmi, &mm, 0);
+	struct vm_area_struct *vma_prev, *vma;
+	VMG_STATE(vmg, &mm, &vmi, 0x5000, 0x9000, flags, 5);
+
+	/*
+	 * Place a VMA prior to the one we're expanding so we assert that we do
+	 * not erroneously try to traverse to the previous VMA even though we
+	 * have, through the use of VMG_FLAG_JUST_EXPAND, indicated we do not
+	 * need to do so.
+	 */
+	alloc_and_link_vma(&mm, 0, 0x2000, 0, flags);
+
+	/*
+	 * We will be positioned at the prev VMA, but looking to expand to
+	 * 0x9000.
+	 */
+	vma_iter_set(&vmi, 0x3000);
+	vma_prev = alloc_and_link_vma(&mm, 0x3000, 0x5000, 3, flags);
+	vmg.prev = vma_prev;
+	vmg.merge_flags = VMG_FLAG_JUST_EXPAND;
+
+	vma = vma_merge_new_range(&vmg);
+	ASSERT_NE(vma, NULL);
+	ASSERT_EQ(vma, vma_prev);
+	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
+	ASSERT_EQ(vma->vm_start, 0x3000);
+	ASSERT_EQ(vma->vm_end, 0x9000);
+	ASSERT_EQ(vma->vm_pgoff, 3);
+	ASSERT_TRUE(vma_write_started(vma));
+	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 int main(void)
 {
 	int num_tests = 0, num_fail = 0;
@@ -1553,6 +1592,7 @@ int main(void)
 	TEST(vmi_prealloc_fail);
 	TEST(merge_extend);
 	TEST(copy_vma);
+	TEST(expand_only_mode);
 
 #undef TEST
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

