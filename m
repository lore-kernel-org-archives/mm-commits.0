Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B41176FA7
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 21:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729200423; cv=none; b=UtFnvJXmzP+Dxm61iNY8OqVG40pwbIWt1Tb9peap8/QO0zSASDESDgUIg7/czC4vJENGg3IyqIuedVV4Y3/ups1YygrxFrv0mBn1kbymKrLNR5x6k3Pcmfq6lLq38xhMTwXt9rn0rSB0/bduf7oC+o9ZK3TcyszJlQJQzwa7oyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729200423; c=relaxed/simple;
	bh=ou98ZAs9zBJ6bQLYUw/ObyqjLPIFtLHr/J6Qb/HBwjw=;
	h=Date:To:From:Subject:Message-Id; b=dF8XZ9UoQcI4Twh99xkeKckEhlQXQCUawwQWuouXG4c4UPytS1MqQ21teSwWzOurK/EGUExc6dQ4fXsJYoJ43cr1I8arHb5Vv8qyzQNJ347voAE/OOTvYwPIvT8zGMl/0PQkPDfi4paHE9sTh0dRgITHvnQ+oY3YPwxOXccvbTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PaGuyGdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PaGuyGdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEBAC4CEC5;
	Thu, 17 Oct 2024 21:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729200423;
	bh=ou98ZAs9zBJ6bQLYUw/ObyqjLPIFtLHr/J6Qb/HBwjw=;
	h=Date:To:From:Subject:From;
	b=PaGuyGdAsH8PkN8WAOUp0rnXk1Je39VR97PK2fCOohvqatJDdvXmgqv45yl/l1IoN
	 5RDiHs/rj/yc7jqOhvkvrxKdKxPvA7ZcUkQcSuIOucmnViqbshUZV+sMM3jglQpIzc
	 yKYwdHF2Ab/ltKr3rUBxhqFQvOF+2jU+rSUFZSvk=
Date: Thu, 17 Oct 2024 14:27:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,oliver.sang@intel.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-add-expand-only-mode-vma-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20241017212703.0BEBAC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: add expand-only mode VMA test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-add-expand-only-mode-vma-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-add-expand-only-mode-vma-test.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch
tools-testing-add-expand-only-mode-vma-test.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

