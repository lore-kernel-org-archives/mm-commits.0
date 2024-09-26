Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226C2535D8;
	Thu, 26 Sep 2024 21:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384647; cv=none; b=iOYBI9owejuh9Xjf6QqxK8iFJheRWcqUfEbNG8vvozHsYMLNjKshaPigQGNJyKlpkT4C1gnox+Rw1uJF5gGmEemOoVc7BXB0GGKfS0n2zBLNCWte/t+FE8du/o3AEdqZ4VeL/a/XRMdOE5biwDYYK18kH4dElxx7PSTvlJCnpoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384647; c=relaxed/simple;
	bh=myBxhbvXkF+uFjwKaGsVG7dtZn9U/SVQvtjmBJDw5RE=;
	h=Date:To:From:Subject:Message-Id; b=rBaDBH57O3f+NQGwIDibBwYIreZp6rhxM9yCLGs/3dg+5Aa7ncP7MmQV7iHRbxiWHHnj2vR1LuZooiBJcRMoh256N8g3dcReoRzt3fksVm3GBFcimj9nfeMazBolGYwfefG1qnKC5gflDzHCuow8dNP9mGufkhwGwhBB1F1WYV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBsYZ8wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBsYZ8wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97543C4CEC5;
	Thu, 26 Sep 2024 21:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384646;
	bh=myBxhbvXkF+uFjwKaGsVG7dtZn9U/SVQvtjmBJDw5RE=;
	h=Date:To:From:Subject:From;
	b=vBsYZ8wq6kILgTIBcq/OW+l7aHykya8XqWXfScsnJHNRkGLbRDvZDvOu6Ky5IpjSP
	 kS2S95C+CmtMi8IHRmuWPZUQjj2NX/E4TewmbuNzyyzwuGNlPEjcqdSa9BvAgFiIBc
	 MJBy0REIdDiqUTIS4j5ToprySI9D6oF8ECn8PK6Y=
Date: Thu, 26 Sep 2024 14:04:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,stable@vger.kernel.org,sidhartha.kumar@oracle.com,Liam.Howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-fix-shared-radix-tree-build.patch removed from -mm tree
Message-Id: <20240926210406.97543C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: fix shared radix-tree build
has been removed from the -mm tree.  Its filename was
     tools-fix-shared-radix-tree-build.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
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

selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch

