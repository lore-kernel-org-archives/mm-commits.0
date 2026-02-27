Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D485C38B7C1
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 20:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772224048; cv=none; b=t40KD0siH856IWb7F0kqc5Z0xPzkfjYXmXsYyGvGgpY/oimfOMbpYfjMs0xv0wGlgOLEAExi7FiYDBMu+OznEe7YBwmLyVsOOoJQ176U/4cZVCQFC961Bt7RkV3oHdvPOESsGlwl6i2BZxzuDmAD8FmhoAYV5yySt/Seu9FL29I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772224048; c=relaxed/simple;
	bh=DTGNFE21xKw0ScuW6Y+H/HGGG3FVIvNRFb1NAnU2zbM=;
	h=Date:To:From:Subject:Message-Id; b=NxpLjjHgIS23MJxaS4ix6dgP1r8LNMm+ZBDb97hQV54CxVWrM5VzXM/CkJ0KZ1IeMAm7xB2X1JdPPbWRoi9/DjjOkvQBCvedWh8lsP6XM0e+91JxIjG7na+9NsoGHe8cqGiMOFuSa5o7jJeD0pEoEFojQkCGXQDSvQHpQX3bk10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ovR1soxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ovR1soxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8B4C116C6;
	Fri, 27 Feb 2026 20:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772224048;
	bh=DTGNFE21xKw0ScuW6Y+H/HGGG3FVIvNRFb1NAnU2zbM=;
	h=Date:To:From:Subject:From;
	b=ovR1soxAHsBej/FOBYulB0hkeb8plHgAzvm4udRMemCCH0lxpqO31Zerxcs/NrFLM
	 3Hkt3jPZ0L2Nax+4P4YfmHOfiHva703V9YTJA7uW2LuaQdw3Pdmosfc/DXl37z791f
	 verF7H7Ie+m8b5AkMoC/Tlsf9vrYH/q5ihLUy2WY=
Date: Fri, 27 Feb 2026 12:27:28 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch added to mm-new branch
Message-Id: <20260227202728.8C8B4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
Date: Fri, 27 Feb 2026 09:06:21 -0800

kdamond_apply_schemes() is using damon_for_each_region_safe(), which is
safe for deallocation of the region inside the loop.  However, the loop
internal logic does not deallocate regions.  Hence it is only wasting the
next pointer.  Also, it causes a problem.

When an address filter is applied, and there is a region that intersects
with the filter, the filter splits the region on the filter boundary.  The
intention is to let DAMOS apply action to only filtered-in address ranges.
However, it is using damon_for_each_region_safe(), which sets the next
region before the execution of the iteration.  Hence, the region that
split and now will be next to the previous region, is simply ignored.  As
a result, DAMOS applies the action to target regions bit slower than
expected, when the address filter is used.  Shouldn't be a big problem but
definitely better to be fixed.  damos_skip_charged_region() was working
around the issue using a double pointer hack.

Use damon_for_each_region(), which is safe for this use case.  And drop
the work around in damos_skip_charged_region().

Link: https://lkml.kernel.org/r/20260227170623.95384-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes
+++ a/mm/damon/core.c
@@ -1715,17 +1715,18 @@ static bool damos_valid_target(struct da
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow and saves the second
- * region in *rp and returns false, so that the caller can apply DAMON action
- * to the second one.
+ * area that not charged in the previous charge widnow, and return true.  The
+ * caller can see the second one on the next iteration of the region walk.
+ * Note that this means the caller should use damon_for_each_region() instead
+ * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
+ * the second region will just be ignored.
  *
- * Return: true if the region should be entirely skipped, false otherwise.
+ * Return: true if the region should be skipped, false otherwise.
  */
 static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region **rp, struct damos *s,
+		struct damon_region *r, struct damos *s,
 		unsigned long min_region_sz)
 {
-	struct damon_region *r = *rp;
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
 
@@ -1752,8 +1753,7 @@ static bool damos_skip_charged_region(st
 				sz_to_skip = min_region_sz;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			r = damon_next_region(r);
-			*rp = r;
+			return true;
 		}
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
@@ -2012,7 +2012,7 @@ static void damon_do_apply_schemes(struc
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		if (damos_skip_charged_region(t, &r, s, c->min_region_sz))
+		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -2355,7 +2355,7 @@ static void damos_trace_stat(struct damo
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r, *next_r;
+	struct damon_region *r;
 	struct damos *s;
 	unsigned long sample_interval = c->attrs.sample_interval ?
 		c->attrs.sample_interval : 1;
@@ -2381,7 +2381,7 @@ static void kdamond_apply_schemes(struct
 		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
 
-		damon_for_each_region_safe(r, next_r, t)
+		damon_for_each_region(r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch

