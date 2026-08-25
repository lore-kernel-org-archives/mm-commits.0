Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3C02F83B5
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622837; cv=none; b=PjaaaA0cKOhlLoa/i4pGsYeU3FKhvwE7viIJ7uSTAKdxG0hQHrBHz24DftECGCiyH4zPzCKVPb3n1cDS9tK9sA11pa3Vka87qoVtsi7a/5lWioeLMhdG/LC8temVO4IFLqdCwDXCzkqSuMZAg+kfVOCshHyExJoRfuthRubVfAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622837; c=relaxed/simple;
	bh=YG4diRrQkItDBVH0SxyDNWkN2+K/RamuY2pOL5MZbh8=;
	h=Date:To:From:Subject:Message-Id; b=aC2rmhV95NCyqqijbrz6fkdXRDwjAcoHXIGZtWbTxOcbNJSaNA+ZTwk+a5aIkD91KC4fd9dPyL4JQbBGYnSeu3FFH15Q4025JUnVuw7ylGV4RpnjbltWY9cyddRFgsLmVhS2kzkXlVK/zVIOiABus+4wlDf4F09Pd2qDEfmBQbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gVBBgIHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gVBBgIHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B267D1F00A3A;
	Tue, 25 Aug 2026 01:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622835;
	bh=iz+TwlR+KeG1z2hqyTTVibl+iQ8FxSLaFx9XATBp06A=;
	h=Date:To:From:Subject;
	b=gVBBgIHqQVxqqJdqga8o/+Q4bPE6cSEvm4qCbbBrO9UVX81ctb7wBsQ/R8dS+Qp2A
	 VVSvoXuKSNoCsxw5av/XFR22qMPkY4gbb0krLwS8cJ71yebZ4g6sMuSaaWTUyemErX
	 Xt+aX+i6IoCIyQEMwqQl1SRvXr4D0Ad88iCKfqMU=
Date: Mon, 24 Aug 2026 18:53:55 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-release-zstd-global-params-from-error-paths.patch removed from -mm tree
Message-Id: <20260825015355.B267D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not release zstd global params from error paths
has been removed from the -mm tree.  Its filename was
     zram-do-not-release-zstd-global-params-from-error-paths.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


