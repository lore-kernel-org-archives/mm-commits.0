Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B2530D413
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334279; cv=none; b=ObLFawLUk6kFSG04FS8osGjU5ABWlXhv5UboF/5LTPEHA5q2doFgaf7h5vB4V9QDf4V20+eXRevdz8uZZUPPwiSRNOAThuR9jhvr9ByLpxdl2cG8+5I2LVKspwUGh+sqadODwiN4Qh1hQIK+IvIQYKV9laluh9kBWjo+Y4l3aXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334279; c=relaxed/simple;
	bh=SrDO0VVUFNZkk4U3y1RohCMVVttHkG+g6g82ywO/GD0=;
	h=Date:To:From:Subject:Message-Id; b=au4LkZCe6fz8WD5+o4mSJh6WfW85R1qR+f7a0EidY57L5x5Lsg+et+EyTC7Pa+558JSvBPfA1LUKjrsH8s5TFByGKRTL+auR7EC6g7NTi8UkBP635poq7HjrGeRk+EqTvfOltwQdiaN/nhv3Achg8cnDAc9xdWp4NylGzJqQv4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p6FvwtYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p6FvwtYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78161F0089B;
	Wed,  7 Oct 2026 00:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334278;
	bh=r7q/6RPhKO24kNuXBCChjlX+zMXl0oBMUqKUS/dZzmg=;
	h=Date:To:From:Subject;
	b=p6FvwtYt2it8icCLfW1Lun2ATiewXMOLDyN7BoxcB937xaTiZ+jjy8fBMZFd+tQcs
	 z0HlRyhJyJ3xd9TsAucm0Gl8RB5DsQCCEcLo5hf8DJkZ3G1YeYGGoTzVYuKS8oDKPy
	 bfnhFlacY50yng+duf6Axpe8Zh2OYcBu/uh7/Mgg=
Date: Tue, 06 Oct 2026 17:51:18 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,hank20010209@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-unused-damon_targets_empty.patch removed from -mm tree
Message-Id: <20261007005118.B78161F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove unused damon_targets_empty()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-unused-damon_targets_empty.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cheng-Han Wu <hank20010209@gmail.com>
Subject: mm/damon/core: remove unused damon_targets_empty()
Date: Mon, 31 Aug 2026 07:57:21 -0700

Patch series "mm/damon/core: remove unused helper functions", v2.

Both damon_targets_empty() and damon_nr_running_ctxs() have had no in-tree
users since commit 5ec4333b1967 ("mm/damon: remove DAMON debugfs
interface") removed their remaining callers.

Remove the unused declarations and definitions.


This patch (of 2):

damon_targets_empty() has had no in-tree users since commit 5ec4333b1967
("mm/damon: remove DAMON debugfs interface") removed its last caller.

Remove the unused declaration and definition.

Link: https://lore.kernel.org/20260831145724.82387-1-sj@kernel.org
Link: https://lore.kernel.org/20260831145724.82387-2-sj@kernel.org
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
---

 include/linux/damon.h |    1 -
 mm/damon/core.c       |    5 -----
 2 files changed, 6 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-unused-damon_targets_empty
+++ a/include/linux/damon.h
@@ -1055,7 +1055,6 @@ int damos_commit_quota_goals(struct damo
 
 struct damon_target *damon_new_target(void);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
-bool damon_targets_empty(struct damon_ctx *ctx);
 void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
 unsigned int damon_nr_regions(struct damon_target *t);
--- a/mm/damon/core.c~mm-damon-core-remove-unused-damon_targets_empty
+++ a/mm/damon/core.c
@@ -795,11 +795,6 @@ void damon_add_target(struct damon_ctx *
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
 
-bool damon_targets_empty(struct damon_ctx *ctx)
-{
-	return list_empty(&ctx->adaptive_targets);
-}
-
 static void damon_del_target(struct damon_target *t)
 {
 	list_del(&t->list);
_

Patches currently in -mm which might be from hank20010209@gmail.com are


