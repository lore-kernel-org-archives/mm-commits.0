Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C838338D6BD
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 19:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784317220; cv=none; b=stVZ0bGnv3z8HvrahYqrXYgcCnHlxBS9oavt8DAKo8unvZK/KJ4WyyJMkJMipvsSYKZbyYFsH3znFAWGk4/qZ7MIgYO3HYdhKxUMMCUXrntjkEm1/1u9z9IdG4FC4ZR0J1rSM6w/V2pHBQXbio8Q3cd0cnwmHMdC+zil9k1O668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784317220; c=relaxed/simple;
	bh=2TiF3yp0kb/IvjPleu6/azlywzFIKCB0hGRG+A9/Pi0=;
	h=Date:To:From:Subject:Message-Id; b=rQf9enSnppftM7eFLSg3jYIQ1j46dk82+EtX9saNb3rQgbP7PLtcFp4gXlHzm9WOluKKxlAVPGtG43LoI0hRijt6ufIKjnRNjyVhXKB0yEvsUWFCkl8Kls4vXtyUZnQ1WAx09ycB4Z189RFLMPG7K8+aYWeKzpIyS34Xi6KbLKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ne3NHXkX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ne3NHXkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C231F000E9;
	Fri, 17 Jul 2026 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784317218;
	bh=7iK4H1QpgFfk5lk+ZDFbQL3Xlf9WnbXUJK1Rhx2Gl4A=;
	h=Date:To:From:Subject;
	b=ne3NHXkXQElVPKhyJTWZdmrvxzgCr4wQ4PiLYsHYNSFYScMB12CtVWM2KNgVl7f71
	 Xw2P559qFL7Uv/e9W2cR8azYrgpRvsmx94QFy2ZfL0RV+3MF8jelTQT6tFCD50bNV6
	 knY7T7LwYBKOJFULn9p7rqxoLe3pbItQECRgwzwY=
Date: Fri, 17 Jul 2026 12:40:18 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-remove-further-superfluous-comments-do_mseal.patch added to mm-new branch
Message-Id: <20260717194018.63C231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: remove further superfluous comments, do_mseal()
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-remove-further-superfluous-comments-do_mseal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-remove-further-superfluous-comments-do_mseal.patch

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
Subject: mm/mseal: remove further superfluous comments, do_mseal()
Date: Fri, 17 Jul 2026 18:27:11 +0100

There's no need to abstract do_mseal() any longer so put the system call
implementation in the system call declaration.

The comment around do_mseal() is strangely formatted, overly long and adds
a lot of superfluous information that the code already provides, so boil
it down to the essentials.

Link: https://lore.kernel.org/20260717-mseal-fixups-v2-3-0daa0014b813@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   74 +++++++++++----------------------------------------
 1 file changed, 16 insertions(+), 58 deletions(-)

--- a/mm/mseal.c~mm-mseal-remove-further-superfluous-comments-do_mseal
+++ a/mm/mseal.c
@@ -99,61 +99,25 @@ void mseal_mmap_page_zero(void)
 }
 
 /*
- * mseal(2) seals the VM's meta data from
- * selected syscalls.
+ * Seal VMAs in the specified input range to prevent an attacker replacing what
+ * is mapped in the range with something else.
  *
- * addr/len: VM address range.
+ * Disallows:
+ * - VMA unmapping, remapping or shrinking.
+ * - Overwriting the VMA with another one via mmap(), mremap() or similar.
+ * - Alteration of properties via mprotect()/pkey_mprotect().
+ * - Destructive madvise() behaviours (like MADV_DONTNEED) on anonymous read-only
+ *   ranges.
  *
- *  The address range by addr/len must meet:
- *   start (addr) must be in a valid VMA.
- *   end (addr + len) must be in a valid VMA.
- *   no gap (unallocated memory) between start and end.
- *   start (addr) must be page aligned.
+ * Since unmapped ranges can be mapped at any time, the input range must span
+ * mapped ranges only.
  *
- *  len: len will be page aligned implicitly.
- *
- *   Below VMA operations are blocked after sealing.
- *   1> Unmapping, moving to another location, and shrinking
- *	the size, via munmap() and mremap(), can leave an empty
- *	space, therefore can be replaced with a VMA with a new
- *	set of attributes.
- *   2> Moving or expanding a different vma into the current location,
- *	via mremap().
- *   3> Modifying a VMA via mmap(MAP_FIXED).
- *   4> Size expansion, via mremap(), does not appear to pose any
- *	specific risks to sealed VMAs. It is included anyway because
- *	the use case is unclear. In any case, users can rely on
- *	merging to expand a sealed VMA.
- *   5> mprotect and pkey_mprotect.
- *   6> Some destructive madvice() behavior (e.g. MADV_DONTNEED)
- *      for anonymous memory, when users don't have write permission to the
- *	memory. Those behaviors can alter region contents by discarding pages,
- *	effectively a memset(0) for anonymous memory.
- *
- *  flags: reserved.
- *
- * return values:
- *  zero: success.
- *  -EINVAL:
- *   invalid input flags.
- *   start address is not page aligned.
- *   Address range (start + len) overflow.
- *  -ENOMEM:
- *   addr is not a valid address (not allocated).
- *   end (start + len) is not a valid address.
- *   a gap (unallocated memory) between start and end.
- *  -EPERM:
- *  - In 32 bit architecture, sealing is not supported.
- * Note:
- *  user can call mseal(2) multiple times, adding a seal on an
- *  already sealed memory is a no-action (no error).
- *
- *  unseal() is not supported.
+ * The flags parameter is currently reserved.
  */
-static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long, flags)
 {
+	size_t len_aligned;
 	unsigned long end;
-	size_t len;
 
 	/* Verify flags not set. */
 	if (flags)
@@ -163,12 +127,12 @@ static int do_mseal(unsigned long start,
 	if (!PAGE_ALIGNED(start))
 		return -EINVAL;
 
-	len = PAGE_ALIGN(len_in);
+	len_aligned = PAGE_ALIGN(len);
 	/* Check to see whether len was rounded up from small -ve to zero. */
-	if (len_in && !len)
+	if (len && !len_aligned)
 		return -EINVAL;
 
-	end = start + len;
+	end = start + len_aligned;
 	if (end < start)
 		return -EINVAL;
 
@@ -177,9 +141,3 @@ static int do_mseal(unsigned long start,
 
 	return mseal_range(start, end);
 }
-
-SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,
-		flags)
-{
-	return do_mseal(start, len, flags);
-}
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

