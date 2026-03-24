Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A9534C989
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388559; cv=none; b=Hb1jbimEKXBlB3D/2c4mUGH+Qnefzb2ffSwAaOag4UjjiZISscUpU/Vcdco5xfPfgVNtpycpubzfSxiUNpIbhmAUszD3sSN+zgTTIQeav7Y/5plU4luyK48zp4znS1Rq0LnKhzxnRxHQErVDNoBrVk2AfAD0isutU0acuk9rZXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388559; c=relaxed/simple;
	bh=jgrwkNJVCqLDyP4AhqVwjLHQTa/UM4JdfkZtCqyEHBI=;
	h=Date:To:From:Subject:Message-Id; b=KDGfwVeaexmXJC2pnclQmEf3dMGMU9lQL8YvAu2hGouEEOz+uIGMGWBQVq1RH3gWggy7ub1TEMxuwMArsL+AI4/huDHVbohIHXFTNjAw8D+f/wcYHWZS+MnnKwEcaKNlpOZk64eBRbemNtC0E/P3nvYwXtIiFy1C/1MunMM/lpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LadJVJGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LadJVJGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC29C19424;
	Tue, 24 Mar 2026 21:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388559;
	bh=jgrwkNJVCqLDyP4AhqVwjLHQTa/UM4JdfkZtCqyEHBI=;
	h=Date:To:From:Subject:From;
	b=LadJVJGincnfAqCAAoZQJYKyweHr4na6TAMi4CcTfZXchFkosA0T+V9A/zgyw5aNF
	 kxoOrMfu0cALABD17AiyEBReSd4VAC7vQrVTBPmhSYTwKIUgnn2wmTlZPf6K9IXkBb
	 UhyXDAMdGTU3+fL43xmu3peR4tPoN/MSHdwUornc=
Date: Tue, 24 Mar 2026 14:42:38 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-unused-target-param-of-get_scheme_score.patch removed from -mm tree
Message-Id: <20260324214239.7AC29C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove unused target param of get_scheme_score()
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-unused-target-param-of-get_scheme_score.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1689,15 +1689,15 @@ static bool __damos_valid_target(struct
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
@@ -2021,7 +2021,7 @@ static void damon_do_apply_schemes(struc
 				s->max_nr_snapshots <= s->stat.nr_snapshots)
 			continue;
 
-		if (damos_valid_target(c, t, r, s))
+		if (damos_valid_target(c, r, s))
 			damos_apply_scheme(c, t, r, s);
 
 		if (damon_is_last_region(r, t))
@@ -2319,7 +2319,7 @@ static void damos_adjust_quota(struct da
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
@@ -985,8 +985,7 @@ static unsigned long damon_va_apply_sche
 }
 
 static int damon_va_scheme_score(struct damon_ctx *context,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damon_region *r, struct damos *scheme)
 {
 
 	switch (scheme->action) {
_

Patches currently in -mm which might be from gutierrez.asier@huawei-partners.com are

docs-mm-damon-design-document-damon-actions-when-transparent_hugepage-is-off.patch

