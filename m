Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F4530F534
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421694; cv=none; b=Iw+VO7SiPAVQlWtXehKV5qugckPzVatK/ReRMi/SswHyOLf7/GoSHxvnA7lokE80+eM8r5KY5am9okBSkPOS3gzinYlTbYmJM+BBxlb0oCiQ8E0KN4QmpqxW1+Cdrr/43PcuvYM/HcMKIQtutCST+esYPTcvXxSkLUfUZ3a+aPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421694; c=relaxed/simple;
	bh=G1JlhyKkDcrEgjhbexNhfb/rmAVsGNwVQPqie/gIf7M=;
	h=Date:To:From:Subject:Message-Id; b=ZPwYGK9fddTa4nmom8nFSxAk/hZso6wnUhbHHl27mbYEmlgAgUkk9ZN0GBkZfJzE6En9GgNo08HG6bZUoO4prZCxsuckpfJDFAERObV/k3Tg6mLrBVZZpBdij/ttX7z7Gck5RuU3KdGDJqCXuZ052qlVlx5Ea5zrLG2nPVclKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sOjRnuZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sOjRnuZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF57C116C6;
	Fri,  6 Feb 2026 23:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421693;
	bh=G1JlhyKkDcrEgjhbexNhfb/rmAVsGNwVQPqie/gIf7M=;
	h=Date:To:From:Subject:From;
	b=sOjRnuZY2N1E0STntP4nELCbE0RiaTkj+wuU7zqWNvRtCR0g/GcPV2H7ZJ1SIGn99
	 dmmAbDj+tLvIFzfBSHeMdTAaUusNYh+tFdcjJV3EaysPwlEj4pKouA0iLF2KmsvlIG
	 9m/074AnKJrCQQVWqvgL1iL32RqJdva3yc+asfSQ=
Date: Fri, 06 Feb 2026 15:48:13 -0800
To: mm-commits@vger.kernel.org,tim.bird@sony.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-spdx-id-lines-to-some-mm-source-files.patch removed from -mm tree
Message-Id: <20260206234813.CDF57C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add SPDX id lines to some mm source files
has been removed from the -mm tree.  Its filename was
     mm-add-spdx-id-lines-to-some-mm-source-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tim Bird <tim.bird@sony.com>
Subject: mm: add SPDX id lines to some mm source files
Date: Wed, 4 Feb 2026 14:31:01 -0700

Some of the memory management source files are missing
SPDX-License-Identifier lines.  Add appropriate IDs
to these files (mostly GPL-2.0, but one LGPL-2.1).

Link: https://lkml.kernel.org/r/20260204213101.1754183-1-tim.bird@sony.com
Signed-off-by: Tim Bird <tim.bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool_test.c   |    1 +
 mm/folio-compat.c   |    1 +
 mm/gup_test.c       |    1 +
 mm/hugetlb_cgroup.c |    9 +--------
 mm/memfd.c          |    3 +--
 mm/mmu_gather.c     |    1 +
 mm/rmap.c           |    2 +-
 mm/shmem.c          |    3 +--
 8 files changed, 8 insertions(+), 13 deletions(-)

--- a/mm/dmapool_test.c~mm-add-spdx-id-lines-to-some-mm-source-files
+++ a/mm/dmapool_test.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/device.h>
 #include <linux/dma-map-ops.h>
 #include <linux/dma-mapping.h>
--- a/mm/folio-compat.c~mm-add-spdx-id-lines-to-some-mm-source-files
+++ a/mm/folio-compat.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Compatibility functions which bloat the callers too much to make inline.
  * All of the callers of these functions should be converted to use folios
--- a/mm/gup_test.c~mm-add-spdx-id-lines-to-some-mm-source-files
+++ a/mm/gup_test.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
--- a/mm/hugetlb_cgroup.c~mm-add-spdx-id-lines-to-some-mm-source-files
+++ a/mm/hugetlb_cgroup.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: LGPL-2.1
 /*
  *
  * Copyright IBM Corporation, 2012
@@ -7,14 +8,6 @@
  * Copyright (C) 2019 Red Hat, Inc.
  * Author: Giuseppe Scrivano <gscrivan@redhat.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
  */
 
 #include <linux/cgroup.h>
--- a/mm/memfd.c~mm-add-spdx-id-lines-to-some-mm-source-files
+++ a/mm/memfd.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * memfd_create system call and file sealing support
  *
  * Code was originally included in shmem.c, and broken out to facilitate
  * use by hugetlbfs as well as tmpfs.
- *
- * This file is released under the GPL.
  */
 
 #include <linux/fs.h>
--- a/mm/mmu_gather.c~mm-add-spdx-id-lines-to-some-mm-source-files
+++ a/mm/mmu_gather.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/gfp.h>
 #include <linux/highmem.h>
 #include <linux/kernel.h>
--- a/mm/rmap.c~mm-add-spdx-id-lines-to-some-mm-source-files
+++ a/mm/rmap.c
@@ -1,8 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * mm/rmap.c - physical to virtual reverse mappings
  *
  * Copyright 2001, Rik van Riel <riel@conectiva.com.br>
- * Released under the General Public License (GPL).
  *
  * Simple, low overhead reverse mapping scheme.
  * Please try to keep this thing as modular as possible.
--- a/mm/shmem.c~mm-add-spdx-id-lines-to-some-mm-source-files
+++ a/mm/shmem.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Resizable virtual memory filesystem for Linux.
  *
@@ -17,8 +18,6 @@
  *
  * tiny-shmem:
  * Copyright (c) 2004, 2008 Matt Mackall <mpm@selenic.com>
- *
- * This file is released under the GPL.
  */
 
 #include <linux/fs.h>
_

Patches currently in -mm which might be from tim.bird@sony.com are


