Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B792F12B94
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578692; cv=none; b=T/UNCIc1kQqMB9LmT9GbAXL/d/HgOPDdwu4fR8jNoNGtTxGFHAIK5AJA0PAk8eSbbbrsvynvvFzbXlUYoNX0aQX3TiCUcckjKj0ErqOUm5OJlAzlkH1z8IZrJBS0OL5z3OZKUB53baxc/8otclHA3pP7yGpY66sEGKi7o9QiAWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578692; c=relaxed/simple;
	bh=QaLMS1fIu82Nc6FG6O/Gcf/H2wTE3dXZa03m8Q2YjYY=;
	h=Date:To:From:Subject:Message-Id; b=YpgX7yD4kgQlUDEwWs+WzhOq2V4Z+4X9o0dibcOXJtBnGzTCos4X0eOhzwKN/VcbWj3xgRknPTQAuia9GAsVYigJn0XaNxgeBp0J/NxlA34aLmyfnPYzY1JDfCBbN+56HgqDUzMDjvhMdy8lNyegMgpNX/p6+OsQweUm7p6bWq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fkoZqQkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fkoZqQkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A9C4CEE6;
	Sat, 15 Feb 2025 00:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739578692;
	bh=QaLMS1fIu82Nc6FG6O/Gcf/H2wTE3dXZa03m8Q2YjYY=;
	h=Date:To:From:Subject:From;
	b=fkoZqQkdK8ROs7JGhi1X8vZFZsjHv/aR8X0fqE6OBUh0q1lQYpjbstxFc0ejVo8dZ
	 oXBIcqv5LoXbm2wdvkRFEpNHSBbBvjxhVMNz1Ch4EDVvPfpIDiClHX38vAIZKfYax3
	 JBinkrXLndOctVih3TzqfHWkBTI3zBUMbhzrVS2s=
Date: Fri, 14 Feb 2025 16:18:11 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-unused-crypto-include.patch added to mm-unstable branch
Message-Id: <20250215001812.216A9C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove unused crypto include
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-unused-crypto-include.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-unused-crypto-include.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove unused crypto include
Date: Fri, 14 Feb 2025 13:50:15 +0900

We stopped using crypto API (for the time being), so remove its include
and replace CRYPTO_MAX_ALG_NAME with a local define.

Link: https://lkml.kernel.org/r/20250214045208.1388854-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    1 -
 drivers/block/zram/zram_drv.c |    4 +++-
 drivers/block/zram/zram_drv.h |    1 -
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-remove-unused-crypto-include
+++ a/drivers/block/zram/zcomp.c
@@ -7,7 +7,6 @@
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/cpuhotplug.h>
-#include <linux/crypto.h>
 #include <linux/vmalloc.h>
 
 #include "zcomp.h"
--- a/drivers/block/zram/zram_drv.c~zram-remove-unused-crypto-include
+++ a/drivers/block/zram/zram_drv.c
@@ -44,6 +44,8 @@ static DEFINE_MUTEX(zram_index_mutex);
 static int zram_major;
 static const char *default_compressor = CONFIG_ZRAM_DEF_COMP;
 
+#define ZRAM_MAX_ALGO_NAME_SZ	128
+
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 /*
@@ -1191,7 +1193,7 @@ static int __comp_algorithm_store(struct
 	size_t sz;
 
 	sz = strlen(buf);
-	if (sz >= CRYPTO_MAX_ALG_NAME)
+	if (sz >= ZRAM_MAX_ALGO_NAME_SZ)
 		return -E2BIG;
 
 	compressor = kstrdup(buf, GFP_KERNEL);
--- a/drivers/block/zram/zram_drv.h~zram-remove-unused-crypto-include
+++ a/drivers/block/zram/zram_drv.h
@@ -17,7 +17,6 @@
 
 #include <linux/rwsem.h>
 #include <linux/zsmalloc.h>
-#include <linux/crypto.h>
 
 #include "zcomp.h"
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-two-staged-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch

