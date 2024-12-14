Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C415366
	for <mm-commits@vger.kernel.org>; Sat, 14 Dec 2024 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734136506; cv=none; b=jr/SKfZ9aD6B9XtnTo7N+5gkxlt3lp7Yh3iDeth4n7dti2vVFKuPweNoSMnCfOk9QM8i0kLxdlY5V5ae0q1o94emq+48f9kKingk2nVMi/SWwpyvjdeIhmXktz3ixR9LSOZCZdnqyievhkH2w9yK/lTZwm4dXAQ2WqMLvJq80W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734136506; c=relaxed/simple;
	bh=OBU+9t/Q3DHXkVN8eL4sVpb3f9Ilpbo6MkSgyFoNECY=;
	h=Date:To:From:Subject:Message-Id; b=ul9Q/W8hX2lDJXUKWLV0Gd50bkF2U7LxaM/LmshxgWc7XTkAQhmLXYmhrQJOIblGtwOgc2ejNQNh0Tge6PF4sb9ZfEFbwibWt9uHgGIz6ZIKSjMteQaleYTgSgsKFAB+mw9UhLwl5m3ylkZZX8SZBWtaHxJJdbkN1mVHqbImGCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f4/jQAjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f4/jQAjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9815FC4CED0;
	Sat, 14 Dec 2024 00:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734136505;
	bh=OBU+9t/Q3DHXkVN8eL4sVpb3f9Ilpbo6MkSgyFoNECY=;
	h=Date:To:From:Subject:From;
	b=f4/jQAjwoMRq9rxGT3MgboPdO/qSq85TIyblaiBPsLaDI1yddSeg38OfPvGLwE2Tu
	 lybkdeqfKtTa4DFJ+CgGgCd56Dy30m+lKx1M/+deEL0AZ1g1WQNz1458W3oL382dgC
	 Z+XjBsiE0LwIAXLX4Aop4Oc4JbdPLCXEpvuGLe0A=
Date: Fri, 13 Dec 2024 16:35:05 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-add-simple-__mmap_region-userland-test.patch added to mm-unstable branch
Message-Id: <20241214003505.9815FC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: add simple __mmap_region() userland test
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-add-simple-__mmap_region-userland-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-add-simple-__mmap_region-userland-test.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -985,7 +985,7 @@ static inline bool is_file_hugepages(str
 
 static inline int security_vm_enough_memory_mm(struct mm_struct *, long)
 {
-	return true;
+	return 0;
 }
 
 static inline bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
mm-correctly-reference-merged-vma.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
fork-avoid-inappropriate-uprobe-access-to-invalid-mm.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch
tools-testing-add-simple-__mmap_region-userland-test.patch

