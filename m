Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722E83BB57
	for <mm-commits@vger.kernel.org>; Wed,  4 Feb 2026 22:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770244558; cv=none; b=Da2P6enKD7xll2lFlvR6WvbqDcEw8eOXUQgMLH+bRzkQGpvPqi/kj+QoqHNerVaPuZAd8V7hPBSxqqHLlv03pe8a4Yw6+6KBZsorrKQulrDE2YDDwDuclDBI6XdmBY6wASyNPlw4pf1t808puaWVln0nVhHN48Sqr1xHVhBiOUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770244558; c=relaxed/simple;
	bh=fILoaQUqI6XHYojmTg4VrrgEvAQmKWNPtDj1mX8jUAs=;
	h=Date:To:From:Subject:Message-Id; b=BgzcikFu5YDgrQYl4DORFFYcmzYTmrN2EV7MqTvfq6x55xvLvbS9ONHr75KEaV0NwM5p0dGLeJAaFtBcnIluBx9IfLZML/gcla8+T/SyidXFTFfM+V1jjVgw9fmp9Jdh7qr0udV/cYvLLo7crn34A7Gc76DDPhqUcPqWBDk9Vlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vF7Jhngu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vF7Jhngu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEE9C4CEF7;
	Wed,  4 Feb 2026 22:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770244558;
	bh=fILoaQUqI6XHYojmTg4VrrgEvAQmKWNPtDj1mX8jUAs=;
	h=Date:To:From:Subject:From;
	b=vF7JhnguBnCTBoGXxPufOoJNKU2OlyKy8+miEU3W3DxrnCJVKybVzSXxbbNCu48cr
	 OZk79nD4OBP4GXAYAYUnDJd91d4LFFP9hp453JNvyHuRK9CYCD0QvdPj9FbEKud7eb
	 tbS+KEyAAwzFyUD1RplEkbhezgwEfNl7CQUuq3k4=
Date: Wed, 04 Feb 2026 14:35:57 -0800
To: mm-commits@vger.kernel.org,tim.bird@sony.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-spdx-id-lines-to-some-mm-source-files.patch added to mm-unstable branch
Message-Id: <20260204223557.EDEE9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Add SPDX id lines to some mm source files
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-spdx-id-lines-to-some-mm-source-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-spdx-id-lines-to-some-mm-source-files.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Tim Bird <tim.bird@sony.com>
Subject: mm: Add SPDX id lines to some mm source files
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

mm-add-spdx-id-lines-to-some-mm-source-files.patch

