Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630F817C3;
	Wed, 13 Dec 2023 01:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FwDQxx1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0837C433C8;
	Wed, 13 Dec 2023 01:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430446;
	bh=m5+dRLdY8iZv9/v6DO+7/k/g4Le28xhlR1GtSEm+RJw=;
	h=Date:To:From:Subject:From;
	b=FwDQxx1DFV2HR1PTfKEyVwrbRi2ZCVOK7Ax8kW12P7JSXWqacjy4X7paz33KtdK/A
	 NbvjTiVCT/lCAIySX5zUKCWDnNRBqBLkvjS1CESQJjgneEQjbFpm7BLUgXnoFhtYUT
	 mFf7EYdBe1E2UuEkEyJAeFi1GRu7BmhZdTeALIbI=
Date: Tue, 12 Dec 2023 17:20:46 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,changbin.du@intel.com,acsjakub@amazon.de,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch removed from -mm tree
Message-Id: <20231213012046.C0837C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: make damon_start() waits until kdamond_fn() starts
has been removed from the -mm tree.  Its filename was
     mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: make damon_start() waits until kdamond_fn() starts
Date: Fri, 8 Dec 2023 17:50:18 +0000

The cleanup tasks of kdamond threads including reset of corresponding
DAMON context's ->kdamond field and decrease of global nr_running_ctxs
counter is supposed to be executed by kdamond_fn().  However, commit
0f91d13366a4 ("mm/damon: simplify stop mechanism") made neither
damon_start() nor damon_stop() ensure the corresponding kdamond has
started the execution of kdamond_fn().

As a result, the cleanup can be skipped if damon_stop() is called fast
enough after the previous damon_start().  Especially the skipped reset
of ->kdamond could cause a use-after-free.

Fix it by waiting for start of kdamond_fn() execution from
damon_start().

Link: https://lkml.kernel.org/r/20231208175018.63880-1-sj@kernel.org
Fixes: 0f91d13366a4 ("mm/damon: simplify stop mechanism")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Jakub Acs <acsjakub@amazon.de>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Jakub Acs <acsjakub@amazon.de>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts
+++ a/include/linux/damon.h
@@ -559,6 +559,8 @@ struct damon_ctx {
 	 * update
 	 */
 	unsigned long next_ops_update_sis;
+	/* for waiting until the execution of the kdamond_fn is started */
+	struct completion kdamond_started;
 
 /* public: */
 	struct task_struct *kdamond;
--- a/mm/damon/core.c~mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts
+++ a/mm/damon/core.c
@@ -445,6 +445,8 @@ struct damon_ctx *damon_new_ctx(void)
 	if (!ctx)
 		return NULL;
 
+	init_completion(&ctx->kdamond_started);
+
 	ctx->attrs.sample_interval = 5 * 1000;
 	ctx->attrs.aggr_interval = 100 * 1000;
 	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
@@ -668,11 +670,14 @@ static int __damon_start(struct damon_ct
 	mutex_lock(&ctx->kdamond_lock);
 	if (!ctx->kdamond) {
 		err = 0;
+		reinit_completion(&ctx->kdamond_started);
 		ctx->kdamond = kthread_run(kdamond_fn, ctx, "kdamond.%d",
 				nr_running_ctxs);
 		if (IS_ERR(ctx->kdamond)) {
 			err = PTR_ERR(ctx->kdamond);
 			ctx->kdamond = NULL;
+		} else {
+			wait_for_completion(&ctx->kdamond_started);
 		}
 	}
 	mutex_unlock(&ctx->kdamond_lock);
@@ -1433,6 +1438,7 @@ static int kdamond_fn(void *data)
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
+	complete(&ctx->kdamond_started);
 	kdamond_init_intervals_sis(ctx);
 
 	if (ctx->ops.init)
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch

