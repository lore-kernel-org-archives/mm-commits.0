Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A957C21B905
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744825; cv=none; b=alrrbgUI+TEK2Aztf+Pj8CX0o6FjBZOXRK9pb9lDBj8qnmf/bjp3S0W9bJW9WlMGUvmsbNxXgMIIb1c5uYQJuIFsEhiV3AWebQf38nRgN7l+QXwmlyZHk34CMpHkX+MlWfB1HomY55CcdlJYDUl/ULvxsr++rCMXnPFChf4IpzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744825; c=relaxed/simple;
	bh=8L8wpnaPzqctG3QorOYj26KNwdZm3jh2r2fXKAqB71o=;
	h=Date:To:From:Subject:Message-Id; b=r9cuW5zLg+FmYA04CX+MbSV2rJpRxMvqBiPE9rSUIuK2c0ZR3YIFnJLL/vBXf80iIXeytwz/SnHgbaNI2pojPN2u46CKoL+WlnmsbquDZotQAYEuzbjDUh3or08Wk7hWuQak/5ulUklpJVkHbEUl8Lt5ts6mOSiiGl14kQJ0+MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r39c6xdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r39c6xdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BD3C2BC9E;
	Sun, 29 Mar 2026 00:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744825;
	bh=8L8wpnaPzqctG3QorOYj26KNwdZm3jh2r2fXKAqB71o=;
	h=Date:To:From:Subject:From;
	b=r39c6xdJtYb/AmwcDKP4xn1DpLLaRHSYYFWM+jdTOuzPgEXryhfUBhLWw3PIX4F0f
	 shSloinkmHdq4hjZJQQ4LEXLxAulOGmP6kn0IjugcZXmdyPwzM+NEBp56aO6Ynpao/
	 CoGpfwjLHxQNah8urSluQckmsQXc/VbPgh/hfEtU=
Date: Sat, 28 Mar 2026 17:40:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch removed from -mm tree
Message-Id: <20260329004025.80BD3C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damon_reset_aggregated() debug_sanity check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damon_reset_aggregated() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:11 -0800

At time of damon_reset_aggregated(), aggregation of the interval should be
completed, and hence nr_accesses and nr_accesses_bp should match.  I found
a few bugs caused it to be broken in the past, from online parameters
update and complicated nr_accesses handling changes.  Add a sanity check
for that under CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_reset_aggregated-debug_sanity-check
+++ a/mm/damon/core.c
@@ -1668,6 +1668,23 @@ static void damon_warn_fix_nr_accesses_c
 	r->nr_accesses_bp = r->nr_accesses * 10000;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_reset_aggregated(struct damon_region *r,
+		struct damon_ctx *c)
+{
+	WARN_ONCE(r->nr_accesses_bp != r->last_nr_accesses * 10000,
+			"nr_accesses_bp %u last_nr_accesses %u sis %lu %lu\n",
+			r->nr_accesses_bp, r->last_nr_accesses,
+			c->passed_sample_intervals, c->next_aggregation_sis);
+}
+#else
+static void damon_verify_reset_aggregated(struct damon_region *r,
+		struct damon_ctx *c)
+{
+}
+#endif
+
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -1684,6 +1701,7 @@ static void kdamond_reset_aggregated(str
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

