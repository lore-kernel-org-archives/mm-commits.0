Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AF831A807;
	Thu, 30 Jul 2026 00:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785372206; cv=none; b=rfH2Yw5fGcOF43MlcS6r0w7VGpRA5hURUOAiIFW1AVzttpYg97tVAYyAwY4WNPJBYTMohAvHqgtD0o5uf8KCNv6vy3ov/f3o8DRZyLIQmCoyqkWj1tq6NGRypuPhGCaTsH4ZUxN+0zGInBlA0fGsFCfVw/J27lb6k+3C/2FPVbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785372206; c=relaxed/simple;
	bh=77SJ15rI4zLvQd/ZdjQawjcWUlMnB/yrenDuoFdzDko=;
	h=Date:To:From:Subject:Message-Id; b=msc/4izSSLkX1GsZNef6qYQ/D1GRmDI/dOQZO+ACUTJQcOCWMA2sx7lpUtytgDcFgUtnsSA9DcjbPUN5QF3Zr5iYXBLy6AVn97ic4a1MS9k3NUUHDFlSdDpfgawjPzWCdeTdXNTEVVaM+kcp2q8mPbWcPF6gNovw5RK/O58kJS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZVRI926F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZVRI926F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801131F000E9;
	Thu, 30 Jul 2026 00:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785372204;
	bh=S/p1hyjo2i5c9mfKeYP19fqgm/Y9djWd+PIqAmEt8GA=;
	h=Date:To:From:Subject;
	b=ZVRI926FMb+KE9EEOVUtcJX8EHM5Ej3cmUfceFw4Yu384Tjb/kwD8hRfvg9dl48Wc
	 kw7645NlFrEECqMy/pih7zmSLn9Am2CWw7oLXlIZGaFaAUY6jZBVeZuDzbzu+X/ODR
	 CDg+LZhmWuoG2x8YFh7lDKSk1b9Wt8iWnzFkXves=
Date: Wed, 29 Jul 2026 17:43:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,haoqinhuang7@gmail.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-set-default-primary-compressor-in-zram_destroy_comps.patch added to mm-new branch
Message-Id: <20260730004324.801131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: set default primary compressor in zram_destroy_comps()
has been added to the -mm mm-new branch.  Its filename is
     zram-set-default-primary-compressor-in-zram_destroy_comps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-set-default-primary-compressor-in-zram_destroy_comps.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: set default primary compressor in zram_destroy_comps()
Date: Wed, 29 Jul 2026 13:57:35 +0900

Patch series "zram: fix zram issues reported by sashiko".

Sashiko drove by and reported [1] a couple of zram issues:
a possible BUG_ON() in zlib code due to missing winbits range
validation and one possible NULL-ptr dereference in zcomp.
Both are low risk yet still worth fixing.


This patch (of 2):

zram_destroy_comps() resets all compressors and leaves them set to NULL,
including the primary one, which is invalid device state, as now
comp_algorithm_show()->strcmp() can be called on a NULL compressor.  Set
default primary compressor in zram_destroy_comps().

Link: https://lore.kernel.org/20260729045745.775973-2-senozhatsky@chromium.org
Fixes: 486fd58af7ac ("zram: don't free statically defined names")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com [1]
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-set-default-primary-compressor-in-zram_destroy_comps
+++ a/drivers/block/zram/zram_drv.c
@@ -2828,6 +2828,7 @@ static void zram_destroy_comps(struct zr
 		zram->comp_algs[prio] = NULL;
 
 	zram_comp_params_reset(zram);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2845,8 +2846,6 @@ static void zram_reset_device(struct zra
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
-
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

documentation-zram-remove-sections-numbering.patch
zram-set-default-primary-compressor-in-zram_destroy_comps.patch
zram-validate-deflate-params.patch

