Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419F63FFD
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 19:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912633; cv=none; b=QM27yFXXpnUNXO93duc3UrEgkw8D1N8F+x2xNB3nmag2TsM1354nfw4wM2/NpznCazSCjELl432Dgd9C2EpQdyATPkRjaRvcNpuJTGpyl8Zy3jfFu880T4Dt+wyQC1vaGM86a5B/wDy7PcuXwQdv/uD4toR3wdH6wlQENkZx+/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912633; c=relaxed/simple;
	bh=vs7Dc9Q8krlSEU7MgBIz8imkQWX1//ufcWElEeUTcbY=;
	h=Date:To:From:Subject:Message-Id; b=ppeet9mLFxtO9ey6r+eQonXE3fHicwR3h0SL2WJRgYzDICXrDSFRhCMGnmsWfsR1HOqLpuvIuTKzq8mUVbsFLX4hCU4vqEqxZeH842JQMLq2VcOIBxKMNZoIzGvVuD7G1lDnADTV5wa/zEHTPmBMAfkZIDWeCfyvS5vB7iB+IGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HbQXf+tW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HbQXf+tW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B18AC4CEF1;
	Tue, 16 Dec 2025 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765912632;
	bh=vs7Dc9Q8krlSEU7MgBIz8imkQWX1//ufcWElEeUTcbY=;
	h=Date:To:From:Subject:From;
	b=HbQXf+tWBvGHBJ4ikiwXIZycSoZWW9KI76coLg9IwTPyprfs5tbI34TYaUAKj10MH
	 +y7clUfnIF4tiCaaqgZ6W/iaJX9eosGczJxz1VNa67+X6RLN0PHxPDW8IIhMiqEPYy
	 sDAY7/umoFdapkOKmyX9DujRotBZ3/S5A56k5P4M=
Date: Tue, 16 Dec 2025 11:17:12 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,rgbi3307@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-deduplicate-intervals_goal-setup-in-damon_stat_build_ctx.patch added to mm-new branch
Message-Id: <20251216191712.9B18AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-deduplicate-intervals_goal-setup-in-damon_stat_build_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-deduplicate-intervals_goal-setup-in-damon_stat_build_ctx.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

mm-damon-stat-deduplicate-intervals_goal-setup-in-damon_stat_build_ctx.patch

