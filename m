Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC28A27E7F0
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 19:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768851249; cv=none; b=cjD/g7d+4cs9cOOdCbQVHVPabBzAYy1QvBnestwrY0ukeiZuuzE9tGKAQKO6EX9Yao+q9yLrYv0o8rBeyuXkZYnELodQIZRP4/PePAiQUkzAMKZsT8M00oPUsK41on3EVozeTOjuMi5nkmFrwLlHlK7NK8+wL1LbChgPixe8mOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768851249; c=relaxed/simple;
	bh=zzdobDahE7Fy1JqtTx4Rh0SHeECx9+0weXX1jKDLHcY=;
	h=Date:To:From:Subject:Message-Id; b=ojsmBRCKoeuALeUs+NB+gn8evAqtzjOP/NREcSsSr1C9Astjng/lOopvtuSzDPX4Gf42HdxQfl+V2QNUsg8KxUzhbHlPnLQChllh4Rz9ZA1o0b4nlEMLI7gwrVKf7C0UScXiS/uUufcGPuGYvEF7jaw58EXNOgyAgHNG4lifmfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UC3GWRbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UC3GWRbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538F8C116C6;
	Mon, 19 Jan 2026 19:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768851249;
	bh=zzdobDahE7Fy1JqtTx4Rh0SHeECx9+0weXX1jKDLHcY=;
	h=Date:To:From:Subject:From;
	b=UC3GWRbT2IF5wX25R3ScjeR4cTJ/I80HLRrpgdUNtnSUXAzKoiQMXBYPOy7mfTG+G
	 QE8c84wxCp3hiyIcsjPJ+kB+hFzbPHdaFTrL8JkYYM7qdjXYBZKKnIdiGSOSiE/O95
	 Aro0Nh8hg/a3NcJikPPLiBodnUWM3mYkVh614ozo=
Date: Mon, 19 Jan 2026 11:34:08 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch added to mm-new branch
Message-Id: <20260119193409.538F8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename vma_flag_test/set_atomic() to vma_test/set_atomic_flag()
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch

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
Subject: mm: rename vma_flag_test/set_atomic() to vma_test/set_atomic_flag()
Date: Mon, 19 Jan 2026 14:48:52 +0000

Patch series "mm: add bitmap VMA flag helpers and convert all mmap_prepare
to use them".

We introduced the bitmap VMA type vma_flags_t in the aptly named commit
9ea35a25d51b ("mm: introduce VMA flags bitmap type") in order to permit
future growth in VMA flags and to prevent the asinine requirement that VMA
flags be available to 64-bit kernels only if they happened to use a bit
number about 32-bits.

This is a long-term project as there are very many users of VMA flags
within the kernel that need to be updated in order to utilise this new
type.

In order to further this aim, this series adds a number of helper functions
to enable ordinary interactions with VMA flags - that is testing, setting
and clearing them.

In order to make working with VMA bit numbers less cumbersome this series
introduces the mk_vma_flags() helper macro which generates a vma_flags_t
from a variadic parameter list, e.g.:

	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
					 VMA_EXEC_BIT);

It turns out that the compiler optimises this very well to the point that
this is just as efficient as using VM_xxx pre-computed bitmap values.

This series then introduces the following functions:

	bool vma_flags_test_mask(vma_flags_t flags, vma_flags_t to_test);
	bool vma_flags_test_all_mask(vma_flags_t flags, vma_flags_t to_test);
	void vma_flags_set_mask(vma_flags_t *flags, vma_flags_t to_set);
	void vma_flags_clear_mask(vma_flags_t *flags, vma_flags_t to_clear);

Providing means of testing, setting, and clearing a specific vma_flags_t
mask.

For convenience, helper macros are provided - vma_flags_test(),
vma_flags_set() and vma_flags_clear(), each of which utilise mk_vma_flags()
to make these operations easier, as well as an EMPTY_VMA_FLAGS macro to
make initialisation of an empty vma_flags_t value easier, e.g.:

	vma_flags_t flags = EMPTY_VMA_FLAGS;

	vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
	...
	if (vma_flags_test(flags, VMA_READ_BIT)) {
		...
	}
	...
	if (vma_flags_test_all_mask(flags, VMA_REMAP_FLAGS)) {
		...
	}
	...
	vma_flags_clear(&flags, VMA_READ_BIT);

Since callers are often dealing with a vm_area_struct (VMA) or vm_area_desc
(VMA descriptor as used in .mmap_prepare) object, this series further
provides helpers for these - firstly vma_set_flags_mask() and vma_set_flags() for a
VMA:

	vma_flags_t flags = EMPTY_VMA_FLAGS:

	vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
	...
	vma_set_flags_mask(&vma, flags);
	...
	vma_set_flags(&vma, VMA_DONTDUMP_BIT);

Note that these do NOT ensure appropriate locks are taken and assume the
callers takes care of this.

For VMA descriptors this series adds vma_desc_[test, set,
clear]_flags_mask() and vma_desc_[test, set, clear]_flags() for a VMA
descriptor, e.g.:

	static int foo_mmap_prepare(struct vm_area_desc *desc)
	{
		...
		vma_desc_set_flags(desc, VMA_SEQ_READ_BIT);
		vma_desc_clear_flags(desc, VMA_RAND_READ_BIT);
		...
		if (vma_desc_test_flags(desc, VMA_SHARED_BIT) {
			...
		}
		...
	}

With these helpers introduced, this series then updates all mmap_prepare
users to make use of the vma_flags_t vm_area_desc->vma_flags field rather
than the legacy vm_flags_t vm_area_desc->vm_flags field.

In order to do so, several other related functions need to be updated, with
separate patches for larger changes in hugetlbfs, secretmem and shmem
before finally removing vm_area_desc->vm_flags altogether.

This lays the foundations for future elimination of vm_flags_t and
associated defines and functionality altogether in the long run, and
elimination of the use of vm_flags_t in f_op->mmap() hooks in the near term
as mmap_prepare replaces these.

There is a useful synergy between the VMA flags and mmap_prepare work here
as with this change in place, converting f_op->mmap() to f_op->mmap_prepare
naturally also converts use of vm_flags_t to vma_flags_t in all drivers
which declare mmap handlers.

This accounts for the majority of the users of the legacy vm_flags_*()
helpers and thus a large number of drivers which need to interact with VMA
flags in general.

This series also updates the userland VMA tests to account for the change,
and adds unit tests for these helper functions to assert that they behave
as expected.

In order to faciliate this change in a sensible way, the series also
separates out the VMA unit tests into - code that is duplicated from the
kernel that should be kept in sync, code that is customised for test
purposes and code that is stubbed out.

We also separate out the VMA userland tests into separate files to make it
easier to manage and to provide a sensible baseline for adding the userland
tests for these helpers.


This patch (of 12):

In order to stay consistent between functions which manipulate a
vm_flags_t argument of the form of vma_flags_...() and those which
manipulate a VMA (in this case the flags field of a VMA), rename
vma_flag_[test/set]_atomic() to vma_[test/set]_atomic_flag().

This lays the groundwork for adding VMA flag manipulation functions in a
subsequent commit.

Link: https://lkml.kernel.org/r/cover.1768834061.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/2e5b2bc153b1e0cd61ff1ae67cb6acd289ddfa7f.1768834061.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +++++--------
 mm/khugepaged.c    |    2 +-
 mm/madvise.c       |    2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag
+++ a/include/linux/mm.h
@@ -987,8 +987,7 @@ static inline void vm_flags_mod(struct v
 	__vm_flags_mod(vma, set, clear);
 }
 
-static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
-					   vma_flag_t bit)
+static inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma, vma_flag_t bit)
 {
 	const vm_flags_t mask = BIT((__force int)bit);
 
@@ -1003,14 +1002,13 @@ static inline bool __vma_flag_atomic_val
  * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
  * valid flags are allowed to do this.
  */
-static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
-				       vma_flag_t bit)
+static inline void vma_set_atomic_flag(struct vm_area_struct *vma, vma_flag_t bit)
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
 
 	vma_assert_stabilised(vma);
 
-	if (__vma_flag_atomic_valid(vma, bit))
+	if (__vma_atomic_valid_flag(vma, bit))
 		set_bit((__force int)bit, bitmap);
 }
 
@@ -1021,10 +1019,9 @@ static inline void vma_flag_set_atomic(s
  * This is necessarily racey, so callers must ensure that serialisation is
  * achieved through some other means, or that races are permissible.
  */
-static inline bool vma_flag_test_atomic(struct vm_area_struct *vma,
-					vma_flag_t bit)
+static inline bool vma_test_atomic_flag(struct vm_area_struct *vma, vma_flag_t bit)
 {
-	if (__vma_flag_atomic_valid(vma, bit))
+	if (__vma_atomic_valid_flag(vma, bit))
 		return test_bit((__force int)bit, &vma->vm_flags);
 
 	return false;
--- a/mm/khugepaged.c~mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag
+++ a/mm/khugepaged.c
@@ -1741,7 +1741,7 @@ static bool file_backed_vma_is_retractab
 	 * obtained on guard region installation after the flag is set, so this
 	 * check being performed under this lock excludes races.
 	 */
-	if (vma_flag_test_atomic(vma, VMA_MAYBE_GUARD_BIT))
+	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT))
 		return false;
 
 	return true;
--- a/mm/madvise.c~mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag
+++ a/mm/madvise.c
@@ -1140,7 +1140,7 @@ static long madvise_guard_install(struct
 	 * acquire an mmap/VMA write lock to read it. All remaining readers may
 	 * or may not see the flag set, but we don't care.
 	 */
-	vma_flag_set_atomic(vma, VMA_MAYBE_GUARD_BIT);
+	vma_set_atomic_flag(vma, VMA_MAYBE_GUARD_BIT);
 
 	/*
 	 * If anonymous and we are establishing page tables the VMA ought to
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

