Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC6E11CAF;
	Wed, 30 Oct 2024 00:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730248567; cv=none; b=TXZbSxjw32t42ZclxuRqx1pRZQ5xyLJ5rZm6hI3Xzonr396gWcuCio1cyQ4da7UAKaa2alOhRuOQZgRjuvr1lTT1lZHze5uYTkJo6LKI8pOHKBQDwNbIgzq+JT6taN7eeiTycmz8NtN/dDdDWgEsjxjver9XmyCB1QI3+m/054U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730248567; c=relaxed/simple;
	bh=8vesT/xFqU5Kf+8PFkX29x88jV++6jCNH45XKYQ69HE=;
	h=Date:To:From:Subject:Message-Id; b=Np8a2F+M7FA7sFDlpnXi6ubf46m5jRlwMP4VmDA2Z8TkaDXzdvwC3DPCK4pO5VlV49KVY2uGOLcLNNuWXNn+Zt6MI8kvgfASgbJC81ILVtm8e3vPmSn5OmxuyVXTW0jyfguHvpl1eBiukHNBQWZ+YtdRnSuUh29BZDFlbKDXvkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LlTXSBgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LlTXSBgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC82C4CECD;
	Wed, 30 Oct 2024 00:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730248566;
	bh=8vesT/xFqU5Kf+8PFkX29x88jV++6jCNH45XKYQ69HE=;
	h=Date:To:From:Subject:From;
	b=LlTXSBgL2Gwavk1tMM5+YtnvInpGXWZNeTUyUf+CPTqortNOqtF3b6ccWyMDtK7uh
	 DfthVE2hFv1gNBW1SI1Yi/6e+XYr/FteMzcz4QlTKZqEpOy6ghfxFUOKSN5Jx7JrwW
	 MNswHtOEzFLKQBBYKIQGI3KeDf7HN8xuZjR322Y4=
Date: Tue, 29 Oct 2024 17:36:06 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@vger.kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,jannh@google.com,James.Bottomley@HansenPartnership.com,deller@gmx.de,davem@davemloft.net,catalin.marinas@arm.com,broonie@kernel.org,andreas@gaisler.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-map_deny_write_exec.patch added to mm-hotfixes-unstable branch
Message-Id: <20241030003606.ABC82C4CECD@smtp.kernel.org>
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
Date: Tue, 29 Oct 2024 18:11:46 +0000

Refactor the map_deny_write_exec() to not unnecessarily require a VMA
parameter but rather to accept VMA flags parameters, which allows us to
use this function early in mmap_region() in a subsequent commit.

While we're here, we refactor the function to be more readable and add
some additional documentation.

Link: https://lkml.kernel.org/r/6be8bb59cd7c68006ebb006eb9d8dc27104b1f70.1730224667.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |   21 ++++++++++++++++++---
 mm/mmap.c            |    2 +-
 mm/mprotect.c        |    2 +-
 mm/vma.h             |    2 +-
 4 files changed, 21 insertions(+), 6 deletions(-)

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
+	/* Under MDWE we do not accept newly writably executable VMAs... */
+	if (new & VM_WRITE)
 		return true;
 
-	if (!(vma->vm_flags & VM_EXEC) && (vm_flags & VM_EXEC))
+	/* ...nor previously non-executable VMAs becoming executable. */
+	if (!(old & VM_EXEC))
 		return true;
 
 	return false;
--- a/mm/mmap.c~mm-refactor-map_deny_write_exec
+++ a/mm/mmap.c
@@ -1505,7 +1505,7 @@ unsigned long mmap_region(struct file *f
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
--- a/mm/vma.h~mm-refactor-map_deny_write_exec
+++ a/mm/vma.h
@@ -42,7 +42,7 @@ struct vma_munmap_struct {
 	int vma_count;                  /* Number of vmas that will be removed */
 	bool unlock;                    /* Unlock after the munmap */
 	bool clear_ptes;                /* If there are outstanding PTE to be cleared */
-	/* 1 byte hole */
+	/* 2 byte hole */
 	unsigned long nr_pages;         /* Number of pages being removed */
 	unsigned long locked_vm;        /* Number of locked pages */
 	unsigned long nr_accounted;     /* Number of VM_ACCOUNT pages */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling.patch
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
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-defer-second-attempt-at-merge-on-mmap-fix.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

