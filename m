Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D731DC99A
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274603; cv=none; b=ugRFZq9Rrphsl95BLI8z2axi8fdkSlRKEELuJDulsKuBtfAVGDY1GvlqCWtc9cMxoiFCpORkgISokj2kFgR/pD9O+gp6svATdFkazZvpQyJ3sO8hPl2eAlMkOfszjhEvtDzGFLcnCyVAr7Tfw8HLlF8wh89e/NwJ05NPT+IgkR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274603; c=relaxed/simple;
	bh=UNCDIvFv+OTsFmiFDIYe+SDKGRTvitsourvqm54HluY=;
	h=Date:To:From:Subject:Message-Id; b=n0HzFSHer3zxkxp5EyXKQuLZKX4L6asFIyX3irgCeVDaWCMxoAUyN+IKl5eVy7tPGyKhfnBdjqsfpiqXWpW6BuezQ6Z3ovwjsSglQ8ppPpq1Kx231R/S4qfeimP8K9vKG5YWND95gPKWadKk9Z6wD2rXYDNSRfvDe309TqWNdmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lf331e6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lf331e6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8FDC4CEEA;
	Tue, 18 Mar 2025 05:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274603;
	bh=UNCDIvFv+OTsFmiFDIYe+SDKGRTvitsourvqm54HluY=;
	h=Date:To:From:Subject:From;
	b=lf331e6hpCgFXNqsXttJkMv/+CL/dkHizmaJc+/4vf3ScMEwGWs06wRJa/6J1Q08C
	 u8SNM4WEmtd62f+d8mfX2MjdYxKWOBPDJCq4OFv7354+lK0Wnwfpm5drJvXBrAnbrm
	 fCFNxNiVUbHFE/Ivfy1lUu14WsR4GhWMdMpp36Fc=
Date: Mon, 17 Mar 2025 22:10:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-before_start-of-damon_callback.patch removed from -mm tree
Message-Id: <20250318051003.AE8FDC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove ->before_start of damon_callback
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-before_start-of-damon_callback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: remove ->before_start of damon_callback
Date: Thu, 6 Mar 2025 09:59:05 -0800

The function pointer field was added to be used as a place to do some
initialization works just before DAMON starts working.  However, nobody is
using it now.  Remove it.

Link: https://lkml.kernel.org/r/20250306175908.66300-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 ++-----
 mm/damon/core.c       |    2 --
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-before_start-of-damon_callback
+++ a/include/linux/damon.h
@@ -603,16 +603,14 @@ struct damon_operations {
 /**
  * struct damon_callback - Monitoring events notification callbacks.
  *
- * @before_start:	Called before starting the monitoring.
  * @after_wmarks_check:	Called after each schemes' watermarks check.
  * @after_sampling:	Called after each sampling.
  * @after_aggregation:	Called after each aggregation.
  * @before_damos_apply:	Called before applying DAMOS action.
  * @before_terminate:	Called before terminating the monitoring.
  *
- * The monitoring thread (&damon_ctx.kdamond) calls @before_start and
- * @before_terminate just before starting and finishing the monitoring,
- * respectively.
+ * The monitoring thread (&damon_ctx.kdamond) calls @before_terminate just
+ * before finishing the monitoring.
  *
  * The monitoring thread calls @after_wmarks_check after each DAMON-based
  * operation schemes' watermarks check.  If users need to make changes to the
@@ -628,7 +626,6 @@ struct damon_operations {
  * If any callback returns non-zero, monitoring stops.
  */
 struct damon_callback {
-	int (*before_start)(struct damon_ctx *context);
 	int (*after_wmarks_check)(struct damon_ctx *context);
 	int (*after_sampling)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
--- a/mm/damon/core.c~mm-damon-remove-before_start-of-damon_callback
+++ a/mm/damon/core.c
@@ -2408,8 +2408,6 @@ static int kdamond_fn(void *data)
 
 	if (ctx->ops.init)
 		ctx->ops.init(ctx);
-	if (ctx->callback.before_start && ctx->callback.before_start(ctx))
-		goto done;
 	ctx->regions_score_histogram = kmalloc_array(DAMOS_MAX_SCORE + 1,
 			sizeof(*ctx->regions_score_histogram), GFP_KERNEL);
 	if (!ctx->regions_score_histogram)
_

Patches currently in -mm which might be from sj@kernel.org are


