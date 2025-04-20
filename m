Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6536A101E6
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745180735; cv=none; b=sZN9eHs0LQme2t0pUyh+QOYITWXb/YEt7v6WEJ/4RwcJgjXC79dvzT6EzMsCinkrnTSx47jvLXrG+D+gj1nCDzZIjppU4Og4fsZYrrXN12ymq6AcKixSJTMRTSvCOI6PV0ro8+pE2KDTXojB7Ag1wPnW4GRI1GxuKxUOZdlZ4p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745180735; c=relaxed/simple;
	bh=gJjd4RChVIdD7RRYHa5SlqhHjkd62TV4uGzWQu+wvM0=;
	h=Date:To:From:Subject:Message-Id; b=GB3aLmoormbfr/DaFrZJCEi6pWIIUVQ4hw1frpyXODKApd5+CtzX97ARp20CA+koO9PcrxHbRB4vfBmdcRFB6U3WXF38ly69YRDE0ic2QNAZIyJ9oo7IRjgxAxlxj8kaOwQg0z+QeC9Qcd5Yyf3zOv5zO1JyeMrnGkdYGKiiI4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M2jbC71z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M2jbC71z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B962DC4CEE2;
	Sun, 20 Apr 2025 20:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745180734;
	bh=gJjd4RChVIdD7RRYHa5SlqhHjkd62TV4uGzWQu+wvM0=;
	h=Date:To:From:Subject:From;
	b=M2jbC71zNnyJbItAvoBA775Oem6zAP4g42EQleRcOZHKMDLRw8EPc9nwj4lZBZrez
	 ziSXIzWUoJqvl/LuBRprJKW+vSZdoIfc6L/HSPkfaQ0CL+TOxzIGhKjwuXt0eFt6KU
	 xBgOJ2nnlTB3np43DwmcV/EaRJ+kjl8ng88UUP94=
Date: Sun, 20 Apr 2025 13:25:34 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch added to mm-unstable branch
Message-Id: <20250420202534.B962DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch

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
Subject: mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer
Date: Sun, 20 Apr 2025 12:40:26 -0700

DAMON sysfs interface file for DAMOS quota goal's node id argument is not
passed to core layer.  Implement the link.

Link: https://lkml.kernel.org/r/20250420194030.75838-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer
+++ a/mm/damon/sysfs-schemes.c
@@ -2149,8 +2149,17 @@ static int damos_sysfs_add_quota_score(
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
-		if (sysfs_goal->metric == DAMOS_QUOTA_USER_INPUT)
+		switch (sysfs_goal->metric) {
+		case DAMOS_QUOTA_USER_INPUT:
 			goal->current_value = sysfs_goal->current_value;
+			break;
+		case DAMOS_QUOTA_NODE_MEM_USED_BP:
+		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
+			goal->nid = sysfs_goal->nid;
+			break;
+		default:
+			break;
+		}
 		damos_add_quota_goal(quota, goal);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch
mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

