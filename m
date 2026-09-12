Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995954BEE5F
	for <mm-commits@vger.kernel.org>; Sat, 12 Sep 2026 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789192680; cv=none; b=i1Eyr+UbAtMfF9j+lzXcKwJRbljTyzgmXSRU4FUX9D3Tq03f8axffTUknPt/N3cAD6Q9QWyWentFrV4ELOMzrmXv394u0Ma1hNVlGZ3AB++HdlZah+d80+jy6fcQw8HUXakOeaVZE+Z/gPNCKPN7SSqhvpTIhc/36W8xdAwKor8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789192680; c=relaxed/simple;
	bh=hmFc439ppUK6cIKDkZ33nTcewCEJnvhfRCFwQJAaeF4=;
	h=Date:To:From:Subject:Message-Id; b=C0B+gMLBoYRGWXRKEalwWJEjkkJUjj9u8dJp6ptJSzK27ejJGSIOBbuLsBA7CWe28P5adLnaVpyzncWFezJ+Anfz1yvdwgnUKoIQ9ZLVu/gugrIGhIdYLuM2BtqqzzSHN4/YiJWvphqMWHHQZDM+W1Ner/xAq+V+4QfoMty1AWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HhrkjxZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HhrkjxZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184501F000FF;
	Sat, 12 Sep 2026 05:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789192678;
	bh=DpfXsDQgSEYuWef+SwdOy0MfxO6GODnzP9BWJ0uFMQI=;
	h=Date:To:From:Subject;
	b=HhrkjxZ8vPt7AH/yLGkuyiSHj/qGKuHGyYshVtEy/z6v9riusJB7VLCSl8uAQ1G+9
	 fuSSYa1Z6xRT/Ao2Nr/b6BQ/xMZ8bAAwIA+KRw3AA/d9iJ6AkbGihmDs0TGqMHtGK3
	 M0UJ7wFVjO3KHFUpIf3HiFDarPMlnbH0Kuh3Q6jc=
Date: Fri, 11 Sep 2026 22:57:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sparse@chrisli.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compilerh-add-assert_static_storage.patch added to mm-new branch
Message-Id: <20260912055758.184501F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler.h: add ASSERT_STATIC_STORAGE()
has been added to the -mm mm-new branch.  Its filename is
     compilerh-add-assert_static_storage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compilerh-add-assert_static_storage.patch

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

lib-fix-lock-initialization-in-region-allocation-benchmark.patch
compilerh-add-assert_static_storage.patch
idr-assert-static-storage-for-define_ida.patch
maple_tree-assert-static-storage-for-define_mtree.patch

