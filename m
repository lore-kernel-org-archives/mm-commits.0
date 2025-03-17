Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F21217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188413; cv=none; b=fI0FjZX6cOCtkvHgqhMyAgFuWYP1SbilbCJeUzO2fQsQzPLTA+qhE01TtfCFC1iAs4h/hfwXXd7tDHvt/Fm/04sPqApQsElI8vuV84vpGy93O2PqU34d6sbVaIX2Qm/KyUK6m8jJsMMwvQAW64FM8iBLSc4zI0ZzIP5DGEe9894=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188413; c=relaxed/simple;
	bh=Yk4g0H/rbqwcjLI3GeS44LjwXIgwoM8deWmvl23L9xc=;
	h=Date:To:From:Subject:Message-Id; b=b4FTpREVnKOks9Quu09EG3xZxC0HQeFVDE8Ad81aTbbcGaqh00FkUBj0rFbdWZFqFlhVDnNG38RjXDxK+oLyPYaSZHLvEmWtbXZkTgK2ndPUpJSs8l/L+wKXnbNqlcTe3k6D57okbRXRgFv7tGIXOgwXrhhZWE72/zUG4iKPeMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NsuHJbzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NsuHJbzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D53BC4CEEC;
	Mon, 17 Mar 2025 05:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188413;
	bh=Yk4g0H/rbqwcjLI3GeS44LjwXIgwoM8deWmvl23L9xc=;
	h=Date:To:From:Subject:From;
	b=NsuHJbzVdAW7sXpLxuYC9ZNDtOPozzZT7gGNHCakkoB2TyxCqajcJ2c7ESFweOpVo
	 gsVlfd4rM4F2sr0cJE0FfHpc+hCTaHMNciSoYuOBFVqzcjULFHO/mRpuwTCN1If9aH
	 kDPgMPVh5l9tORLtpLjrOswx1j4m9EBLjx6iuYKU=
Date: Sun, 16 Mar 2025 22:13:32 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-unused-crypto-include.patch removed from -mm tree
Message-Id: <20250317051333.4D53BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove unused crypto include
has been removed from the -mm tree.  Its filename was
     zram-remove-unused-crypto-include.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


