Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672142;
	b=Im++2Ha/z04caz5wv6q7ZLhy0V39s1povBnHKqt6Iwb8AAPUsogJ6aN3bhpIAMdPK3iQ
	 I7tswDuoe8cjPWa3rKTqpbcDhf9rMUJPtsC4Z6hC9Q0yilk5v8DrAYeBrguilCHGSUqCj
	 4gTVOHAQ5JGBc6+Bb2arDqX4EgQeb8wchlAX2rKITD9c0btmpvk88FvpB30y4SaIA42f9
	 9Pxs9Pk3kQ4dLrv1DA7LNUpKSUJwhW5IkvnK5J6CdPCG/schK6w3Ffgfs6fXt0XlC65wp
	 ROOCSdIrHv4e6AQPL2VdIXphSwJ/PDWIpMh3jdzBMUDHzCN3tjW1CbhiVHzR0hilvNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672142;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eKrRFECzIzSsGQ+NuDvDqBKaz3T8giMc/FGgy1sk7Kg=;
	b=Kx7h9uFox0+yJr3AEYUWT3Q9DUfo2HHNY1Ab+9gfZndGsdKj6TQcdsvLZKp4OPJb+PKs
	 P+cTJFpctWnWG/hFhOmrwKUoBCawglFeHIu0KsMU7Ne9HrdvgZGSLCy8tNyARRohzTUzU
	 WtO3qdOeY6jNkpoZ1t6/pMSOeiu1js18HzxcDJG356e5bCTKpMU5hYA1n6yTIOj8tMhW+
	 ht53z5oelbErkazmqI4bOJAiDwd5DPxMFsFzPaIRVISel8DGnVg8QCYO50HBQj7Qd2ZTu
	 /Awf1eWTtrCTpC77zV0EhY9D61q6J15suwDFsspBVKh636cjOWNm+YB0E82VDkZErRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lHKQ5J4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F05606A32D;
	Tue,  3 Nov 2026 02:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lHKQ5J4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7CD1F0093A;
	Tue,  3 Nov 2026 02:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672142;
	bh=eKrRFECzIzSsGQ+NuDvDqBKaz3T8giMc/FGgy1sk7Kg=;
	h=Date:To:From:Subject;
	b=lHKQ5J4UrkTzeRxqyOwxzF14/JoJPVB2fSCB0r3ZeacxnzJqO/6auV9Pc4jPQfmyg
	 mgba/IUOk2rfxE8hMSbl66XCii4rJstdSYh6CEke8wwcloTk0HFY8WA8sIRiEMR7XD
	 NhjiyH6rSYOiz/dh4XZZBiEVe8IckUFVRFjEDksY=
Date: Mon, 02 Nov 2026 18:15:41 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sjpark@amazon.de,
	sieberf@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch removed from -mm tree
Message-Id: <20261103021541.DC7CD1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: move static variable last_nr_regions to damon_ctx
has been removed from the -mm tree.  Its filename was
     mm-damon-core-move-static-variable-last_nr_regions-to-damon_ctx.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch

