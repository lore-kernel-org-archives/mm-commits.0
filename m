Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7E03C7DEB
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439132; cv=none; b=O3nMjo4ACY6HsMoqtdcCWNbsUNawIM9myrfKs9DDJFKfQJpOLvA/00FsDERXSKy8952aRLB2C+zlCdsHq7qWa8LjMYXyXDlUmLT+yT9nd0kFn/SX3ect3Xc9w7jdEXY0YUWaN+ATfswgHnqpiNKTFiWvGOC80zT15y/9X8NQg4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439132; c=relaxed/simple;
	bh=qWRbGBPgofHnULvR1+z26w+sCz92q2RV8xWsvYBY+m4=;
	h=Date:To:From:Subject:Message-Id; b=JTFCOp5pp8VgnV71KtD2O80lamp3E8PXgli90HuSICVelzA0TmwqBrY1fOs+GdroPfRiJIduRbQb6qi04ahOJUjDq6AuwT5KZEg1yPa8ABdPQnr77Yf/YCf4akYJXNu5gAKOS3iZJAo4CgiM5Ia4xzmztYzHGjR2DWlA05QxBFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ni8ZnTxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ni8ZnTxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1769F1F00898;
	Tue,  2 Jun 2026 22:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439131;
	bh=UW8oTQfLOI7nfsX3x6GBTK9BM+PR2MpyvMxNr+9q11U=;
	h=Date:To:From:Subject;
	b=ni8ZnTxEAKPtpEUQgwjVkbMpxx3HMqxEKQwyVRJRPTEjmy2Axx/kEVv9ElSNsRCLz
	 edNdIpm9nFM2T3lQLKSeqdl+FaLLu616fxUH4fLaJruiZe8MtkWKdidqUPeoVcSntw
	 s9ILwr1pZQ1mVPgKTOlPHUP1CYnb/Z4e3K7H6LDs=
Date: Tue, 02 Jun 2026 15:25:30 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,ssh1326@icloud.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,niecheng1@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-clarify-next_intervals_tune_sis-update-path.patch removed from -mm tree
Message-Id: <20260602222531.1769F1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: clarify next_intervals_tune_sis update path
has been removed from the -mm tree.  Its filename was
     mm-damon-core-clarify-next_intervals_tune_sis-update-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: niecheng <niecheng1@uniontech.com>
Subject: mm/damon/core: clarify next_intervals_tune_sis update path
Date: Tue, 19 May 2026 18:20:59 -0700

Patch series "mm/damon: documentation and comment fixes".


This patch (of 3):

damon_set_attrs() updates next_aggregation_sis and next_ops_update_sis for
online attrs updates, but it does not update next_intervals_tune_sis
there.

This can look like a missing update when reading damon_set_attrs() alone,
while next_intervals_tune_sis is actually updated in kdamond_fn().

Add a short comment to make this explicit.

Link: https://lore.kernel.org/20260520012104.93602-1-sj@kernel.org
Link: https://lore.kernel.org/20260520012104.93602-2-sj@kernel.org
Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: niecheng <niecheng1@uniontech.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Sakurai Shun <ssh1326@icloud.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-clarify-next_intervals_tune_sis-update-path
+++ a/mm/damon/core.c
@@ -909,6 +909,9 @@ int damon_set_attrs(struct damon_ctx *ct
 		attrs->aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
 		attrs->ops_update_interval / sample_interval;
+	/*
+	 * next_intervals_tune_sis will be updated inside kdamond_fn().
+	 */
 
 	damon_update_monitoring_results(ctx, attrs, aggregating);
 	ctx->attrs = *attrs;
_

Patches currently in -mm which might be from niecheng1@uniontech.com are


