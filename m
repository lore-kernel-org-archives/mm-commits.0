Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4613B8D50
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439030; cv=none; b=Z1PRkjcObm6KS6Xhhkb3F/aLhBHSb0lE0I4mofVNOmQ/UOV1dWd0D9DHj/stAzmh4T8h+8kMJuUza3EJdYCVER/qNuZUTv63y0+zKN/DRmtXszFiCEuja0CNmH/brzEfwT1MsQ14lGbD8keWvTQsHFiW+iFijvfR28kehzgLATs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439030; c=relaxed/simple;
	bh=ZLFQccCTpks3HdMzSknkV89F8SlbYnDUmlzHbiAut1o=;
	h=Date:To:From:Subject:Message-Id; b=NcdvzfgQ7WmT5lsh3lVRtwRITaSIcud7XD0VweE2hWFCNdavUj7zS+2p2eE3zjF3YL/p5FG0rtimR8kJU8C83R2tq+knqWLmQWGyRlNj5owBl9asDwXyazVncCdpymOTNMOdYcnBXPcSNlDlVaVQEFMQdtWxx/NmJjsS17ILSjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FHs3skGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FHs3skGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DCA1F00898;
	Tue,  2 Jun 2026 22:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439029;
	bh=LUiYoCqk3UhOXbdidUMFgGg8YexrNKdyN2Q0CXQiVjs=;
	h=Date:To:From:Subject;
	b=FHs3skGPs9XgUm68tHNpdvUa+wk9sybreeGEdWQfEeAWYX4eOtojuHs+sIeH40I9h
	 Sf1f9u7MW94EJgylocpOmyhqB56OYuUCJ0PNHY0g28oB3y2DG6OxRocZ8cFecaxJEG
	 Z3eSP/qvxgPgH3CYFDalPQ/0ZLBtQTGLMoouau+s=
Date: Tue, 02 Jun 2026 15:23:48 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-validate-min_region_size-to-be-power-of-2.patch removed from -mm tree
Message-Id: <20260602222349.02DCA1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: validate min_region_size to be power of 2
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-validate-min_region_size-to-be-power-of-2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri, 1 May 2026 09:37:50 +0800

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_RECLAIM,
'min_region_sz' becomes a non-power-of-2 value. While damon_commit_ctx()
correctly detects this and returns -EINVAL, it sets the
'maybe_corrupted' flag during this process.

This flag causes the running kdamond to terminate. While the termination
is a safety measure, it is suboptimal in this case because the error is
just a simple invalid input from the user, which shouldn't neccessitate
stopping the kdamond.

Reproduction
============
1. Enable DAMON_RECLAIM
2. Set addr_unit=3
3. Commit inputs via 'commit_inputs'
4. Observe kdamond termination

Solution
========
Add an early validation in damon_reclaim_apply_parameters() to check
'min_region_sz' before any state change occurs. If it is non-power-of-2,
return -EINVAL immediately, preventing 'maybe_corrupted' from being set.

Link: https://lore.kernel.org/20260501013750.71704-3-aethernet65535@gmail.com
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-validate-min_region_size-to-be-power-of-2
+++ a/mm/damon/reclaim.c
@@ -210,6 +210,11 @@ static int damon_reclaim_apply_parameter
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
_

Patches currently in -mm which might be from aethernet65535@gmail.com are


