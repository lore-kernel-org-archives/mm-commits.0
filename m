Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D06195811
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738011495; cv=none; b=krIY83Kj375j/ZkbhRrBq7Z4QEuXFDMJQySbW898/67adYERdiuFrHNdBHOZf5CV8YXW0l96IK6eUmrF8g/ZFyHwsp4FptgjuO7WhmkxV/7yEsm9FLSqXI74nYNG9mHNl6bMU4tlGc9/2Z6QXtZ7tWdzdM4s3UcIDo4BQomyDg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738011495; c=relaxed/simple;
	bh=59ld6WSgVYcexYtE+PyzU7m7enBYA9xh+ZK4m1bNaWM=;
	h=Date:To:From:Subject:Message-Id; b=q0CClkvLAlUkdFyZ2SyBELWIc/BL32tFcD3vlcHg0r+CYsDR9y3mg0KLvPab0gH0KSuRzNuOnxYs6rQDJJckU700VfH0TOv8AhFVHADLJ25TYa3D8ElyKXpxrWRDjbZCnmzGHDtC+BMYq4yqh2XSjscezXHKJKpK/pQ6jnOdaII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pyIH9iLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pyIH9iLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C85C4CED2;
	Mon, 27 Jan 2025 20:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738011495;
	bh=59ld6WSgVYcexYtE+PyzU7m7enBYA9xh+ZK4m1bNaWM=;
	h=Date:To:From:Subject:From;
	b=pyIH9iLXhwV14a4nr2OxXUpcuvWufLNjAaAHFxIlEYc4skpdi/yDknsP3AVVo24K9
	 2xQfGGZnJk8USG/nSD53vyM5Tg/K67iHlzqAc5cG05JRGhqdMC7HQADmRnCe+of38S
	 aLCeSG2IHOniJTDWHntv6XkT5FzrvXEj2DzsA3lc=
Date: Mon, 27 Jan 2025 12:58:15 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-crypto-include.patch added to mm-unstable branch
Message-Id: <20250127205815.85C85C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove crypto include
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-crypto-include.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-crypto-include.patch

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
Subject: zram: remove crypto include
Date: Mon, 27 Jan 2025 16:29:14 +0900

Remove a leftover crypto header include.

Link: https://lkml.kernel.org/r/20250127072932.1289973-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    1 -
 drivers/block/zram/zram_drv.c |    4 +++-
 drivers/block/zram/zram_drv.h |    1 -
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-remove-crypto-include
+++ a/drivers/block/zram/zcomp.c
@@ -7,7 +7,6 @@
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
-#include <linux/crypto.h>
 #include <linux/vmalloc.h>
 
 #include "zcomp.h"
--- a/drivers/block/zram/zram_drv.c~zram-remove-crypto-include
+++ a/drivers/block/zram/zram_drv.c
@@ -43,6 +43,8 @@ static DEFINE_MUTEX(zram_index_mutex);
 static int zram_major;
 static const char *default_compressor = CONFIG_ZRAM_DEF_COMP;
 
+#define ZRAM_MAX_ALGO_NAME_SZ	64
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
--- a/drivers/block/zram/zram_drv.h~zram-remove-crypto-include
+++ a/drivers/block/zram/zram_drv.h
@@ -16,7 +16,6 @@
 #define _ZRAM_DRV_H_
 
 #include <linux/zsmalloc.h>
-#include <linux/crypto.h>
 
 #include "zcomp.h"
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-switch-to-non-atomic-entry-locking.patch
zram-do-not-use-per-cpu-compression-streams.patch
zram-remove-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-two-staged-handle-allocation.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-permit-reclaim-in-recompression-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-unlock-slot-during-recompression.patch

