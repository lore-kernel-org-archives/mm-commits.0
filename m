Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E7E155757
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188542; cv=none; b=ewoK4/nK3LMOszDShXOb9JF89okP050wtI9xXHA0iajGaiuSRYJs+cFo8OfEmi2EdVOg3oKZc+p4KQOLa5dI2Ad5Rw+jDD8OmuL1L4nrU2jBOxnh6XuFpltIN8QXjN9o8mxXaXa5Scml8eCjTkw1y5eGoUn8/FEavU2V1axxKho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188542; c=relaxed/simple;
	bh=5WWnx7yyX9mKMDSdtEJqPtHsq6C0cRo0iBVEklEIEJs=;
	h=Date:To:From:Subject:Message-Id; b=sLSS6Ox8o2luiGLgEGXahtXasJDwxvz+MDef9p6IOg/SqzVILHDaVtKjeU9Jk6lLXCK9Of+9uZnQts/TNJXqB6EdKs8asiA8/EpPr8oDz7+iY4SAZ9HRKYO9lIMcIXw8GyZLPymWm3gmXti8VY5oFJQZ4qM4dGHBPFKwzuc28YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HVrpAleE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HVrpAleE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A79C4CEEC;
	Mon, 17 Mar 2025 05:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188541;
	bh=5WWnx7yyX9mKMDSdtEJqPtHsq6C0cRo0iBVEklEIEJs=;
	h=Date:To:From:Subject:From;
	b=HVrpAleEDtEe/NlN7Rl6RtIW3AMJhrBjGB9ejZPCa3nugz64VKa8nvF90eQJ4iy/Y
	 BhyHVxts84zViAS7u9oqFXhn/HRBjP9Iny4eO6ikzOJAWjbhAloQwW+WCWhw5a9f0x
	 /RHpuK0be5Txi/LmuVUqjwi/Ykc02/DnCfP+L8hI=
Date: Sun, 16 Mar 2025 22:15:41 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch removed from -mm tree
Message-Id: <20250317051541.B9A79C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add default allow/reject behavior fields to struct damos
has been removed from the -mm tree.  Its filename was
     mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add default allow/reject behavior fields to struct damos
Date: Tue, 4 Mar 2025 13:19:10 -0800

Current default allow/reject behavior of filters handling stage has made
before introduction of the allow behavior.  For allow-filters usage, it is
confusing and inefficient.

It is more intuitive to decide the default filtering stage allow/reject
behavior as opposite to the last filter's behavior.  The decision should
be made separately for core and operations layers' filtering stages, since
last core layer-handled filter is not really a last filter if there are
operations layer handling filters.

Keeping separate decisions for the two categories can make the logic
simpler.  Add fields for storing the two decisions.

Link: https://lkml.kernel.org/r/20250304211913.53574-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/damon.h~mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos
+++ a/include/linux/damon.h
@@ -502,6 +502,9 @@ struct damos {
 	 * layer-handled filters.  If true, operations layer allows it, too.
 	 */
 	bool core_filters_allowed;
+	/* whether to reject core/ops filters umatched regions */
+	bool core_filters_default_reject;
+	bool ops_filters_default_reject;
 /* public: */
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
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

