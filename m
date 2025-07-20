Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E499E1553AA
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976944; cv=none; b=euiXCBGnXAQyWVNQPERSgofrQ2Mk5+lQt66iIVvXzqoKHhko7i8z1GGpnb9FvpR1De3ANa/x4fESEEceMnutUgd9QdjPgKGD7KFiHJeF1Rqc0TzE9V2L4aEPsPliEDmEj9q6OkD3B1mqcFgjZr2PPAdT6EN3S2SRctN3juEP0+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976944; c=relaxed/simple;
	bh=iM5HNmSKuKZCvy2kNjB7Kpf5NjFY73KsaZbIV/Ki44Y=;
	h=Date:To:From:Subject:Message-Id; b=DY6wogfZiZ32Q0Nja8PiSr/AjKQk7o/cXm0w/uednAT5AF3ErPCPvTV/ZK9g+v50hxN8q36UKyw4TjAndnlCE4UDmRgIIPyx8fWPVYIGLI1SQvHBc4RWXxhsWlY3G2MDdsc4LpABEJTBpmv698LkLQHlIgaxJZWTL5eogq3mIE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j8li300p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j8li300p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FCEC4CEE3;
	Sun, 20 Jul 2025 02:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976943;
	bh=iM5HNmSKuKZCvy2kNjB7Kpf5NjFY73KsaZbIV/Ki44Y=;
	h=Date:To:From:Subject:From;
	b=j8li300pkZ7/734ztiL5nxl8TTAX7AM/9RjrAS04UYQrk9dni8aDTmKV2lcdHesad
	 2L8kB8QucQFGenHEiKBQFWHUnf/aL6zDj6INFEmprQ2JFlyAghgIjmujBQ0B0ykZKX
	 f2lzL9Ut1VgHBCzEEE97urg6QCXb58uaWJkm82Ns=
Date: Sat, 19 Jul 2025 19:02:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch removed from -mm tree
Message-Id: <20250720020223.B9FCEC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: destroy targets when kdamond_fn() finish
has been removed from the -mm tree.  Its filename was
     mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: destroy targets when kdamond_fn() finish
Date: Sat, 12 Jul 2025 12:50:14 -0700

When kdamond_fn() completes, the targets are kept.  Those are kept to let
callers do additional cleanups if they need.  There are no such additional
cleanups though.  DAMON sysfs interface deallocates those in
before_terminate() callback, to reduce unnecessary memory usage, for
[f]vaddr use case.  Just destroy the targets for every case in the core
layer.  This saves more memory and simplifies the logic.

Link: https://lkml.kernel.org/r/20250712195016.151108-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-destroy-targets-when-kdamond_fn-finish
+++ a/mm/damon/core.c
@@ -2657,6 +2657,7 @@ done:
 		running_exclusive_ctxs = false;
 	mutex_unlock(&damon_lock);
 
+	damon_destroy_targets(ctx);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

