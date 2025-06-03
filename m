Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B851FDD
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 02:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748917430; cv=none; b=e9V2HfQVUupDsI1lUYpIHO4vT6wozoByZCfjwS+MtnIOzyEm/lfDaM6Q1rh5RPHQ6YjUIDi9/Z27cuSLR/tZcv3c5scfasLp96PVNXu72Mem2036/7BJqxf2eWaaknT6HTyfNFByFzip/xBeYjgw+F92PV0B9krO509mvQ+edt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748917430; c=relaxed/simple;
	bh=4zR+oaMCkX7vMN2YcELZp04E0ZnHrJJ1z98I9HtO8nA=;
	h=Date:To:From:Subject:Message-Id; b=tXDFRnrCBVpuRsCyyEF2a7hLfOnn8//rtx60BFW8YKV0fSMdYTn469ws8oIY7DygIFulFlS+UGuhwmnCBz/OXgSYihpQR1xYH4zQA0MXkexbh0ZxwSyN5Z3YsiiTUA2BgewKbVg/YC8cH2NcFs07Dd+3Q04aMgjBxExXFcfFzFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fn2V2tHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fn2V2tHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1873C4CEEB;
	Tue,  3 Jun 2025 02:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748917430;
	bh=4zR+oaMCkX7vMN2YcELZp04E0ZnHrJJ1z98I9HtO8nA=;
	h=Date:To:From:Subject:From;
	b=Fn2V2tHvHAzz1+NBTRXOuwrv4oULqOLhfmEU4C9C61CE/MNdIwpkw6D+ku5tXi32C
	 q7zNbU5gJ5w5lSXYTA9w6TjGEeAOFGBlpdHseZymlBFSVijOiYsodZnbDaiRGcooaP
	 ahqNr/go5zepk+TXg9BQAYoUMvBGS0+rZchbVaZQ=
Date: Mon, 02 Jun 2025 19:23:49 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-s-primitives-code-on-comments.patch added to mm-unstable branch
Message-Id: <20250603022349.F1873C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: s/primitives/code/ on comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-s-primitives-code-on-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-s-primitives-code-on-comments.patch

This patch will later appear in the mm-unstable branch at
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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon: s/primitives/code/ on comments
Date: Fri, 30 May 2025 13:31:15 +0800

The word 'primitive' is not explicit.  To make the code more easily
understood, this commit renames 'primitives' to 'code' in header comments
of some source files.

Link: https://lkml.kernel.org/r/20250530053115.153238-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/modules-common.c |    2 +-
 mm/damon/modules-common.h |    2 +-
 mm/damon/ops-common.c     |    2 +-
 mm/damon/ops-common.h     |    2 +-
 mm/damon/paddr.c          |    2 +-
 mm/damon/sysfs-common.c   |    2 +-
 mm/damon/sysfs-common.h   |    2 +-
 mm/damon/vaddr.c          |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/damon/modules-common.c~mm-damon-s-primitives-code-on-comments
+++ a/mm/damon/modules-common.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Common Primitives for DAMON Modules
+ * Common Code for DAMON Modules
  *
  * Author: SeongJae Park <sj@kernel.org>
  */
--- a/mm/damon/modules-common.h~mm-damon-s-primitives-code-on-comments
+++ a/mm/damon/modules-common.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Common Primitives for DAMON Modules
+ * Common Code for DAMON Modules
  *
  * Author: SeongJae Park <sj@kernel.org>
  */
--- a/mm/damon/ops-common.c~mm-damon-s-primitives-code-on-comments
+++ a/mm/damon/ops-common.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Common Primitives for Data Access Monitoring
+ * Common Code for Data Access Monitoring
  *
  * Author: SeongJae Park <sj@kernel.org>
  */
--- a/mm/damon/ops-common.h~mm-damon-s-primitives-code-on-comments
+++ a/mm/damon/ops-common.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Common Primitives for Data Access Monitoring
+ * Common Code for Data Access Monitoring
  *
  * Author: SeongJae Park <sj@kernel.org>
  */
--- a/mm/damon/paddr.c~mm-damon-s-primitives-code-on-comments
+++ a/mm/damon/paddr.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * DAMON Primitives for The Physical Address Space
+ * DAMON Code for The Physical Address Space
  *
  * Author: SeongJae Park <sj@kernel.org>
  */
--- a/mm/damon/sysfs-common.c~mm-damon-s-primitives-code-on-comments
+++ a/mm/damon/sysfs-common.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Common Primitives for DAMON Sysfs Interface
+ * Common Code for DAMON Sysfs Interface
  *
  * Author: SeongJae Park <sj@kernel.org>
  */
--- a/mm/damon/sysfs-common.h~mm-damon-s-primitives-code-on-comments
+++ a/mm/damon/sysfs-common.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Common Primitives for DAMON Sysfs Interface
+ * Common Code for DAMON Sysfs Interface
  *
  * Author: SeongJae Park <sj@kernel.org>
  */
--- a/mm/damon/vaddr.c~mm-damon-s-primitives-code-on-comments
+++ a/mm/damon/vaddr.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * DAMON Primitives for Virtual Address Spaces
+ * DAMON Code for Virtual Address Spaces
  *
  * Author: SeongJae Park <sj@kernel.org>
  */
_

Patches currently in -mm which might be from lienze@kylinos.cn are

mm-damon-s-primitives-code-on-comments.patch

