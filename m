Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86496282F2E;
	Mon, 29 Jun 2026 04:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708566; cv=none; b=Ff42pPUQNFXxHYw/jsaDGIlA2kLsX+JldwDGCwMcyonUK9iz/tTjIcrgKjsHaYMDory/oT5iVXqB8cIZSdvFOxzc+OUdZVDO+gTokUBBs1pVymOaEBjCuIXG4ipH7G/Ceinz58Z20uj6q02PS5S3BHQv3pMFM28KiGTzdxuH+Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708566; c=relaxed/simple;
	bh=g14rgiT1HMiIZKPhepmOnbqqLOWOs7UVUoe2yzHSWpI=;
	h=Date:To:From:Subject:Message-Id; b=n0okKFp0df0xGV21priaAV9jb2ID1qaLS2DRfl0vZYAQAELz1yCEj57u5J3vxaKFq0UIi7IuhL66XRcKGVH/vt87sdipSE9LPBWz9+X56c40e4jOw3J7iolDfntA/bzoOYCkixHk9kvL8shZmvt/xcOqewiy2a9poY3yUS+cBvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NufMqehW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NufMqehW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACB51F000E9;
	Mon, 29 Jun 2026 04:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708565;
	bh=FaRCoZyqQX4X8Kh0/s9Re3O1e95mcVbfGpzThwAOnDE=;
	h=Date:To:From:Subject;
	b=NufMqehWgNa5IV/ZO/l97xLjnaaVAvVlE5zL9Wx/Xm1M/D4076EXdGtdqdJ76gpo9
	 pVAs9pS9BFkHzm8YSUJ7ZZcGdjlD3Ev+2G98p96f5GFLGnKJs1CtCeX3tzjMKPOnzD
	 uu/bbKpIDJpVp5aD+F+tRX6PGPYBADd5gjGoq26Q=
Date: Sun, 28 Jun 2026 21:49:25 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch added to mm-new branch
Message-Id: <20260629044925.5ACB51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/prcl: stop and free damon ctx when damon_call() fails
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch

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
From: SJ Park <sj@kernel.org>
Subject: samples/damon/prcl: stop and free damon ctx when damon_call() fails
Date: Sun, 28 Jun 2026 14:54:45 -0700

damon_sample_prcl_start() calls damon_call() right after damon_start() is
succeeded.  The kdamond that has started by the damon_start() could be
terminated by itself before or in the middle of the damon_call()
execution.  There could be multiple reasons for such a stop including
monitoring target process termination and kdamond_fn() internal memory
allocation failures.  In the case, damon_call() will fail and return an
error without cleaning up the DAMON context object.  The
damon_sample_prcl_start() caller assumes it would clean up the object,
though.  When the user requests to start DAMON again,
damon_sample_prcl_start() is called again, allocates a new DAMON context
object and overwrites the pointer for the previous object.  As a result,
the previous context object is leaked.

Safely stop the kdamond and deallocate the context object when the failure
is returned.  Note that the kdamond should be stopped first, because
damon_call() failure means not complete termination of the kdamond but
only the fact that the termination process has started.

The user impact shouldn't be that significant because the race is not easy
to happen, and only up to one DAMON context object can be leaked per race.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-7-sj@kernel.org
Link: https://lore.kernel.org/20260610035214.4850-1-sj@kernel.org [1]
Fixes: a6c33f1054e3 ("samples/damon/prcl: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/samples/damon/prcl.c~samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails
+++ a/samples/damon/prcl.c
@@ -112,7 +112,12 @@ static int damon_sample_prcl_start(void)
 	}
 
 	repeat_call_control.data = ctx;
-	return damon_call(ctx, &repeat_call_control);
+	err = damon_call(ctx, &repeat_call_control);
+	if (err) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+	return err;
 }
 
 static void damon_sample_prcl_stop(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
maintainers-s-seongjae-sj.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch

