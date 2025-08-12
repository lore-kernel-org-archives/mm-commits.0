Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C0A215789
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754961135; cv=none; b=CydjtdoArUDiqeGOOtXd79uwZxcIoRI9yzPdU8ZA3IDkglvADpVD+2anLnTgsVBy08QXQUPRm2EjihnFZRQ8WFCNhCokB8/yC3IplM2u2pQl7y2jX/ELvvgezJSTtwKLBefnMSGYlnbI+DDeHkgFssWel6yvzlcMr8klzvTOGuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754961135; c=relaxed/simple;
	bh=9PYl+AE2OsfwbWGGqcwgFCi9NnffSK6m/OvHXVG2KMw=;
	h=Date:To:From:Subject:Message-Id; b=IeqpbXmMK5LN09V5zt5LJJCknJGWKLM3F3zQ/fygnxBL04oYbyai+Z/e2GHcCAwT/6bDIXjXVuFUoRd8S8of9DH5F2jXU/OkN/+0uor7EyOwF4evowCI2CTs6Pelg49M1XOB595VM6kEprnAbAhNHcQiPLTKjWhdWY96QWsYxnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QMDAhHg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QMDAhHg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF59C4CEED;
	Tue, 12 Aug 2025 01:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754961134;
	bh=9PYl+AE2OsfwbWGGqcwgFCi9NnffSK6m/OvHXVG2KMw=;
	h=Date:To:From:Subject:From;
	b=QMDAhHg7o/NmQUdDxPsr/zaUW0c65wyAXLQk8p9Ane2pzH/Rp1URdIoisHRJiKfso
	 D60RCrKspcmZxNN9fSHG1CStrKT4KwinCjXBBuUoE1CiBFC2TZ72tNVvvK7c4Xr7i8
	 CJrbKQdiJ3/Fi8fqSWjs3GChXChXqgBWKLu8D1Hc=
Date: Mon, 11 Aug 2025 18:12:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,peterz@infradead.org,liam.howlett@oracle.com,jhubbard@nvidia.com,jannh@google.com,dan.j.williams@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812011214.BCF59C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing: add linux/args.h header and fix radix, VMA tests
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc:
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

mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch
tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch

