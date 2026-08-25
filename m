Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EA3343D91
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622841; cv=none; b=tI5BVYk69ytEK96liRwJekTwtHxP+fiulgVJFoI4wMw4OfkPdvccjnvQVbFGiDl0YWN4+ZcNVlFVROeGkP4yiELC/KHvFASK6plTITN80gF5SHf08Y2Yd70LtSRlH6l0EbVTLEF3TmjvDmXYuoG8Lg4DVpoNDKsHp5U8jMYW7iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622841; c=relaxed/simple;
	bh=YElYzAYwj5B3S6UIkDQcFC0P7NlxEWBkunCjvO35JaI=;
	h=Date:To:From:Subject:Message-Id; b=gpQynBatMsgiKXzZikO7xFnGAs/AFEfcuAnzJvu7voediK36TKRDLI3arVkOeXruw2vlevF6RdyTqWhSXCq0DGoEL0Icd3S8hSZHyCOv6LMClhh8nGSTTFxaFbHBoU7spx5JqM11n+06x6qXV2kJvb8pmGrZc9NZxYSk/7hKVxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UJkBFfne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UJkBFfne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588591F00A3D;
	Tue, 25 Aug 2026 01:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622840;
	bh=JL1h28Jwjt5PrRxqQQ2kdHKuX9sheDaE168yjGoNcrc=;
	h=Date:To:From:Subject;
	b=UJkBFfneOL2/e1Y6kFCsKNN/wL1rZMv9Wgt3rdlhQ3NciYozbSBHPXkkslOdA8Xtr
	 JU2IRejD116A0bGWI3g4FPiRkD460brVljsfj6yOig6M86UCGaCLT3J6/X0qnO1hdU
	 WRs5L3twXemkSeL1nZvKhxNqNze4QPx7bVKnykp0=
Date: Mon, 24 Aug 2026 18:53:59 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-reset-per-priority-params-when-changing-algorithm-before-init.patch removed from -mm tree
Message-Id: <20260825015400.588591F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: reset per-priority params when changing algorithm before init
has been removed from the -mm tree.  Its filename was
     zram-reset-per-priority-params-when-changing-algorithm-before-init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haoqin Huang <haoqinhuang@tencent.com>
Subject: zram: reset per-priority params when changing algorithm before init
Date: Tue, 4 Aug 2026 17:38:41 +0800

Parameters validated against one algorithm may be invalid for another
(e.g.  lz4 accepts level=65535 but zstd does not).  Although algorithm
changes are blocked after disksize is set, they are allowed before device
initialization.  Reset per-priority params on algorithm change so that
stale parameters do not silently carry over.

Link: https://lore.kernel.org/20260804093841.67920-6-haoqinhuang7@gmail.com
Signed-off-by: Haoqin Huang <haoqinhuang@tencent.com>
Signed-off-by: Rongwei Wang <zigiwang@tencent.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-reset-per-priority-params-when-changing-algorithm-before-init
+++ a/drivers/block/zram/zram_drv.c
@@ -1652,6 +1652,17 @@ static void comp_algorithm_set(struct zr
 	zram->comp_algs[prio] = alg;
 }
 
+static void comp_params_reset(struct zram *zram, u32 prio)
+{
+	struct zcomp_params *params = &zram->params[prio];
+
+	vfree(params->dict);
+	params->level = ZCOMP_PARAM_NOT_SET;
+	params->deflate.winbits = ZCOMP_PARAM_NOT_SET;
+	params->dict_sz = 0;
+	params->dict = NULL;
+}
+
 static int __comp_algorithm_store(struct zram *zram, u32 prio, const char *buf)
 {
 	const char *alg;
@@ -1672,20 +1683,10 @@ static int __comp_algorithm_store(struct
 	}
 
 	comp_algorithm_set(zram, prio, alg);
+	comp_params_reset(zram, prio);
 	return 0;
 }
 
-static void comp_params_reset(struct zram *zram, u32 prio)
-{
-	struct zcomp_params *params = &zram->params[prio];
-
-	vfree(params->dict);
-	params->level = ZCOMP_PARAM_NOT_SET;
-	params->deflate.winbits = ZCOMP_PARAM_NOT_SET;
-	params->dict_sz = 0;
-	params->dict = NULL;
-}
-
 static int comp_params_store(struct zram *zram, u32 prio, s32 level,
 			     const char *dict_path,
 			     struct deflate_params *deflate_params)
_

Patches currently in -mm which might be from haoqinhuang@tencent.com are


