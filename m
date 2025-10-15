Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD971C5486;
	Wed, 15 Oct 2025 03:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760498133; cv=none; b=mMGzORso8dUEcDkL6JJLKuZv1bvNCO/QhyPkGDCqmrPQjNeBasa+scwEal28Rc89L0OWFp5+tAcIOt/VM8tDHOHHRzYfqIaZiFRif7Bh9Y8dlILMYLBdUSFUN9+PP0F5T+dDSGkdd3Ntl2KvBUajX6dN8Sdm82FwQteid/O0K7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760498133; c=relaxed/simple;
	bh=IsOxIS9gYx730NsBmxrfiRYjvGrgVeg3WVpm/P6Kafw=;
	h=Date:To:From:Subject:Message-Id; b=da+xoOI6yspZNoeRwIgperXsdmO0HixQMKJE9lNqEtGAVWQO2NMJIMkRlcHxqhI9/6ozR8jaehsPh5bHQo7lLmnAA53TtV+aDbQVzG56HETS3ewie5AOqu0gtJooTpzPYRhHiI4bC/yMGoAJAJMb2XGVwv1LEXuhO5qRXMECcKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/Rd/q/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/Rd/q/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A2FC4CEE7;
	Wed, 15 Oct 2025 03:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760498131;
	bh=IsOxIS9gYx730NsBmxrfiRYjvGrgVeg3WVpm/P6Kafw=;
	h=Date:To:From:Subject:From;
	b=D/Rd/q/j9EiSPaEAmBclAoHFhOUqomge5Zv2HhtwdzX1SlZnHvWyojOqaQOA9HRGg
	 ko/VK5pvMJSqJAPxDAl8iZ21Ui3IifbbFDCMC1Vf6zsgDYJWd9BlbYrexC6ZQAAvMe
	 K8PeshQu0f3263RPb1xeHuXGu/36shBwVFI2z8pI=
Date: Tue, 14 Oct 2025 20:15:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch added to mm-hotfixes-unstable branch
Message-Id: <20251015031531.98A2FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: use damos_commit_quota_goal() for new goal commit
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch

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
Subject: mm/damon/core: use damos_commit_quota_goal() for new goal commit
Date: Mon, 13 Oct 2025 17:18:44 -0700

When damos_commit_quota_goals() is called for adding new DAMOS quota goals
of DAMOS_QUOTA_USER_INPUT metric, current_value fields of the new goals
should be also set as requested.

However, damos_commit_quota_goals() is not updating the field for the
case, since it is setting only metrics and target values using
damos_new_quota_goal(), and metric-optional union fields using
damos_commit_quota_goal_union().  As a result, users could see the first
current_value parameter that committed online with a new quota goal is
ignored.  Users are assumed to commit the current_value for
DAMOS_QUOTA_USER_INPUT quota goals, since it is being used as a feedback. 
Hence the real impact would be subtle.  That said, this is obviously not
intended behavior.

Fix the issue by using damos_commit_quota_goal() which sets all quota goal
parameters, instead of damos_commit_quota_goal_union(), which sets only
the union fields.

Link: https://lkml.kernel.org/r/20251014001846.279282-1-sj@kernel.org
Fixes: 1aef9df0ee90 ("mm/damon/core: commit damos_quota_goal->nid")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit
+++ a/mm/damon/core.c
@@ -835,7 +835,7 @@ int damos_commit_quota_goals(struct damo
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
-		damos_commit_quota_goal_union(new_goal, src_goal);
+		damos_commit_quota_goal(new_goal, src_goal);
 		damos_add_quota_goal(dst, new_goal);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch
mm-damon-sysfs-dealloc-commit-test-ctx-always.patch
mm-damon-core-fix-list_add_tail-call-on-damon_call.patch
mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch
mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

