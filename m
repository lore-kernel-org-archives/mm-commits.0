Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE373B19A3;
	Fri,  7 Aug 2026 02:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068117; cv=none; b=YQvEPi7G524ozaYEFULM1wJ7/toKHCiAqXxK/xT6IYx6y9YuxlHkM4T42LidQB9/DA5q+AzihOa494vUkGdmk3a/VLVC/BZsmAwbiOr8gj/ZNft5kC7h99/u4/eylAuQ1J68R5YoNZigFfr0GFnvELQlXiINZzU2+3zdn+PcpC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068117; c=relaxed/simple;
	bh=hL+XuBtewfc769Pvn7RUDj6sz1uM0NcRQ72zDXZ1Ax4=;
	h=Date:To:From:Subject:Message-Id; b=BG+dMZ39i6uBKb0sytVCBTfDXQW/EzadOXhannvH2qWaBmTd2tfy55XBw7CBYXTIu1Ljwl6I83peiwULX+GuvTz8j0N3g862LlLjiedrwdzaZfU4wLpVu24QzfjpX+YhjlfA22vDXXQzo+YUedddrSEzH/vB9mMC5tz6cnPow/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S8Q2dQQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S8Q2dQQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD701F00A3A;
	Fri,  7 Aug 2026 02:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068116;
	bh=dCAsGmoGtS4yzywPAzGqL35JAaxRzz5ZetFhX0J//vE=;
	h=Date:To:From:Subject;
	b=S8Q2dQQH72RAJyCfO2dq8Ok00s8jrguUfUho+No0QRs0RSvnPlqw7wcsvyhjRs9Ng
	 v0kZ5Qt7XLuFhCAQ7L+TFzgBOZmhElmypKTzjz9hgFVutvDtUu0/tDpOqirNRsQT+d
	 VuEyxD6/DRsA9QzzmzNL4qegtFwQpA6JtQj10IS4=
Date: Thu, 06 Aug 2026 19:01:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-initialize-damos-last_applied.patch removed from -mm tree
Message-Id: <20260807020156.1DD701F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: initialize damos->last_applied
has been removed from the -mm tree.  Its filename was
     mm-damon-core-initialize-damos-last_applied.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: initialize damos->last_applied
Date: Fri, 17 Jul 2026 17:14:35 -0700

Patch series "mm/damon: fix uninitialized DAMOS field and kunit exec
expectation bugs".

Fix a few Sashiko-found unurgent bugs.  Patch 1 fixes use of uninitialized
damos->last_applied field.  Patches 2-7 fix DAMON kunit tests that do
invalid memory access under test failures.

The bugs are better to be fixed and eventually merged into stable@ kernel.
That said, the fixes are arguably not urgent.  Patch 1 only introduces
negligible DAMOS efficiency degradation in occasional cases.  Kunit fixes
could introduce quite bad consequences but those are test code that affect
only test run setups.


This patch (of 7):

Multiple DAMON regions could exist across a folio.  If they fulfill the
condition to apply a DAMOS scheme, the scheme could be applied multiple
times to the folio.  To avoid this, each DAMOS scheme stores the folio
that the scheme was applied to last time in the damos->last_applied field
and skips repeatedly applying the same scheme to the same folio.

The field is being used without initialization, though.  Hence, the
mechanism could wrongly skip applying a scheme to a folio at the very
first time of DAMOS run.

The user impact is trivial.  DAMON might unexpectedly skip applying DAMOS
action for one folio for the first time per scheme.  In the DAMON's
best-effort world, this is never a real problem.  No critical consequences
such as kernel panic or memory corruption happen.

It is a clear bug, though, and the fix is straightforward.  Fix the issue
by initializing the field in DAMOS scheme creation function,
damon_new_scheme().

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-1-sj@kernel.org
Link: https://lore.kernel.org/20260718001442.87129-2-sj@kernel.org
Link: https://lore.kernel.org/20260714055436.120034-1-sj@kernel.org [1]
Fixes: 94ba17adaba0 ("mm/damon: avoid applying DAMOS action to same entity multiple times")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-initialize-damos-last_applied
+++ a/mm/damon/core.c
@@ -705,6 +705,7 @@ struct damos *damon_new_scheme(struct da
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	scheme->max_nr_snapshots = 0;
+	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
_

Patches currently in -mm which might be from sj@kernel.org are


