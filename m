Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C652C27E7F0
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 19:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768851252; cv=none; b=jQG/qaXoAA/A25uofmkZojn8mVVoyNuiRFcYNvNbV9jGUgzvNHvyVzokNGrtoMhwUGmVB7S5Y6tTWJKpKmnByqN4+5pynWO+if4G/hf4CQP+tb02DyoVlPMSXtO1FMasqVWzqZzc3H8v+DuQsFJazSmk6JT5pv8bQHT4JwWfSKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768851252; c=relaxed/simple;
	bh=2O/j+c5NwQ3Dc7wusYegDcXMQazhapyvcpyFwGTD2jQ=;
	h=Date:To:From:Subject:Message-Id; b=pJplcZyOvCzkd7V7U66rWRrXIXCYX1dIkSJrivGizNfmXTMIxZnPXDj5kB2vXexeCq/bxr2nGjvZRsRcA0U4OAXhsYy7vgBuoV3OByMZF7gN3RciwxXefX5e9lJDJPrMfNb4k4TEd5aoF7yTZI8UxFmBqXxTufr6L/vPSw9VWCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VzzQWBN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VzzQWBN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A59C116C6;
	Mon, 19 Jan 2026 19:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768851252;
	bh=2O/j+c5NwQ3Dc7wusYegDcXMQazhapyvcpyFwGTD2jQ=;
	h=Date:To:From:Subject:From;
	b=VzzQWBN8lSPvrQNKpETB+ayY6rR6Ya80Kzbby7fdxDJtAD+dsF1fa6YvevK5p5w47
	 fzfncsKVWSrt7VB9m48hkH25UMMZ0uuQRVf6z/DeAX+uDhRqmorc9fpjuplj5HS4rK
	 acAHF5wmH8R10kv6lt4MYYnC4L1VSTNYRnXCe3J0=
Date: Mon, 19 Jan 2026 11:34:11 -0800
To: mm-commits@vger.kernel.org,jgg@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch added to mm-new branch
Message-Id: <20260119193412.64A59C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add mk_vma_flags() bitmap flag macro helper
has been added to the -mm mm-new branch.  Its filename is
     mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch

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
Subject: mm: add mk_vma_flags() bitmap flag macro helper
Date: Mon, 19 Jan 2026 14:48:53 +0000

This patch introduces the mk_vma_flags() macro helper to allow easy
manipulation of VMA flags utilising the new bitmap representation
implemented of VMA flags defined by the vma_flags_t type.

It is a variadic macro which provides a bitwise-or'd representation of all
of each individual VMA flag specified.

Note that, while we maintain VM_xxx flags for backwards compatibility
until the conversion is complete, we define VMA flags of type vma_flag_t
using VMA_xxx_BIT to avoid confusing the two.

This helper macro therefore can be used thusly:

vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT);

We allow for up to 5 flags to specified at a time which should accommodate
all current kernel uses of combined VMA flags.

Testing has demonstrated that the compiler optimises this code such that
it generates the same assembly utilising this macro as it does if the
flags were specified manually, for instance:

vma_flags_t get_flags(void)
{
	return mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
}

Generates the same code as:

vma_flags_t get_flags(void)
{
	vma_flags_t flags;

	vma_flags_clear_all(&flags);
	vma_flag_set(&flags, VMA_READ_BIT);
	vma_flag_set(&flags, VMA_WRITE_BIT);
	vma_flag_set(&flags, VMA_EXEC_BIT);

	return flags;
}

And:

vma_flags_t get_flags(void)
{
	vma_flags_t flags;
	unsigned long *bitmap = ACCESS_PRIVATE(&flags, __vma_flags);

	*bitmap = 1UL << (__force int)VMA_READ_BIT;
	*bitmap |= 1UL << (__force int)VMA_WRITE_BIT;
	*bitmap |= 1UL << (__force int)VMA_EXEC_BIT;

	return flags;
}

That is:

get_flags:
        movl    $7, %eax
        ret

Link: https://lkml.kernel.org/r/2eb7bd931e63111207d434a50b355dd19dc8a814.1768834061.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/include/linux/mm.h~mm-add-mk_vma_flags-bitmap-flag-macro-helper
+++ a/include/linux/mm.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MM_H
 #define _LINUX_MM_H
 
+#include <linux/args.h>
 #include <linux/errno.h>
 #include <linux/mmdebug.h>
 #include <linux/gfp.h>
@@ -1027,6 +1028,38 @@ static inline bool vma_test_atomic_flag(
 	return false;
 }
 
+/* Set an individual VMA flag in flags, non-atomically. */
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
+/*
+ * Helper macro which bitwise-or combines the specified input flags into a
+ * vma_flags_t bitmap value. E.g.:
+ *
+ * vma_flags_t flags = mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,
+ * 		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+ *
+ * The compiler cleverly optimises away all of the work and this ends up being
+ * equivalent to aggregating the values manually.
+ */
+#define mk_vma_flags(...) __mk_vma_flags(COUNT_ARGS(__VA_ARGS__), \
+					 (const vma_flag_t []){__VA_ARGS__})
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
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

