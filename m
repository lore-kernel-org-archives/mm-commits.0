Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0F379DA
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756422133; cv=none; b=lN8JmSPvQRB30WQFO0wvFYSHWP94uOl3bMEJ1dkXQE4BjTNb3XtpzeIGHPEMuC1EF+QlZai/TgQsQz6k0Wfe6qw1/krCNutZ2IAUaDJ/lwwjAggl98s9WAm1ZPYXTQXql7jizycxe+qMw2H2tDqM62mIKDQ+uQuTOVCguT2B9uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756422133; c=relaxed/simple;
	bh=+XLm7AjzNFKh/e9JI1AtgygBtSBZ9MvEOgIxqNL14og=;
	h=Date:To:From:Subject:Message-Id; b=ldf+/8vHvqmFgezl+8DuHIndC/UsbxPpSJF245mhCMKkEMYgYqZP1ewSAj7JczniEnfaxiLn4GNPYnlilkvBEnT9TNWaBs+ZK7wB4/301ocADFQfox+mqctkY9+8RIt0PokgEZHHfimxF2jFg4gkfHjxShaDfSofPO81oijcHiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DaT3Qpdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DaT3Qpdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B8AC4CEEB;
	Thu, 28 Aug 2025 23:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756422133;
	bh=+XLm7AjzNFKh/e9JI1AtgygBtSBZ9MvEOgIxqNL14og=;
	h=Date:To:From:Subject:From;
	b=DaT3QpdzAYJR1wiJY3AbjB44tKBJG7bAtvBsf3WVSPSEqMqhsIwVEGSJOyAaLXkAK
	 9Gi+M93fv2UjHrO5NGUtDsx/kiRT8buhxFXEZrweR5M0IGpEmyEzYQY3PaKMXC/iEf
	 U8QeWAw5chbXWZY9wzDKjY/HOD0Gm0sNYG1MqlGs=
Date: Thu, 28 Aug 2025 16:02:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-use-existing-atomich-for-vma-maple-tests.patch added to mm-new branch
Message-Id: <20250828230213.32B8AC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: testing: use existing atomic.h for vma/maple tests
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-use-existing-atomich-for-vma-maple-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-use-existing-atomich-for-vma-maple-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: tools: testing: use existing atomic.h for vma/maple tests
Date: Thu, 28 Aug 2025 12:28:01 +0000

The shared userspace logic used for unit-testing maple tree and VMA code
currently has its own replacements for atomics helpers.  This is not
needed as the necessary APIs already have userspace implementations in the
tools tree.  Switching over to that allows deleting a bit of code.

Note that the implementation is different; while the version being deleted
here is implemented using liburcu, the existing version in tools uses
either x86 asm or compiler builtins.  It's assumed that both are equally
likely to be correct.

The tools tree's version of atomic_t is a struct type while the version
being deleted was just a typedef of an integer.  This means it's no longer
valid to call __sync_bool_compare_and_swap() directly on it.  One option
would be to just peek into the struct and call it on the field, but it
seems a little cleaner to just use the corresponding atomic.h API whic has
been added recently.  Now the fake mapping_map_writable() is copied from
the real one.

Link: https://lkml.kernel.org/r/20250828-b4-vma-no-atomic-h-v2-4-02d146a58ed2@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/linux/maple_tree.h |    6 ++----
 tools/testing/vma/linux/atomic.h        |   17 -----------------
 tools/testing/vma/vma_internal.h        |   12 +++---------
 3 files changed, 5 insertions(+), 30 deletions(-)

--- a/tools/testing/shared/linux/maple_tree.h~tools-testing-use-existing-atomich-for-vma-maple-tests
+++ a/tools/testing/shared/linux/maple_tree.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
-#define atomic_t int32_t
-#define atomic_inc(x) uatomic_inc(x)
-#define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) uatomic_set(x, y)
+#include <linux/atomic.h>
+
 #define U8_MAX UCHAR_MAX
 #include "../../../../include/linux/maple_tree.h"
diff --git a/tools/testing/vma/linux/atomic.h a/tools/testing/vma/linux/atomic.h
deleted file mode 100644
--- a/tools/testing/vma/linux/atomic.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-
-#ifndef _LINUX_ATOMIC_H
-#define _LINUX_ATOMIC_H
-
-#define atomic_t int32_t
-#define atomic_inc(x) uatomic_inc(x)
-#define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) uatomic_set(x, y)
-#define U8_MAX UCHAR_MAX
-
-#ifndef atomic_cmpxchg_relaxed
-#define  atomic_cmpxchg_relaxed		uatomic_cmpxchg
-#define  atomic_cmpxchg_release         uatomic_cmpxchg
-#endif /* atomic_cmpxchg_relaxed */
-
-#endif	/* _LINUX_ATOMIC_H */
--- a/tools/testing/vma/vma_internal.h~tools-testing-use-existing-atomich-for-vma-maple-tests
+++ a/tools/testing/vma/vma_internal.h
@@ -21,6 +21,7 @@
 
 #include <stdlib.h>
 
+#include <linux/atomic.h>
 #include <linux/list.h>
 #include <linux/maple_tree.h>
 #include <linux/mm.h>
@@ -1363,15 +1364,8 @@ static inline bool map_deny_write_exec(u
 
 static inline int mapping_map_writable(struct address_space *mapping)
 {
-	int c = atomic_read(&mapping->i_mmap_writable);
-
-	/* Derived from the raw_atomic_inc_unless_negative() implementation. */
-	do {
-		if (c < 0)
-			return -EPERM;
-	} while (!__sync_bool_compare_and_swap(&mapping->i_mmap_writable, c, c+1));
-
-	return 0;
+	return atomic_inc_unless_negative(&mapping->i_mmap_writable) ?
+		0 : -EPERM;
 }
 
 static inline unsigned long move_page_tables(struct pagetable_move_control *pmc)
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-remove-is_migrate_highatomic.patch
mm-page_alloc-harmonize-should_compact_retry-type.patch
tools-include-implement-a-couple-of-atomic_t-ops.patch
tools-testing-allow-importing-arch-headers-in-sharedmk.patch
tools-testing-support-extra_cflags-in-sharedmk.patch
tools-testing-use-existing-atomich-for-vma-maple-tests.patch

