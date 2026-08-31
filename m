Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C207E3E7621
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218362; cv=none; b=O0XwF8fnzZnACrzixuLWrKfVUC+DUhGAmW8y3rhyyVZx5qnUZ1GjyjlRp29wc5Z3WO14dugjApqQgbX2NbrZkKgiB2U0D7LhXl8d2Kp1henr6lQjIVkmi+lMjtJBv1oWYRW8h2NhLLrR9qjb9zA31eYNAIFIpSPWUMF2mPG+mxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218362; c=relaxed/simple;
	bh=2IKOxzpxH8l7gFFej+kLOMRVzmlxy27tQSRfC76f2fM=;
	h=Date:To:From:Subject:Message-Id; b=jh6YQRNGPyueBiYaBgv7KsLa6RHTIzOh0TKq+uhga2K12rMzqZIQPStPsXCWnFRiMm30naidxU6i9Ca695ntkqYIJUVoEwLFM+SsesJms11t5212po2VMMQIHsPdbcRTwFYfB+eThOalx9fLHH6mYVzuC0OrdH3QUPf+hjF1bZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1062h3vR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1062h3vR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531DF1F000E9;
	Mon, 31 Aug 2026 23:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218361;
	bh=6soLGRnxNPVJh3mCqCVRqXMhPRTwjvi3I5rIDNE0KKg=;
	h=Date:To:From:Subject;
	b=1062h3vRmbMG4AFThtz4X7lTjPKmN897F1RKzOtarVxkOPIE09LzG5JWfJk8hu6UT
	 0tkaLFskttJLE4OvyiD2lNb0rAJbok0n3TXEPvYQ0T7Oekx45nLaGvKkX3s9ztz+Sa
	 AfGxO1pZSROnkeU/VeqKgslPBPSEVjhfPGOq0uLA=
Date: Mon, 31 Aug 2026 16:19:20 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,hank20010209@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-unused-damon_nr_running_ctxs.patch added to mm-new branch
Message-Id: <20260831231921.531DF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove unused damon_nr_running_ctxs()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-unused-damon_nr_running_ctxs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-unused-damon_nr_running_ctxs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Cheng-Han Wu <hank20010209@gmail.com>
Subject: mm/damon/core: remove unused damon_nr_running_ctxs()
Date: Mon, 31 Aug 2026 07:57:22 -0700

damon_nr_running_ctxs() has had no in-tree users since commit 5ec4333b1967
("mm/damon: remove DAMON debugfs interface") removed all of its callers.

Remove the unused declaration and definition.

Link: https://lore.kernel.org/20260831145724.82387-3-sj@kernel.org
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 -
 mm/damon/core.c       |   14 --------------
 2 files changed, 15 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-unused-damon_nr_running_ctxs
+++ a/include/linux/damon.h
@@ -1065,7 +1065,6 @@ int damon_set_attrs(struct damon_ctx *ct
 void damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
 int damon_commit_ctx(struct damon_ctx *old_ctx, struct damon_ctx *new_ctx);
-int damon_nr_running_ctxs(void);
 bool damon_is_registered_ops(enum damon_ops_id id);
 int damon_register_ops(struct damon_operations *ops);
 int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
--- a/mm/damon/core.c~mm-damon-core-remove-unused-damon_nr_running_ctxs
+++ a/mm/damon/core.c
@@ -1847,20 +1847,6 @@ out:
 	return err;
 }
 
-/**
- * damon_nr_running_ctxs() - Return number of currently running contexts.
- */
-int damon_nr_running_ctxs(void)
-{
-	int nr_ctxs;
-
-	mutex_lock(&damon_lock);
-	nr_ctxs = nr_running_ctxs;
-	mutex_unlock(&damon_lock);
-
-	return nr_ctxs;
-}
-
 /* Returns the size upper limit for each monitoring region */
 static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 {
_

Patches currently in -mm which might be from hank20010209@gmail.com are

mm-damon-core-remove-unused-damon_targets_empty.patch
mm-damon-core-remove-unused-damon_nr_running_ctxs.patch

