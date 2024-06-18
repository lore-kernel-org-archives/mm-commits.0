Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3E4158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739387; cv=none; b=GtOvsPl4uzoShMkYTk0VM06hWdzkcyG19QP6A/4rxSndnH1IOJh6MuL+6f7elwAm6C9HSe/O6RJ6GWVmKE6hH5V3Ef76xMitW+4H/t1/2umBUAjBH7hDn4q6sI7RI78eztZF88533kXNFx6VyBZVtNbqqEreLj/qhL4rAjrUR/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739387; c=relaxed/simple;
	bh=99X5bbY+9uh6uCweDg/l7ZQdalERMNkGW02Gbim+BPk=;
	h=Date:To:From:Subject:Message-Id; b=n41bZD9FKSo7XYvIm1hejtI1qV8Sc7CCM+NIXzcY81sAX/J//CSI9cEBBwcfOmSLE2blUoQ/sKhXELmo7GQcIXzULOo/hxFrt7XuwjVmz/CnJf9MBL346bo19MdRdsKXUDE6MWqlp4kycfyVYx0FvlskV41cnQJPHPtIboBaeaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pUuDxT2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pUuDxT2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10306C3277B;
	Tue, 18 Jun 2024 19:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739387;
	bh=99X5bbY+9uh6uCweDg/l7ZQdalERMNkGW02Gbim+BPk=;
	h=Date:To:From:Subject:From;
	b=pUuDxT2eVTBZkNZh+suJZMjtpBZZrRGbiujwheoky1JXr4vB47YaTAbNSzPeMN/gY
	 a8g0raAZIc9WlbzqfYMQzOrfdhE3YuR9k51WuFNPeNiGLm69fevu/MW9cXEoXOYqkl
	 kCjnBCwMvtRCxP2X+A5IDCBW/rCPM1tA+UurqicA=
Date: Tue, 18 Jun 2024 12:36:26 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-damos-quota-goals-online-commit-function.patch added to mm-unstable branch
Message-Id: <20240618193627.10306C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: implement DAMOS quota goals online commit function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-damos-quota-goals-online-commit-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-damos-quota-goals-online-commit-function.patch

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
Subject: mm/damon/core: implement DAMOS quota goals online commit function
Date: Tue, 18 Jun 2024 11:17:58 -0700

Patch series "mm/damon: introduce DAMON parameters online commit function".

DAMON context struct (damon_ctx) contains user requests (parameters),
internal status, and operation results.  For flexible usages, DAMON API
users are encouraged to manually manipulate the struct.  That works well
for simple use cases.  However, it has turned out that it is not that
simple at least for online parameters udpate.  It is easy to forget
properly maintaining internal status and operation results.  Also, such
manual manipulation for online tuning is implemented multiple times on
DAMON API users including DAMON sysfs interface, DAMON_RECLAIM and
DAMON_LRU_SORT.  As a result, we have multiple sources of bugs for same
problem.  Actually we found and fixed a few bugs from online parameter
updating of DAMON API users.

Implement a function for online DAMON parameters update in core layer, and
replace DAMON API users' manual manipulation code for the use case.  The
core layer function could still have bugs, but this change reduces the
source of bugs for the problem to one place.


This patch (of 12):

Implement functions for supporting online DAMOS quota goals parameters
update.  The function receives two DAMOS quota structs.  One is the struct
that currently being used by a kdamond and therefore to be updated.  The
other one contains the parameters to be applied to the first one.  The
function applies the new parameters to the destination struct while
keeping/updating the internal status.  The function should be called from
parameters-update safe place, like DAMON callbacks.

Link: https://lkml.kernel.org/r/20240618181809.82078-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240618181809.82078-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 
 mm/damon/core.c       |   59 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-damos-quota-goals-online-commit-function
+++ a/include/linux/damon.h
@@ -742,6 +742,7 @@ struct damos *damon_new_scheme(struct da
 			int target_nid);
 void damon_add_scheme(struct damon_ctx *ctx, struct damos *s);
 void damon_destroy_scheme(struct damos *s);
+int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src);
 
 struct damon_target *damon_new_target(void);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
--- a/mm/damon/core.c~mm-damon-core-implement-damos-quota-goals-online-commit-function
+++ a/mm/damon/core.c
@@ -666,6 +666,65 @@ void damon_set_schemes(struct damon_ctx
 		damon_add_scheme(ctx, schemes[i]);
 }
 
+static struct damos_quota_goal *damos_nth_quota_goal(
+		int n, struct damos_quota *q)
+{
+	struct damos_quota_goal *goal;
+	int i = 0;
+
+	damos_for_each_quota_goal(goal, q) {
+		if (i++ == n)
+			return goal;
+	}
+	return NULL;
+}
+
+static void damos_commit_quota_goal(
+		struct damos_quota_goal *dst, struct damos_quota_goal *src)
+{
+	dst->metric = src->metric;
+	dst->target_value = src->target_value;
+	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
+		dst->current_value = src->current_value;
+	/* keep last_psi_total as is, since it will be updated in next cycle */
+}
+
+/**
+ * damos_commit_quota_goals() - Commit DAMOS quota goals to another quota.
+ * @dst:	The commit destination DAMOS quota.
+ * @src:	The commit source DAMOS quota.
+ *
+ * Copies user-specified parameters for quota goals from @src to @dst.  Users
+ * should use this function for quota goals-level parameters update of running
+ * DAMON contexts, instead of manual in-place updates.
+ *
+ * This function should be called from parameters-update safe context, like
+ * DAMON callbacks.
+ */
+int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
+{
+	struct damos_quota_goal *dst_goal, *next, *src_goal, *new_goal;
+	int i = 0, j = 0;
+
+	damos_for_each_quota_goal_safe(dst_goal, next, dst) {
+		src_goal = damos_nth_quota_goal(i++, src);
+		if (src_goal)
+			damos_commit_quota_goal(dst_goal, src_goal);
+		else
+			damos_destroy_quota_goal(dst_goal);
+	}
+	damos_for_each_quota_goal_safe(src_goal, next, src) {
+		if (j++ < i)
+			continue;
+		new_goal = damos_new_quota_goal(
+				src_goal->metric, src_goal->target_value);
+		if (!new_goal)
+			return -ENOMEM;
+		damos_add_quota_goal(dst, new_goal);
+	}
+	return 0;
+}
+
 /**
  * damon_nr_running_ctxs() - Return number of currently running contexts.
  */
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

