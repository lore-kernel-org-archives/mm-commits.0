Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4125158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739389; cv=none; b=LjeoC0cYXDM9Vpay6CHZkDWkdlJMlQAzwXv79JinoZLSJ7eT+M1HYnZUxVzsn1RV6Io4qTVJsuSNYWkJ5FXtLdcUoJbX6SPpZNOJ+biMCYjtNIVGQXFcaHotWj+aSILPUqJwL5lYtXWAvNCfHhyz7SROkSnsxNdcKMW4VZUkyqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739389; c=relaxed/simple;
	bh=lsXpDww1wr/hiyxjFeewjnZ1XOwuM4WYvD3mFCAmbyA=;
	h=Date:To:From:Subject:Message-Id; b=YqFPmFAOBwK+pKKS1nQ47wwh0JSBRNjYafyhcXkzaNY7TqSmL39C5uj50Soc4oWmP3+pi2MtCY5jeifnvMGR1kRxMLH1mh061teb81tqKYLpj76KRc6WILeEUumoTNpqCG1tYddyv3HAsNhT8vmjs4OogZjPi0+oxO/KfQrDkM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=btJ1/hOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="btJ1/hOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63369C4AF1A;
	Tue, 18 Jun 2024 19:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739389;
	bh=lsXpDww1wr/hiyxjFeewjnZ1XOwuM4WYvD3mFCAmbyA=;
	h=Date:To:From:Subject:From;
	b=btJ1/hOIc9aGQ5lZEz32nB2DELBTO9MFXdhhunp6skuTz3cf9aPC4lHVNIxQFTOhe
	 EAXnSXlAAFi2vBZ3T65RSh5pH29VB3Zi5eSPZEBbGJ0kstHo6Ae0WHzAYXBUB6qJ4/
	 4PkNMKaeMocRjJ+owmt4ancEI1uFoKXOFVO9Y7w4=
Date: Tue, 18 Jun 2024 12:36:28 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-damon-context-commit-function.patch added to mm-unstable branch
Message-Id: <20240618193629.63369C4AF1A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: implement DAMON context commit function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-damon-context-commit-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-damon-context-commit-function.patch

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
Subject: mm/damon/core: implement DAMON context commit function
Date: Tue, 18 Jun 2024 11:17:59 -0700

Implement functions for supporting online DAMON context level parameters
update.  The function receives two DAMON context structs.  One is the
struct that currently being used by a kdamond and therefore to be updated.
The other one contains the parameters to be applied to the first one. 
The function applies the new parameters to the destination struct while
keeping/updating the internal status and operation results.  The function
should be called from DAMON context-update-safe place, like DAMON
callbacks.

Link: https://lkml.kernel.org/r/20240618181809.82078-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 
 mm/damon/core.c       |  274 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 275 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-damon-context-commit-function
+++ a/include/linux/damon.h
@@ -756,6 +756,7 @@ void damon_destroy_ctx(struct damon_ctx
 int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs);
 void damon_set_schemes(struct damon_ctx *ctx,
 			struct damos **schemes, ssize_t nr_schemes);
+int damon_commit_ctx(struct damon_ctx *old_ctx, struct damon_ctx *new_ctx);
 int damon_nr_running_ctxs(void);
 bool damon_is_registered_ops(enum damon_ops_id id);
 int damon_register_ops(struct damon_operations *ops);
--- a/mm/damon/core.c~mm-damon-core-implement-damon-context-commit-function
+++ a/mm/damon/core.c
@@ -725,6 +725,280 @@ int damos_commit_quota_goals(struct damo
 	return 0;
 }
 
+static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
+{
+	int err;
+
+	dst->reset_interval = src->reset_interval;
+	dst->ms = src->ms;
+	dst->sz = src->sz;
+	err = damos_commit_quota_goals(dst, src);
+	if (err)
+		return err;
+	dst->weight_sz = src->weight_sz;
+	dst->weight_nr_accesses = src->weight_nr_accesses;
+	dst->weight_age = src->weight_age;
+	return 0;
+}
+
+static struct damos_filter *damos_nth_filter(int n, struct damos *s)
+{
+	struct damos_filter *filter;
+	int i = 0;
+
+	damos_for_each_filter(filter, s) {
+		if (i++ == n)
+			return filter;
+	}
+	return NULL;
+}
+
+static void damos_commit_filter_arg(
+		struct damos_filter *dst, struct damos_filter *src)
+{
+	switch (dst->type) {
+	case DAMOS_FILTER_TYPE_MEMCG:
+		dst->memcg_id = src->memcg_id;
+		break;
+	case DAMOS_FILTER_TYPE_ADDR:
+		dst->addr_range = src->addr_range;
+		break;
+	case DAMOS_FILTER_TYPE_TARGET:
+		dst->target_idx = src->target_idx;
+		break;
+	default:
+		break;
+	}
+}
+
+static void damos_commit_filter(
+		struct damos_filter *dst, struct damos_filter *src)
+{
+	dst->type = src->type;
+	dst->matching = src->matching;
+	damos_commit_filter_arg(dst, src);
+}
+
+static int damos_commit_filters(struct damos *dst, struct damos *src)
+{
+	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
+	int i = 0, j = 0;
+
+	damos_for_each_filter_safe(dst_filter, next, dst) {
+		src_filter = damos_nth_filter(i++, src);
+		if (src_filter)
+			damos_commit_filter(dst_filter, src_filter);
+		else
+			damos_destroy_filter(dst_filter);
+	}
+
+	damos_for_each_filter_safe(src_filter, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_filter = damos_new_filter(
+				src_filter->type, src_filter->matching);
+		if (!new_filter)
+			return -ENOMEM;
+		damos_commit_filter_arg(new_filter, src_filter);
+		damos_add_filter(dst, new_filter);
+	}
+	return 0;
+}
+
+static struct damos *damon_nth_scheme(int n, struct damon_ctx *ctx)
+{
+	struct damos *s;
+	int i = 0;
+
+	damon_for_each_scheme(s, ctx) {
+		if (i++ == n)
+			return s;
+	}
+	return NULL;
+}
+
+static int damos_commit(struct damos *dst, struct damos *src)
+{
+	int err;
+
+	dst->pattern = src->pattern;
+	dst->action = src->action;
+	dst->apply_interval_us = src->apply_interval_us;
+
+	err = damos_commit_quota(&dst->quota, &src->quota);
+	if (err)
+		return err;
+
+	dst->wmarks = src->wmarks;
+
+	err = damos_commit_filters(dst, src);
+	return err;
+}
+
+static int damon_commit_schemes(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damos *dst_scheme, *next, *src_scheme, *new_scheme;
+	int i = 0, j = 0, err;
+
+	damon_for_each_scheme_safe(dst_scheme, next, dst) {
+		src_scheme = damon_nth_scheme(i++, src);
+		if (src_scheme) {
+			err = damos_commit(dst_scheme, src_scheme);
+			if (err)
+				return err;
+		} else {
+			damon_destroy_scheme(dst_scheme);
+		}
+	}
+
+	damon_for_each_scheme_safe(src_scheme, next, src) {
+		if (j++ < i)
+			continue;
+		new_scheme = damon_new_scheme(&src_scheme->pattern,
+				src_scheme->action,
+				src_scheme->apply_interval_us,
+				&src_scheme->quota, &src_scheme->wmarks,
+				NUMA_NO_NODE);
+		if (!new_scheme)
+			return -ENOMEM;
+		damon_add_scheme(dst, new_scheme);
+	}
+	return 0;
+}
+
+static struct damon_target *damon_nth_target(int n, struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	int i = 0;
+
+	damon_for_each_target(t, ctx) {
+		if (i++ == n)
+			return t;
+	}
+	return NULL;
+}
+
+/*
+ * The caller should ensure the regions of @src are
+ * 1. valid (end >= src) and
+ * 2. sorted by starting address.
+ *
+ * If @src has no region, @dst keeps current regions.
+ */
+static int damon_commit_target_regions(
+		struct damon_target *dst, struct damon_target *src)
+{
+	struct damon_region *src_region;
+	struct damon_addr_range *ranges;
+	int i = 0, err;
+
+	damon_for_each_region(src_region, src)
+		i++;
+	if (!i)
+		return 0;
+
+	ranges = kmalloc_array(i, sizeof(*ranges), GFP_KERNEL | __GFP_NOWARN);
+	if (!ranges)
+		return -ENOMEM;
+	i = 0;
+	damon_for_each_region(src_region, src)
+		ranges[i++] = src_region->ar;
+	err = damon_set_regions(dst, ranges, i);
+	kfree(ranges);
+	return err;
+}
+
+static int damon_commit_target(
+		struct damon_target *dst, bool dst_has_pid,
+		struct damon_target *src, bool src_has_pid)
+{
+	int err;
+
+	err = damon_commit_target_regions(dst, src);
+	if (err)
+		return err;
+	if (dst_has_pid)
+		put_pid(dst->pid);
+	if (src_has_pid)
+		get_pid(src->pid);
+	dst->pid = src->pid;
+	return 0;
+}
+
+static int damon_commit_targets(
+		struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_target *dst_target, *next, *src_target, *new_target;
+	int i = 0, j = 0, err;
+
+	damon_for_each_target_safe(dst_target, next, dst) {
+		src_target = damon_nth_target(i++, src);
+		if (src_target) {
+			err = damon_commit_target(
+					dst_target, damon_target_has_pid(dst),
+					src_target, damon_target_has_pid(src));
+			if (err)
+				return err;
+		} else {
+			if (damon_target_has_pid(dst))
+				put_pid(dst_target->pid);
+			damon_destroy_target(dst_target);
+		}
+	}
+
+	damon_for_each_target_safe(src_target, next, src) {
+		if (j++ < i)
+			continue;
+		new_target = damon_new_target();
+		if (!new_target)
+			return -ENOMEM;
+		err = damon_commit_target(new_target, false,
+				src_target, damon_target_has_pid(src));
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+/**
+ * damon_commit_ctx() - Commit parameters of a DAMON context to another.
+ * @dst:	The commit destination DAMON context.
+ * @src:	The commit source DAMON context.
+ *
+ * This function copies user-specified parameters from @src to @dst and update
+ * the internal status and results accordingly.  Users should use this function
+ * for context-level parameters update of running context, instead of manual
+ * in-place updates.
+ *
+ * This function should be called from parameters-update safe context, like
+ * DAMON callbacks.
+ */
+int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	int err;
+
+	err = damon_commit_schemes(dst, src);
+	if (err)
+		return err;
+	err = damon_commit_targets(dst, src);
+	if (err)
+		return err;
+	/*
+	 * schemes and targets should be updated first, since
+	 * 1. damon_set_attrs() updates monitoring results of targets and
+	 * next_apply_sis of schemes, and
+	 * 2. ops update should be done after pid handling is done (target
+	 *    committing require putting pids).
+	 */
+	err = damon_set_attrs(dst, &src->attrs);
+	if (err)
+		return err;
+	dst->ops = src->ops;
+
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

