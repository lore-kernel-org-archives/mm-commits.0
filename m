Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1061A5D8F0
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 19:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730490193; cv=none; b=Acm2qJIiXPcxRxxkH6z8OmpKSJ0UZiiU/6/BW37Y6C/72k56pcOy7QdkDvnJU4dxjn6Mq+Q+QpW7xLrDIaYsEFCpBzhojp03II5rZr44QqHxeHSB6AU1dk0A2NIEtslpNtbLHG9tML/b41WVGt5GDxZMSgOwEFEf+cou4JKMQgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730490193; c=relaxed/simple;
	bh=szZY95pxmFq8gHJsN0/QwwPzHpjdEQBhjvZlcZp5pxo=;
	h=Date:To:From:Subject:Message-Id; b=orTn64QYPKYVnHxnU7BDdwLysjwPYsc9DI5+9CcYXGK5Ols6muyhsVUK0xF0WGmLJVcGsM8PnBa8sgHLoEqLAFx/C4+JmWe+FAhfgGK4yfkYcINWvPr9GgYCw5NBYSntH6ILCNZi/Gbrt3Cj5Rt0Z79TSnOSMgql4AwRHfPnpMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NivQIGMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NivQIGMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771D8C4CECE;
	Fri,  1 Nov 2024 19:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730490192;
	bh=szZY95pxmFq8gHJsN0/QwwPzHpjdEQBhjvZlcZp5pxo=;
	h=Date:To:From:Subject:From;
	b=NivQIGMYKkKh+4iB681sQqxBmoD1gtkkl/K/mnFcHytpeIvnP0QMXPZtnDavUiPiy
	 /ttDW42SK+syJ+d4wzFPWfA0Cl1MFYyj8x3Q+AdBoz/U89DzV4LIiiTAB7P1O+wPGB
	 OrNUFRSXAcuvAI0flp7VEGfx9SIQpYgdxIofTgjQ=
Date: Fri, 01 Nov 2024 12:43:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch added to mm-unstable branch
Message-Id: <20241101194312.771D8C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unnecessary page_table_lock on stack expansion
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

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
Subject: mm: remove unnecessary page_table_lock on stack expansion
Date: Fri, 1 Nov 2024 18:46:27 +0000

Ever since commit 8d7071af8907 ("mm: always expand the stack with the mmap
write lock held") we have been expanding the stack with the mmap write
lock held.

This is true in all code paths:

get_arg_page()
  -> expand_downwards()
setup_arg_pages()
  -> expand_stack_locked()
    -> expand_downwards() / expand_upwards()
lock_mm_and_find_vma()
  -> expand_stack_locked()
    -> expand_downwards() / expand_upwards()
create_elf_tables()
  -> find_extend_vma_locked()
    -> expand_stack_locked()
expand_stack()
  -> vma_expand_down()
    -> expand_downwards()
expand_stack()
  -> vma_expand_up()
    -> expand_upwards()

Each of which acquire the mmap write lock before doing so.  Despite this,
we maintain code that acquires a page table lock in the expand_upwards()
and expand_downwards() code, stating that we hold a shared mmap lock and
thus this is necessary.

It is not, we do not have to worry about concurrent VMA expansions so we
can simply drop this, and update comments accordingly.

We do not even need be concerned with racing page faults, as
vma_start_write() is invoked in both cases.

Link: https://lkml.kernel.org/r/20241101184627.131391-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

--- a/mm/mmap.c~mm-remove-unnecessary-page_table_lock-on-stack-expansion
+++ a/mm/mmap.c
@@ -1039,6 +1039,8 @@ static int expand_upwards(struct vm_area
 	if (!(vma->vm_flags & VM_GROWSUP))
 		return -EFAULT;
 
+	mmap_assert_write_locked(mm);
+
 	/* Guard against exceeding limits of the address space. */
 	address &= PAGE_MASK;
 	if (address >= (TASK_SIZE & PAGE_MASK))
@@ -1074,11 +1076,7 @@ static int expand_upwards(struct vm_area
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
 	vma_start_write(vma);
-	/*
-	 * vma->vm_start/vm_end cannot change under us because the caller
-	 * is required to hold the mmap_lock in read mode.  We need the
-	 * anon_vma lock to serialize against concurrent expand_stacks.
-	 */
+	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
 	/* Somebody else might have raced and expanded it already */
@@ -1092,16 +1090,6 @@ static int expand_upwards(struct vm_area
 		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
-				/*
-				 * We only hold a shared mmap_lock lock here, so
-				 * we need to protect against concurrent vma
-				 * expansions.  anon_vma_lock_write() doesn't
-				 * help here, as we don't guarantee that all
-				 * growable vmas in a mm share the same root
-				 * anon vma.  So, we reuse mm->page_table_lock
-				 * to guard against concurrent vma expansions.
-				 */
-				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
@@ -1110,7 +1098,6 @@ static int expand_upwards(struct vm_area
 				/* Overwrite old entry in mtree. */
 				vma_iter_store(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
-				spin_unlock(&mm->page_table_lock);
 
 				perf_event_mmap(vma);
 			}
@@ -1137,6 +1124,8 @@ int expand_downwards(struct vm_area_stru
 	if (!(vma->vm_flags & VM_GROWSDOWN))
 		return -EFAULT;
 
+	mmap_assert_write_locked(mm);
+
 	address &= PAGE_MASK;
 	if (address < mmap_min_addr || address < FIRST_USER_ADDRESS)
 		return -EPERM;
@@ -1166,11 +1155,7 @@ int expand_downwards(struct vm_area_stru
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
 	vma_start_write(vma);
-	/*
-	 * vma->vm_start/vm_end cannot change under us because the caller
-	 * is required to hold the mmap_lock in read mode.  We need the
-	 * anon_vma lock to serialize against concurrent expand_stacks.
-	 */
+	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
 	/* Somebody else might have raced and expanded it already */
@@ -1184,16 +1169,6 @@ int expand_downwards(struct vm_area_stru
 		if (grow <= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
-				/*
-				 * We only hold a shared mmap_lock lock here, so
-				 * we need to protect against concurrent vma
-				 * expansions.  anon_vma_lock_write() doesn't
-				 * help here, as we don't guarantee that all
-				 * growable vmas in a mm share the same root
-				 * anon vma.  So, we reuse mm->page_table_lock
-				 * to guard against concurrent vma expansions.
-				 */
-				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
@@ -1203,7 +1178,6 @@ int expand_downwards(struct vm_area_stru
 				/* Overwrite old entry in mtree. */
 				vma_iter_store(&vmi, vma);
 				anon_vma_interval_tree_post_update_vma(vma);
-				spin_unlock(&mm->page_table_lock);
 
 				perf_event_mmap(vma);
 			}
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
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

