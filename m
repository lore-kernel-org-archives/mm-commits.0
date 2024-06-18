Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266D8158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739406; cv=none; b=SRdDdj1o61VUZ71JVkgHH3+A7ICAxXvF2SmHELrDrF8mVAf+g8n5UdzeUP/1Snduau4ZZWWidn/lZo8EoQV1uDIzouDaqyYJa/nc1M2l7OfU09pkRlONmgyh9RB4Wh0cYTAIZAQfNDJjohsWAKK13+08K5LWgW3n5v16DoslYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739406; c=relaxed/simple;
	bh=sIpHl1lUTMpAZu0MuBiVWqhVXFaxyvfdACJS2fqpdCE=;
	h=Date:To:From:Subject:Message-Id; b=n/4XrhdRR1j6hA5mr1c2lsTuBw+LTgJkGeqIGk+wCTBOLDGHo5GCBy4F8Ynj9lxGTYvfjjspDZ8WriLLzuHY116EiqMPRs98qu3JXu6M/XQY5Yr9q0Ib5tLBVRio2rJnNzWRgwaBIOEhurJWvaD2ZYdUhkX75PuYaBy4t6kBICE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l/UOvl9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l/UOvl9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0854C3277B;
	Tue, 18 Jun 2024 19:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739406;
	bh=sIpHl1lUTMpAZu0MuBiVWqhVXFaxyvfdACJS2fqpdCE=;
	h=Date:To:From:Subject:From;
	b=l/UOvl9FU8zoEQZ+BkaGNRcEpR7lW/Dv5+Mc4AkW+yGYDoG6v3TBroMJmb0YKNrDQ
	 Bj7gWLZ/5jHLZD3QxSAZGk75u3m/jqfIjNRmCWrtMqssP2enyCJYSbt79vsy5i2PHC
	 ayOI2s8mDIy9W05KREB7hoadkIjp6KTmisYxfv7M=
Date: Tue, 18 Jun 2024 12:36:45 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch added to mm-unstable branch
Message-Id: <20240618193645.F0854C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: remove unnecessary code for online tuning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: remove unnecessary code for online tuning
Date: Tue, 18 Jun 2024 11:18:07 -0700

DAMON_RECLAIM contains code for handling of online DAMON parameters update
edge cases.  It is no more necessary since damon_commit_ctx() takes care
of the cases.  Remove the unnecessary code.

Link: https://lkml.kernel.org/r/20240618181809.82078-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-remove-unnecessary-code-for-online-tuning
+++ a/mm/damon/reclaim.c
@@ -181,23 +181,11 @@ static struct damos *damon_reclaim_new_s
 			NUMA_NO_NODE);
 }
 
-static void damon_reclaim_copy_quota_status(struct damos_quota *dst,
-		struct damos_quota *src)
-{
-	dst->total_charged_sz = src->total_charged_sz;
-	dst->total_charged_ns = src->total_charged_ns;
-	dst->charged_sz = src->charged_sz;
-	dst->charged_from = src->charged_from;
-	dst->charge_target_from = src->charge_target_from;
-	dst->charge_addr_from = src->charge_addr_from;
-	dst->esz_bp = src->esz_bp;
-}
-
 static int damon_reclaim_apply_parameters(void)
 {
 	struct damon_ctx *param_ctx;
 	struct damon_target *param_target;
-	struct damos *scheme, *old_scheme;
+	struct damos *scheme;
 	struct damos_quota_goal *goal;
 	struct damos_filter *filter;
 	int err;
@@ -214,11 +202,6 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		goto out;
-	if (!list_empty(&ctx->schemes)) {
-		damon_for_each_scheme(old_scheme, ctx)
-			damon_reclaim_copy_quota_status(&scheme->quota,
-					&old_scheme->quota);
-	}
 	damon_set_schemes(ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch

