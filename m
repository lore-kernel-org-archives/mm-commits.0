Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4166838D6BD
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 19:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784317218; cv=none; b=eqK6qMzmt8liBjgAvFYO6lRakSMwYUcGCcjsIfwmwRM8OluFSQQ5pm5ygPBabDeBO3JLVg/d/YKXhdp9wbExSgvrVPx0VHCH/Xc+kx1E8p6Dtwg/ot8IYoE2tzX0iK8Anmz81X4p30IiqBH55Kl/z6Vnf+vsxKJ4vXLVdtLbyIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784317218; c=relaxed/simple;
	bh=O/FZyAwsygLfYX+H5ETIbsal4ReF8hDJjRt5zCjtayE=;
	h=Date:To:From:Subject:Message-Id; b=kHuQdpxtsO9kSd/WTLwV+4Iss5sCAye5JWOx/Lg0KnmIJaf4Myk4boyt46Sm3kVEszUcRXq811S+oa/2jxccYOfro5ErZw3CvcP5JiaUextS6bv3BM0cscAaR3sIyleIgL4wMt/fNvB9OqXvDbze+xRLt/SQCj2di4aBlx2/4Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MxqeMk27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MxqeMk27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8B11F00A3A;
	Fri, 17 Jul 2026 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784317215;
	bh=UCsRBOy9oaLds87GWrn9TEVlgaC8Ocvip7DNMaiArIw=;
	h=Date:To:From:Subject;
	b=MxqeMk27JjzFcp/3WqWzbiNaNJGwZkyagyVZytdlr7yOvWhiaQswpAwHN3RadR1a0
	 wPI68t+wNjZwGxqWO86C4eRriY+P4azijByjMjNry4nd/BbWo4BahkjZQeGMfDTSHh
	 IPCiUhzrcpQneki7ZXNm52fzks7CKgM6klmS07pk=
Date: Fri, 17 Jul 2026 12:40:14 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch added to mm-new branch
Message-Id: <20260717194015.5C8B11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: limit scope of mseal address zero to address zero
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch

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
Subject: mm/mseal: limit scope of mseal address zero to address zero
Date: Fri, 17 Jul 2026 18:27:10 +0100

Commit 44f65d900698 ("binfmt_elf: mseal address zero") unconditionally
provided do_mseal() to any internal kernel caller in order to address a
corner case slated for possible removal.

It also incorrectly attempts to mseal without checking to see whether the
mapping even succeeded.

Restrict the scope to the corner case by providing mseal_mmap_page_zero()
which asserts the MMAP_PAGE_ZERO personality.

Avoid unnecessary checks in the start, end range by abstracting the actual
mseal()'ing to mseal_range() and have mseal_mmap_page_zero() call that
instead.

Also only try to seal the VMA if we mapped the VMA.  This isn't strictly
necessary as the operation would error out anyway, but it's useless work
and could be problematic if me make future changes to mseal semantics.

Link: https://lore.kernel.org/20260717-mseal-fixups-v2-2-0daa0014b813@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c    |    7 +-----
 include/linux/mm.h |    8 +------
 mm/mseal.c         |   49 ++++++++++++++++++++++++++++++-------------
 3 files changed, 39 insertions(+), 25 deletions(-)

--- a/fs/binfmt_elf.c~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/fs/binfmt_elf.c
@@ -1353,11 +1353,8 @@ out_free_interp:
 		   emulate the SVr4 behavior. Sigh. */
 		error = vm_mmap(NULL, 0, PAGE_SIZE, PROT_READ | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE, 0);
-
-		retval = do_mseal(0, PAGE_SIZE, 0);
-		if (retval)
-			pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
-					    task_pid_nr(current), retval);
+		if (!error)
+			mseal_mmap_page_zero();
 	}
 
 	regs = current_pt_regs();
--- a/include/linux/mm.h~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/include/linux/mm.h
@@ -5291,13 +5291,9 @@ int reserve_mem_find_by_name(const char
 int reserve_mem_release_by_name(const char *name);
 
 #ifdef CONFIG_64BIT
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags);
+void mseal_mmap_page_zero(void);
 #else
-static inline int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
-{
-	/* noop on 32 bit */
-	return 0;
-}
+static inline void mseal_mmap_page_zero(void) {}
 #endif
 
 /*
--- a/mm/mseal.c~mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero
+++ a/mm/mseal.c
@@ -32,7 +32,7 @@ static bool range_contains_unmapped(unsi
 	return prev_end < end;
 }
 
-static int mseal_apply(unsigned long start, unsigned long end)
+static int __mseal_range(unsigned long start, unsigned long end)
 {
 	VMA_ITERATOR(vmi, current->mm, start);
 	struct vm_area_struct *vma, *prev;
@@ -66,6 +66,38 @@ static int mseal_apply(unsigned long sta
 	return 0;
 }
 
+static int mseal_range(unsigned long start, unsigned long end)
+{
+	int err;
+
+	err = mmap_write_lock_killable(current->mm);
+	if (err)
+		return err;
+	if (range_contains_unmapped(start, end))
+		err = -ENOMEM;
+	else
+		err = __mseal_range(start, end);
+	mmap_write_unlock(current->mm);
+	return err;
+}
+
+/**
+ * mseal_mmap_page_zero() - If the MMAP_PAGE_ZERO personality is set, mseal()
+ * the page mapped at address zero.
+ */
+void mseal_mmap_page_zero(void)
+{
+	int err;
+
+	if (WARN_ON_ONCE(!(current->personality & MMAP_PAGE_ZERO)))
+		return;
+
+	err = mseal_range(0, PAGE_SIZE);
+	if (err)
+		pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
+				    task_pid_nr(current), err);
+}
+
 /*
  * mseal(2) seals the VM's meta data from
  * selected syscalls.
@@ -118,11 +150,9 @@ static int mseal_apply(unsigned long sta
  *
  *  unseal() is not supported.
  */
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
-	struct mm_struct *mm = current->mm;
 	unsigned long end;
-	int ret = 0;
 	size_t len;
 
 	/* Verify flags not set. */
@@ -145,16 +175,7 @@ int do_mseal(unsigned long start, size_t
 	if (end == start)
 		return 0;
 
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
-	if (range_contains_unmapped(start, end))
-		ret = -ENOMEM;
-	else
-		ret = mseal_apply(start, end);
-
-	mmap_write_unlock(mm);
-	return ret;
+	return mseal_range(start, end);
 }
 
 SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-move-alloc-tag-to-mm.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch

