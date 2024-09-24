Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87041335C7
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 20:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727208226; cv=none; b=rn+O76F83kQEYyubVigeOP+d96rkEH9mNFvGYyw0C5h6VcmcckDgIPdd1Yl/CbsXIhOxgwsm9XTiUysCGmIfSzTy/w9tchOz2xkCMZJqnEL8UNv/B9sFVFqCozOeWHYdrQXeTFLgztERMcsMXOFnnW2uURgl5nXAz87hjkLJmZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727208226; c=relaxed/simple;
	bh=4tZQu5G8GYhgynppVWlB70OcefqPUiVwKEnysr1rBIQ=;
	h=Date:To:From:Subject:Message-Id; b=dzXI/7W5ipNEwVlOfV0W2fnR32nA0vMTvhUBtIGIiN1DeDhv5dUEWo4GM+YA/4awkwsngLoxfLXvW7OrIdqzXbBQeOi2gxGr1qIjqdLUOmQAPEeSdu3jAomZ1CCFDB6lGoGOCa/BLMtrHe9y/5HPruAtaqTQxafj01sYUCCnLV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vPg58lMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vPg58lMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9CAC4CEC4;
	Tue, 24 Sep 2024 20:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727208226;
	bh=4tZQu5G8GYhgynppVWlB70OcefqPUiVwKEnysr1rBIQ=;
	h=Date:To:From:Subject:From;
	b=vPg58lMMVLjcKbcgFwL1Dagq/HdGp/9MSfK8LB+7ko6DxU76j2Pk9eHcj7XWuUzjg
	 3s7wplAWVrS+5bqksNfOnGMfs5G+0gEx4CRVQtnzNk6nMcHynFzvKpCE26/+m9S5Xs
	 cxlnH6NunHH8oEahX47Wk/n8yoD9DL4b6KMAfKkA=
Date: Tue, 24 Sep 2024 13:03:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,Liam.Howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-fix-shared-radix-tree-build.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924200346.2D9CAC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: fix shared radix-tree build
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-fix-shared-radix-tree-build.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-fix-shared-radix-tree-build.patch

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
Subject: tools: fix shared radix-tree build
Date: Tue, 24 Sep 2024 19:07:24 +0100

The shared radix-tree build is not correctly recompiling when
lib/maple_tree.c and lib/test_maple_tree.c are modified - fix this by
adding these core components to the SHARED_DEPS list.

Additionally, add missing header guards to shared header files.

Link: https://lkml.kernel.org/r/20240924180724.112169-1-lorenzo.stoakes@oracle.com
Fixes: 74579d8dab47 ("tools: separate out shared radix-tree components")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/maple-shared.h  |    4 ++++
 tools/testing/shared/shared.h        |    4 ++++
 tools/testing/shared/shared.mk       |    4 +++-
 tools/testing/shared/xarray-shared.h |    4 ++++
 4 files changed, 15 insertions(+), 1 deletion(-)

--- a/tools/testing/shared/maple-shared.h~tools-fix-shared-radix-tree-build
+++ a/tools/testing/shared/maple-shared.h
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef __MAPLE_SHARED_H__
+#define __MAPLE_SHARED_H__
 
 #define CONFIG_DEBUG_MAPLE_TREE
 #define CONFIG_MAPLE_SEARCH
@@ -7,3 +9,5 @@
 #include <stdlib.h>
 #include <time.h>
 #include "linux/init.h"
+
+#endif /* __MAPLE_SHARED_H__ */
--- a/tools/testing/shared/shared.h~tools-fix-shared-radix-tree-build
+++ a/tools/testing/shared/shared.h
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __SHARED_H__
+#define __SHARED_H__
 
 #include <linux/types.h>
 #include <linux/bug.h>
@@ -31,3 +33,5 @@
 #ifndef dump_stack
 #define dump_stack()	assert(0)
 #endif
+
+#endif /* __SHARED_H__ */
--- a/tools/testing/shared/shared.mk~tools-fix-shared-radix-tree-build
+++ a/tools/testing/shared/shared.mk
@@ -15,7 +15,9 @@ SHARED_DEPS = Makefile ../shared/shared.
 	../../../include/linux/maple_tree.h \
 	../../../include/linux/radix-tree.h \
 	../../../lib/radix-tree.h \
-	../../../include/linux/idr.h
+	../../../include/linux/idr.h \
+	../../../lib/maple_tree.c \
+	../../../lib/test_maple_tree.c
 
 ifndef SHIFT
 	SHIFT=3
--- a/tools/testing/shared/xarray-shared.h~tools-fix-shared-radix-tree-build
+++ a/tools/testing/shared/xarray-shared.h
@@ -1,4 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef __XARRAY_SHARED_H__
+#define __XARRAY_SHARED_H__
 
 #define XA_DEBUG
 #include "shared.h"
+
+#endif /* __XARRAY_SHARED_H__ */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-fix-shared-radix-tree-build.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch

