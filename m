Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DF11428E0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291735; cv=none; b=TDJeX8wkj0u3ThVyfUU/k1eX8cgGfL13JPpLIizQumijj18dLxYrSj5u4ypF+KwhkQKTp6bWHQIje/N6LTNXpgp7hvLKRZeKSsEFpWtKGtAU4HwSHc9xDRXAe/1o1NeqDQ4vgkHV0qbpSaWVgPcWmuDEksJFm/LVsBYeqa9nKag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291735; c=relaxed/simple;
	bh=bbxrqvOUZE7dZp6WkR4wtw3GxzOiVMZZeMXdKU/TJ8g=;
	h=Date:To:From:Subject:Message-Id; b=K/9yWvWQGosD8IEY/DRkxD9RCKTeSLw5lnj1WSXxOlRcWRBVw+ihFIc513YqB0AgmwN6GnoQ4qgmw06x+fVoD1effkehfjj14Jc4+zLgqyAgqfpYIZNtsJYHaZQjXb3CGwB4C9cAwFoALP0dJOaxmbIPgzemCOHTwwED9UK4l9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qBTVy9sI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qBTVy9sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F8FC32782;
	Tue, 25 Jun 2024 05:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291734;
	bh=bbxrqvOUZE7dZp6WkR4wtw3GxzOiVMZZeMXdKU/TJ8g=;
	h=Date:To:From:Subject:From;
	b=qBTVy9sILMpTI1/bHmJ3dTilePGzFh2lIe7Ho8Yt8EZiwWkRF4ihz1N+7KwzHX3SC
	 b3v49BVs934Y8wUEi3l7Lm7Y0Jn7RavX0DcHdshY9MayDDo/3zKblTUl7WVuRaJO3l
	 QcjdoHStYwO9C3zgcaBaKC7eMUb33MOEbqy6kn0I=
Date: Mon, 24 Jun 2024 22:02:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-damos-quota-goals-online-commit-function.patch removed from -mm tree
Message-Id: <20240625050214.86F8FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement DAMOS quota goals online commit function
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-damos-quota-goals-online-commit-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

