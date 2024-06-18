Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDEF158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739394; cv=none; b=a7XpnERbkImRdHCxZB3XUsKKiz0/hEp0V1tEiyZUEJmj2+fOHCF6jEKiNuEgag8z/OOQ3Pz7kgrohMQpe12kS966QZtZ7dXL5kG8qzYrqmYqXegzN916h6pCJBvPmTa75ogr4tEvDeBFxbQyfjiqTzUN1lSvqGvK+cSQOtJXNtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739394; c=relaxed/simple;
	bh=0b7CaTkacFgGftCcaPJP2NBdjiQMRC47mu0LQkQO8nE=;
	h=Date:To:From:Subject:Message-Id; b=qaT+ogd4+hDFN+oqmF4HYX0ClZyYA3+aY1zcaaYzyqkNfMkwA7TsltVo1vm1sST4wRxsL3QRPgg5/66aCmrYskXZoaRPDQdZIecZYVYWtmC0VrFUzxb4QYLOjWK3mFGs8cUrbjSIL8PZLa+RZ7Yz5GzbexGM7cCHA3/E/j5Go/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VGrxUg3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VGrxUg3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9F5C3277B;
	Tue, 18 Jun 2024 19:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739393;
	bh=0b7CaTkacFgGftCcaPJP2NBdjiQMRC47mu0LQkQO8nE=;
	h=Date:To:From:Subject:From;
	b=VGrxUg3AW88wup+xfUOGuo+FN6dBbEK4v9yfWFWDcqiJRq6/igX9U99PiRmdST65T
	 w3GEi5iuRVT+JOA6fVwO9Mxv5ChEv3/9d5pbq//SgSM+nRwJcIJJMd2E7gDH46h9Ok
	 /5iY1svBEzV8ZaeXw+fsWDQQYIUYTuadjH4dBZfs=
Date: Tue, 18 Jun 2024 12:36:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch added to mm-unstable branch
Message-Id: <20240618193633.BC9F5C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: use damos_commit_quota_goals()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch

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
Subject: mm/damon/sysfs-schemes: use damos_commit_quota_goals()
Date: Tue, 18 Jun 2024 11:18:01 -0700

DAMON_SYSFS manually manipulates the DAMOS quota structs for online quotal
goals parameter update.  Since the struct contains not only input
parameters but also internal status and operation results, it is not that
simple.  Now DAMON core layer provides a function for the usage, namely
damon_commit_quota_goals().  Replace the manual manipulation logic with
the function.  The core layer function could have its own bugs, but this
change removes a source of bugs.

Link: https://lkml.kernel.org/r/20240618181809.82078-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-use-damos_commit_quota_goals
+++ a/mm/damon/sysfs-schemes.c
@@ -1983,10 +1983,13 @@ int damos_sysfs_set_quota_scores(struct
 		struct damon_ctx *ctx)
 {
 	struct damos *scheme;
+	struct damos_quota quota = {};
 	int i = 0;
 
+	INIT_LIST_HEAD(&quota.goals);
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_scheme *sysfs_scheme;
+		struct damos_quota_goal *g, *g_next;
 		int err;
 
 		/* user could have removed the scheme sysfs dir */
@@ -1995,9 +1998,16 @@ int damos_sysfs_set_quota_scores(struct
 
 		sysfs_scheme = sysfs_schemes->schemes_arr[i];
 		err = damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
-				&scheme->quota);
+				&quota);
+		if (err) {
+			damos_for_each_quota_goal_safe(g, g_next, &quota)
+				damos_destroy_quota_goal(g);
+			return err;
+		}
+		err = damos_commit_quota_goals(&scheme->quota, &quota);
+		damos_for_each_quota_goal_safe(g, g_next, &quota)
+			damos_destroy_quota_goal(g);
 		if (err)
-			/* kdamond will clean up schemes and terminated */
 			return err;
 		i++;
 	}
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

