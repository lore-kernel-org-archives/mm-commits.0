Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF62741B5
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 19:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768851286; cv=none; b=Dnk45nmYDaqVxjH6QgWvSnEoiYt1Cf4H9u5qnbG8Q6rx7KfzSXw92AnUgwhEKzfLrI56F8dCqWK1rRCf58CYp9Glbo0uGkce7SdQ2g9ikkQPG2EUom8P9jlIh9C9KcIxsAdCYE2a6LGGWQbLEMgCTc54e1M6WVECuupHY3jrQi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768851286; c=relaxed/simple;
	bh=N9mkHcLROc5DAKpPaDAvawatr8D1IdB6rNC1jpcbs20=;
	h=Date:To:From:Subject:Message-Id; b=V0+mNt/FqTyZLAs7jJH7159a1JxJuT8lIqRnQs25IQ6wMXVTcuG9Qnyl/oQL330MVNpAascmje0EiDK+27o9tMxl78wlr7FHAWpfxyuJWsTbwvb+hJfXWv60gbyIKn1lRH7hbLtQzjKaRqdDLRmyajzLSGMJW+TpafytdQcmOOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DzhLrN4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DzhLrN4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD21C116C6;
	Mon, 19 Jan 2026 19:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768851285;
	bh=N9mkHcLROc5DAKpPaDAvawatr8D1IdB6rNC1jpcbs20=;
	h=Date:To:From:Subject:From;
	b=DzhLrN4u7Bgzx71rLOpQNKlg3DpaeVlwO8rfodAr8USN1YobZQAxWNxidei6R3sUR
	 27h4kz4P2rHtBj3PQuqz7ZT5vgZfRTG2IEiZ+BzO6MOipu907BGQvvZPxxToWKybd5
	 OsKTqosqYP0KLK4bgSeAtv1mFBdhL/CLRwdICgWw=
Date: Mon, 19 Jan 2026 11:34:45 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vm_area_desc-utilise-vma_flags_t-only.patch added to mm-new branch
Message-Id: <20260119193445.BFD21C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make vm_area_desc utilise vma_flags_t only
has been added to the -mm mm-new branch.  Its filename is
     mm-make-vm_area_desc-utilise-vma_flags_t-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-vm_area_desc-utilise-vma_flags_t-only.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: make vm_area_desc utilise vma_flags_t only
Date: Mon, 19 Jan 2026 14:49:00 +0000

Now we have eliminated all uses of vm_area_desc->vm_flags, eliminate this
field, and have mmap_prepare users utilise the vma_flags_t
vm_area_desc->vma_flags field only.

As part of this change we alter is_shared_maywrite() to accept a
vma_flags_t parameter, and introduce is_shared_maywrite_vm_flags() for use
with legacy vm_flags_t flags.

We also update struct mmap_state to add a union between vma_flags and
vm_flags temporarily until the mmap logic is also converted to using
vma_flags_t.

Also update the VMA userland tests to reflect this change.

Link: https://lkml.kernel.org/r/8a80f23faea395bcf29cdad8ab903de6becd64c5.1768834061.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    9 +++++++--
 include/linux/mm_types.h         |    5 +----
 mm/filemap.c                     |    2 +-
 mm/util.c                        |    2 +-
 mm/vma.c                         |   11 +++++++----
 mm/vma.h                         |    3 +--
 tools/testing/vma/vma_internal.h |    9 +++++++--
 7 files changed, 25 insertions(+), 16 deletions(-)

--- a/include/linux/mm.h~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/include/linux/mm.h
@@ -1291,15 +1291,20 @@ static inline bool vma_is_accessible(con
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
-static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
 {
 	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
 		(VM_SHARED | VM_MAYWRITE);
 }
 
+static inline bool is_shared_maywrite(vma_flags_t flags)
+{
+	return vma_flags_test_all(flags, VMA_SHARED_BIT, VMA_MAYWRITE_BIT);
+}
+
 static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 {
-	return is_shared_maywrite(vma->vm_flags);
+	return is_shared_maywrite(vma->flags);
 }
 
 static inline
--- a/include/linux/mm_types.h~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/include/linux/mm_types.h
@@ -877,10 +877,7 @@ struct vm_area_desc {
 	/* Mutable fields. Populated with initial state. */
 	pgoff_t pgoff;
 	struct file *vm_file;
-	union {
-		vm_flags_t vm_flags;
-		vma_flags_t vma_flags;
-	};
+	vma_flags_t vma_flags;
 	pgprot_t page_prot;
 
 	/* Write-only fields. */
--- a/mm/filemap.c~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/mm/filemap.c
@@ -4012,7 +4012,7 @@ int generic_file_readonly_mmap(struct fi
 
 int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (is_shared_maywrite(desc->vm_flags))
+	if (is_shared_maywrite(desc->vma_flags))
 		return -EINVAL;
 	return generic_file_mmap_prepare(desc);
 }
--- a/mm/util.c~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/mm/util.c
@@ -1154,7 +1154,7 @@ int __compat_vma_mmap(const struct file_
 
 		.pgoff = vma->vm_pgoff,
 		.vm_file = vma->vm_file,
-		.vm_flags = vma->vm_flags,
+		.vma_flags = vma->flags,
 		.page_prot = vma->vm_page_prot,
 
 		.action.type = MMAP_NOTHING, /* Default */
--- a/mm/vma.c~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/mm/vma.c
@@ -15,7 +15,10 @@ struct mmap_state {
 	unsigned long end;
 	pgoff_t pgoff;
 	unsigned long pglen;
-	vm_flags_t vm_flags;
+	union {
+		vm_flags_t vm_flags;
+		vma_flags_t vma_flags;
+	};
 	struct file *file;
 	pgprot_t page_prot;
 
@@ -2369,7 +2372,7 @@ static void set_desc_from_map(struct vm_
 
 	desc->pgoff = map->pgoff;
 	desc->vm_file = map->file;
-	desc->vm_flags = map->vm_flags;
+	desc->vma_flags = map->vma_flags;
 	desc->page_prot = map->page_prot;
 }
 
@@ -2650,7 +2653,7 @@ static int call_mmap_prepare(struct mmap
 		map->file_doesnt_need_get = true;
 		map->file = desc->vm_file;
 	}
-	map->vm_flags = desc->vm_flags;
+	map->vma_flags = desc->vma_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
 	map->vm_ops = desc->vm_ops;
@@ -2823,7 +2826,7 @@ unsigned long mmap_region(struct file *f
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && is_shared_maywrite(vm_flags)) {
+	if (file && is_shared_maywrite_vm_flags(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)
--- a/mm/vma.h~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/mm/vma.h
@@ -286,8 +286,7 @@ static inline void set_vma_from_desc(str
 	vma->vm_pgoff = desc->pgoff;
 	if (desc->vm_file != vma->vm_file)
 		vma_set_file(vma, desc->vm_file);
-	if (desc->vm_flags != vma->vm_flags)
-		vm_flags_set(vma, desc->vm_flags);
+	vma->flags = desc->vma_flags;
 	vma->vm_page_prot = desc->page_prot;
 
 	/* User-defined fields. */
--- a/tools/testing/vma/vma_internal.h~mm-make-vm_area_desc-utilise-vma_flags_t-only
+++ a/tools/testing/vma/vma_internal.h
@@ -1009,15 +1009,20 @@ static inline void vma_desc_clear_flags_
 #define vma_desc_clear_flags(desc, ...) \
 	vma_desc_clear_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
 
-static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+static inline bool is_shared_maywrite_vm_flags(vm_flags_t vm_flags)
 {
 	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
 		(VM_SHARED | VM_MAYWRITE);
 }
 
+static inline bool is_shared_maywrite(vma_flags_t flags)
+{
+	return vma_flags_test_all(flags, VMA_SHARED_BIT, VMA_MAYWRITE_BIT);
+}
+
 static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
 {
-	return is_shared_maywrite(vma->vm_flags);
+	return is_shared_maywrite(vma->flags);
 }
 
 static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch
mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
locking-add-rwsem_is_write_locked-update-non-lockdep-asserts.patch
mm-vma-add-vma_is__locked-helpers.patch
mm-add-use-vma_is_stabilised-vma_assert_stabilised-helpers.patch
selftests-mm-remove-virtual_address_range-test.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

