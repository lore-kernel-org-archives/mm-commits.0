Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FB616DEB1;
	Mon, 29 Jun 2026 04:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708563; cv=none; b=tnjQ8i2bSk+8oD8l8OSIAqi1zlGtGo5PP7DyfieibjPU3xXUr5CBID3dvYab9GWC8kqvX5jbrNUlltPQJxF2m+RVGP7b832J8V0nAQtN+q+rneaPjiz+0R8ndmuAWbsfn98A76/yOBG80IeJ2yrC3gkt+rrAO1yFW56WCGYzC7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708563; c=relaxed/simple;
	bh=4EYvPPm9RZ4VLg6mpLNmmDO2u8Iea53PvoYCJxKmTfo=;
	h=Date:To:From:Subject:Message-Id; b=qOodpl/PqYm8hI3GYy9alJiPlMnu4JUzOCc2hcMQucgW6V3cxt8QEbeDQUOWxyJb8+DqGF8pdeCuZM94r0yHLrbU/rKvNC+19V+z6PEL2G2q4n4PcU1bcHvqzbfSUjDSgeJw6QQGZvpAbCyL6k5FwJgCVCN9aKcCbJDZaYw8o+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UKLC72Ok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UKLC72Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DF81F000E9;
	Mon, 29 Jun 2026 04:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708561;
	bh=g21Dd01+Kaixr8icLlcaNywVnclIZD4TaQKCmIt0HN4=;
	h=Date:To:From:Subject;
	b=UKLC72OkwLF700JJYj+757D31Vj1VuM9wOJwVQEBRkyVhCWdlkza4RwxpWVC3iMz+
	 x987FwWzqwGuZ0lgVv5lMnLbbFSNhBAj5krWAf4XZ1cNiJKVYfKM4555ffmUczFF9a
	 IPxRklY3fq4hujoV5Yc7m507JufiXvx9KNf4HTm4=
Date: Sun, 28 Jun 2026 21:49:20 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-mtier-handle-damon_stop-failure.patch added to mm-new branch
Message-Id: <20260629044921.61DF81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/mtier: handle damon_stop() failure
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-mtier-handle-damon_stop-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-mtier-handle-damon_stop-failure.patch

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
Subject: samples/damon/mtier: handle damon_stop() failure
Date: Sun, 28 Jun 2026 14:54:43 -0700

damon_sample_mtier_stop() assumes its damon_stop() call will always
successfully stops the two DAMON contexts.  Hence it deallocates the two
DAMON contexts after the damon_stop() call.  However, if a given context
is already stopped, damon_stop() fails and returns an error while letting
the DAMON contexts that have not yet stopped keep running.  This kind of
unexpected early DAMON context stops could happen due to memory allocation
failures in kdamond_fn().  Because damon_sample_mtier_stop() just
deallocates all DAMON contexts with damon_target and damon_region objects
that are linked to the contexts, the execution of the unstopped DAMON
context (kdamond) ends up using the memory that freed (use-after-free). 
Fix the issue by separating the damon_stop() to be invoked per context.

Note that DAMON_SYSFS also allows multiple DAMON contexts execution.  But,
it calls damon_stop() for each context one by one.  Hence this issue is
only in mtier.

For the long term, it would be better to refactor damon_stop() to always
ensure stopping all contexts regardless of the failures in the middle. 
Make this fix in the current way, though, to keep it simple and easy to
backport.  I will do the refactoring later.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-5-sj@kernel.org
Link: https://lore.kernel.org/20260609014219.3013-1-sj@kernel.org [1]
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/samples/damon/mtier.c~samples-damon-mtier-handle-damon_stop-failure
+++ a/samples/damon/mtier.c
@@ -199,7 +199,8 @@ static int damon_sample_mtier_start(void
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 2);
+	damon_stop(ctxs, 1);
+	damon_stop(&ctxs[1], 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }
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

