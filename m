Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251E936EA93
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788376924; cv=none; b=Yl4p0d83MvRMOKDcifrFFUTvuUEnBs0Zn0569A2eVg4wG+KknQ2t02OR7BMPpQMSDv34WG/xz4MpyxuqS+UJ3b2kkEQofafPnJdiiiLbhRuTcW/DY6VlR/iZyj1Zr6JoYWOssBF8W/c85HFEnLUdMS0PbVKVbsZSSzwtIvpYZxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788376924; c=relaxed/simple;
	bh=M2q55CdYllZtJG47u/wLbkEmEsoBZ4BaKWuJ6WcZY/I=;
	h=Date:To:From:Subject:Message-Id; b=IA5QGbbGyeb9gRL/Ue7KIoFZbWFf6gr57bwbmpBCMiHHj1lZmz/x36ajAFwFiFVe81Ybc50+ltLXFbzYWs8atY/CxWnIwz4slHUDxTY8zh6FFAPlKwoA840zgRRSlRtC4cb8dct74hsxMpDuo1QCWQv4Z9vLViBhPkSFUzdJffA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bhyWudt0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bhyWudt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2331F000E9;
	Wed,  2 Sep 2026 19:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788376923;
	bh=dGRjj3UHJHcspCIur9sTfNbOoG3APZGjZGgdZ0PPWX8=;
	h=Date:To:From:Subject;
	b=bhyWudt0kG496GykKcaUhNzSvP2R0NUcTm6B/hCE/UXwyLgBblmrtMo0blkmj/zFM
	 1SRgJczj8NxCLFkhhOP4pYrGceL7AJ9B7iEIP/UTKS4UBoxbWfwh9q50UFpjB4cGrG
	 a37gFtmysGMIevDqZv0+Opz56J5zBgVBTwDfKTGs=
Date: Wed, 02 Sep 2026 12:22:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,jack@suse.cz,hughd@google.com,gregkh@linuxfoundation.org,david@kernel.org,baolin.wang@linux.alibaba.com,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch added to mm-new branch
Message-Id: <20260902192202.EE2331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
Date: Wed, 02 Sep 2026 19:00:22 +0100

Now we've made MAP_PRIVATE-mapped /dev/zero mappings truly anonymous, add
a VMA userland test to assert that this is the case and everything is as
we would expect for an anonymous mapping.

Link: https://lore.kernel.org/20260902-map-private-dev-zero-v1-5-a578c730cec7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/mmap.c |   37 +++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/tools/testing/vma/tests/mmap.c~tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon
+++ a/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,44 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static bool test_pure_anon_dev_zero(void)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	struct file file = {
+		.f_op = &zero_fops,
+	};
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+
+	/*
+	 * Map a MAP_PRIVATE-/dev/zero mapping at address 0x300000 with a page
+	 * offset of 0x10, which we expect to be reset to the anonymous page
+	 * offset.
+	 */
+	addr = __mmap_region(&file, 0x300000, 0x3000, vma_flags, 0x10, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Assert that it truly is an anonymous mapping. */
+	vma = vma_lookup(&mm, addr);
+	ASSERT_NE(vma, NULL);
+	ASSERT_TRUE(vma_is_anonymous(vma));
+	ASSERT_EQ(vma->vm_file, NULL);
+	ASSERT_EQ(vma->vm_private_data, NULL);
+	/* Expect anonymous page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0x300);
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(pure_anon_dev_zero);
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch
mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch
mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

