Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BE43803E3
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 19:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784316911; cv=none; b=FUetXriCFFCDUIqirqBaclkD4IALZVlySBaGBlC6EZbgekzWbIX/VHzvev5KsBx7JWEwPAbOEGtFx6fIV9NgJ7AEbnkMnJuIVOfDrU2qzC/InA+xp+2TmXE2JBRV0vIBPSZTZOX3BvVlviDYAR0IJvJ0t/AyqP7G1sQl974beeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784316911; c=relaxed/simple;
	bh=fSnalIymk73dcKd5kTaK9W6sYWHJXRULsfSTqGoK+1c=;
	h=Date:To:From:Subject:Message-Id; b=bTNzvDjRlyr1SMplE5Gx2xNCebZttwRAB3CIYSkIpZGAgzOfFio8Cj4Cwl2V5IoSdIAB8nJ8CNJokIYkn8Xud1Nf72m99YiZyjuhN9rcelyer5saghF8qOOf0HjGW7upKXk/XB5JaIK1egoPERACenViXvkfgtP5PJukZraXTM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WfMEE7GP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WfMEE7GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4671E1F000E9;
	Fri, 17 Jul 2026 19:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784316909;
	bh=y6FiRx6rAt/C5Qvhuv0K4yxsTl9+wDMgtHKVqHi9qMI=;
	h=Date:To:From:Subject;
	b=WfMEE7GPMAerAjbnWSZ/Oh2JOcWnTPZ01D8xVRFmQPQo7gKrsE3WcNYtn+B2k9H0/
	 9bLMnVdGWx4vAEvP3xQq1BmViwLBV6gR1yvDkKdFd3ad7buKYAo503o3SjpTzWm5Cn
	 mF+kRzxZqnguhXrLfpxqG8E6UOegf3Kc1in8lf3w=
Date: Fri, 17 Jul 2026 12:35:08 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch removed from -mm tree
Message-Id: <20260717193509.4671E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: remove superfluous comments, fix confusion around mm
has been removed from the -mm tree.  Its filename was
     mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mseal: remove superfluous comments, fix confusion around mm
Date: Thu, 16 Jul 2026 14:43:09 +0100

Patch series "mm/mseal: further cleanups", v3.

The mseal implementation is still rather confusing, so tighten things up a
little.

The only user of do_mseal() outside of the system call is the
MMAP_PAGE_ZERO process personality - retain better control over how mseal
is utilised by providing mseal_mmap_page_zero() for this instead.

The comments are overly long and confusing, so cut them down so they're a
lot clearer.

Remove confusing mm_struct params (mseal can not be used on remote mm's)
and wrap the actual system call logic into the system call declaration.


This patch (of 3):

Remove comment blocks that don't add value and eliminate any confusion
about whether or not we permit mseal()'ing of remote mm's by explicitly
referencing current->mm consistently.

Also avoid ugly goto by using an else branch.

No functional change intended.

Link: https://lore.kernel.org/20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org
Link: https://lore.kernel.org/20260716-mseal-fixups-v1-1-3a9609bf041b@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de> 
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
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

 mm/mseal.c |   48 ++++++++----------------------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

--- a/mm/mseal.c~mm-mseal-remove-superfluous-comments-fix-confusion-around-mm
+++ a/mm/mseal.c
@@ -16,28 +16,7 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-/*
- * mseal() disallows an input range which contain unmapped ranges (VMA holes).
- *
- * It disallows unmapped regions from start to end whether they exist at the
- * start, in the middle, or at the end of the range, or any combination thereof.
- *
- * This is because after sealing a range, there's nothing to stop memory mapping
- * of ranges in the remaining gaps later, meaning that the user might then
- * wrongly consider the entirety of the mseal()'d range to be sealed when it
- * in fact isn't.
- */
-
-/*
- * Does the [start, end) range contain any unmapped memory?
- *
- * We ensure that:
- * - start is part of a valid VMA.
- * - end is part of a valid VMA.
- * - no gap (unallocated memory) exists between start and end.
- */
-static bool range_contains_unmapped(struct mm_struct *mm,
-		unsigned long start, unsigned long end)
+static bool range_contains_unmapped(unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma;
 	unsigned long prev_end = start;
@@ -53,11 +32,10 @@ static bool range_contains_unmapped(stru
 	return prev_end < end;
 }
 
-static int mseal_apply(struct mm_struct *mm,
-		unsigned long start, unsigned long end)
+static int mseal_apply(unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma, *prev;
-	VMA_ITERATOR(vmi, mm, start);
+	VMA_ITERATOR(vmi, current->mm, start);
 
 	/* We know there are no gaps so this will be non-NULL. */
 	vma = vma_iter_load(&vmi);
@@ -145,7 +123,6 @@ int do_mseal(unsigned long start, size_t
 	size_t len;
 	int ret = 0;
 	unsigned long end;
-	struct mm_struct *mm = current->mm;
 
 	/* Verify flags not set. */
 	if (flags)
@@ -167,24 +144,15 @@ int do_mseal(unsigned long start, size_t
 	if (end == start)
 		return 0;
 
-	if (mmap_write_lock_killable(mm))
+	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
-	if (range_contains_unmapped(mm, start, end)) {
+	if (range_contains_unmapped(start, end))
 		ret = -ENOMEM;
-		goto out;
-	}
-
-	/*
-	 * Second pass, this should success, unless there are errors
-	 * from vma_modify_flags, e.g. merge/split error, or process
-	 * reaching the max supported VMAs, however, those cases shall
-	 * be rare.
-	 */
-	ret = mseal_apply(mm, start, end);
+	else
+		ret = mseal_apply(start, end);
 
-out:
-	mmap_write_unlock(mm);
+	mmap_write_unlock(current->mm);
 	return ret;
 }
 
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
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch

