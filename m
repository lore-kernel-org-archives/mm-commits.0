Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F05B26ED3D
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 19:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768851257; cv=none; b=PcnxKJEns/x5QA4hu2O2Hsn+p8FPPaG2OSTFrDq0KCAXpkBy+UevFynyLBrmI24BLgzL5W+8t+1Z/Lgml+pl0IDJqXOiwQhqI65ZlU2S4/q393kq4PEjOv4XQCBpJg0M7FtT3zTlrje6DgVeFh3FUPQ0UisZJRTVGQQouacsuGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768851257; c=relaxed/simple;
	bh=oqTCREk8qI0h0rhiLf74a6rSlehH0983pBn/jKWQyxo=;
	h=Date:To:From:Subject:Message-Id; b=hceslykJd2AsF1Yd8bkEBORQDgY/JWhtIJtWZS0RVodZ/hLlxeaXQ4tPLc+s1d5dE+4OPmt16oGR/DbgGXfVDblC7cPwg2ZyHd6C4KL6sruG25/VoOxHkb3QchEaKy58gLhNJ8pnBW7fXI+jH3iwNbbMldmiOtIYhHr2UKwrLGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c11sPSjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c11sPSjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3818BC116C6;
	Mon, 19 Jan 2026 19:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768851257;
	bh=oqTCREk8qI0h0rhiLf74a6rSlehH0983pBn/jKWQyxo=;
	h=Date:To:From:Subject:From;
	b=c11sPSjEaCh8oImWnyvmNW+jIUQr2+emmZS1npOx9Qe8i0uuA0Hw/XCIjqm5G2TNr
	 ooW/ZQfWI9cYnJdV5qh01FC1zuZ1hutDmsfLL2Dj9bDrYSuLQJdH4GkMEOGpLBL4jY
	 /MtLYT2DxX/+GvARrVYWvTWTyDlgU3YEuJS1Ncno=
Date: Mon, 19 Jan 2026 11:34:16 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-basic-vma-flag-operation-helper-functions.patch added to mm-new branch
Message-Id: <20260119193417.3818BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add basic VMA flag operation helper functions
has been added to the -mm mm-new branch.  Its filename is
     mm-add-basic-vma-flag-operation-helper-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-basic-vma-flag-operation-helper-functions.patch

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
Subject: mm: add basic VMA flag operation helper functions
Date: Mon, 19 Jan 2026 14:48:55 +0000

Now we have the mk_vma_flags() macro helper which permits easy
specification of any number of VMA flags, add helper functions which
operate with vma_flags_t parameters.

This patch provides vma_flags_test[_mask](), vma_flags_set[_mask]() and
vma_flags_clear[_mask]() respectively testing, setting and clearing flags
with the _mask variants accepting vma_flag_t parameters, and the non-mask
variants implemented as macros which accept a list of flags.

This allows us to trivially test/set/clear aggregate VMA flag values as
necessary, for instance:

	if (vma_flags_test(flags, VMA_READ_BIT, VMA_WRITE_BIT))
		goto readwrite;

	vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT);

	vma_flags_clear(&flags, VMA_READ_BIT, VMA_WRITE_BIT);

We also add a function for testing that ALL flags are set for convenience,
e.g.:

	if (vma_flags_test_all(flags, VMA_READ_BIT, VMA_MAYREAD_BIT)) {
		/* Both READ and MAYREAD flags set */
		...
	}

The compiler generates optimal assembly for each such that they behave as
if the caller were setting the bitmap flags manually.

This is important for e.g. drivers which manipulate flag values rather than
a VMA's specific flag values.

We also add helpers for testing, setting and clearing flags for VMA's and VMA
descriptors to reduce boilerplate.

Also add the EMPTY_VMA_FLAGS define to aid initialisation of empty flags.

Finally, update the userland VMA tests to add the helpers there so they can
be utilised as part of userland testing.

Link: https://lkml.kernel.org/r/6662dd9fe977edc7dde233edf5d762ee14a43fa0.1768834061.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |  165 +++++++++++++++++++++++++++++
 include/linux/mm_types.h         |    4 
 tools/testing/vma/vma_internal.h |  147 ++++++++++++++++++++++---
 3 files changed, 295 insertions(+), 21 deletions(-)

--- a/include/linux/mm.h~mm-add-basic-vma-flag-operation-helper-functions
+++ a/include/linux/mm.h
@@ -1060,6 +1060,171 @@ static inline vma_flags_t __mk_vma_flags
 #define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
 					 (const vma_flag_t []){__VA_ARGS__})
 
+/*  Test each of to_test flags in flags, non-atomically. */
+static __always_inline bool vma_flags_test_mask(vma_flags_t flags,
+		vma_flags_t to_test)
+{
+	const unsigned long *bitmap = ACCESS_PRIVATE(&flags, __vma_flags);
+	const unsigned long *bitmap_to_test = ACCESS_PRIVATE(&to_test, __vma_flags);
+
+	return bitmap_intersects(bitmap_to_test, bitmap, NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Test whether any specified VMA flag is set, e.g.:
+ *
+ * if (vma_flags_test(flags, VMA_READ_BIT, VMA_MAYREAD_BIT)) { ... }
+ */
+#define vma_flags_test(flags, ...) \
+	vma_flags_test_mask(flags, mk_vma_flags(__VA_ARGS__))
+
+/* Test that ALL of the to_test flags are set, non-atomically. */
+static __always_inline bool vma_flags_test_all_mask(vma_flags_t flags,
+		vma_flags_t to_test)
+{
+	const unsigned long *bitmap = ACCESS_PRIVATE(&flags, __vma_flags);
+	const unsigned long *bitmap_to_test = ACCESS_PRIVATE(&to_test, __vma_flags);
+
+	return bitmap_subset(bitmap_to_test, bitmap, NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Test whether ALL specified VMA flags are set, e.g.:
+ *
+ * if (vma_flags_test_all(flags, VMA_READ_BIT, VMA_MAYREAD_BIT)) { ... }
+ */
+#define vma_flags_test_all(flags, ...) \
+	vma_flags_test_all_mask(flags, mk_vma_flags(__VA_ARGS__))
+
+/* Set each of the to_set flags in flags, non-atomically. */
+static __always_inline void vma_flags_set_mask(vma_flags_t *flags, vma_flags_t to_set)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	const unsigned long *bitmap_to_set = ACCESS_PRIVATE(&to_set, __vma_flags);
+
+	bitmap_or(bitmap, bitmap, bitmap_to_set, NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Set all specified VMA flags, e.g.:
+ *
+ * vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+ */
+#define vma_flags_set(flags, ...) \
+	vma_flags_set_mask(flags, mk_vma_flags(__VA_ARGS__))
+
+/* Clear all of the to-clear flags in flags, non-atomically. */
+static __always_inline void vma_flags_clear_mask(vma_flags_t *flags, vma_flags_t to_clear)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	const unsigned long *bitmap_to_clear = ACCESS_PRIVATE(&to_clear, __vma_flags);
+
+	bitmap_andnot(bitmap, bitmap, bitmap_to_clear, NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Clear all specified individual flags, e.g.:
+ *
+ * vma_flags_clear(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+ */
+#define vma_flags_clear(flags, ...) \
+	vma_flags_clear_mask(flags, mk_vma_flags(__VA_ARGS__))
+
+/*
+ * Helper to test that ALL specified flags are set in a VMA.
+ *
+ * Note: appropriate locks must be held, this function does not acquire them for
+ * you.
+ */
+static inline bool vma_test_all_flags_mask(struct vm_area_struct *vma,
+					   vma_flags_t flags)
+{
+	return vma_flags_test_all_mask(vma->flags, flags);
+}
+
+/*
+ * Helper macro for checking that ALL specified flags are set in a VMA, e.g.:
+ *
+ * if (vma_test_all_flags(vma, VMA_READ_BIT, VMA_MAYREAD_BIT) { ... }
+ */
+#define vma_test_all_flags(vma, ...) \
+	vma_test_all_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+
+/*
+ * Helper to set all VMA flags in a VMA.
+ *
+ * Note: appropriate locks must be held, this function does not acquire them for
+ * you.
+ */
+static inline void vma_set_flags_mask(struct vm_area_struct *vma,
+				      vma_flags_t flags)
+{
+	vma_flags_set_mask(&vma->flags, flags);
+}
+
+/*
+ * Helper macro for specifying VMA flags in a VMA, e.g.:
+ *
+ * vma_set_flags(vma, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
+ * 		VMA_DONTDUMP_BIT);
+ *
+ * Note: appropriate locks must be held, this function does not acquire them for
+ * you.
+ */
+#define vma_set_flags(vma, ...) \
+	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+
+/* Helper to test all VMA flags in a VMA descriptor. */
+static inline bool vma_desc_test_flags_mask(struct vm_area_desc *desc,
+					    vma_flags_t flags)
+{
+	return vma_flags_test_mask(desc->vma_flags, flags);
+}
+
+/*
+ * Helper macro for testing VMA flags for an input pointer to a struct
+ * vm_area_desc object describing a proposed VMA, e.g.:
+ *
+ * if (vma_desc_test_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT,
+ *		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)) { ... }
+ */
+#define vma_desc_test_flags(desc, ...) \
+	vma_desc_test_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
+
+/* Helper to set all VMA flags in a VMA descriptor. */
+static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
+					   vma_flags_t flags)
+{
+	vma_flags_set_mask(&desc->vma_flags, flags);
+}
+
+/*
+ * Helper macro for specifying VMA flags for an input pointer to a struct
+ * vm_area_desc object describing a proposed VMA, e.g.:
+ *
+ * vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
+ * 		VMA_DONTDUMP_BIT);
+ */
+#define vma_desc_set_flags(desc, ...) \
+	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
+
+/* Helper to clear all VMA flags in a VMA descriptor. */
+static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
+					     vma_flags_t flags)
+{
+	vma_flags_clear_mask(&desc->vma_flags, flags);
+}
+
+/*
+ * Helper macro for clearing VMA flags for an input pointer to a struct
+ * vm_area_desc object describing a proposed VMA, e.g.:
+ *
+ * vma_desc_clear_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
+ * 		VMA_DONTDUMP_BIT);
+ */
+#define vma_desc_clear_flags(desc, ...) \
+	vma_desc_clear_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
--- a/include/linux/mm_types.h~mm-add-basic-vma-flag-operation-helper-functions
+++ a/include/linux/mm_types.h
@@ -834,7 +834,7 @@ struct mmap_action {
 
 	/*
 	 * If specified, this hook is invoked when an error occurred when
-	 * attempting the selection action.
+	 * attempting the selected action.
 	 *
 	 * The hook can return an error code in order to filter the error, but
 	 * it is not valid to clear the error here.
@@ -858,6 +858,8 @@ typedef struct {
 	DECLARE_BITMAP(__vma_flags, NUM_VMA_FLAG_BITS);
 } __private vma_flags_t;
 
+#define EMPTY_VMA_FLAGS ((vma_flags_t){ })
+
 /*
  * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
  * manipulate mutable fields which will cause those fields to be updated in the
--- a/tools/testing/vma/vma_internal.h~mm-add-basic-vma-flag-operation-helper-functions
+++ a/tools/testing/vma/vma_internal.h
@@ -21,7 +21,13 @@
 
 #include <stdlib.h>
 
+#ifdef __CONCAT
+#undef __CONCAT
+#endif
+
+#include <linux/args.h>
 #include <linux/atomic.h>
+#include <linux/bitmap.h>
 #include <linux/list.h>
 #include <linux/maple_tree.h>
 #include <linux/mm.h>
@@ -38,6 +44,8 @@ extern unsigned long dac_mmap_min_addr;
 #define dac_mmap_min_addr	0UL
 #endif
 
+#define ACCESS_PRIVATE(p, member) ((p)->member)
+
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
 #define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
@@ -533,6 +541,8 @@ typedef struct {
 	DECLARE_BITMAP(__vma_flags, NUM_VMA_FLAG_BITS);
 } __private vma_flags_t;
 
+#define EMPTY_VMA_FLAGS ((vma_flags_t){ })
+
 struct mm_struct {
 	struct maple_tree mm_mt;
 	int map_count;			/* number of VMAs */
@@ -882,6 +892,123 @@ static inline pgprot_t vm_get_page_prot(
 	return __pgprot(vm_flags);
 }
 
+static inline void vma_flags_clear_all(vma_flags_t *flags)
+{
+	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
+}
+
+static inline void vma_flag_set(vma_flags_t *flags, vma_flag_t bit)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+
+	__set_bit((__force int)bit, bitmap);
+}
+
+static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
+{
+	vma_flags_t flags;
+	int i;
+
+	vma_flags_clear_all(&flags);
+	for (i = 0; i < count; i++)
+		vma_flag_set(&flags, bits[i]);
+	return flags;
+}
+
+#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
+					 (const vma_flag_t []){__VA_ARGS__})
+
+static __always_inline bool vma_flags_test_mask(vma_flags_t flags,
+		vma_flags_t to_test)
+{
+	const unsigned long *bitmap = ACCESS_PRIVATE(&flags, __vma_flags);
+	const unsigned long *bitmap_to_test = ACCESS_PRIVATE(&to_test, __vma_flags);
+
+	return bitmap_intersects(bitmap_to_test, bitmap, NUM_VMA_FLAG_BITS);
+}
+
+#define vma_flags_test(flags, ...) \
+	vma_flags_test_mask(flags, mk_vma_flags(__VA_ARGS__))
+
+static __always_inline void vma_flags_set_mask(vma_flags_t *flags, vma_flags_t to_set)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	const unsigned long *bitmap_to_set = ACCESS_PRIVATE(&to_set, __vma_flags);
+
+	bitmap_or(bitmap, bitmap, bitmap_to_set, NUM_VMA_FLAG_BITS);
+}
+
+#define vma_flags_set(flags, ...) \
+	vma_flags_set_mask(flags, mk_vma_flags(__VA_ARGS__))
+
+static __always_inline void vma_flags_clear_mask(vma_flags_t *flags, vma_flags_t to_clear)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	const unsigned long *bitmap_to_clear = ACCESS_PRIVATE(&to_clear, __vma_flags);
+
+	bitmap_andnot(bitmap, bitmap, bitmap_to_clear, NUM_VMA_FLAG_BITS);
+}
+
+#define vma_flags_clear(flags, ...) \
+	vma_flags_clear_mask(flags, mk_vma_flags(__VA_ARGS__))
+
+static __always_inline bool vma_flags_test_all_mask(vma_flags_t flags,
+		vma_flags_t to_test)
+{
+	const unsigned long *bitmap = ACCESS_PRIVATE(&flags, __vma_flags);
+	const unsigned long *bitmap_to_test = ACCESS_PRIVATE(&to_test, __vma_flags);
+
+	return bitmap_subset(bitmap_to_test, bitmap, NUM_VMA_FLAG_BITS);
+}
+
+#define vma_flags_test_all(flags, ...) \
+	vma_flags_test_all_mask(flags, mk_vma_flags(__VA_ARGS__))
+
+static inline void vma_set_flags_mask(struct vm_area_struct *vma,
+				      vma_flags_t flags)
+{
+	vma_flags_set_mask(&vma->flags, flags);
+}
+
+#define vma_set_flags(vma, ...) \
+	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+
+static inline bool vma_test_all_flags_mask(struct vm_area_struct *vma,
+					   vma_flags_t flags)
+{
+	return vma_flags_test_all_mask(vma->flags, flags);
+}
+
+#define vma_test_all_flags(vma, ...) \
+	vma_test_all_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+
+static inline bool vma_desc_test_flags_mask(struct vm_area_desc *desc,
+					    vma_flags_t flags)
+{
+	return vma_flags_test_mask(desc->vma_flags, flags);
+}
+
+#define vma_desc_test_flags(desc, ...) \
+	vma_desc_test_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
+
+static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
+					   vma_flags_t flags)
+{
+	vma_flags_set_mask(&desc->vma_flags, flags);
+}
+
+#define vma_desc_set_flags(desc, ...) \
+	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
+
+static inline void vma_desc_clear_flags_mask(struct vm_area_desc *desc,
+					     vma_flags_t flags)
+{
+	vma_flags_clear_mask(&desc->vma_flags, flags);
+}
+
+#define vma_desc_clear_flags(desc, ...) \
+	vma_desc_clear_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
+
 static inline bool is_shared_maywrite(vm_flags_t vm_flags)
 {
 	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
@@ -1540,31 +1667,11 @@ static inline void userfaultfd_unmap_com
 {
 }
 
-#define ACCESS_PRIVATE(p, member) ((p)->member)
-
-#define bitmap_size(nbits)	(ALIGN(nbits, BITS_PER_LONG) / BITS_PER_BYTE)
-
-static __always_inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
-{
-	unsigned int len = bitmap_size(nbits);
-
-	if (small_const_nbits(nbits))
-		*dst = 0;
-	else
-		memset(dst, 0, len);
-}
-
 static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
 {
 	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
 }
 
-/* Clears all bits in the VMA flags bitmap, non-atomically. */
-static inline void vma_flags_clear_all(vma_flags_t *flags)
-{
-	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
-}
-
 /*
  * Copy value to the first system word of VMA flags, non-atomically.
  *
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

