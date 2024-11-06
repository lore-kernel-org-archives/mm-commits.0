Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A1C13D281;
	Wed,  6 Nov 2024 00:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854224; cv=none; b=T1GIyIFaC6NQeEk3z7CbgN99s8Srnf3a3NEbkx9eulxGrOwMME2ie74VUb8AW16MxpNXT/OCrue+oYSRYmy8DFepBDOvKEtuamqNO6zO6XOYcuXjpVdgnrJU7SkA8R8CLsKYpDlq/KYUMCvm0OLthfFSzDg6rhebi7Rm2QjDl0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854224; c=relaxed/simple;
	bh=DPhc6Mwykp8CW2mXAz4i2Ek36TZ9bz6i4JN4j32ButU=;
	h=Date:To:From:Subject:Message-Id; b=jqDjjn+PgYamvjtJHXrAxUb47o93x2i3fKR6RwTexajKLvC7IdhADwoXlGBxlZeY13TElLfyBBCwDDj1mkblMt2XbxmRnfi/3LJSFWFxnceAP1fxaqJAQy5mD2ZUvz9p2avFTOYlvHst/qvMyV7+5KPZ4v6GsJEamzioM6Cc4Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1QlDsYPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1QlDsYPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E877C4CECF;
	Wed,  6 Nov 2024 00:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854224;
	bh=DPhc6Mwykp8CW2mXAz4i2Ek36TZ9bz6i4JN4j32ButU=;
	h=Date:To:From:Subject:From;
	b=1QlDsYPb0/ZRc02jXXAS+83kgznymQ7gJcdyP+zhe35XFpRVYtYMbq0PuTCHEiCjC
	 VEIvx7eYtpq9NPbRRIwQKHazBo9ZngS7BAMPPQuDObZvcdaWDW/P+FKN5iSsor0GV8
	 yhR19zGZzikAlRG+476ldh0UtWMBphZjyhaRg9ig=
Date: Tue, 05 Nov 2024 16:50:23 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@vger.kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,jannh@google.com,James.Bottomley@HansenPartnership.com,deller@gmx.de,davem@davemloft.net,catalin.marinas@arm.com,broonie@kernel.org,andreas@gaisler.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-refactor-map_deny_write_exec.patch removed from -mm tree
Message-Id: <20241106005024.5E877C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: refactor map_deny_write_exec()
has been removed from the -mm tree.  Its filename was
     mm-refactor-map_deny_write_exec.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

