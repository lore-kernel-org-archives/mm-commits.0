Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73F91EEA54
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 03:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771556776; cv=none; b=vDjSGqn5JRxnFjrG+jie8REjJMVoVWGvK8JNw2GYdvljc1IWaZApCovSIYyfP9h+7e/C+C083yXH+7naAcYHI5O1lJ1aQ7ovBx4o61q03xC0PK1EChKu5Qd7ycCxI3+izxbmg9R2f5ts+4osHAKl0r3KkbLl35SiE1zilAi4/mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771556776; c=relaxed/simple;
	bh=FrtdwQZZQF5wt+pwp+tU9eI9SyVMPpR4HN/KkuD0p3E=;
	h=Date:To:From:Subject:Message-Id; b=j9igXGERtYvrzdbKOaObfiMqrjU3JTf5CZGBJZqGQ0z09n8iU2tEj7GMezo54IPUUN7RYahvHBV28pmz9XZw1T3iY7NUmAwFNTSlz+kt4fKCPaXBrApfctLVrC0XFiW9/XxPZAg8LhAUaKqQX7v8phVUvJHYF5pGspXCBVyYBRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lDBFVB/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lDBFVB/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED5BC4CEF7;
	Fri, 20 Feb 2026 03:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771556776;
	bh=FrtdwQZZQF5wt+pwp+tU9eI9SyVMPpR4HN/KkuD0p3E=;
	h=Date:To:From:Subject:From;
	b=lDBFVB/UecSTGhbXPZpTh2TI9heTknIJeqFSRX+MNnA3YtoDhYhiMyCBFD0IAH3tv
	 qDTpeSEEixXkQhqL9MJhsJkxS6H53254yCbNtupppCU6M/Ck+bMxYcr1qyMsoVH/yQ
	 iZmhed0DaekB91ZJuIHJS+bfCYdeNOMcIJ6k5+nw=
Date: Thu, 19 Feb 2026 19:06:15 -0800
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-unused-target-param-of-get_scheme_score.patch added to mm-new branch
Message-Id: <20260220030616.3ED5BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove unused target param of get_scheme_score()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-remove-unused-target-param-of-get_scheme_score.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-unused-target-param-of-get_scheme_score.patch

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
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: mm/damon: remove unused target param of get_scheme_score()
Date: Fri, 13 Feb 2026 14:50:32 +0000

damon_target is not used by get_scheme_score operations, nor with virtual
neither with physical addresses.

Link: https://lkml.kernel.org/r/20260213145032.1740407-1-gutierrez.asier@huawei-partners.com
Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +--
 mm/damon/core.c       |   10 +++++-----
 mm/damon/paddr.c      |    3 +--
 mm/damon/vaddr.c      |    3 +--
 4 files changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-unused-target-param-of-get_scheme_score
+++ a/include/linux/damon.h
@@ -647,8 +647,7 @@ struct damon_operations {
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
-			struct damon_target *t, struct damon_region *r,
-			struct damos *scheme);
+			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme, unsigned long *sz_filter_passed);
--- a/mm/damon/core.c~mm-damon-remove-unused-target-param-of-get_scheme_score
+++ a/mm/damon/core.c
@@ -1682,15 +1682,15 @@ static bool __damos_valid_target(struct
 		r->age <= s->pattern.max_age_region;
 }
 
-static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
-		struct damon_region *r, struct damos *s)
+static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
+		struct damos *s)
 {
 	bool ret = __damos_valid_target(r, s);
 
 	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
 		return ret;
 
-	return c->ops.get_scheme_score(c, t, r, s) >= s->quota.min_score;
+	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
 }
 
 /*
@@ -2014,7 +2014,7 @@ static void damon_do_apply_schemes(struc
 				s->max_nr_snapshots <= s->stat.nr_snapshots)
 			continue;
 
-		if (damos_valid_target(c, t, r, s))
+		if (damos_valid_target(c, r, s))
 			damos_apply_scheme(c, t, r, s);
 
 		if (damon_is_last_region(r, t))
@@ -2312,7 +2312,7 @@ static void damos_adjust_quota(struct da
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
-			score = c->ops.get_scheme_score(c, t, r, s);
+			score = c->ops.get_scheme_score(c, r, s);
 			c->regions_score_histogram[score] +=
 				damon_sz_region(r);
 			if (score > max_score)
--- a/mm/damon/paddr.c~mm-damon-remove-unused-target-param-of-get_scheme_score
+++ a/mm/damon/paddr.c
@@ -343,8 +343,7 @@ static unsigned long damon_pa_apply_sche
 }
 
 static int damon_pa_scheme_score(struct damon_ctx *context,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damon_region *r, struct damos *scheme)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
--- a/mm/damon/vaddr.c~mm-damon-remove-unused-target-param-of-get_scheme_score
+++ a/mm/damon/vaddr.c
@@ -986,8 +986,7 @@ static unsigned long damon_va_apply_sche
 }
 
 static int damon_va_scheme_score(struct damon_ctx *context,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damon_region *r, struct damos *scheme)
 {
 
 	switch (scheme->action) {
_

Patches currently in -mm which might be from gutierrez.asier@huawei-partners.com are

mm-damon-remove-unused-target-param-of-get_scheme_score.patch

