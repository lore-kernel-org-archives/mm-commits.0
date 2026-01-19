Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2302C1594
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768851301; cv=none; b=evVTGZcrum4uzOb7fgc1LEHgwbHh8ZsgDvvM8MAuROzBeT6zTYHzWezWV4UnZf4IMbJEwGLm0IfOxRm1dDkMbDRmDB+odc03FBd1EqhTqAzP8UZmNa5rpF15hmVSo4E2cQFQWIL41chOElpijO9H6NlcD/p9WNiTbROEf7Mn8O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768851301; c=relaxed/simple;
	bh=IpvTsq8XhfwgKiBPgTkQa7S8X4LGG/OWZbSkNmgaCIo=;
	h=Date:To:From:Subject:Message-Id; b=lIVnpX12Y2QSNH800MO3SBmDtap5fZN/Bg5j0JlGYJI1CvKPcFH6lM2DwSqBAsXffLcK1hlghn+vwm35FU/UkmD5sRHxpJkoNbcI+e/uWLfSWogVMx0x+qvCJQIITdEJaJ1E0C8Qj15QBGbOK5A4YObfJWgI5ybt60gCe/TXL2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RC6/QAjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RC6/QAjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA28EC116C6;
	Mon, 19 Jan 2026 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768851300;
	bh=IpvTsq8XhfwgKiBPgTkQa7S8X4LGG/OWZbSkNmgaCIo=;
	h=Date:To:From:Subject:From;
	b=RC6/QAjGTUBqlY+rgsohipZ+pZimLTUw9Z2IkxEjgfM09nvBQqdRsuI0RucGIliz5
	 FA4NwNtEv2IxUkjnZhGF8wncTMJurzno5rjAkDmsz70toF/Oh/MHdpbQl79pgsS05F
	 m4OLPYynqoM4VWdu1fPh9d0uVTCcSEnQ7PAEQtts=
Date: Mon, 19 Jan 2026 11:35:00 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch added to mm-new branch
Message-Id: <20260119193500.DA28EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: add VMA userland tests for VMA flag functions
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

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
Subject: tools/testing/vma: add VMA userland tests for VMA flag functions
Date: Mon, 19 Jan 2026 14:49:03 +0000

Now we have the capability to test the new helpers for the bitmap VMA
flags in userland, do so.

We also update the Makefile such that both VMA (and while we're here)
mm_struct flag sizes can be customised on build.  We default to 128-bit to
enable testing of flags above word size even on 64-bit systems.

We add userland tests to ensure that we do not regress VMA flag behaviour
with the introduction when using bitmap VMA flags, nor accidentally
introduce unexpected results due to for instance higher bit values not
being correctly cleared/set.

As part of this change, make __mk_vma_flags() a custom function so we can
handle specifying invalid VMA bits.  This is purposeful so we can have the
VMA tests work at lower and higher number of VMA flags without having to
duplicate code too much.

Link: https://lkml.kernel.org/r/2fbe7a18f517d7d8de9157f7f5b7bfc461cb7758.1768834061.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/Makefile       |    3 
 tools/testing/vma/tests/vma.c    |  300 +++++++++++++++++++++++++++++
 tools/testing/vma/vma_internal.h |   31 +-
 3 files changed, 322 insertions(+), 12 deletions(-)

--- a/tools/testing/vma/Makefile~tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions
+++ a/tools/testing/vma/Makefile
@@ -4,6 +4,9 @@
 
 default: vma
 
+# These can be varied to test different sizes.
+CFLAGS += -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128
+
 include ../shared/shared.mk
 
 OFILES = $(SHARED_OFILES) main.o shared.o maple-shim.o
--- a/tools/testing/vma/tests/vma.c~tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions
+++ a/tools/testing/vma/tests/vma.c
@@ -1,5 +1,25 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+static bool compare_legacy_flags(vm_flags_t legacy_flags, vma_flags_t flags)
+{
+	const unsigned long legacy_val = legacy_flags;
+	/* The lower word should contain the precise same value. */
+	const unsigned long flags_lower = flags.__vma_flags[0];
+#if NUM_VMA_FLAGS > BITS_PER_LONG
+	int i;
+
+	/* All bits in higher flag values should be zero. */
+	for (i = 1; i < NUM_VMA_FLAGS / BITS_PER_LONG; i++) {
+		if (flags.__vma_flags[i] != 0)
+			return false;
+	}
+#endif
+
+	static_assert(sizeof(legacy_flags) == sizeof(unsigned long));
+
+	return legacy_val == flags_lower;
+}
+
 static bool test_copy_vma(void)
 {
 	vm_flags_t vm_flags = VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE;
@@ -33,7 +53,287 @@ static bool test_copy_vma(void)
 	return true;
 }
 
+static bool test_vma_flags_unchanged(void)
+{
+	vma_flags_t flags = EMPTY_VMA_FLAGS;
+	vm_flags_t legacy_flags = 0;
+	int bit;
+	struct vm_area_struct vma;
+	struct vm_area_desc desc;
+
+
+	vma.flags = EMPTY_VMA_FLAGS;
+	desc.vma_flags = EMPTY_VMA_FLAGS;
+
+	for (bit = 0; bit < BITS_PER_LONG; bit++) {
+		vma_flags_t mask = mk_vma_flags(bit);
+
+		legacy_flags |= (1UL << bit);
+
+		/* Individual flags. */
+		vma_flags_set(&flags, bit);
+		ASSERT_TRUE(compare_legacy_flags(legacy_flags, flags));
+
+		/* Via mask. */
+		vma_flags_set_mask(&flags, mask);
+		ASSERT_TRUE(compare_legacy_flags(legacy_flags, flags));
+
+		/* Same for VMA. */
+		vma_set_flags(&vma, bit);
+		ASSERT_TRUE(compare_legacy_flags(legacy_flags, vma.flags));
+		vma_set_flags_mask(&vma, mask);
+		ASSERT_TRUE(compare_legacy_flags(legacy_flags, vma.flags));
+
+		/* Same for VMA descriptor. */
+		vma_desc_set_flags(&desc, bit);
+		ASSERT_TRUE(compare_legacy_flags(legacy_flags, desc.vma_flags));
+		vma_desc_set_flags_mask(&desc, mask);
+		ASSERT_TRUE(compare_legacy_flags(legacy_flags, desc.vma_flags));
+	}
+
+	return true;
+}
+
+static bool test_vma_flags_cleared(void)
+{
+	const vma_flags_t empty = EMPTY_VMA_FLAGS;
+	vma_flags_t flags;
+	int i;
+
+	/* Set all bits high. */
+	memset(&flags, 1, sizeof(flags));
+	/* Try to clear. */
+	vma_flags_clear_all(&flags);
+	/* Equal to EMPTY_VMA_FLAGS? */
+	ASSERT_EQ(memcmp(&empty, &flags, sizeof(flags)), 0);
+	/* Make sure every unsigned long entry in bitmap array zero. */
+	for (i = 0; i < sizeof(flags) / BITS_PER_LONG; i++) {
+		const unsigned long val = flags.__vma_flags[i];
+
+		ASSERT_EQ(val, 0);
+	}
+
+	return true;
+}
+
+/*
+ * Assert that VMA flag functions that operate at the system word level function
+ * correctly.
+ */
+static bool test_vma_flags_word(void)
+{
+	vma_flags_t flags = EMPTY_VMA_FLAGS;
+	const vma_flags_t comparison =
+		mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, 64, 65);
+
+	/* Set some custom high flags. */
+	vma_flags_set(&flags, 64, 65);
+	/* Now overwrite the first word. */
+	vma_flags_overwrite_word(&flags, VM_READ | VM_WRITE);
+	/* Ensure they are equal. */
+	ASSERT_EQ(memcmp(&flags, &comparison, sizeof(flags)), 0);
+
+	flags = EMPTY_VMA_FLAGS;
+	vma_flags_set(&flags, 64, 65);
+
+	/* Do the same with the _once() equivalent. */
+	vma_flags_overwrite_word_once(&flags, VM_READ | VM_WRITE);
+	ASSERT_EQ(memcmp(&flags, &comparison, sizeof(flags)), 0);
+
+	flags = EMPTY_VMA_FLAGS;
+	vma_flags_set(&flags, 64, 65);
+
+	/* Make sure we can set a word without disturbing other bits. */
+	vma_flags_set(&flags, VMA_WRITE_BIT);
+	vma_flags_set_word(&flags, VM_READ);
+	ASSERT_EQ(memcmp(&flags, &comparison, sizeof(flags)), 0);
+
+	flags = EMPTY_VMA_FLAGS;
+	vma_flags_set(&flags, 64, 65);
+
+	/* Make sure we can clear a word without disturbing other bits. */
+	vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+	vma_flags_clear_word(&flags, VM_EXEC);
+	ASSERT_EQ(memcmp(&flags, &comparison, sizeof(flags)), 0);
+
+	return true;
+}
+
+/* Ensure that vma_flags_test() and friends works correctly. */
+static bool test_vma_flags_test(void)
+{
+	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					       VMA_EXEC_BIT, 64, 65);
+	struct vm_area_struct vma;
+	struct vm_area_desc desc;
+
+	vma.flags = flags;
+	desc.vma_flags = flags;
+
+#define do_test(...)						\
+	ASSERT_TRUE(vma_flags_test(flags, __VA_ARGS__));	\
+	ASSERT_TRUE(vma_desc_test_flags(&desc, __VA_ARGS__))
+
+#define do_test_all_true(...)					\
+	ASSERT_TRUE(vma_flags_test_all(flags, __VA_ARGS__));	\
+	ASSERT_TRUE(vma_test_all_flags(&vma, __VA_ARGS__))
+
+#define do_test_all_false(...)					\
+	ASSERT_FALSE(vma_flags_test_all(flags, __VA_ARGS__));	\
+	ASSERT_FALSE(vma_test_all_flags(&vma, __VA_ARGS__))
+
+	/*
+	 * Testing for some flags that are present, some that are not - should
+	 * pass. ANY flags matching should work.
+	 */
+	do_test(VMA_READ_BIT, VMA_MAYREAD_BIT, VMA_SEQ_READ_BIT);
+	/* However, the ...test_all() variant should NOT pass. */
+	do_test_all_false(VMA_READ_BIT, VMA_MAYREAD_BIT, VMA_SEQ_READ_BIT);
+	/* But should pass for flags present. */
+	do_test_all_true(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64, 65);
+	/* Also subsets... */
+	do_test_all_true(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64);
+	do_test_all_true(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+	do_test_all_true(VMA_READ_BIT, VMA_WRITE_BIT);
+	do_test_all_true(VMA_READ_BIT);
+	/*
+	 * Check _mask variant. We don't need to test extensively as macro
+	 * helper is the equivalent.
+	 */
+	ASSERT_TRUE(vma_flags_test_mask(flags, flags));
+	ASSERT_TRUE(vma_flags_test_all_mask(flags, flags));
+
+	/* Single bits. */
+	do_test(VMA_READ_BIT);
+	do_test(VMA_WRITE_BIT);
+	do_test(VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	do_test(64);
+	do_test(65);
+#endif
+
+	/* Two bits. */
+	do_test(VMA_READ_BIT, VMA_WRITE_BIT);
+	do_test(VMA_READ_BIT, VMA_EXEC_BIT);
+	do_test(VMA_WRITE_BIT, VMA_EXEC_BIT);
+	/* Ordering shouldn't matter. */
+	do_test(VMA_WRITE_BIT, VMA_READ_BIT);
+	do_test(VMA_EXEC_BIT, VMA_READ_BIT);
+	do_test(VMA_EXEC_BIT, VMA_WRITE_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	do_test(VMA_READ_BIT, 64);
+	do_test(VMA_WRITE_BIT, 64);
+	do_test(64, VMA_READ_BIT);
+	do_test(64, VMA_WRITE_BIT);
+	do_test(VMA_READ_BIT, 65);
+	do_test(VMA_WRITE_BIT, 65);
+	do_test(65, VMA_READ_BIT);
+	do_test(65, VMA_WRITE_BIT);
+#endif
+	/* Three bits. */
+	do_test(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
+#if NUM_VMA_FLAG_BITS > 64
+	/* No need to consider every single permutation. */
+	do_test(VMA_READ_BIT, VMA_WRITE_BIT, 64);
+	do_test(VMA_READ_BIT, VMA_WRITE_BIT, 65);
+
+	/* Four bits. */
+	do_test(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64);
+	do_test(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 65);
+
+	/* Five bits. */
+	do_test(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT, 64, 65);
+#endif
+
+#undef do_test
+#undef do_test_all_true
+#undef do_test_all_false
+
+	return true;
+}
+
+/* Ensure that vma_flags_clear() and friends works correctly. */
+static bool test_vma_flags_clear(void)
+{
+	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+					 VMA_EXEC_BIT, 64, 65);
+	vma_flags_t mask = mk_vma_flags(VMA_EXEC_BIT, 64);
+	struct vm_area_struct vma;
+	struct vm_area_desc desc;
+
+	vma.flags = flags;
+	desc.vma_flags = flags;
+
+	/* Cursory check of _mask() variant, as the helper macros imply. */
+	vma_flags_clear_mask(&flags, mask);
+	vma_flags_clear_mask(&vma.flags, mask);
+	vma_desc_clear_flags_mask(&desc, mask);
+	ASSERT_FALSE(vma_flags_test(flags, VMA_EXEC_BIT, 64));
+	ASSERT_FALSE(vma_flags_test(vma.flags, VMA_EXEC_BIT, 64));
+	ASSERT_FALSE(vma_desc_test_flags(&desc, VMA_EXEC_BIT, 64));
+	/* Reset. */
+	vma_flags_set(&flags, VMA_EXEC_BIT, 64);
+	vma_set_flags(&vma, VMA_EXEC_BIT, 64);
+	vma_desc_set_flags(&desc, VMA_EXEC_BIT, 64);
+
+	/*
+	 * Clear the flags and assert clear worked, then reset flags back to
+	 * include specified flags.
+	 */
+#define do_test_and_reset(...)					\
+	vma_flags_clear(&flags, __VA_ARGS__);			\
+	vma_flags_clear(&vma.flags, __VA_ARGS__);		\
+	vma_desc_clear_flags(&desc, __VA_ARGS__);		\
+	ASSERT_FALSE(vma_flags_test(flags, __VA_ARGS__));	\
+	ASSERT_FALSE(vma_flags_test(vma.flags, __VA_ARGS__));	\
+	ASSERT_FALSE(vma_desc_test_flags(&desc, __VA_ARGS__));	\
+	vma_flags_set(&flags, __VA_ARGS__);			\
+	vma_set_flags(&vma, __VA_ARGS__);			\
+	vma_desc_set_flags(&desc, __VA_ARGS__)
+
+	/* Single flags. */
+	do_test_and_reset(VMA_READ_BIT);
+	do_test_and_reset(VMA_WRITE_BIT);
+	do_test_and_reset(VMA_EXEC_BIT);
+	do_test_and_reset(64);
+	do_test_and_reset(65);
+
+	/* Two flags, in different orders. */
+	do_test_and_reset(VMA_READ_BIT, VMA_WRITE_BIT);
+	do_test_and_reset(VMA_READ_BIT, VMA_EXEC_BIT);
+	do_test_and_reset(VMA_READ_BIT, 64);
+	do_test_and_reset(VMA_READ_BIT, 65);
+	do_test_and_reset(VMA_WRITE_BIT, VMA_READ_BIT);
+	do_test_and_reset(VMA_WRITE_BIT, VMA_EXEC_BIT);
+	do_test_and_reset(VMA_WRITE_BIT, 64);
+	do_test_and_reset(VMA_WRITE_BIT, 65);
+	do_test_and_reset(VMA_EXEC_BIT, VMA_READ_BIT);
+	do_test_and_reset(VMA_EXEC_BIT, VMA_WRITE_BIT);
+	do_test_and_reset(VMA_EXEC_BIT, 64);
+	do_test_and_reset(VMA_EXEC_BIT, 65);
+	do_test_and_reset(64, VMA_READ_BIT);
+	do_test_and_reset(64, VMA_WRITE_BIT);
+	do_test_and_reset(64, VMA_EXEC_BIT);
+	do_test_and_reset(64, 65);
+	do_test_and_reset(65, VMA_READ_BIT);
+	do_test_and_reset(65, VMA_WRITE_BIT);
+	do_test_and_reset(65, VMA_EXEC_BIT);
+	do_test_and_reset(65, 64);
+
+	/* Three flags. */
+
+#undef do_test_some_missing
+#undef do_test_and_reset
+
+	return true;
+}
+
 static void run_vma_tests(int *num_tests, int *num_fail)
 {
 	TEST(copy_vma);
+	TEST(vma_flags_unchanged);
+	TEST(vma_flags_cleared);
+	TEST(vma_flags_word);
+	TEST(vma_flags_test);
+	TEST(vma_flags_clear);
 }
--- a/tools/testing/vma/vma_internal.h~tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions
+++ a/tools/testing/vma/vma_internal.h
@@ -527,7 +527,7 @@ struct mutex {};
 #define DECLARE_BITMAP(name, bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
-#define NUM_MM_FLAG_BITS (64)
+/* NUM_MM_FLAG_BITS defined by test code. */
 typedef struct {
 	__private DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
 } mm_flags_t;
@@ -536,7 +536,7 @@ typedef struct {
  * Opaque type representing current VMA (vm_area_struct) flag state. Must be
  * accessed via vma_flags_xxx() helper functions.
  */
-#define NUM_VMA_FLAG_BITS BITS_PER_LONG
+/* NUM_VMA_FLAG_BITS defined by test code. */
 typedef struct {
 	DECLARE_BITMAP(__vma_flags, NUM_VMA_FLAG_BITS);
 } __private vma_flags_t;
@@ -904,16 +904,7 @@ static inline void vma_flag_set(vma_flag
 	__set_bit((__force int)bit, bitmap);
 }
 
-static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
-{
-	vma_flags_t flags;
-	int i;
-
-	vma_flags_clear_all(&flags);
-	for (i = 0; i < count; i++)
-		vma_flag_set(&flags, bits[i]);
-	return flags;
-}
+static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits);
 
 #define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
 					 (const vma_flag_t []){__VA_ARGS__})
@@ -1835,6 +1826,22 @@ static inline void vma_lock_init(struct
 		refcount_set(&vma->vm_refcnt, 0);
 }
 
+static inline vma_flags_t __mk_vma_flags(size_t count, const vma_flag_t *bits)
+{
+	vma_flags_t flags;
+	int i;
+
+	/*
+	 * For testing purposes: allow invalid bit specification so we can
+	 * easily test.
+	 */
+	vma_flags_clear_all(&flags);
+	for (i = 0; i < count; i++)
+		if (bits[i] < NUM_VMA_FLAG_BITS)
+			vma_flag_set(&flags, bits[i]);
+	return flags;
+}
+
 static inline void vma_numab_state_init(struct vm_area_struct *vma)
 {
 }
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

