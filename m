Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499751C27
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 04:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749185770; cv=none; b=iB5c+JglQuUdCkXWQnksu2NBn/LRdbFYHjjCBfPnbV60LOZnCcXQnMcxEgOQbsDBBHTf3+oe8mstIyiCmv9aPSJzzryL1j2ECqU8NJW3UT0BSUlkuYrUNRl4W/kp3De3rjnxU8hqjCh5sJhE3rzKkUpLmtfX8f19l7OS0yGN3OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749185770; c=relaxed/simple;
	bh=xTxex+NMt+H/REPjlBxcLunU6yTXtG+uSMxwKNyPsTc=;
	h=Date:To:From:Subject:Message-Id; b=rPBx3cSlVeCU8iZz3WzaY7z0jHD6D6Afu3mGjcxiK4X6RE4Dreh4L/o6XOhCthtqdriLVftUp7DrMtTLbkjVuDazzjy5nS3iNM5Ay7LW1lvtze77dc9Uso4PqcnruuS3D0aipzdAsawfgHOnMAxY4xbAsX3q/EIKBaXYYHuEQdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=grMG8wPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="grMG8wPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4216C4CEEB;
	Fri,  6 Jun 2025 04:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749185770;
	bh=xTxex+NMt+H/REPjlBxcLunU6yTXtG+uSMxwKNyPsTc=;
	h=Date:To:From:Subject:From;
	b=grMG8wPXC/TEYl/jnLJDlRgIJZK46KSlMhwK8meYnOYV0zKb/CXPiCX1rpIupN5sT
	 ykeixxoUyEy/CkoOPW8LKFKiltvbrs3DZi8Bl3gg8tB9wGWEivzLt6YI1+teDN3FmH
	 WQ+9uYQtw9cFxeJ3tjVr33ewH8E9+AI00tGQNftc=
Date: Thu, 05 Jun 2025 21:56:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-s-primitives-code-on-comments.patch removed from -mm tree
Message-Id: <20250606045609.F4216C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: s/primitives/code/ on comments
has been removed from the -mm tree.  Its filename was
     mm-damon-s-primitives-code-on-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


