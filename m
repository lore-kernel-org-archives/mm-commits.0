Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A132AE99;
	Sun, 21 Sep 2025 21:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490004; cv=none; b=QzILCJ0/knJED+ZHYRcbi7jxynhsZ+pnLMPjFftGvwftaSJ9a2ReAdSIAGW/6TjlEv8Ud3XvsWTkloKh16l+iJJl1OSZqsX72L1OKDabSz+CUsktd/gj+hjtTiwpsqjlX5sIbLYgZfYLbhSSKTtUYW082Kmh4nar+cCVk1CC6qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490004; c=relaxed/simple;
	bh=hP3DlIVr1TwMa5vadzlB1s2gQb6G2FeEaKfEYn6YPHk=;
	h=Date:To:From:Subject:Message-Id; b=A4f3qHvPgK3qK6ZEokbt0l1mIYn1he63Ny4LmHIvmAwqj7g73n0H2UPogJL4vNUSITCYAt5KF0jx3WdeRNHF5aTqIVI9OqUBGhOMQqWKlmXoYqb1RBCnSEr0tElBMEpnVu7ODF7hu2TT73rjEh2TqG2NL+ovnv24V9A6rEeGeFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uzc5AZnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uzc5AZnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97D2C4CEE7;
	Sun, 21 Sep 2025 21:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490004;
	bh=hP3DlIVr1TwMa5vadzlB1s2gQb6G2FeEaKfEYn6YPHk=;
	h=Date:To:From:Subject:From;
	b=Uzc5AZntILP0/wghh6W4PdIVXGibiAR8pvRqqf29D3O/TVa0Lp7WMu5YTaYbxg6my
	 O+R+IvRP8hF6Jj/dWU5m0cPsKxQUq0wP22ab9TaYf0MNY6jtlJFrcULOcXQbwan3jH
	 AhD170zX9moYFuXBHS9+IJv5GR5M12R6uN0d/SmA=
Date: Sun, 21 Sep 2025 14:26:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,joshua.hahnjy@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch removed from -mm tree
Message-Id: <20250921212644.A97D2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: use param_ctx for damon_attrs staging
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use param_ctx for damon_attrs staging
Date: Mon, 15 Sep 2025 20:15:49 -0700

damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is, however, directly
updating the monitoring attributes of the running context.  And the
attributes are over-written by later damon_commit_ctx() call.  This means
that the monitoring attributes parameters are not really working.  Fix the
wrong use of the parameter context.

Link: https://lkml.kernel.org/r/20250916031549.115326-1-sj@kernel.org
Fixes: a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: <stable@vger.kernel.org>	[6.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging
+++ a/mm/damon/lru_sort.c
@@ -219,7 +219,7 @@ static int damon_lru_sort_apply_paramete
 		goto out;
 	}
 
-	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

