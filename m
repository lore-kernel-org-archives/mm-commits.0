Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812B819F11F
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 10:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729678911; cv=none; b=my8OjfARt2cubVRKRwH9NOJci/Bioulr+Y+T9msfEnQ2B0m6quA5lYHVBq2WlXIQAZ/BJ2zwHF4/8V80sTNyKVVvNsuM5gYYaS68i7O+oJuthtZJy6UB/MnlDTpU3O7gmfWWfd3VMMRntcSB7yX0CooIdxDd3UB+cGyFJwtvaUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729678911; c=relaxed/simple;
	bh=jJZl2hqe0EbkR4bcUoPn0FbA+IDqLXYc2UosnlLivP0=;
	h=Date:To:From:Subject:Message-Id; b=KmnMXAG5lbzh/FildY91l3Z5ZudCy7xxsbTmGoJM7Jlb2WQzN/DjN8/xzge2ZOtV/e3grVpJEx4EQ5vtrVejWxeDDkE0c09XZQqfb6Z2CNzkxC8A4Bov8pLjkTDdKWQDGSFiO2buB1uUFMvqDFaPcpuFVxtqFAxZMJn4X/DaRZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uA5q86Cb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uA5q86Cb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44043C4CEC6;
	Wed, 23 Oct 2024 10:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729678911;
	bh=jJZl2hqe0EbkR4bcUoPn0FbA+IDqLXYc2UosnlLivP0=;
	h=Date:To:From:Subject:From;
	b=uA5q86Cb04W1UTNMcbgxO/R0gNWpE635F9gktvnAObr1fomj86MFNsgMXYO/QHuiD
	 JbPjfI0xsZQywk0MKldOxqMOEv5i3+k3GFPvaQKM93XBKnV5wi+ps/9wNkPbxyVVoV
	 thOBa/a+kwtK6jss6+R5W9ZcbhkauCqDULH0xyUg=
Date: Wed, 23 Oct 2024 03:21:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@kernel.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-map_deny_write_exec.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023102151.44043C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: refactor map_deny_write_exec()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-refactor-map_deny_write_exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-map_deny_write_exec.patch

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
Subject: mm: refactor map_deny_write_exec()
Date: Tue, 22 Oct 2024 21:40:54 +0100

Refactor the map_deny_write_exec() to not unnecessarily require a VMA
parameter but rather to accept VMA flags parameters, which allows us to
use this function early in mmap_region() in a subsequent commit.

While we're here, we refactor the function to be more readable and add
some additional documentation.

Link: https://lkml.kernel.org/r/e67b7f6c682bddbea2fe8b2d87b8441e4d2ea6e6.1729628198.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: <stable@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |   21 ++++++++++++++++++---
 mm/mmap.c            |    2 +-
 mm/mprotect.c        |    2 +-
 3 files changed, 20 insertions(+), 5 deletions(-)

--- a/include/linux/mman.h~mm-refactor-map_deny_write_exec
+++ a/include/linux/mman.h
@@ -188,16 +188,31 @@ static inline bool arch_memory_deny_writ
  *
  *	d)	mmap(PROT_READ | PROT_EXEC)
  *		mmap(PROT_READ | PROT_EXEC | PROT_BTI)
+ *
+ * This is only applicable if the user has set the Memory-Deny-Write-Execute
+ * (MDWE) protection mask for the current process.
+ *
+ * @old specifies the VMA flags the VMA originally possessed, and @new the ones
+ * we propose to set.
+ *
+ * Return: false if proposed change is OK, true if not ok and should be denied.
  */
-static inline bool map_deny_write_exec(struct vm_area_struct *vma,  unsigned long vm_flags)
+static inline bool map_deny_write_exec(unsigned long old, unsigned long new)
 {
+	/* If MDWE is disabled, we have nothing to deny. */
 	if (!test_bit(MMF_HAS_MDWE, &current->mm->flags))
 		return false;
 
-	if ((vm_flags & VM_EXEC) && (vm_flags & VM_WRITE))
+	/* If the new VMA is not executable, we have nothing to deny. */
+	if (!(new & VM_EXEC))
+		return false;
+
+	/* Under MDWE we absolutely do not accept writably executable... */
+	if (new & VM_WRITE)
 		return true;
 
-	if (!(vma->vm_flags & VM_EXEC) && (vm_flags & VM_EXEC))
+	/* ...nor newly executable VMAs. */
+	if (!(old & VM_EXEC))
 		return true;
 
 	return false;
--- a/mm/mmap.c~mm-refactor-map_deny_write_exec
+++ a/mm/mmap.c
@@ -1504,7 +1504,7 @@ unsigned long mmap_region(struct file *f
 		vma_set_anonymous(vma);
 	}
 
-	if (map_deny_write_exec(vma, vma->vm_flags)) {
+	if (map_deny_write_exec(vma->vm_flags, vma->vm_flags)) {
 		error = -EACCES;
 		goto close_and_free_vma;
 	}
--- a/mm/mprotect.c~mm-refactor-map_deny_write_exec
+++ a/mm/mprotect.c
@@ -810,7 +810,7 @@ static int do_mprotect_pkey(unsigned lon
 			break;
 		}
 
-		if (map_deny_write_exec(vma, newflags)) {
+		if (map_deny_write_exec(vma->vm_flags, newflags)) {
 			error = -EACCES;
 			break;
 		}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
mm-vma-add-expand-only-vma-merge-mode-and-optimise-do_brk_flags.patch
tools-testing-add-expand-only-mode-vma-test.patch
mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-insolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-do-not-attempt-second-merge-for-file-backed-vmas.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

