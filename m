Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7611D225D7
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743989562; cv=none; b=J8ewZdzwSRILqx+oL7L36RJ0BSHuaOLlWfugaBA3MShyUtsrUlxShwEdPm9/86/v9eGLtLNqofgiztkYGLsiW9MrVNxmNXjzo8vqYpPRLjsOagvDD3VoQa5HUXXM+SVorhcKP5tRiw6uE82htVMqd2rZGd8PbSLXclu6jvCHA/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743989562; c=relaxed/simple;
	bh=fc1tlArDcF0/gKKHaKR/cq6V8l9B7HqRVfpFyhsIyJ4=;
	h=Date:To:From:Subject:Message-Id; b=plM3W+4zdZnKDZdzfVUtAZ/geCM6S8FDkLPd6j044/jy1257cgkvv5s8YjNJ3dIqR6bAL2LRPopDyNWwJ5/h1Pp4siF/oI0amvjiqFmATn5Q57DmauaxacvIcQ7zag+s4+WOFR2f45rIoD7A5w4uamixWJi0vjgHbzLk8wMBYbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pzXSyRAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pzXSyRAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E0DC4CEE3;
	Mon,  7 Apr 2025 01:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743989560;
	bh=fc1tlArDcF0/gKKHaKR/cq6V8l9B7HqRVfpFyhsIyJ4=;
	h=Date:To:From:Subject:From;
	b=pzXSyRAn7XY8cvaA3mTvScFlW6Dv1Q0yZjbQRn4+l34pB/2LSWIT2waO3IoOpyole
	 gKkVmf94M2v3lOzauzhFGWSaDw4ZgScygY3FPD6KxyhpZld3i5p93QmQTN5+Dw86UY
	 jK6CyF8L57PKLOVhYfrW646KnaGrX1J+L7w54uTs=
Date: Sun, 06 Apr 2025 18:32:40 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-cleanup-headers-includes.patch added to mm-new branch
Message-Id: <20250407013240.D4E0DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: cleanup headers includes
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-cleanup-headers-includes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-cleanup-headers-includes.patch

This patch will later appear in the mm-new branch at
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

zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch
zram-modernize-writeback-interface.patch
zram-modernize-writeback-interface-v3.patch
zsmalloc-cleanup-headers-includes.patch

