Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E8155757
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188543; cv=none; b=gi/ifKUT4jlIN/gYLNUeBiKDxj5gmrCV6XZkLCXAbW2uFFQK+3F1SK6nQ+fztlaQDpsNYZjjp2oNm2aHFm9Gegl2m3oS5Jvnega5zBrxB//YHeaUs0Ou4f4cE/h+uTkOvJ9ACAUo3VTakpTCo2QDKaDHHh4ZF45HrlQnQ8Uyv10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188543; c=relaxed/simple;
	bh=PskBCWaFqVyVmuo4/qXmP8W+mBQ2ci5k11CCo9pVwQ4=;
	h=Date:To:From:Subject:Message-Id; b=EpbcSo3G3FSz+I0wAGA9avxGe6Y4YvWMkNGUQ6oUrSt24ecMRcMi61yi92MW7DOaej76a/734Rkp00do57GUCxdb+8Legu8AwvLfzDoEKV9j9AB9YOR8Q5VgwJeDOKYA4UX399ewmyY/0KOisQkhIzASfSmrCuEkbkhh7Bw1Jwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nqfQKf+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nqfQKf+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1B5C4CEEC;
	Mon, 17 Mar 2025 05:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188542;
	bh=PskBCWaFqVyVmuo4/qXmP8W+mBQ2ci5k11CCo9pVwQ4=;
	h=Date:To:From:Subject:From;
	b=nqfQKf+obn6ZHtU/gcVq7OU9W3SYetRZpo4pf3g7edPOv+XAYzQ/nb4dLfK4R7wwH
	 6TwDuBOVKmABtY5GnehQdHsbJUmHo8PcmJ3QXw2KPagqAoIdR55dgeDk2QbgCWGemd
	 CDWnOFwoM0rcIRwo6PEtTtRJ9retn8JeRMmlO1/A=
Date: Sun, 16 Mar 2025 22:15:42 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch removed from -mm tree
Message-Id: <20250317051542.CF1B5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: set damos_filter default allowance behavior based on installed filters
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: set damos_filter default allowance behavior based on installed filters
Date: Tue, 4 Mar 2025 13:19:11 -0800

Decide whether to allow or reject by default on core and opertions layer
handled filters evaluation stages.  It is decided as the opposite of the
last installed filter's behavior.  If there is no filter at all, allow by
default.  If there is any operations layer handled filters, core layer's
filtering stage sets allowing as the default behavior regardless of the
last filter of core layer-handling ones, since the last filter of core
layer handled filters in the case is not really the last filter of the
entire filtering stage.

Also, make the core layer's DAMOS filters handling stage uses the newly
set behavior field.

[sj@kernel.org: setup damos->{core,ops}_filters_default_reject for initial start]
  Link: https://lkml.kernel.org/r/20250315222610.35245-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250304211913.53574-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters
+++ a/mm/damon/core.c
@@ -518,7 +518,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
 
 	ctx->passed_sample_intervals = 0;
-	/* These will be set from kdamond_init_intervals_sis() */
+	/* These will be set from kdamond_init_ctx() */
 	ctx->next_aggregation_sis = 0;
 	ctx->next_ops_update_sis = 0;
 
@@ -891,6 +891,32 @@ static int damos_commit_ops_filters(stru
 	return 0;
 }
 
+/**
+ * damos_filters_default_reject() - decide whether to reject memory that didn't
+ *				    match with any given filter.
+ * @filters:	Given DAMOS filters of a group.
+ */
+static bool damos_filters_default_reject(struct list_head *filters)
+{
+	struct damos_filter *last_filter;
+
+	if (list_empty(filters))
+		return false;
+	last_filter = list_last_entry(filters, struct damos_filter, list);
+	return last_filter->allow;
+}
+
+static void damos_set_filters_default_reject(struct damos *s)
+{
+	if (!list_empty(&s->ops_filters))
+		s->core_filters_default_reject = false;
+	else
+		s->core_filters_default_reject =
+			damos_filters_default_reject(&s->filters);
+	s->ops_filters_default_reject =
+		damos_filters_default_reject(&s->ops_filters);
+}
+
 static int damos_commit_filters(struct damos *dst, struct damos *src)
 {
 	int err;
@@ -898,7 +924,11 @@ static int damos_commit_filters(struct d
 	err = damos_commit_core_filters(dst, src);
 	if (err)
 		return err;
-	return damos_commit_ops_filters(dst, src);
+	err = damos_commit_ops_filters(dst, src);
+	if (err)
+		return err;
+	damos_set_filters_default_reject(dst);
+	return 0;
 }
 
 static struct damos *damon_nth_scheme(int n, struct damon_ctx *ctx)
@@ -1580,7 +1610,7 @@ static bool damos_filter_out(struct damo
 			return !filter->allow;
 		}
 	}
-	return false;
+	return s->core_filters_default_reject;
 }
 
 /*
@@ -2315,7 +2345,7 @@ static int kdamond_wait_activation(struc
 	return -EBUSY;
 }
 
-static void kdamond_init_intervals_sis(struct damon_ctx *ctx)
+static void kdamond_init_ctx(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
 		ctx->attrs.sample_interval : 1;
@@ -2333,6 +2363,7 @@ static void kdamond_init_intervals_sis(s
 		apply_interval = scheme->apply_interval_us ?
 			scheme->apply_interval_us : ctx->attrs.aggr_interval;
 		scheme->next_apply_sis = apply_interval / sample_interval;
+		damos_set_filters_default_reject(scheme);
 	}
 }
 
@@ -2350,7 +2381,7 @@ static int kdamond_fn(void *data)
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
 	complete(&ctx->kdamond_started);
-	kdamond_init_intervals_sis(ctx);
+	kdamond_init_ctx(ctx);
 
 	if (ctx->ops.init)
 		ctx->ops.init(ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

