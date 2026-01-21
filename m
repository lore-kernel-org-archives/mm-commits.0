Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7D27FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966082; cv=none; b=IlHJ1gvBRo/WK1KHAsouVRUIbm+xn3fMaW9iXab7R551c6HzpqXEQaCuoRr/fLMIlpcLG/s9BUhKG3CsVVsUBxyIY2fdn+XzgjOVgqPejE+3PZsbsMGhCXU1tBnu4ROllozH27HrfDPmvy+MfHcrQGV8Ni376aO2tpDw33ZObLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966082; c=relaxed/simple;
	bh=Jw2DSldk3BnosbkE52B7nCd6A0gLQmXtQBjuSBy92GU=;
	h=Date:To:From:Subject:Message-Id; b=jLa1twIZ5SKZrOvU7IFYQ3tiyzaPDnGMIdS94riiWsP3E9FnsXvfNX6iICe+bTnIWQHlv0pbfyg5XIbIyxu6KC5lACtkChARipdiQaU5+XUNLvLfkad8sHBkE/gbg3KU9AzHs66/3TGBReRdEhiN3wSVKcIPEI5/rtKKA5mGDSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vv1DEItq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vv1DEItq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45907C16AAE;
	Wed, 21 Jan 2026 03:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966082;
	bh=Jw2DSldk3BnosbkE52B7nCd6A0gLQmXtQBjuSBy92GU=;
	h=Date:To:From:Subject:From;
	b=Vv1DEItq6AazQXXpvugiFGfjSsLZJVACbyciSfL8ski0QYIT8cjhpy7VKSr7LvT4b
	 rscvufTFdXXqjQ2RmSPkTYInz63r6MVzvupCL2LCgt8kVHZGiCy/IFJDKAD5aKXHon
	 jSRzkOICM6nFxA0TfZvphKlbymM9L7kw1Q09FuSc=
Date: Tue, 20 Jan 2026 19:28:01 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,rgbi3307@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-deduplicate-intervals_goal-setup-in-damon_stat_build_ctx.patch removed from -mm tree
Message-Id: <20260121032802.45907C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-deduplicate-intervals_goal-setup-in-damon_stat_build_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: JaeJoon Jung <rgbi3307@gmail.com>
Subject: mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
Date: Mon, 15 Dec 2025 23:34:38 -0800

The damon_stat_build_ctx() function sets the values of intervals_goal
structure members.  These values are applied to damon_ctx in
damon_set_attrs().  However, It is resetting the values that were already
applied previously to the same values.  I suggest removing this code as it
constitutes duplicate execution.

Link: https://patch.msgid.link/20251206011716.7185-1-rgbi3307@gmail.com
Link: https://lkml.kernel.org/r/20251216073440.40891-1-sj@kernel.org
Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
Reviewed-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-deduplicate-intervals_goal-setup-in-damon_stat_build_ctx
+++ a/mm/damon/stat.c
@@ -173,14 +173,6 @@ static struct damon_ctx *damon_stat_buil
 	if (damon_set_attrs(ctx, &attrs))
 		goto free_out;
 
-	/*
-	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
-	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
-	 */
-	ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
-		.access_bp = 400, .aggrs = 3,
-		.min_sample_us = 5000, .max_sample_us = 10000000,
-	};
 	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
 		goto free_out;
 
_

Patches currently in -mm which might be from rgbi3307@gmail.com are


