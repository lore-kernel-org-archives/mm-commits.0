Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C23131A81F
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486758; cv=none; b=lT1zz06W6HS4SJ02ZIf+83E7JLtxpros6mjH8mtY2XM9FhUbEXez9Z9wzp25k5Ez4HFYijZS8eiyTZFTKtufTTWv6COhddIGjq8v4OKoFT9XRtlCaHdqSVvotOoXKpcMjK80suJLYBOLsccAXOHInaFpvYY8WjpXOwVh4gKKyIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486758; c=relaxed/simple;
	bh=amoVsVEFVW3fmnyIjUXBUS4tjzUrRwu8ocvOBHNrixs=;
	h=Date:To:From:Subject:Message-Id; b=t+JnoXvjn+C6wacnV3wmcg9BA+/K1R8Gx2fx3YfnkveTQ361le3QeIixErKwHQjbbAoOJjxUA1WRoaPp/90OR2Ey0EVFAVUOAc2Fs8ubFZMcGzcxbbx/8fbJuncoWccqlnXd4cZanhMY7jg6ZJ0xHh54X0IKn15Jx3fPupJ2Zx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HQroZ+4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HQroZ+4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5369EC116C6;
	Tue, 27 Jan 2026 04:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486758;
	bh=amoVsVEFVW3fmnyIjUXBUS4tjzUrRwu8ocvOBHNrixs=;
	h=Date:To:From:Subject:From;
	b=HQroZ+4ZTjxbvkHoFg6rdw2ugPXKZUxvNIHAW0Hs0zX7Ctiwyp1fQz56Nmz6sYPg6
	 HYcGyd8lqSoa+4WLDr4Rimm5ocPFF0rVrFuXZoSJ1g7uxF+l0DcyDS4NvN9W8kWi9v
	 jwNb/m09obJ6wwAT/4m7skY5fwyg4fN12GhMZ4Tk=
Date: Mon, 26 Jan 2026 20:05:57 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-damon_kdamond_pid.patch removed from -mm tree
Message-Id: <20260127040558.5369EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement damon_kdamond_pid()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-damon_kdamond_pid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: implement damon_kdamond_pid()
Date: Thu, 15 Jan 2026 07:20:41 -0800

Patch series "mm/damon: hide kdamond and kdamond_lock from API callers".

'kdamond' and 'kdamond_lock' fields initially exposed to DAMON API callers
for flexible synchronization and use cases.  As DAMON API became somewhat
complicated compared to the early days, Keeping those exposed could only
encourage the API callers to invent more creative but complicated and
difficult-to-debug use cases.

Fortunately DAMON API callers didn't invent that many creative use cases. 
There exist only two use cases of 'kdamond' and 'kdamond_lock'.  Finding
whether the kdamond is actively running, and getting the pid of the
kdamond.  For the first use case, a dedicated API function, namely
'damon_is_running()' is provided, and all DAMON API callers are using the
function for the use case.  Hence only the second use case is where the
fields are directly being used by DAMON API callers.

To prevent future invention of complicated and erroneous use cases of the
fields, hide the fields from the API callers.  For that, provide new
dedicated DAMON API functions for the remaining use case, namely
damon_kdamond_pid(), migrate DAMON API callers to use the new function,
and mark the fields as private fields.


This patch (of 5):

'kdamond' and 'kdamond_lock' are directly being used by DAMON API callers
for getting the pid of the corresponding kdamond.  To discourage invention
of creative but complicated and erroneous new usages of the fields that
require careful synchronization, implement a new API function that can
simply be used without the manual synchronizations.

Link: https://lkml.kernel.org/r/20260115152047.68415-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260115152047.68415-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-damon_kdamond_pid
+++ a/include/linux/damon.h
@@ -972,6 +972,7 @@ bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
+int damon_kdamond_pid(struct damon_ctx *ctx);
 
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
--- a/mm/damon/core.c~mm-damon-core-implement-damon_kdamond_pid
+++ a/mm/damon/core.c
@@ -1442,6 +1442,23 @@ bool damon_is_running(struct damon_ctx *
 	return running;
 }
 
+/**
+ * damon_kdamond_pid() - Return pid of a given DAMON context's worker thread.
+ * @ctx:	The DAMON context of the question.
+ *
+ * Return: pid if @ctx is running, negative error code otherwise.
+ */
+int damon_kdamond_pid(struct damon_ctx *ctx)
+{
+	int pid = -EINVAL;
+
+	mutex_lock(&ctx->kdamond_lock);
+	if (ctx->kdamond)
+		pid = ctx->kdamond->pid;
+	mutex_unlock(&ctx->kdamond_lock);
+	return pid;
+}
+
 /*
  * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
  *				      an inactive context.
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch
maple_tree-start-using-maple-copy-node-for-destination-fix.patch

