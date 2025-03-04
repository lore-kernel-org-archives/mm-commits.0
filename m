Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7273234
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048716; cv=none; b=r1dxdsvoYt7sK84OT4SD9ta1eGZ10SF2/9s+K4MUXybZiY1PRGUepD16w7OufRK10MyvcmveDcc1nq4gTUfjXVsVNE1y4mg4kF2MLCUyThAJ5CrMKBcQPKzDj2Yh0WF2XJloGx84aoe7fvSnr5cJ3qi8dUIFE/jNRq5cItWj/7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048716; c=relaxed/simple;
	bh=6h/5R5YYgMEvPAycI7+7DUtZjym8/QN882wRdVc+rlU=;
	h=Date:To:From:Subject:Message-Id; b=oPnx65G6XkguALHRUYhlMsOT1W8CccgnZUdxJmk77QIK3pfJr57RpbBGweckVb0UHVtqLoUA6KFs5oSCLSAT4jFwy16NG7VDPI6gZoNRPs2o8H/lllcrl5aarwJJFJe5OVakquvqeeYF2sZo6kBKy0nNypVB3NYb/vGvuNh8vUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MifqfCKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MifqfCKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DDBC4CEE4;
	Tue,  4 Mar 2025 00:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741048715;
	bh=6h/5R5YYgMEvPAycI7+7DUtZjym8/QN882wRdVc+rlU=;
	h=Date:To:From:Subject:From;
	b=MifqfCKkkQI/N/aNpO+XA9jt5F08P3sambPvZor9+LVs79Ne6hP/jpGvry3GaZy7Y
	 yJd14r/Te95UfCG0D7PLIO+JZ7/WVRaSaFpvXUvmN74646EGdQUZC3p8+WXkPiXm3T
	 k2Kub+mjnJiKHtdPjjI6PBykXsnlfgA2lnqfnTuU=
Date: Mon, 03 Mar 2025 16:38:35 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-unused-crypto-include.patch added to mm-unstable branch
Message-Id: <20250304003835.B5DDBC4CEE4@smtp.kernel.org>
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
Date: Mon, 3 Mar 2025 11:03:12 +0900

We stopped using crypto API (for the time being), so remove its include
and replace CRYPTO_MAX_ALG_NAME with a local define.

Link: https://lkml.kernel.org/r/20250303022425.285971-4-senozhatsky@chromium.org
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
@@ -1148,7 +1150,7 @@ static int __comp_algorithm_store(struct
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
zram-remove-second-stage-of-handle-allocation.patch
zram-add-gfp_nowarn-to-incompressible-zsmalloc-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zram-move-post-processing-target-allocation.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-sleepable-zspage-reader-lock.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch

