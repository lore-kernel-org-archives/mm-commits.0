Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF3537187F
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439156; cv=none; b=A7tOdxuMBmRZCZ+g27iDp2Nw3xx5710r8Zy80ygsbp/e1ITqSgsNCGEc+adjYd+bwzmVW6Ru4yme7CEXaPdV/Nv8uWeCoumAfAeeiJjZGMATD4wsD4a74M0hNEesYN/2VKyVisZcHUt6/PuAzTFLfDFX93Rc8XJWKsvGN4Xp+E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439156; c=relaxed/simple;
	bh=S6FnoHwdwheSJQfuQ/TWHwKZ+t1CNqag6fJdR7/J2xg=;
	h=Date:To:From:Subject:Message-Id; b=CV/73i3eQpK01jWouSwrrGHEh96WTt4rEbVbKYuzuYYbTnVL9Obd9K8vpEbXAfTw6pubuF43WMYt7YYclK8UTmDAv+WN9iSIRsaKua6lkxnKV+ytHyZ5lVD9mW6Ytj+GZCTin31MjFpmmnevjGA35chOgAu08rjjQyDoHYRdkSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OXVQfe5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXVQfe5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4502E1F00898;
	Tue,  2 Jun 2026 22:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439155;
	bh=Ah6wSeA1/OPNnGoRwqH2VkxLq8Bez/Q701F6G1tJI+Y=;
	h=Date:To:From:Subject;
	b=OXVQfe5Sd9TVqtCU458RfJKTquBgilPyQs5wzPqrL6Xo3gFRl9QTTVZnAufhWegou
	 0uTL/IJyG4dTA6Qjigb/m9cUkhaDzhd/A3yRhRaOSLVeD7sJ3wN5NjivrZhBjguVYM
	 3Lzb1jZnbv2uRcPre4gJ1oGkU0/ejqHtuw+d6BZo=
Date: Tue, 02 Jun 2026 15:25:54 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-damon_verify_nr_regions.patch removed from -mm tree
Message-Id: <20260602222555.4502E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove damon_verify_nr_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-damon_verify_nr_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove damon_verify_nr_regions()
Date: Fri, 22 May 2026 08:40:20 -0700

When CONFIG_DAMON_DEBUG_SANITY is enabled, damon_verify_nr_regions() is
called for each damon_nr_regions() invocation.  damon_veify_nr_regions()
iterates all regions.  damon_nr_regions() is called for each region in
kdamond_reset_aggregated() and damos_apply_scheme().  Hence it imposes
O(n**2) overhead where n is the number of regions.

Though the verification is enabled only under DAMON_DEBUG_SANITY, which is
not for production use cases, it could be too high overhead.  Meanwhile,
damon_verify_ctx() is doing the damon_nr_regions() test.  Because
damon_verify_ctx() is called for each kdamond_call(), the test coverage
from damon_verify_ctx() could be sufficient.  Remove damon_nr_regions()
verification.

Link: https://lore.kernel.org/20260522154026.80546-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-damon_verify_nr_regions
+++ a/mm/damon/core.c
@@ -686,27 +686,8 @@ void damon_destroy_target(struct damon_t
 	damon_free_target(t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-	struct damon_region *r;
-	unsigned int count = 0;
-
-	damon_for_each_region(r, t)
-		count++;
-	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
-			t->nr_regions, count);
-}
-#else
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-}
-#endif
-
 unsigned int damon_nr_regions(struct damon_target *t)
 {
-	damon_verify_nr_regions(t);
-
 	return t->nr_regions;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

