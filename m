Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2BE1553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011050; cv=none; b=F+JPDMbOWsssLDGLYHYnfidjHR78TkFUFL1fvc4Gx38l6TF0vKHhzmKoeFW7IiwsNZ6rmzslyFFsdJd0OQ4Q4la1qVjs40n7BeSkwIteZfO2+DxXp/XQforz5yT/rfU3t4NU7V5Kk1ZWUGDAm6x8IQCuAp6CCcu5+JfdisHGhzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011050; c=relaxed/simple;
	bh=E3SPZVxOX1m7vJrAem3XumA2elpbzggSH2g2Hmnhimo=;
	h=Date:To:From:Subject:Message-Id; b=MSimb9erKG4Zdhsp6oOc4Dr5WFC4pc41NTzMsCUPDW3BTJ9XQZ9q7otktmMraC7u0HzQyHEM+LYXhsS2W7X8EjILBHfv3zH3wlJud7ehoZ5MVjJ4sgXrZeoRG37bHeYCRBVr01QAQ+fBimygJhMFY009oxzIikBclMh/ZQ/jmK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oR2tBGJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oR2tBGJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E50EC4CEE4;
	Mon, 12 May 2025 00:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011050;
	bh=E3SPZVxOX1m7vJrAem3XumA2elpbzggSH2g2Hmnhimo=;
	h=Date:To:From:Subject:From;
	b=oR2tBGJUccObpMsF49mXcyCQSMx9pD487DNVQiiZRmGJePm922nnPUHaMv4ajtiQF
	 68HGcQYCAT2SMOd1lOQjTssyLAwG8O9jsI8o++YMNdRq13Ucz2p71glDWXq2OFBKDl
	 kW0tDmIKPts9mu74H7wJBXdbf8sMsj0zDzwyJyE0=
Date: Sun, 11 May 2025 17:50:50 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-cleanup-headers-includes.patch removed from -mm tree
Message-Id: <20250512005050.8E50EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: cleanup headers includes
has been removed from the -mm tree.  Its filename was
     zsmalloc-cleanup-headers-includes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: cleanup headers includes
Date: Tue, 25 Mar 2025 17:04:16 +0900

Remove unused headers includes from zsmalloc and move pagemap.h and
migrate.h includes into zpdesc header.

Link: https://lkml.kernel.org/r/20250325080427.3449359-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h   |    3 +++
 mm/zsmalloc.c |   12 +-----------
 2 files changed, 4 insertions(+), 11 deletions(-)

--- a/mm/zpdesc.h~zsmalloc-cleanup-headers-includes
+++ a/mm/zpdesc.h
@@ -7,6 +7,9 @@
 #ifndef __MM_ZPDESC_H__
 #define __MM_ZPDESC_H__
 
+#include <linux/migrate.h>
+#include <linux/pagemap.h>
+
 /*
  * struct zpdesc -	Memory descriptor for zpool memory.
  * @flags:		Page flags, mostly unused by zsmalloc.
--- a/mm/zsmalloc.c~zsmalloc-cleanup-headers-includes
+++ a/mm/zsmalloc.c
@@ -26,17 +26,10 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/highmem.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/pgtable.h>
-#include <asm/tlbflush.h>
-#include <linux/cpumask.h>
-#include <linux/cpu.h>
-#include <linux/vmalloc.h>
-#include <linux/preempt.h>
 #include <linux/spinlock.h>
 #include <linux/sprintf.h>
 #include <linux/shrinker.h>
@@ -44,11 +37,8 @@
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
 #include <linux/zpool.h>
-#include <linux/migrate.h>
-#include <linux/wait.h>
-#include <linux/pagemap.h>
 #include <linux/fs.h>
-#include <linux/local_lock.h>
+#include <linux/workqueue.h>
 #include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


