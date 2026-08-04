Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217EA33937F
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 19:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873577; cv=none; b=qLbTTIf7Xvfer7vRGi2RLwWKS4s+vDYvRh07p/JjHYTDxCX5kRlrqXuK5TKuvU7rlXVultb6YaWas0lNRarnxVV5b0pKXLpOOZEdWYRXRw746pF0SqisEc9knPdjGG95mzKHocGz7l/lLWNFmiKeQG+t0EoI0wuPe3i0u2daVdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873577; c=relaxed/simple;
	bh=4rnAIGKkKDwhJUJTh4hVC9vHe0FrJ3daO2QZIEL6Gyo=;
	h=Date:To:From:Subject:Message-Id; b=YQTWEJnwr0FT5K2Zo/++U7PFjX7VSsDq4tX6jXEAK/hrNOW1CnEzRRd/APIo6rDxvKPrsSluSQcPSl3ULOILuU/zoHu86laM8e4EDnQ9yPPx+R5RFACXwTQSQ6zdGwMfoBOGj1xey7t25f4vRjN4/Ws6rLCHBwnOHIN2mHT44HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UxPtrYYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UxPtrYYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918FA1F000E9;
	Tue,  4 Aug 2026 19:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785873575;
	bh=9dL0qB0AECcWeieyfHk7gxBucLLx6Rzmk4elRcbd/GA=;
	h=Date:To:From:Subject;
	b=UxPtrYYav8Zgy2K+cIQoXHEaU27SWk8EaXc+YoiN1P5g9ObCEX0cyGQ5PWXSTqjn7
	 hEi5B3mkyQa4TEdmojD7MPgMHHKfOW2mMBBiqWl7jGAvPV6gj/E7mqIbuGJAhDEpQQ
	 ZSw7sdypfNQG5nbkoTcqD/ZWIN/eCoDxwqwQ/7lo=
Date: Tue, 04 Aug 2026 12:59:35 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-release-zstd-global-params-from-error-paths.patch added to mm-new branch
Message-Id: <20260804195935.918FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not release zstd global params from error paths
has been added to the -mm mm-new branch.  Its filename is
     zram-do-not-release-zstd-global-params-from-error-paths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-release-zstd-global-params-from-error-paths.patch

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
Subject: zram: do not release zstd global params from error paths
Date: Tue, 4 Aug 2026 17:38:37 +0800

Patch series "zram: fix zstd error paths and add parameter validation", v6,

Patch 1 removes zstd_release_params() from both zstd_create() and
zstd_setup_params() error paths -- the former is a layering violation
in a per-CPU callback, the latter is redundant as zcomp_init() already
calls release_params() on setup failure.

Patch 2 rejects zero-size dictionaries and prints distinct error
messages for sz < 0 (returns the original error code) and sz == 0
("empty file"). Currently errors are silently swallowed.

Patch 3 adds pr_fmt to each backend file so that pr_err() messages
are auto-prefixed with the algorithm name.

Patch 4 validates dict and level parameters in each backend's
.setup_params(), rejecting unsupported combinations and out-of-range
levels.

Patch 5 resets per-priority params on algorithm change before init.


This patch (of 5):

zstd_setup_params() creates global cdict and ddict stored in
params->drv_data, shared across all per-CPU contexts.  The per-CPU
zstd_create() error path called zstd_release_params(), which freed those
globally-shared objects.  This is a layering violation: a per-CPU callback
should only clean up its own context, not release resources owned by the
compression lifecycle.

zstd_setup_params() called zstd_release_params() on its own error path as
well, but zcomp_init() already calls release_params() when setup fails, so
this is redundant.

Remove zstd_release_params() from both error paths.

Link: https://lore.kernel.org/20260804093841.67920-1-haoqinhuang7@gmail.com
Link: https://lore.kernel.org/20260804093841.67920-2-haoqinhuang7@gmail.com
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

 drivers/block/zram/backend_zstd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-do-not-release-zstd-global-params-from-error-paths
+++ a/drivers/block/zram/backend_zstd.c
@@ -85,7 +85,6 @@ static int zstd_setup_params(struct zcom
 	return 0;
 
 error:
-	zstd_release_params(params);
 	return -EINVAL;
 }
 
@@ -161,7 +160,6 @@ static int zstd_create(struct zcomp_para
 	return 0;
 
 error:
-	zstd_release_params(params);
 	zstd_destroy(ctx);
 	return -EINVAL;
 }
_

Patches currently in -mm which might be from haoqinhuang@tencent.com are

zram-do-not-release-zstd-global-params-from-error-paths.patch
zram-reject-zero-size-dictionary.patch
zram-add-pr_fmt-to-backend-files.patch
zram-validate-parameters-in-each-backends-setup_params.patch
zram-reset-per-priority-params-when-changing-algorithm-before-init.patch

