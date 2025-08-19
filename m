Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69161270EAB
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646593; cv=none; b=UzFJmE6vCD9FYptYNhKwd70Gp7pKTdXPPPnZ44j1Vu/mQpGKWjEUHf7BSZ0G+8X3MPXqLq1szRbSx7s3hxkccKrmVRSM1kXavgFBbWoESXQdhDSYLHsHPqK3LGUvY1ACaurkoHrMUXKyBL8Ty41+YuMkKllUayFWBqGHlGMDnTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646593; c=relaxed/simple;
	bh=nCNZyWH0Ul3lsPcG6ot6rIK1zoIKKYXxhuDOY5S3pWc=;
	h=Date:To:From:Subject:Message-Id; b=G9HATS8kGgs/yje6m3JiP9Ng3nQbTsSjFgyK1l4rNWC70cxo0t7q2Rpqe7c4LbYcvAjSa0hb4J1hHtpXIG/BEFf+jdaT46XSRKOjFmJPcxYcPTF7b1lz7q+fQO91rd1yqTUX9HHu9On5NDVdNW8OOFyEGpbIx3MxQazbJk0ShlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=heHdwexM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="heHdwexM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D892BC4CEF1;
	Tue, 19 Aug 2025 23:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646592;
	bh=nCNZyWH0Ul3lsPcG6ot6rIK1zoIKKYXxhuDOY5S3pWc=;
	h=Date:To:From:Subject:From;
	b=heHdwexMGbWu/IM/zPvlnpI1Z/HZeXyJJSvLkg5saD78VnU8++YkZgierr9Z/awnl
	 PaLYUDCzl7x1X0bdCARllAoevAwrD8rfHMS9CQQW6hu+qYZqEoY+j82lEqlmJ7zWIX
	 wv1bf4VO3E+q8fxk53edIGbzWXXnqpBdFfY0lZOk=
Date: Tue, 19 Aug 2025 16:36:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,peterz@infradead.org,liam.howlett@oracle.com,jhubbard@nvidia.com,jannh@google.com,dan.j.williams@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch removed from -mm tree
Message-Id: <20250819233632.D892BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing: add linux/args.h header and fix radix, VMA tests
has been removed from the -mm tree.  Its filename was
     tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing: add linux/args.h header and fix radix, VMA tests
Date: Mon, 11 Aug 2025 06:26:54 +0100

Commit 857d18f23ab1 ("cleanup: Introduce ACQUIRE() and ACQUIRE_ERR() for
conditional locks") accidentally broke the radix tree, VMA userland tests
by including linux/args.h which is not present in the tools/include
directory.

This patch copies this over and adds an #ifdef block to avoid duplicate
__CONCAT declaration in conflict with system headers when we ultimately
include this.

Link: https://lkml.kernel.org/r/20250811052654.33286-1-lorenzo.stoakes@oracle.com
Fixes: 857d18f23ab1 ("cleanup: Introduce ACQUIRE() and ACQUIRE_ERR() for conditional locks") 
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/args.h       |   28 ++++++++++++++++++++++++++++
 tools/testing/shared/linux/idr.h |    4 ++++
 2 files changed, 32 insertions(+)

diff --git a/tools/include/linux/args.h a/tools/include/linux/args.h
new file mode 100644
--- /dev/null
+++ a/tools/include/linux/args.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_ARGS_H
+#define _LINUX_ARGS_H
+
+/*
+ * How do these macros work?
+ *
+ * In __COUNT_ARGS() _0 to _12 are just placeholders from the start
+ * in order to make sure _n is positioned over the correct number
+ * from 12 to 0 (depending on X, which is a variadic argument list).
+ * They serve no purpose other than occupying a position. Since each
+ * macro parameter must have a distinct identifier, those identifiers
+ * are as good as any.
+ *
+ * In COUNT_ARGS() we use actual integers, so __COUNT_ARGS() returns
+ * that as _n.
+ */
+
+/* This counts to 15. Any more, it will return 16th argument. */
+#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _n, X...) _n
+#define COUNT_ARGS(X...) __COUNT_ARGS(, ##X, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+
+/* Concatenate two parameters, but allow them to be expanded beforehand. */
+#define __CONCAT(a, b) a ## b
+#define CONCATENATE(a, b) __CONCAT(a, b)
+
+#endif	/* _LINUX_ARGS_H */
--- a/tools/testing/shared/linux/idr.h~tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests
+++ a/tools/testing/shared/linux/idr.h
@@ -1 +1,5 @@
+/* Avoid duplicate definitions due to system headers. */
+#ifdef __CONCAT
+#undef __CONCAT
+#endif
 #include "../../../../include/linux/idr.h"
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch

