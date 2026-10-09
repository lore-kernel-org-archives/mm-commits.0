Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251AB41A776
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525567; cv=none; b=c0vEyccirp3sH+NHFJEDG9uNvqb0C0bMM7IZ+uhfhXSPj1vOIUJq+roFV8nm7x66ORmJfN8splS3EIJh6ejIhPyjglt10w3P2yeaIMYSAIYDHZm3/f9Rko9tIdUoZyP0sZ8spR9x3XVEarJMF+wbkASkrOHB59FR2YtD/v8O13k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525567; c=relaxed/simple;
	bh=Vm+wDbaTx49QZAMM2H74ZuRZpnjQ8IefGi4HF9tA5lo=;
	h=Date:To:From:Subject:Message-Id; b=N7cldvMrO08PdnvsX31WdQgGFb3nAV8zV8mBmdrAbzwqdUBKJYvzWpqnuvPsCHa613DQdpfLrBoIxT4aQWkgg+d7BUkecYjJDJD9jK3vqRkzOVZQy/nB29zLYN7ZN20dvKoYbrHAtJkz0BzR/qD8WsC4114bJ/qxnZxJWzZeNuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eVieSwFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eVieSwFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE01F1F000FF;
	Fri,  9 Oct 2026 05:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525566;
	bh=SqxIntLP/i0W4h2Chpl1LDsroCa28U5LIGlbADwbSlA=;
	h=Date:To:From:Subject;
	b=eVieSwFvApoRm7zybeqOc7zIU3laHhG95ahL3229LgdRRfK9BwhGdcJcWPyvviNFC
	 Q86L1K4ZWE60cuopmZCa64bQCY5TB75wp9Ulr42w7VVxz2tPLvZ8a4rxQNwzUamqEj
	 CW9uQnDOsVoQPdfSgAd5bxZjZDqF/he93PGt6a0U=
Date: Thu, 08 Oct 2026 22:59:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sparse@chrisli.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] compilerh-add-assert_static_storage.patch removed from -mm tree
Message-Id: <20261009055925.EE01F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler.h: add ASSERT_STATIC_STORAGE()
has been removed from the -mm tree.  Its filename was
     compilerh-add-assert_static_storage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: compiler.h: add ASSERT_STATIC_STORAGE()
Date: Fri, 11 Sep 2026 18:14:41 -0400

Patch series "Catch automatic storage in IDA and Maple Tree definitions".

A 0day report [1] from the region allocation benchmark exposed a lockdep
initialization bug: a stack-local Maple Tree used MTREE_INIT(), whose
embedded lock has a static initializer.  On the first allocation, lockdep
rejected the lock address as a non-static class key and disabled locking
validation.  The IDA benchmark had the same issue, masked because it ran
after Maple Tree had already disabled lockdep.

The fix [2] switches the test to using mt_init_flags() and ida_init(). 
This series adds a compile-time check to the related DEFINE_IDA() and
DEFINE_MTREE() declaration macros to catch the same class of mistake
earlier.

Patch 1 introduces ASSERT_STATIC_STORAGE().  It declares an unused static
pointer initialized with the object's address, requiring that address to
be a valid static initializer.  Patches 2 and 3 apply the helper to IDA
and Maple Tree definitions, respectively.

The helper is mirrored in the tools compiler header.  The existing
automatic local IDAs and Maple Trees in the userspace radix-tree tests are
converted to runtime initialization.  The interval-tree span test keeps
its existing mt_init_flags() call and uses a plain Maple Tree declaration.

For example, an automatic local definition:

  void example(void)
  {
          DEFINE_IDA(ida);
          ida_destroy(&ida);
  }

now produces:

  error: initializer element is not constant
  note: in expansion of macro 'ASSERT_STATIC_STORAGE'
  note: in expansion of macro 'DEFINE_IDA'

File-scope definitions and static local definitions remain valid. 
Automatic local objects should use ida_init(), mt_init(), or
mt_init_flags().

The check is limited to declaration macros.  Direct uses of IDA_INIT(),
MTREE_INIT(), and MTREE_INIT_EXT() remain unchanged.  The helper cannot be
inserted directly into those initializer expressions because it expands to
a declaration.

Validated by GCC and Clang checks accepting static storage and rejecting
automatic storage The userspace IDR/IDA and Maple Tree test are passed as
well.


This patch (of 3):

Static lock initializers rely on a persistent object address when lockdep
assigns a lock-class key.  Using such an initializer for an automatic
local object can compile successfully but disable lockdep on the first
lock acquisition.

Add ASSERT_STATIC_STORAGE() for declaration macros that require static
storage duration.  It declares an unused static pointer initialized with
the object's address.  An automatic local object's address is not a valid
static initializer, so the compiler rejects it.

Mirror the helper in tools/include/linux/compiler.h because the userspace
radix-tree tests include the kernel IDA and Maple Tree headers with the
tools compiler definitions.

For example:

  void example(void)
  {
          int object;
          ASSERT_STATIC_STORAGE(object);
  }

GCC reports:

  error: initializer element is not constant
    name##_storage_check = &(name)
                           ^
  note: in expansion of macro 'ASSERT_STATIC_STORAGE'
    ASSERT_STATIC_STORAGE(object);

File-scope objects and static local objects remain valid.  The helper
takes an object identifier and must be used as a declaration after that
object has been declared.

Link: https://lore.kernel.org/all/20260911155244.1406122-1-ynorov@nvidia.com/
Link: https://lore.kernel.org/20260911221444.1523311-2-ynorov@nvidia.com
Link: https://download.01.org/0day-ci/archive/20260910/202609101106.771b567e-lkp@intel.com/ [1]
Link: https://lore.kernel.org/all/20260911155244.1406122-1-ynorov@nvidia.com/ [2]
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 include/linux/compiler.h       |    5 +++++
 tools/include/linux/compiler.h |    5 +++++
 2 files changed, 10 insertions(+)

--- a/include/linux/compiler.h~compilerh-add-assert_static_storage
+++ a/include/linux/compiler.h
@@ -275,6 +275,11 @@ static inline void *offset_to_ptr(const
 #define __ADDRESSABLE(sym) \
 	___ADDRESSABLE(sym, __section(".discard.addressable"))
 
+/* Enforce static storage duration. */
+#define ASSERT_STATIC_STORAGE(name) \
+	static typeof(name) * const __always_unused \
+		name##_storage_check = &(name)
+
 /*
  * This returns a constant expression while determining if an argument is
  * a constant expression, most importantly without evaluating the argument.
--- a/tools/include/linux/compiler.h~compilerh-add-assert_static_storage
+++ a/tools/include/linux/compiler.h
@@ -73,6 +73,11 @@
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 #endif
 
+/* Enforce static storage duration. */
+#define ASSERT_STATIC_STORAGE(name) \
+	static typeof(name) * const __always_unused \
+		name##_storage_check = &(name)
+
 /*
  * This returns a constant expression while determining if an argument is
  * a constant expression, most importantly without evaluating the argument.
_

Patches currently in -mm which might be from ynorov@nvidia.com are


