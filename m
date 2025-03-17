Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72EA21883E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188538; cv=none; b=XqVVwAFnhxuI0qsdC6PKB01JuCpTvX54GPeXicJ/dtAbwITw026dLGvFRCKWGAAT/NSEkVY2arJSUOhjbskNMe1WVW0ALR8CmGSD8+9s6eW+rj2a488NepvLRzQ9tCB6CHD5zNUaJNO30U3rzy8uK5dNXihirk50UKOuVmNRK9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188538; c=relaxed/simple;
	bh=EPuD+QKez3DpBvwCmqtGaFtrTk9aD0BIHKtDET5u/po=;
	h=Date:To:From:Subject:Message-Id; b=escPFqDnG5d/VljYYod9ebg6mUV9QsaAGkuSwZZCD6Ln45dRg/lOInFax8yPZ6/QBTDBmvwRlGZMQb7tTJgFEK/BGmzXakD4JCGu9V+rxpqURJ7tvRZG++Rg2CONYfhD2X/0xg1YidJtK3vg/S/BajOHnD+NvpUCRwp/spjl8CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZwAPqLzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZwAPqLzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891B9C4CEEC;
	Mon, 17 Mar 2025 05:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188538;
	bh=EPuD+QKez3DpBvwCmqtGaFtrTk9aD0BIHKtDET5u/po=;
	h=Date:To:From:Subject:From;
	b=ZwAPqLzziy/+jBouQ59+5xvXfK/dnccSpFZlmtFrm4rrxPuW/nOgb8kepMlh0Xo+R
	 +O91xxn+hmi/ejm0sOqJ0RAZiw6WLFk0g8jbAMMn5PjWeLvQNoOVJbGQoBXJxGl1JU
	 VvVcUkpMJX64hN6TnyIi68H8LfJdcxAdxXeiyFwE=
Date: Sun, 16 Mar 2025 22:15:38 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-support-committing-ops_filters.patch removed from -mm tree
Message-Id: <20250317051538.891B9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: support committing ops_filters
has been removed from the -mm tree.  Its filename was
     mm-damon-core-support-committing-ops_filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: support committing ops_filters
Date: Tue, 4 Mar 2025 13:19:07 -0800

DAMON kernel API callers should use damon_commit_ctx() to install DAMON
parameters including DAMOS filters.  But damos_commit_ops_filters(), which
is called by damon_commit_ctx() for filters installing, is not handling
damos->ops_filters.  Hence, no DAMON kernel API caller can use
damos->ops_filters.  Do the committing of the ops_filters to make it
usable.

Link: https://lkml.kernel.org/r/20250304211913.53574-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-support-committing-ops_filters
+++ a/mm/damon/core.c
@@ -820,7 +820,7 @@ static void damos_commit_filter(
 	damos_commit_filter_arg(dst, src);
 }
 
-static int damos_commit_filters(struct damos *dst, struct damos *src)
+static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
 	int i = 0, j = 0;
@@ -848,6 +848,44 @@ static int damos_commit_filters(struct d
 	return 0;
 }
 
+static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
+{
+	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
+	int i = 0, j = 0;
+
+	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
+		src_filter = damos_nth_filter(i++, src);
+		if (src_filter)
+			damos_commit_filter(dst_filter, src_filter);
+		else
+			damos_destroy_filter(dst_filter);
+	}
+
+	damos_for_each_ops_filter_safe(src_filter, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_filter = damos_new_filter(
+				src_filter->type, src_filter->matching,
+				src_filter->allow);
+		if (!new_filter)
+			return -ENOMEM;
+		damos_commit_filter_arg(new_filter, src_filter);
+		damos_add_filter(dst, new_filter);
+	}
+	return 0;
+}
+
+static int damos_commit_filters(struct damos *dst, struct damos *src)
+{
+	int err;
+
+	err = damos_commit_core_filters(dst, src);
+	if (err)
+		return err;
+	return damos_commit_ops_filters(dst, src);
+}
+
 static struct damos *damon_nth_scheme(int n, struct damon_ctx *ctx)
 {
 	struct damos *s;
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

