Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EE94A3418
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 19:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873586; cv=none; b=uKcSIhF+WwYyFWMqV+fkYcZaZ3JL2cRY3nuG03dMLDcw0aC5O03gqxCixn9bGYztawvCsoA9XzY0YsR3YQkaCuwPK6Ump9M0uSidSHVZvP43gWkS68BqVlYxOhcz+AQaQ6ASmsbZ4aLTKm+qLOuYjTZn3rWBZx6yOW0noDy9R30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873586; c=relaxed/simple;
	bh=p41KR9BTa6kl1iPVuRSV1ZaK0Er6Fp6zaPDPhYKT5M4=;
	h=Date:To:From:Subject:Message-Id; b=CYIWY2XYcwwEJ3cYc+TlMe/0NWxsmQaLuuWFrI7qH6Ss1adW4BguNa8fRt7sEVFdyAaI6O59VYpuQZBeO8hQ0TvdahNE6Dlyl2hRCTF3mGlrIhgd+ysf7DJpLjAuqKTbb9KuiPlA7hURvq3qkahpQR9e+yoFH6qx23So8phSy3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AajUtdzb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AajUtdzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92E81F000E9;
	Tue,  4 Aug 2026 19:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785873585;
	bh=MRBdhClH0KMoD55JzmJgDiwbkcE8F7XAt1myJmIWFCU=;
	h=Date:To:From:Subject;
	b=AajUtdzbXdxi9cL/a2Xn0CmwxCVXecCwD3C1bsbb2rGqU/XR+Ny7aop9dI9WV27UO
	 RyvOsrJDd4vFbxDxAmefoG6GSgDZl6KvSf0/6HXXzPznj9qm8BU5l7F/9rSyvSm4LG
	 XROHaXx0chJzPl6N4z1NbLKan4tAS+3RteQv7SoU=
Date: Tue, 04 Aug 2026 12:59:44 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-validate-parameters-in-each-backends-setup_params.patch added to mm-new branch
Message-Id: <20260804195944.D92E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: validate parameters in each backend's setup_params
has been added to the -mm mm-new branch.  Its filename is
     zram-validate-parameters-in-each-backends-setup_params.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-validate-parameters-in-each-backends-setup_params.patch

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
Subject: zram: validate parameters in each backend's setup_params
Date: Tue, 4 Aug 2026 17:38:40 +0800

Dict and level parameters are silently accepted even for backends that do
not support them.  Validate these parameters in each backend's
.setup_params() to reject unsupported combinations and out-of-range levels
with a specific error message.

Link: https://lore.kernel.org/20260804093841.67920-5-haoqinhuang7@gmail.com
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

 drivers/block/zram/backend_842.c     |    8 ++++++++
 drivers/block/zram/backend_deflate.c |   13 ++++++++++++-
 drivers/block/zram/backend_lz4.c     |    6 +++++-
 drivers/block/zram/backend_lz4hc.c   |   12 +++++++++++-
 drivers/block/zram/backend_lzo.c     |    8 ++++++++
 drivers/block/zram/backend_lzorle.c  |    8 ++++++++
 drivers/block/zram/backend_zstd.c    |    7 ++++++-
 7 files changed, 58 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/backend_842.c~zram-validate-parameters-in-each-backends-setup_params
+++ a/drivers/block/zram/backend_842.c
@@ -15,6 +15,14 @@ static void release_params_842(struct zc
 
 static int setup_params_842(struct zcomp_params *params)
 {
+	if (params->dict_sz) {
+		pr_err("dictionary is not supported\n");
+		return -EOPNOTSUPP;
+	}
+	if (params->level != ZCOMP_PARAM_NOT_SET) {
+		pr_err("compression level is not supported\n");
+		return -EOPNOTSUPP;
+	}
 	return 0;
 }
 
--- a/drivers/block/zram/backend_deflate.c~zram-validate-parameters-in-each-backends-setup_params
+++ a/drivers/block/zram/backend_deflate.c
@@ -24,8 +24,19 @@ static void deflate_release_params(struc
 
 static int deflate_setup_params(struct zcomp_params *params)
 {
-	if (params->level == ZCOMP_PARAM_NOT_SET)
+	if (params->dict_sz) {
+		pr_err("dictionary is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (params->level == ZCOMP_PARAM_NOT_SET) {
 		params->level = Z_DEFAULT_COMPRESSION;
+	} else if (params->level < Z_DEFAULT_COMPRESSION ||
+		   params->level > Z_BEST_COMPRESSION) {
+		pr_err("invalid compression level %d\n", params->level);
+		return -EINVAL;
+	}
+
 	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET) {
 		params->deflate.winbits = DEFLATE_DEF_WINBITS;
 	} else {
--- a/drivers/block/zram/backend_lz4.c~zram-validate-parameters-in-each-backends-setup_params
+++ a/drivers/block/zram/backend_lz4.c
@@ -32,8 +32,12 @@ static int lz4_setup_params(struct zcomp
 	LZ4_stream_t *dict_stream;
 	int ret;
 
-	if (params->level == ZCOMP_PARAM_NOT_SET)
+	if (params->level == ZCOMP_PARAM_NOT_SET) {
 		params->level = LZ4_ACCELERATION_DEFAULT;
+	} else if (params->level < LZ4_ACCELERATION_DEFAULT) {
+		pr_err("invalid compression level %d\n", params->level);
+		return -EINVAL;
+	}
 
 	if (!params->dict || !params->dict_sz)
 		return 0;
--- a/drivers/block/zram/backend_lz4hc.c~zram-validate-parameters-in-each-backends-setup_params
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -22,8 +22,18 @@ static void lz4hc_release_params(struct
 
 static int lz4hc_setup_params(struct zcomp_params *params)
 {
-	if (params->level == ZCOMP_PARAM_NOT_SET)
+	if (params->level == ZCOMP_PARAM_NOT_SET) {
 		params->level = LZ4HC_DEFAULT_CLEVEL;
+	} else if (params->level < 1 || params->level > LZ4HC_MAX_CLEVEL) {
+		/*
+		 * Use < 1 rather than < LZ4HC_MIN_CLEVEL here because
+		 * LZ4HC_compress_generic() only clamps levels below 1
+		 * (levels 1 and 2 are valid). LZ4HC_MIN_CLEVEL (3) is
+		 * advisory and not enforced by the library.
+		 */
+		pr_err("invalid compression level %d\n", params->level);
+		return -EINVAL;
+	}
 
 	return 0;
 }
--- a/drivers/block/zram/backend_lzo.c~zram-validate-parameters-in-each-backends-setup_params
+++ a/drivers/block/zram/backend_lzo.c
@@ -14,6 +14,14 @@ static void lzo_release_params(struct zc
 
 static int lzo_setup_params(struct zcomp_params *params)
 {
+	if (params->dict_sz) {
+		pr_err("dictionary is not supported\n");
+		return -EOPNOTSUPP;
+	}
+	if (params->level != ZCOMP_PARAM_NOT_SET) {
+		pr_err("compression level is not supported\n");
+		return -EOPNOTSUPP;
+	}
 	return 0;
 }
 
--- a/drivers/block/zram/backend_lzorle.c~zram-validate-parameters-in-each-backends-setup_params
+++ a/drivers/block/zram/backend_lzorle.c
@@ -14,6 +14,14 @@ static void lzorle_release_params(struct
 
 static int lzorle_setup_params(struct zcomp_params *params)
 {
+	if (params->dict_sz) {
+		pr_err("dictionary is not supported\n");
+		return -EOPNOTSUPP;
+	}
+	if (params->level != ZCOMP_PARAM_NOT_SET) {
+		pr_err("compression level is not supported\n");
+		return -EOPNOTSUPP;
+	}
 	return 0;
 }
 
--- a/drivers/block/zram/backend_zstd.c~zram-validate-parameters-in-each-backends-setup_params
+++ a/drivers/block/zram/backend_zstd.c
@@ -60,8 +60,13 @@ static int zstd_setup_params(struct zcom
 		return -ENOMEM;
 
 	params->drv_data = zp;
-	if (params->level == ZCOMP_PARAM_NOT_SET)
+	if (params->level == ZCOMP_PARAM_NOT_SET) {
 		params->level = zstd_default_clevel();
+	} else if (params->level < zstd_min_clevel() ||
+		   params->level > zstd_max_clevel()) {
+		pr_err("invalid compression level %d\n", params->level);
+		goto error;
+	}
 
 	zp->cprm = zstd_get_params(params->level, PAGE_SIZE);
 
_

Patches currently in -mm which might be from haoqinhuang@tencent.com are

zram-do-not-release-zstd-global-params-from-error-paths.patch
zram-reject-zero-size-dictionary.patch
zram-add-pr_fmt-to-backend-files.patch
zram-validate-parameters-in-each-backends-setup_params.patch
zram-reset-per-priority-params-when-changing-algorithm-before-init.patch

