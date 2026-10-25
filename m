Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792947248;
	b=mTeIvr+0Vg2weBEXH8wHD9k4AAlGTdughXd4VAI6pbZcWYaWtUeeGMNXfCgTwMbN44Pc
	 omWDmDIuDrBImpK2rtPrvl3jg3MSrCdMvnah6h7OmggsEUnb3X96ZWg8JCt1HU6e6JgU/
	 eSnaqxqhKts6+YZ2T69cM+DS6tbVfTmrg3tamlsoyrGYmxjTijGyD8LwJ7cc14fYZ0CzM
	 jlLh9xr/0Zk4kWvUwJBvbzEoGtk+eEIYdxbOAgfNL0U+khWwnujj0QpF+OxscNu1fMa/k
	 qb4kEw4hxF122kyO30d+w2k0Uf2VE8kaYtrMCHMtGJmmGvfkTdOzuEqcDXogCD624Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792947248;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7o5Zb9mXHZt3WsgFCTaiwTu3eVbUeCOA9n40KPT6Lwc=;
	b=y8q8/SnoB795RynGVSl+5DJqBHB7rI15uZDWOhiXXcyare9Wp5g8n2Xd1A+7zW+k1xs5
	 rRHizDu4VkJTp3mYKMa+voM3t4L6OFclF9KATG5a5wQclDq8M37ABQ8NmbJxxYroA6419
	 P1w5cMaxF0nA1k2j2piGKMjHpcCzggOcfwO4IOlq9ey9N2hxscky+uV1diEtXidoVAt3m
	 uwBemdiAftwrZlXSBQkwGniZUEq0inhkdjZeJO/GUHNlm5UcF7ZQ1Bo5Ig0UlmN3NPa8X
	 G9ss8SyzfzgpCOskXlnHtMcPs5joafUHgXpSSJisQe4RrjjJVtmgMdjRFrToGUX1+1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="c/2aiiFE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF8A606A31E;
	Sun, 25 Oct 2026 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=c/2aiiFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AB01F01825;
	Sun, 25 Oct 2026 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792947247;
	bh=7o5Zb9mXHZt3WsgFCTaiwTu3eVbUeCOA9n40KPT6Lwc=;
	h=Date:To:From:Subject;
	b=c/2aiiFEDq7C074KU3ZFL02b/XMEQExF/tx28HbgnH1sHYOd3dJcC7BCaLwOaU5HO
	 kEJqncOr65YtFujMsqswSbmM2EVz7KdR9xMPpnMoI+hLatAYiNsae5KGXzCsQpctSO
	 0LuTZgp34bSm7cKNVJHkiZY4y57icoTOKlFY749c=
Date: Sun, 25 Oct 2026 09:54:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjpark@amazon.de,
	sieberf@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch added to mm-unstable branch
Message-Id: <20261025165407.B9AB01F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: move static variable last_nr_regions to damon_ctx
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Sun, 25 Oct 2026 09:48:05 -0700

kdamond_split_regions() uses a static variable last_nr_regions, to infer
if the region boundaries are too stable.  If it looks too stable, it
does a more aggressive region split because it might be a fake stability
coming from non-aggressive split.  Because the variable is static, the
inference can be racy and wrong when multiple kdamonds are running in
parallel.

The user impact is not critical.  No crash, no leak.  DAMON's
best-effort monitoring accuracy can be degraded when multiple kdamonds
are used in parallel and the workload has certain access patterns. Still
it is a bug that is better to fix.

Move the variable into the damon_ctx struct to fix the problem.

Link: https://lore.kernel.org/20261025164808.152048-3-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-eebfcdde-2881-48ef-8df1-e2019d2a47f2
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: <stable@vger.kernel.org> # 5.15.x
---

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |    5 ++---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx
+++ a/include/linux/damon.h
@@ -958,6 +958,11 @@ struct damon_ctx {
 
 	/* @rnd_state:	Per-ctx PRNG state for damon_rand(). */
 	struct rnd_state rnd_state;
+	/*
+	 * number of regions after last merge.  Read kdamond_split_regions()
+	 * for more details.
+	 */
+	unsigned long last_nr_regions;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
--- a/mm/damon/core.c~mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx
+++ a/mm/damon/core.c
@@ -3795,7 +3795,6 @@ static noinline_for_stack void kdamond_s
 	struct damon_target *t;
 	unsigned long nr_regions = 0;
 	unsigned long max_nr_regions = ctx->attrs.max_nr_regions;
-	static unsigned long last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -3811,7 +3810,7 @@ static noinline_for_stack void kdamond_s
 	}
 
 	/* Maybe the middle of the region has different access frequency */
-	if (last_nr_regions == nr_regions &&
+	if (ctx->last_nr_regions == nr_regions &&
 			nr_regions < max_nr_regions / 3)
 		nr_subregions = 3;
 
@@ -3820,7 +3819,7 @@ static noinline_for_stack void kdamond_s
 				       ctx->min_region_sz);
 
 done:
-	last_nr_regions = nr_regions;
+	ctx->last_nr_regions = nr_regions;
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch
mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch
mm-damon-core-move-static-variable-rotation-to-damon_ctx.patch

