Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63F61A01D5;
	Mon, 24 Jun 2024 21:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719263210; cv=none; b=sfrIpelZvW5PszP2a0WEYWpaRfkDuiOx9os2WIFO8WlFGEwArFtAoENmwaGwRAK+4WXEw48oB8OUqdfWE1rcd8QvrCiIz4Z5klALCv6twkYrWXz6j1NaJXYDOS0ioeCB7vBm3im0AZb0QACNErK0ZX76xMhO9vUAzMbAnGDag+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719263210; c=relaxed/simple;
	bh=qFCl1m+Ukig7YDSG9NpL30WnhP/UQ1NV50UgaCsieM0=;
	h=Date:To:From:Subject:Message-Id; b=FtmlHYoqpACXfYSzNE+v1abIMORkh7HR8Igspi+tK723QhWtdK0z5jY+rVbeMe+n4rDDDOo0Fs0NdU+KPzJ3/v1+hnGl2EWTILqmy7oKnKG9WVEnEBSm81iDnfkrEZDjcAVGnhrdZgZMpz3x1WhlbannmIKbXBZBdHc3tT0+Q/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o/3NUwoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o/3NUwoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53960C2BBFC;
	Mon, 24 Jun 2024 21:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719263210;
	bh=qFCl1m+Ukig7YDSG9NpL30WnhP/UQ1NV50UgaCsieM0=;
	h=Date:To:From:Subject:From;
	b=o/3NUwoDFCFl5RG9/3e9iS1LcBRhUkwTdDZU/x0T6Yq6a5ydKKvc8fr1L2h4SuJSo
	 2gvdJcEaDzzkRS5oM5k6XijI1gCl6wOJbzMB48lLg95xU44vJUNPfpJ1YBLxvjF7rc
	 TiZhDMZ/G7p1yXfQBowbPxqSiceSd2GiahBkvaWw=
Date: Mon, 24 Jun 2024 14:06:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch added to mm-hotfixes-unstable branch
Message-Id: <20240624210650.53960C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: merge regions aggressively when max_nr_regions is unmet
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/core: merge regions aggressively when max_nr_regions is unmet
Date: Mon, 24 Jun 2024 10:58:14 -0700

DAMON keeps the number of regions under max_nr_regions by skipping regions
split operations when doing so can make the number higher than the limit. 
It works well for preventing violation of the limit.  But, if somehow the
violation happens, it cannot recovery well depending on the situation.  In
detail, if the real number of regions having different access pattern is
higher than the limit, the mechanism cannot reduce the number below the
limit.  In such a case, the system could suffer from high monitoring
overhead of DAMON.

The violation can actually happen.  For an example, the user could reduce
max_nr_regions while DAMON is running, to be lower than the current number
of regions.  Fix the problem by repeating the merge operations with
increasing aggressiveness in kdamond_merge_regions() for the case, until
the limit is met.

Link: https://lkml.kernel.org/r/20240624175814.89611-1-sj@kernel.org
Fixes: b9a6ac4e4ede ("mm/damon: adaptively adjust regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet
+++ a/mm/damon/core.c
@@ -1358,14 +1358,30 @@ static void damon_merge_regions_of(struc
  * access frequencies are similar.  This is for minimizing the monitoring
  * overhead under the dynamically changeable access pattern.  If a merge was
  * unnecessarily made, later 'kdamond_split_regions()' will revert it.
+ *
+ * The total number of regions could be temporarily higher than the
+ * user-defined limit, max_nr_regions for some cases.  For an example, the user
+ * updates max_nr_regions to a number that lower than the current number of
+ * regions while DAMON is running.  Depending on the access pattern, it could
+ * take indefinitve time to reduce the number below the limit.  For such a
+ * case, repeat merging until the limit is met while increasing @threshold and
+ * @sz_limit.
  */
 static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 				  unsigned long sz_limit)
 {
 	struct damon_target *t;
+	unsigned int nr_regions;
 
-	damon_for_each_target(t, c)
-		damon_merge_regions_of(t, threshold, sz_limit);
+	do {
+		nr_regions = 0;
+		damon_for_each_target(t, c) {
+			damon_merge_regions_of(t, threshold, sz_limit);
+			nr_regions += damon_nr_regions(t);
+		}
+		threshold = max(1, threshold * 2);
+		sz_limit = max(1, sz_limit * 2);
+	} while (nr_regions > c->attrs.max_nr_regions);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch
docs-damon-document-damos_migrate_hotcold-fix.patch
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
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

