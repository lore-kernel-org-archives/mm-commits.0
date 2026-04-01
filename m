Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF5337E317;
	Wed,  1 Apr 2026 03:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775014585; cv=none; b=h5KHAi4p8YCn76Guzx5Ibhg2lXgeCYD7H8Zb7ELNMQGUEFm+l+YgwaDqZiik+CKvzQY7ADbsYxtkit5XLyQaf0Y7VG4QFbQL/NcU+ZfUfQ47VV5sFFjs8LDWlxHhrPVoARc49qYLwGju0tvAx3LkLYkVSfLictlvDBaVfkyn8sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775014585; c=relaxed/simple;
	bh=xqcgULTzfzyjxVvlL2LFRENO/FlO1kKGjbHJgUP8/2w=;
	h=Date:To:From:Subject:Message-Id; b=ifq69sq0HZkAbRTTWkdLriijO4cdimtJlhEoet4iBCL3bunP/eu6Sw4DXPpG7PaZ3UQeMO2za/dqBWwvoUOXbLlYdPHc+sKyF4YDrdAMtRISavlsuOVBbQsCnnnIFILVL8eilkBYLzAeCRDoVzQ3dQgt3oBiufnJwp6cCqPvHA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r/yfbhYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r/yfbhYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78374C4CEF7;
	Wed,  1 Apr 2026 03:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775014584;
	bh=xqcgULTzfzyjxVvlL2LFRENO/FlO1kKGjbHJgUP8/2w=;
	h=Date:To:From:Subject:From;
	b=r/yfbhYLJCoGsg3GPbNq+1DlPCz9mYGLv726kf9WjCITmwLnbS18COJaYUDl+Ih+H
	 VKXPLFDJ5M1szjy1ADfKBToXqncxJGgubMTwZLs5iQn7huysdUTRboHJyGUnq9kXI1
	 6mswOeiTXGpVtEyZKNEprQVvZE9HqGP2F9UIVVZg=
Date: Tue, 31 Mar 2026 20:36:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch added to mm-hotfixes-unstable branch
Message-Id: <20260401033624.78374C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:30:50 -0700

DAMON_LRU_SORT handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered in [1] by sashiko.

Link: https://lkml.kernel.org/r/20260329153052.46657-3-sj@kernel.org
Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [1]
Fixes: 6acfcd0d7524 ("Docs/admin-guide/damon: add a document for DAMON_LRU_SORT")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,10 @@ of parametrs except ``enabled`` again.
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
 active_mem_bp
 -------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_mem_usedfree_bp.patch
mm-damon-core-validate-damos_quota_goal-nid-for-node_memcg_usedfree_bp.patch
mm-damon-core-use-time_in_range_open-for-damos-quota-window-start.patch
docs-admin-guide-mm-damon-reclaim-warn-commit_inputs-vs-param-updates-race.patch
docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

