Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A8531E822
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 01:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789089471; cv=none; b=ZH3/p86iNT02XJ6kSp2NhC8Z9DlozR8/OC2vcYuG3hb9yyVJ/8bhoFW5/AlTNA7KfxxdYOpo3Gx4axKhowyApdHDzYOEExQaKLJq+g1a2jGGWtMXhMfZEi1dphigoVISn4o9hZe/KjmzwwAzGONXZv95oJiUYskeqrGZxsC6Mao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789089471; c=relaxed/simple;
	bh=1kGhkEH5lJIFmF4hLtRiFg0GHwbz9o1DLzzsu+iBuwU=;
	h=Date:To:From:Subject:Message-Id; b=cSlgMyNr1ksr7eC53q4XKo/9SQ2GX17MwS6PV8IA2NTQwWDzeWJsWr0iBKam/4UmS7pkPY0bkOVGgfVAScEIMv/ZGT31qDnuUshKPwiCnVZM96Lm+GdImkgajGCxNq2Dx2Z013a4L6/VFdgHgKpsljN2pJoR/bc4PDolL9Y6TXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1JCOktcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1JCOktcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92A41F00893;
	Fri, 11 Sep 2026 01:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789089468;
	bh=P9FaRN+JSCORsQO6RaKrCZq0juDKOhXA20frED34t/4=;
	h=Date:To:From:Subject;
	b=1JCOktccIZyXgZGEi+Akzlgta284tO2fH4PW0zvlCRMSGUiB69tRzpjSRqXfD/Vu9
	 btE+qRL29+zNwthG0OdfVJ1uDTq9SBlzEEUpo+xu/+2kWFizZm/FpNJBlwepxsuQGV
	 aciwB6+LSLuDxXxZUr8v//xNRvHpuPcoNFW0y/ZQ=
Date: Thu, 10 Sep 2026 18:17:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,hi@tychen.cc,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-cover-hole-filling-through-__mmap_region.patch added to mm-new branch
Message-Id: <20260911011748.C92A41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: cover hole filling through __mmap_region()
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-cover-hole-filling-through-__mmap_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-cover-hole-filling-through-__mmap_region.patch

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
From: Tianyi Chen <hi@tychen.cc>
Subject: tools/testing/vma: cover hole filling through __mmap_region()
Date: Tue, 8 Sep 2026 17:55:15 +0800

The mmap tests extend existing mappings one neighbor at a time, while
merge tests construct merge state directly.  Neither exercises filling a
hole between compatible mappings through the mmap setup and completion
path.

Fill a gap through __mmap_region() and require both neighbors to merge
into one VMA.  Repeat with only the new mapping's execute permission set
and require three separate VMAs.  Check boundaries, permissions, page
offsets, map_count and cleanup.

Link: https://lore.kernel.org/178886112560.138404.17741948638665342936.vma-v2@tychen.cc
Signed-off-by: Tianyi Chen <hi@tychen.cc>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: Codex:GPT-6
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/tests/mmap.c |   68 +++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

--- a/tools/testing/vma/tests/mmap.c~tools-testing-vma-cover-hole-filling-through-__mmap_region
+++ a/tools/testing/vma/tests/mmap.c
@@ -45,6 +45,72 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static bool mmap_region_fill_hole(bool merge)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT);
+	vma_flags_t middle_flags = vma_flags;
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	int count = 0;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+	if (!merge)
+		vma_flags_set(&middle_flags, VMA_EXEC_BIT);
+
+	/* Map at 0x300000, length 0x3000. */
+	addr = __mmap_region(NULL, 0x300000, 0x3000, vma_flags, 0x300, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Map at 0x306000, length 0x3000, leaving a hole. */
+	addr = __mmap_region(NULL, 0x306000, 0x3000, vma_flags, 0x306, NULL);
+	ASSERT_EQ(addr, 0x306000);
+	ASSERT_EQ(mm.map_count, 2);
+
+	/* Map at 0x303000, length 0x3000, filling the hole. */
+	addr = __mmap_region(NULL, 0x303000, 0x3000, middle_flags, 0x303, NULL);
+	ASSERT_EQ(addr, 0x303000);
+	ASSERT_EQ(mm.map_count, merge ? 1 : 3);
+
+	vma_iter_set(&vmi, 0);
+	for_each_vma(vmi, vma) {
+		const unsigned long start = 0x300000 + count * 0x3000;
+		const unsigned long end = merge ? 0x309000 : start + 0x3000;
+		/* Only the middle VMA in the non-merge case has VMA_EXEC. */
+		const bool is_middle_vma = count == 1;
+		const bool expect_exec_vma = is_middle_vma && !merge;
+
+		ASSERT_EQ(vma->vm_start, start);
+		ASSERT_EQ(vma->vm_end, end);
+		ASSERT_EQ(vma_start_pgoff(vma), start >> PAGE_SHIFT);
+		ASSERT_EQ(vma_start_anon_pgoff(vma), start >> PAGE_SHIFT);
+
+		ASSERT_TRUE(vma_test_all(vma, VMA_READ_BIT, VMA_WRITE_BIT,
+					 VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT,
+					 VMA_MAYEXEC_BIT));
+		ASSERT_EQ(vma_test(vma, VMA_EXEC_BIT), expect_exec_vma);
+
+		count++;
+	}
+
+	ASSERT_EQ(count, mm.map_count);
+
+	ASSERT_EQ(cleanup_mm(&mm, &vmi), count);
+	return true;
+}
+
+static bool test_mmap_region_fill_hole_merge(void)
+{
+	return mmap_region_fill_hole(true);
+}
+
+static bool test_mmap_region_fill_hole_flags_mismatch(void)
+{
+	return mmap_region_fill_hole(false);
+}
+
 static bool test_pure_anon_dev_zero(void)
 {
 	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
@@ -84,5 +150,7 @@ static bool test_pure_anon_dev_zero(void
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(mmap_region_fill_hole_merge);
+	TEST(mmap_region_fill_hole_flags_mismatch);
 	TEST(pure_anon_dev_zero);
 }
_

Patches currently in -mm which might be from hi@tychen.cc are

selftests-mm-reject-invalid-test-selections-before-running-tests.patch
selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected.patch
tools-testing-vma-cover-hole-filling-through-__mmap_region.patch

