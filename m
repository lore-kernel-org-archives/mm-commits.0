Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263DC4A3418
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 19:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873592; cv=none; b=oZ5Qh/hUg6QNvZhOGJDNB5JWAmK2+cS30dDv3eH7E7PQI9EnHxizeaW12SPU8owvcspZxDnLfUK+/QCR2M5KgXhgvQm4a+4vnNi8D2XeS45OQEMrivZmceDWxmNBbUhwIN/26jM+mmbW+iZ/qi6XOv2PDWr3QTgKDln/y7HXxM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873592; c=relaxed/simple;
	bh=jJgSzOHXCNI4I/IzjMD1wh7I4c3j9/ow2RhuaPUveWg=;
	h=Date:To:From:Subject:Message-Id; b=XCj2AEbpO5sqC+MPJ6quMjGjq9yHsk4I2jK9SuhUO9R5V2Ssv53gdi5bsm6A8ZVSvEv4UkhRf+as8oZIhQlxaVY7xACD6frcI/3QBGno72GEP1nzUf7QugodyPZ1gP+Ny2h5iDy+hJOLVBiIBfmoZYmgNmOmibq06Zx49Y5iucI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i0cpmoja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i0cpmoja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00991F000E9;
	Tue,  4 Aug 2026 19:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785873589;
	bh=VsC3PGzrPkTqDrmV188hcjM1ElysJwLtDcer1clFByM=;
	h=Date:To:From:Subject;
	b=i0cpmojaCqDXAkirUxOmkHja64Xc3CZMK3hPxNNdFYESrTr/CCdnHT0BdxtT57Fte
	 0nQUtfcOlzviQ3P07a1OoGhPotg3lDm42I2MjmnEacrQqfLxseiBOShkiNmYvTyej4
	 QRnLpYd53wSAH5KSDe6tIw1jRJOyLtkZjwuL4F00=
Date: Tue, 04 Aug 2026 12:59:49 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-reset-per-priority-params-when-changing-algorithm-before-init.patch added to mm-new branch
Message-Id: <20260804195949.B00991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: reset per-priority params when changing algorithm before init
has been added to the -mm mm-new branch.  Its filename is
     zram-reset-per-priority-params-when-changing-algorithm-before-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-reset-per-priority-params-when-changing-algorithm-before-init.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

zram-do-not-release-zstd-global-params-from-error-paths.patch
zram-reject-zero-size-dictionary.patch
zram-add-pr_fmt-to-backend-files.patch
zram-validate-parameters-in-each-backends-setup_params.patch
zram-reset-per-priority-params-when-changing-algorithm-before-init.patch

