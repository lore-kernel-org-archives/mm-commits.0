Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A181D23D3ED
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837084; cv=none; b=NJKUi+jLbm/YrA1ID2LUXRhUiQiQkHo5GOsxBjQHTfXPsaEUsHCGTOtF6K9A3HcoBlX3r9cixKKfGlJAjBz6F3Di3SdhSbn6fAjCcOdeTsBRqyBaZ1875q9N0eDE39Ytdm5Otaj8+q4W8/HW371r4vLaJ8rU8YxmMu2Rl0R4oXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837084; c=relaxed/simple;
	bh=nv518uI0izP0OUt1qO+/R61nejaOIeih//Y1iTcqWic=;
	h=Date:To:From:Subject:Message-Id; b=IKzUq2Pv2cFBmYBabPiJz5V1Ou9O7BgBmggZSSeIwENRMP+Nb4G0vOTp9jDwWbacdU1GRU3tbtVEFihc+leVZNVcUkgfvwyD4LEUkCQNAya6uBHwPt+tvkJsEB2+Uv7CAwdR0lJKn/pAQo9ygLUlzY3PpNt4TBLaLXKGoU4y04g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m37onVlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m37onVlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AFDC4CEDD;
	Tue, 14 Jan 2025 06:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837084;
	bh=nv518uI0izP0OUt1qO+/R61nejaOIeih//Y1iTcqWic=;
	h=Date:To:From:Subject:From;
	b=m37onVlVvGjJUcCzNdrrPI+eYf2/AtQpNwvgQxOmFGb8WtQnS9fI7/+C52rWNslxt
	 uynFm8+5EE/2qcXLEL9NC3/wGdpbB8XV4OJrfEUzOMVNKhW8H7I/fVyVMk/3UxcVHo
	 Oc//sZ2wDtQuP0IQXyJmLYOAp2FQHt8AVxqSu/7w=
Date: Mon, 13 Jan 2025 22:44:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-add-simple-__mmap_region-userland-test.patch removed from -mm tree
Message-Id: <20250114064444.76AFDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: testing: add simple __mmap_region() userland test
has been removed from the -mm tree.  Its filename was
     tools-testing-add-simple-__mmap_region-userland-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools: testing: add simple __mmap_region() userland test
Date: Fri, 13 Dec 2024 16:24:09 +0000

Introduce demonstrative, basic, __mmap_region() test upon which we can
base further work upon moving forwards.

This simply asserts that mappings can be made and merges occur as
expected.

As part of this change, fix the security_vm_enough_memory_mm() stub which
was previously incorrectly implemented.

Link: https://lkml.kernel.org/r/20241213162409.41498-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma.c          |   53 +++++++++++++++++++++++++++++
 tools/testing/vma/vma_internal.h |    2 -
 2 files changed, 54 insertions(+), 1 deletion(-)

--- a/tools/testing/vma/vma.c~tools-testing-add-simple-__mmap_region-userland-test
+++ a/tools/testing/vma/vma.c
@@ -1574,6 +1574,57 @@ static bool test_expand_only_mode(void)
 	return true;
 }
 
+static bool test_mmap_region_basic(void)
+{
+	struct mm_struct mm = {};
+	unsigned long addr;
+	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+
+	/* Map at 0x300000, length 0x3000. */
+	addr = __mmap_region(NULL, 0x300000, 0x3000,
+			     VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE,
+			     0x300, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Map at 0x250000, length 0x3000. */
+	addr = __mmap_region(NULL, 0x250000, 0x3000,
+			     VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE,
+			     0x250, NULL);
+	ASSERT_EQ(addr, 0x250000);
+
+	/* Map at 0x303000, merging to 0x300000 of length 0x6000. */
+	addr = __mmap_region(NULL, 0x303000, 0x3000,
+			     VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE,
+			     0x303, NULL);
+	ASSERT_EQ(addr, 0x303000);
+
+	/* Map at 0x24d000, merging to 0x250000 of length 0x6000. */
+	addr = __mmap_region(NULL, 0x24d000, 0x3000,
+			     VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE,
+			     0x24d, NULL);
+	ASSERT_EQ(addr, 0x24d000);
+
+	ASSERT_EQ(mm.map_count, 2);
+
+	for_each_vma(vmi, vma) {
+		if (vma->vm_start == 0x300000) {
+			ASSERT_EQ(vma->vm_end, 0x306000);
+			ASSERT_EQ(vma->vm_pgoff, 0x300);
+		} else if (vma->vm_start == 0x24d000) {
+			ASSERT_EQ(vma->vm_end, 0x253000);
+			ASSERT_EQ(vma->vm_pgoff, 0x24d);
+		} else {
+			ASSERT_FALSE(true);
+		}
+	}
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 int main(void)
 {
 	int num_tests = 0, num_fail = 0;
@@ -1607,6 +1658,8 @@ int main(void)
 	TEST(copy_vma);
 	TEST(expand_only_mode);
 
+	TEST(mmap_region_basic);
+
 #undef TEST
 
 	printf("%d tests run, %d passed, %d failed.\n",
--- a/tools/testing/vma/vma_internal.h~tools-testing-add-simple-__mmap_region-userland-test
+++ a/tools/testing/vma/vma_internal.h
@@ -996,7 +996,7 @@ static inline bool is_file_hugepages(str
 
 static inline int security_vm_enough_memory_mm(struct mm_struct *, long)
 {
-	return true;
+	return 0;
 }
 
 static inline bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

