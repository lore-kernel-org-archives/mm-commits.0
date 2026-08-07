Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB533B8BBF
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068062; cv=none; b=N0OeHTCbD+kA+xw7TVfRvd85laBRcP+jk5iSF1cOdASYxNIo/7r/h2q6XiBwLawKExIQ025RGC0eMpbLhiG4eEH0oYG7VR8NQ9RUwv+t9t/XgCVFjtTOLJH6o3+9JRERmuZiio9h+7L3ynsemOg3X8vl5ijCXs9MNkbU6iLZx5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068062; c=relaxed/simple;
	bh=j0vhJg++VmTrhNjeW1To6iFt4uW9uIgW1dPyS7/W9J8=;
	h=Date:To:From:Subject:Message-Id; b=epAageQGDyXIgzP9lUwoGmz8Y6PSTCalibjNz4s9sYZRGYmLbo/8nmDjupmyDAZDNdvf7EDddpplG0s2B50dPyn5wzex9zA3dpRkB5nGlkMeRIhruDaMh6xw7u1xCiMmw+iv/+KibjK8I24cDqmyDibyWviTHFEz1VLb40U0Jkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPWMSfIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPWMSfIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E93E1F00A3D;
	Fri,  7 Aug 2026 02:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068056;
	bh=KLohWVdgsZNSdmxZstMigV2QQcIoMr4VwlmX4fyqtoQ=;
	h=Date:To:From:Subject;
	b=VPWMSfIX+60Pp/sv/vNRkfuvEke0XsqYRQBfZNFB6PWcgCSS9e/+eSy4r1VMH5PKX
	 ocyPrDPg638fYshv9l24qzhXx/xXwiE+jWiXovtsWWly9g1rrQM1iiKbZUdxjzuq3s
	 DgXXWc1zfurf+47gKi8oSd8/gNNkqhqtHMfJJoS0=
Date: Thu, 06 Aug 2026 19:00:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,lance.yang@linux.dev,jannh@google.com,jani.nikula@intel.com,jack@suse.cz,dev.jain@arm.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,airlied@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20260807020056.0E93E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mlock: convert mlock code to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/mlock: convert mlock code to use vma_flags_t
Date: Sat, 11 Jul 2026 19:45:08 +0100

Replace use of the legacy vm_flags_t flags with vma_flags_t values
throughout the mlock logic.

Additionally update comments to reflect the changes to be consistent.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-11-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   88 +++++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 41 deletions(-)

--- a/mm/mlock.c~mm-mlock-convert-mlock-code-to-use-vma_flags_t
+++ a/mm/mlock.c
@@ -329,7 +329,7 @@ static inline bool allow_mlock_munlock(s
 	 * be split. And the pages are not in VM_LOCKed VMA
 	 * can be reclaimed.
 	 */
-	if (!(vma->vm_flags & VM_LOCKED))
+	if (!vma_test(vma, VMA_LOCKED_BIT))
 		return true;
 
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
@@ -368,7 +368,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test(vma, VMA_LOCKED_BIT))
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -393,7 +393,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 		if (!allow_mlock_munlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma_test(vma, VMA_LOCKED_BIT))
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -417,8 +417,8 @@ out:
  * @end - end of range in @vma
  * @new_vma_flags - the new set of flags for @vma.
  *
- * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
- * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
+ * Called for mlock(), mlock2() and mlockall(), to set @vma VMA_LOCKED_BIT;
+ * called for munlock() and munlockall(), to clear VMA_LOCKED_BIT from @vma.
  */
 static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end,
@@ -431,14 +431,14 @@ static void mlock_vma_pages_range(struct
 
 	/*
 	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VM_LOCKED vma,
+	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
 	 * will call mlock_vma_folio() and raise page's mlock_count:
 	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VM_IO,
-	 * which is a VM_SPECIAL flag not allowed on VM_LOCKED vmas.
+	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
+	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
 	 * mmap_lock is held in write mode here, so this weird
 	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VM_IO if VM_LOCKED.
+	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
 	 */
 	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
 		vma_flags_set(new_vma_flags, VMA_IO_BIT);
@@ -458,7 +458,7 @@ static void mlock_vma_pages_range(struct
 /*
  * mlock_fixup  - handle mlock[all]/munlock[all] requests.
  *
- * Filters out "special" vmas -- VM_LOCKED never gets set for these, and
+ * Filters out "special" vmas -- VMA_LOCKED_BIT never gets set for these, and
  * munlock is a no-op.  However, for some special vmas, we go ahead and
  * populate the ptes.
  *
@@ -466,24 +466,23 @@ static void mlock_vma_pages_range(struct
  */
 static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       struct vm_area_struct **prev, unsigned long start,
-	       unsigned long end, vm_flags_t newflags)
+	       unsigned long end, vma_flags_t *new_vma_flags)
 {
-	vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
 	const vma_flags_t old_vma_flags = vma->flags;
 	struct mm_struct *mm = vma->vm_mm;
 	int nr_pages;
 	int ret = 0;
 
-	if (vma_flags_same_pair(&old_vma_flags, &new_vma_flags) ||
+	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
 	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
 		/*
-		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
-		 * For secretmem, don't allow the memory to be unlocked.
+		 * Don't set VMA_LOCKED_BIT or VMA_LOCKONFAULT_BIT and don't
+		 * count.  For secretmem, don't allow the memory to be unlocked.
 		 */
 		goto out;
 	}
 
-	vma = vma_modify_flags(vmi, *prev, vma, start, end, &new_vma_flags);
+	vma = vma_modify_flags(vmi, *prev, vma, start, end, new_vma_flags);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
@@ -493,7 +492,7 @@ static int mlock_fixup(struct vma_iterat
 	 * Keep track of amount of locked VM.
 	 */
 	nr_pages = (end - start) >> PAGE_SHIFT;
-	if (!vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT))
+	if (!vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
 		nr_pages = -nr_pages;
 	else if (vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT))
 		nr_pages = 0;
@@ -502,15 +501,15 @@ static int mlock_fixup(struct vma_iterat
 	/*
 	 * vm_flags is protected by the mmap_lock held in write mode.
 	 * It's okay if try_to_unmap_one unmaps a page just after we
-	 * set VM_LOCKED, populate_vma_page_range will bring it back.
+	 * set VMA_LOCKED_BIT, populate_vma_page_range will bring it back.
 	 */
-	if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
+	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT) &&
 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
 		/* No work to do, and mlocking twice would be wrong */
 		vma_start_write(vma);
-		vma->flags = new_vma_flags;
+		vma->flags = *new_vma_flags;
 	} else {
-		mlock_vma_pages_range(vma, start, end, &new_vma_flags);
+		mlock_vma_pages_range(vma, start, end, new_vma_flags);
 	}
 out:
 	*prev = vma;
@@ -518,7 +517,7 @@ out:
 }
 
 static int apply_vma_lock_flags(unsigned long start, size_t len,
-				vm_flags_t flags)
+				const vma_flags_t *flags)
 {
 	unsigned long nstart, end, tmp;
 	struct vm_area_struct *vma, *prev;
@@ -543,18 +542,20 @@ static int apply_vma_lock_flags(unsigned
 	tmp = vma->vm_start;
 	for_each_vma_range(vmi, vma, end) {
 		int error;
-		vm_flags_t newflags;
+		vma_flags_t newflags;
 
 		if (vma->vm_start != tmp)
 			return -ENOMEM;
 
-		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
-		newflags |= flags;
+		newflags = vma->flags;
+		vma_flags_clear_mask(&newflags, VMA_LOCKED_MASK);
+		vma_flags_set_mask(&newflags, *flags);
+
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
-		error = mlock_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
+		error = mlock_fixup(&vmi, vma, &prev, nstart, tmp, &newflags);
 		if (error)
 			return error;
 		tmp = vma_iter_end(&vmi);
@@ -589,7 +590,7 @@ static unsigned long count_mm_mlocked_pa
 		end = start + len;
 
 	for_each_vma_range(vmi, vma, end) {
-		if (vma->vm_flags & VM_LOCKED) {
+		if (vma_test(vma, VMA_LOCKED_BIT)) {
 			if (start > vma->vm_start)
 				count -= (start - vma->vm_start);
 			if (end < vma->vm_end) {
@@ -615,7 +616,8 @@ static int __mlock_posix_error_return(lo
 	return retval;
 }
 
-static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t flags)
+static __must_check int do_mlock(unsigned long start, size_t len,
+				 vma_flags_t *flags)
 {
 	unsigned long locked;
 	unsigned long lock_limit;
@@ -664,24 +666,27 @@ static __must_check int do_mlock(unsigne
 
 SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
 {
-	return do_mlock(start, len, VM_LOCKED);
+	vma_flags_t flags = mk_vma_flags(VMA_LOCKED_BIT);
+
+	return do_mlock(start, len, &flags);
 }
 
 SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
 {
-	vm_flags_t vm_flags = VM_LOCKED;
+	vma_flags_t vma_flags = mk_vma_flags(VMA_LOCKED_BIT);
 
 	if (flags & ~MLOCK_ONFAULT)
 		return -EINVAL;
 
 	if (flags & MLOCK_ONFAULT)
-		vm_flags |= VM_LOCKONFAULT;
+		vma_flags_set(&vma_flags, VMA_LOCKONFAULT_BIT);
 
-	return do_mlock(start, len, vm_flags);
+	return do_mlock(start, len, &vma_flags);
 }
 
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
+	vma_flags_t flags = EMPTY_VMA_FLAGS;
 	int ret;
 
 	start = untagged_addr(start);
@@ -691,7 +696,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
-	ret = apply_vma_lock_flags(start, len, 0);
+	ret = apply_vma_lock_flags(start, len, &flags);
 	mmap_write_unlock(current->mm);
 
 	return ret;
@@ -705,14 +710,15 @@ SYSCALL_DEFINE2(munlock, unsigned long,
  * There are a couple of subtleties with this.  If mlockall() is called multiple
  * times with different flags, the values do not necessarily stack.  If mlockall
  * is called once including the MCL_FUTURE flag and then a second time without
- * it, VM_LOCKED and VM_LOCKONFAULT will be cleared from mm->def_vma_flags.
+ * it, VMA_LOCKED_BIT and VMA_LOCKONFAULT_BIT will be cleared from
+ * mm->def_vma_flags.
  */
 static int apply_mlockall_flags(int flags)
 {
 	VMA_ITERATOR(vmi, current->mm, 0);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev = NULL;
-	vm_flags_t to_add = 0;
+	vma_flags_t to_add = EMPTY_VMA_FLAGS;
 
 	vma_flags_clear_mask(&mm->def_vma_flags, VMA_LOCKED_MASK);
 	if (flags & MCL_FUTURE) {
@@ -726,20 +732,20 @@ static int apply_mlockall_flags(int flag
 	}
 
 	if (flags & MCL_CURRENT) {
-		to_add |= VM_LOCKED;
+		vma_flags_set(&to_add, VMA_LOCKED_BIT);
 		if (flags & MCL_ONFAULT)
-			to_add |= VM_LOCKONFAULT;
+			vma_flags_set(&to_add, VMA_LOCKONFAULT_BIT);
 	}
 
 	for_each_vma(vmi, vma) {
 		int error;
-		vm_flags_t newflags;
+		vma_flags_t newflags = vma->flags;
 
-		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
-		newflags |= to_add;
+		vma_flags_clear_mask(&newflags, VMA_LOCKED_MASK);
+		vma_flags_set_mask(&newflags, to_add);
 
 		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
-				    newflags);
+				    &newflags);
 		/* Ignore errors, but prev needs fixing up. */
 		if (error)
 			prev = vma;
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

